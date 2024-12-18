package com.exercise_calendar.exercise_calendar.entity;

import com.exercise_calendar.exercise_calendar.model.Role;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String username;
    private String password;
    private String name;
    private String email;

    @Enumerated(EnumType.STRING)
    private Role role = Role.USER;  // 기본 역할 설정
}
