package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.ExerciseReqDto;
import com.exercise_calendar.exercise_calendar.service.ExerciseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/exercise")
public class ExerciseController {
    @Autowired
    private ExerciseService exerciseService;

    @PostMapping("/register")
    public ResponseEntity<ExerciseReqDto> register(@RequestBody ExerciseReqDto dto){
        exerciseService.register(dto);
        return ResponseEntity.ok(dto);
    }
}
