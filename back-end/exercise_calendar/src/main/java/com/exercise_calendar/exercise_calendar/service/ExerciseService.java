package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.*;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.ExerciseRepository;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExerciseService {
    @Autowired
    private ExerciseRepository exerciseRepository;
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
        exercise.setDate(dto.getDate());

        exerciseRepository.save(exercise);

        return CreateResDto.builder()
                .id(exercise.getId())
                .category(exercise.getCategory())
                .startTime(exercise.getStartTime())
                .endTime(exercise.getEndTime())
                .description(exercise.getDescription())
                .rating(exercise.getRating())
                .date(exercise.getDate())
                .build();
    }

    /*
    전체 운동 기록 조회 (정렬 필터 적용)
    1. 최신 날짜순(latest, 기본값)
    2. 평점 높은순(highestRating)
    3. 오래된 날짜순(oldest)
    */
    public List<GetAllResDto.ExerciseDto> getAllExercises(String username, String sortBy) {
        User user = customUserDetailsService.getUser(username);
        List<Exercise> exercises = exerciseRepository.findByUser(user);

        // 정렬 조건 설정
        Comparator<Exercise> comparator;

        if ("highestRating".equals(sortBy)) {
            comparator = Comparator.comparingInt(Exercise::getRating).reversed(); // 평점 높은 순
        } else if ("oldest".equals(sortBy)) {
            comparator = Comparator.comparing(Exercise::getDate, Comparator.nullsFirst(Comparator.naturalOrder())); // 오래된 날짜 순
        } else if ("latest".equals(sortBy)) {
            comparator = Comparator.comparing(Exercise::getDate, Comparator.nullsFirst(Comparator.naturalOrder())); // 최신 날짜 순
        } else {
            // `sortBy`가 `null` 또는 예상하지 못한 값인 경우 기본 동작 설정
            throw new IllegalArgumentException("유효하지 않은 정렬 기준입니다: " + sortBy);
        }

        // 정렬 적용
        List<Exercise> sortedExercises = exercises.stream()
                .sorted(comparator)
                .collect(Collectors.toList());

        // ExerciseDto 리스트 반환
        return sortedExercises.stream()
                .map(exercise -> GetAllResDto.ExerciseDto.builder()
                        .id(exercise.getId())
                        .category(exercise.getCategory())
                        .date(exercise.getDate())
                        .rating(exercise.getRating())
                        .build())
                .collect(Collectors.toList());
    }



    //날짜별 운동 조회
    public GetByDateResDto getExerciseByDate(GetByDateReqDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = customUserDetailsService.getUser(username);

        LocalDate date = dto.getDate();

        List<Exercise> exercises = exerciseRepository.findByWriterAndDate(user, date);

        return GetByDateResDto.builder()
                .exercises(exercises.stream()
                        .map(exercise -> GetByDateResDto.ExerciseDto.builder()
                                .id(exercise.getId())
                                .category(exercise.getCategory())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }


    //운동 상세 조회
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
                .createTime(LocalDate.from(exercise.getDate()))
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
