package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.dto.*;
import com.exercise_calendar.exercise_calendar.service.ExerciseService;
import org.hibernate.sql.Update;
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

    //운동 전체 조회
    @GetMapping("/getAll/{username}")
    public ResponseEntity<?> getAllExercises(@PathVariable String username, @RequestParam String sortBy) {
        try {
            GetAllResDto response = exerciseService.getAllExercises(username, sortBy);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }

    //날짜별 운동 조회
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

    //운동 상세 조회
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

    @PatchMapping("/update/{id}")
    public ResponseEntity<?> updateExercise(@PathVariable long id, @RequestBody UpdateDto dto){
        try{
            UpdateDto response = exerciseService.update(dto);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteExercise(@PathVariable Long id) {
        try{
            exerciseService.delete(id);
            return ResponseEntity.status(HttpStatus.OK).body("삭제가 완료 됐습니다.");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 에러가 발생했습니다.");
        }
    }
}
