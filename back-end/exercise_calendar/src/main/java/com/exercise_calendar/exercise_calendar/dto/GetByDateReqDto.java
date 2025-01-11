package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
public class GetByDateReqDto {
    private LocalDate date;
}
