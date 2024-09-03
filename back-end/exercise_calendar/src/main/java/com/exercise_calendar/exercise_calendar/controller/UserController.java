package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    private ResponseEntity<String> register(@RequestBody User user) {
        // 프론트엔드에서 전달된 값 확인 (디버깅용)
        System.out.println("Received User Data: " + user.toString());
        String msg = userService.registerUser(user);
        if (user.getUsername() == null || user.getUserid() == null || user.getPassword() == null || user.getEmail() == null) {
            System.out.println("Some fields are null!");
        }
        return new ResponseEntity<String>(msg, HttpStatus.OK);
    }
}
