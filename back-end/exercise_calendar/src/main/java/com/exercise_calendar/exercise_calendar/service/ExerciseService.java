package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.createReqDto;
import com.exercise_calendar.exercise_calendar.dto.createResDto;
import com.exercise_calendar.exercise_calendar.dto.exerciseByDateReqDto;
import com.exercise_calendar.exercise_calendar.dto.exerciseByDateResDto;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.ExerciseRepository;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExerciseService {
    @Autowired
    private ExerciseRepository exerciseRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CustomUserDetailsService  customUserDetailsService;


    public createResDto create(createReqDto dto) {
        // SecurityContext에서 현재 로그인한 사용자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        // Exercise 엔티티 생성 시 로그인한 사용자 정보 설정
        Exercise exercise = new Exercise();
        exercise.setWriter(user);  // Exercise 엔티티의 writer에 로그인한 사용자 정보 설정
        exercise.setCategory(dto.getCategory());
        exercise.setStartTime(dto.getStartTime());
        exercise.setEndTime(dto.getEndTime());
        exercise.setDescription(dto.getDescription());
        exercise.setRating(dto.getRating());

        exerciseRepository.save(exercise);

        return createResDto.builder()
                .category(exercise.getCategory())
                .startTime(exercise.getStartTime())
                .endTime(exercise.getEndTime())
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .build();
    }

    public exerciseByDateResDto getExerciseByDate(exerciseByDateReqDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        LocalDate date = dto.getDate();

        List<Exercise> exercises = exerciseRepository.findByWriterAndDate(user, date);

        // 결과 변환
        return exerciseByDateResDto.builder()
                .exercises(exercises.stream()
                        .map(exercise -> exerciseByDateResDto.ExerciseDto.builder()
                                .id(exercise.getId())
                                .category(exercise.getCategory())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }

}
