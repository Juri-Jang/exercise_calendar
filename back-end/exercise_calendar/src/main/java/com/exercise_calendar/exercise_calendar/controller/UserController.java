package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.UserProfileResDto;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.jwt.JWTUtil;
import com.exercise_calendar.exercise_calendar.repository.RefreshRepository;
import com.exercise_calendar.exercise_calendar.service.CustomUserDetailsService;
import com.exercise_calendar.exercise_calendar.service.UserService;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomUserDetailsService customUserDetailsService;
    @Autowired
    private JWTUtil jwtUtil;
    @Autowired
    private RefreshRepository refreshRepository;

    @CrossOrigin(origins = "*")  // 모든 출처에서의 요청 허용, 필요에 따라 제한 가능
    @GetMapping("/check-userid/{userid}")
    public ResponseEntity<Boolean> checkUserid(@PathVariable String userid) {
        System.out.println(userid);
        boolean isTaken = userService.isUseridTaken(userid);
        return ResponseEntity.ok(isTaken); //이미 존재하면 true, 신규이면 false
    }

    @PostMapping("/signup")
    private ResponseEntity<String> signup(@RequestBody User user) {
        // 프론트엔드에서 전달된 값 확인 (디버깅용)
        System.out.println("Received User Data: " + user.toString());
        String msg = userService.registerUser(user);
        if (user.getUsername() == null || user.getUsername() == null || user.getPassword() == null || user.getEmail() == null) {
            System.out.println("Some fields are null!");
        }
        return new ResponseEntity<String>(msg, HttpStatus.OK);
    }

    @GetMapping("/profile")
    @ResponseBody
    public ResponseEntity<UserProfileResDto> getUserProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName(); // 현재 인증된 사용자의 이름 가져오기

        try {
            UserProfileResDto userProfile = customUserDetailsService.getUserProfile(username);
            return ResponseEntity.ok(userProfile);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @GetMapping("/validateToken")
    public ResponseEntity<?> validateToken(@RequestHeader("access") String accessToken,
                                           @RequestHeader("X-Refresh-Token") String refreshToken) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 인증되지 않은 경우 (필터에서 인증 실패한 경우)
        if (authentication == null) {
            return ResponseEntity.status(HttpServletResponse.SC_UNAUTHORIZED).body("Unauthorized");
        }

        // Refresh Token 검증 (JWT 필터에서 이미 accessToken 검증을 거쳤으므로, refreshToken만 확인)
        try {
            jwtUtil.isExpired(refreshToken);
        } catch (ExpiredJwtException e) {
            return new ResponseEntity<>("refresh token expired", HttpStatusCode.valueOf(HttpServletResponse.SC_FORBIDDEN));
        }

        // Refresh Token 카테고리 확인
        String category = jwtUtil.getCategory(refreshToken);
        if (!"refresh".equals(category)) {
            return new ResponseEntity<>("invalid refresh token", HttpStatusCode.valueOf(HttpServletResponse.SC_FORBIDDEN));
        }

        // Refresh Token의 유효성 (DB에 저장된 값과 비교)
        boolean isExist = refreshRepository.existsByRefresh(refreshToken);
        if (!isExist) {
            return new ResponseEntity<>("invalid refresh token", HttpStatusCode.valueOf(HttpServletResponse.SC_FORBIDDEN));
        }

        // 정상적인 경우
        return ResponseEntity.ok("Token is valid");
    }


}
