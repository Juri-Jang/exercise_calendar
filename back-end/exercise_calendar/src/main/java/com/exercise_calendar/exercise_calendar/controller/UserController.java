package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    private ResponseEntity<String> register(@RequestBody User user) {
        String msg = userService.saveUser(user);

        return new ResponseEntity<String>(msg, HttpStatus.OK);
    }
}
