package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
//@CrossOrigin(origins = "http://192.168.219.103:8080")
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
        if (user.getUsername() == null || user.getUserid() == null || user.getPassword() == null || user.getEmail() == null) {
            System.out.println("Some fields are null!");
        }
        return new ResponseEntity<String>(msg, HttpStatus.OK);
    }


}
