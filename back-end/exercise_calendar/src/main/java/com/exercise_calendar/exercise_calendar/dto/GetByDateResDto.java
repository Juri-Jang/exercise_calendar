package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class GetByDateResDto {
    private List<ExerciseDto> exercises;

    @Data
    @Builder
    public static class ExerciseDto {
        private long id;
        private String category;
    }
}
