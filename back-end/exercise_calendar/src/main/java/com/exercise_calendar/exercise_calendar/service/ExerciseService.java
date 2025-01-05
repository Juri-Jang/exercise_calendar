package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.ExerciseReqDto;
import com.exercise_calendar.exercise_calendar.dto.ExerciseResDto;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.ExerciseRepository;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ExerciseService {
    @Autowired
    private ExerciseRepository exerciseRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    public User getUser(String username){
        Optional<User> user = userRepository.findByUsername(username);
        if(user.isPresent()){
            return user.get();
        }else{
            throw new UsernameNotFoundException("User not found");
        }
    }

    public ExerciseResDto create(ExerciseReqDto dto) {
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
        return ExerciseResDto.builder()
                .category(exercise.getCategory())
                .startTime(exercise.getStartTime())
                .endTime(exercise.getEndTime())
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .build();
    }

}
