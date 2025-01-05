package com.exercise_calendar.exercise_calendar.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class LoginReqDto {
    private String username;
    private String password;
}
