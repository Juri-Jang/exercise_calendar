package com.exercise_calendar.exercise_calendar.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
public class ExerciseReqDto {

    private String category;
    private LocalTime startTime;
    private LocalTime endTime;
    private String description;
    private int rating;

}
