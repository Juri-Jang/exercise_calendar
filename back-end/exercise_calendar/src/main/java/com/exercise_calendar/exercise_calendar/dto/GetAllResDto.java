package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class GetAllResDto {
    private List<GetAllResDto.ExerciseDto> exercises;

    @Data
    @Builder
    public static class ExerciseDto {
        private long id;
        private String category;
        private LocalDate date;
        private Integer rating;
    }
}
