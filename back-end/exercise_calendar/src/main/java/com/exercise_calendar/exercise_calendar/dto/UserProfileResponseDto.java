package com.exercise_calendar.exercise_calendar.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
public class UserProfileResponseDto {
    private String username;
    private String email;
    private String name;

    public UserProfileResponseDto(String username, String email, String name) {
        this.username = username;
        this.email = email;
        this.name = name;
    }
}
