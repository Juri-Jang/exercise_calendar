package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.UserProfileResponse;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @CrossOrigin(origins = "*")  // 모든 출처에서의 요청 허용, 필요에 따라 제한 가능
    @GetMapping("/check-userid/{userid}")
    public ResponseEntity<Boolean> checkUserid(@PathVariable String userid) {
        System.out.println(userid);
        boolean isTaken = userService.isUseridTaken(userid);
        return ResponseEntity.ok(isTaken); //이미 존재하면 true, 신규이면 false
    }

    @PostMapping("/register")
    private ResponseEntity<String> register(@RequestBody User user) {
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
    public String securityUserName(Principal principal) {
        System.out.println("tewtfgdsfg");
        return principal.getName();
    }
//    public ResponseEntity<UserProfileResponse> getProfile() {
//        System.out.println("Profile API called");
//
//        // SecurityContextHolder에서 인증 정보 가져오기
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//
//        if (authentication == null || !authentication.isAuthenticated()) {
//            System.out.println("Authentication failed or user is not authenticated");
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
//        }
//
//        String username = authentication.getName();
//        System.out.println("Authenticated username: " + username);
//
//        // 사용자 정보 조회
//        User user = userService.getUserProfile(username);
//        if (user == null) {
//            System.out.println("User not found for username: " + username);
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
//        }
//
//        // UserProfileResponse 매핑
//        UserProfileResponse userProfileDTO = new UserProfileResponse();
//        userProfileDTO.setUsername(user.getUsername());
//        userProfileDTO.setEmail(user.getEmail());
//        userProfileDTO.setName(user.getName());
//
//        System.out.println("UserProfileResponse created: " + userProfileDTO);
//
//        return ResponseEntity.ok(userProfileDTO);
//    }

}
