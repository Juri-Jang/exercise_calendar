package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.entity.Refresh;
import com.exercise_calendar.exercise_calendar.jwt.JWTUtil;
import com.exercise_calendar.exercise_calendar.repository.RefreshRepository;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;

@Controller
@ResponseBody
public class ReissueController {

    private final JWTUtil jwtUtil;
    private final RefreshRepository refreshRepository;

    public ReissueController(JWTUtil jwtUtil, RefreshRepository refreshRepository) {
        this.jwtUtil = jwtUtil;
        this.refreshRepository = refreshRepository;
    }

    @PostMapping("/reissue")
    public ResponseEntity<?> reissue(HttpServletRequest request, HttpServletResponse response) {
        // 1. 헤더에서 리프레시 토큰 추출
        String refresh = request.getHeader("X-Refresh-Token");

        if (refresh == null || refresh.isEmpty()) {
            // response 상태 코드
            return new ResponseEntity<>("refresh token null", HttpStatus.BAD_REQUEST);
        }

        // 2. 토큰 만료 여부 확인
        try {
            jwtUtil.isExpired(refresh);
        } catch (ExpiredJwtException e) {
            return new ResponseEntity<>("refresh token expired", HttpStatus.BAD_REQUEST);
        }

        // 3. 토큰이 refresh인지 확인
        String category = jwtUtil.getCategory(refresh);
        if (!"refresh".equals(category)) {
            return new ResponseEntity<>("invalid refresh token", HttpStatus.BAD_REQUEST);
        }

        // 4. DB에서 refresh 토큰 존재 여부 확인
        boolean isExist = refreshRepository.existsByRefresh(refresh);
        if (!isExist) {
            return new ResponseEntity<>("invalid refresh token", HttpStatus.BAD_REQUEST);
        }

        // 5. 새로운 액세스 및 리프레시 토큰 생성
        String username = jwtUtil.getUsername(refresh);
        String role = jwtUtil.getRole(refresh);
        String newAccess = jwtUtil.createJwt("access", username, role, 600000L); // 10분
        String newRefresh = jwtUtil.createJwt("refresh", username, role, 604800000L); // 7일

        // 기존 리프레시 토큰 삭제 후 새로 저장
        refreshRepository.deleteByRefresh(refresh);
        addRefreshEntity(username, newRefresh, 604800000L);

        // 6. 응답에 새 토큰 전달 (헤더로 설정)
        response.setHeader("access", newAccess);
        response.setHeader("X-Refresh-Token", newRefresh);

        return new ResponseEntity<>(HttpStatus.OK);
    }


    private void addRefreshEntity(String username, String refresh, Long expiredMs) {

        Date date = new Date(System.currentTimeMillis() + expiredMs);

        Refresh refreshEntity = new Refresh();
        refreshEntity.setUsername(username);
        refreshEntity.setRefresh(refresh);
        refreshEntity.setExpiration(date.toString());

        refreshRepository.save(refreshEntity);
    }
}
