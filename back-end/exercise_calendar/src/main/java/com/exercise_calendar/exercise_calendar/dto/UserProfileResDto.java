package com.exercise_calendar.exercise_calendar.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserProfileResDto {
    private String username;
    private String email;
    private String name;
}
