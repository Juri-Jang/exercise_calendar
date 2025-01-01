package com.exercise_calendar.exercise_calendar.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Getter
@Setter
public class Exercise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private LocalTime startTime;

    @Column(nullable = false)
    private LocalTime endTime;

    @Column(nullable = true)
    private String description;

    @Column(nullable = false)
    private int rating;

    @CreationTimestamp
    @Column(nullable = false)
    private LocalDateTime createTime;


    public Exercise(String category, LocalTime startTime, LocalTime endTime, String description, int rating) {
        this.category = category;
        this.startTime = startTime;
        this.endTime = endTime;
        this.description = description;
        this.rating = rating;
    }


    public Exercise() {

    }
}
