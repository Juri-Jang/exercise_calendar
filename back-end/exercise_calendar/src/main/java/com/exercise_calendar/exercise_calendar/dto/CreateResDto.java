package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
public class CreateResDto {
    private Long id;
    private String category;
    private LocalTime startTime;
    private LocalTime endTime;
    private String description;
    private int rating;
    private LocalDate date;
}
