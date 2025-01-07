package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.*;
import com.exercise_calendar.exercise_calendar.service.ExerciseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/exercise")
public class ExerciseController {
    @Autowired
    private ExerciseService exerciseService;

    @PostMapping("/create")
    public ResponseEntity<?> register(@RequestBody CreateReqDto dto) {
        try {
            CreateResDto exercise = exerciseService.create(dto);
            return ResponseEntity.status(HttpStatus.OK).body(exercise);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }

    @GetMapping("/getByDate")
    public ResponseEntity<?> getExerciseByDate(@RequestParam LocalDate date) {
        try {
            GetByDateReqDto dto = GetByDateReqDto.builder().date(date).build();
            GetByDateResDto response = exerciseService.getExerciseByDate(dto);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }

    @GetMapping("/details/{id}")
    public ResponseEntity<?> getExerciseDetails(@PathVariable Long id) {
        try{
            GetDetailsResDto response = exerciseService.getExerciseDetails(id);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }
}
