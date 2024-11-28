package com.exercise_calendar.exercise_calendar.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserProfileDTO {
    private String username;
    private String email;
    private String name;
}
