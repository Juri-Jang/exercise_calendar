package com.exercise_calendar.exercise_calendar.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateReqDto {
    private String category;
    private LocalTime startTime;
    private LocalTime endTime;
    private String description;
    private int rating;
    private LocalDate date;

}
