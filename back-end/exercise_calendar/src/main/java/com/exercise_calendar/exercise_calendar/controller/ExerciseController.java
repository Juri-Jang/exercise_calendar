package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.ExerciseReqDto;
import com.exercise_calendar.exercise_calendar.dto.ExerciseResDto;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.service.ExerciseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

    @PostMapping("/create")
    public ResponseEntity<?> register(@RequestBody ExerciseReqDto dto) {
        try {
            ExerciseResDto exercise = exerciseService.create(dto);
            return ResponseEntity.status(HttpStatus.OK).body(exercise);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }
}
