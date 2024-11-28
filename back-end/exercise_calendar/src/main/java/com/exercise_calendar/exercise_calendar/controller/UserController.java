package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.UserProfileDTO;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

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
    public UserProfileDTO getProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = userService.getUserProfile(username);

        UserProfileDTO userProfileDTO = new UserProfileDTO();
        userProfileDTO.setUsername(user.getUsername());
        userProfileDTO.setEmail(user.getEmail());
        userProfileDTO.setName(user.getName());

        return userProfileDTO;
    }

}
