package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
@Builder
public class GetAllResDto {
    private List<GetAllResDto.ExerciseDto> exercises;

    @Data
    @Builder
    public static class ExerciseDto {
        private Long id;
        private String category;
        private LocalTime startTime;
        private LocalTime endTime;
        private String description;
        private int rating;
        private LocalDate date;
    }
}
