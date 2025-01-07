package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.*;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.ExerciseRepository;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.time.LocalTime;
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


    public CreateResDto create(CreateReqDto dto) {
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

        return CreateResDto.builder()
                .category(exercise.getCategory())
                .startTime(exercise.getStartTime())
                .endTime(exercise.getEndTime())
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .build();
    }

    public GetByDateResDto getExerciseByDate(GetByDateReqDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        LocalDate date = dto.getDate();

        List<Exercise> exercises = exerciseRepository.findByWriterAndDate(user, date);

        // 결과 변환
        return GetByDateResDto.builder()
                .exercises(exercises.stream()
                        .map(exercise -> GetByDateResDto.ExerciseDto.builder()
                                .id(exercise.getId())
                                .category(exercise.getCategory())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }

    public GetDetailsResDto getExerciseDetails(long id) throws AccessDeniedException {
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("해당 운동 정보가 없습니다."));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        if (!exercise.getWriter().equals(user)) {
            throw new AccessDeniedException("조회할 권한이 없습니다.");
        }

        return GetDetailsResDto.builder()
                .id(exercise.getId())
                .category(exercise.getCategory())
                .createTime(LocalDate.from(exercise.getCreateTime()))
                .startTime(LocalTime.from(exercise.getStartTime()))
                .endTime(LocalTime.from(exercise.getEndTime()))
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .build();

    }


    public UpdateDto update(UpdateDto dto) throws AccessDeniedException{
        Exercise exercise = exerciseRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalStateException("해당 운동 정보가 없습니다."));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        if (!exercise.getWriter().equals(user)) {
            throw new AccessDeniedException("조회할 권한이 없습니다.");
        }

        if(dto.getCategory() != null){
            exercise.setCategory(dto.getCategory());
        }
        if(dto.getStartTime() != null){
            exercise.setStartTime(dto.getStartTime());
        }
        if(dto.getEndTime() != null){
            exercise.setEndTime(dto.getEndTime());
        }
        if(dto.getDescription() != null){
            exercise.setDescription(dto.getDescription());
        }
        if(dto.getRating() != null){
            exercise.setRating(dto.getRating());
        }
        exerciseRepository.save(exercise);
        return UpdateDto.builder()
                .id(exercise.getId())
                .category(exercise.getCategory())
                .startTime(LocalTime.from(exercise.getStartTime()))
                .endTime(LocalTime.from(exercise.getEndTime()))
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .build();
    }

    public void delete(long id) throws AccessDeniedException{
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("해당 운동 정보가 없습니다."));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        if (!exercise.getWriter().equals(user)) {
            throw new AccessDeniedException("조회할 권한이 없습니다.");
        }
        exerciseRepository.deleteById(id);
    }
}
