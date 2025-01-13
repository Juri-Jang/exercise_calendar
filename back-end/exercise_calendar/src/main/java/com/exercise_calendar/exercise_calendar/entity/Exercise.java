package com.exercise_calendar.exercise_calendar.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Getter
@Setter
public class Exercise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(fetch = FetchType.LAZY) //지연 로딩 방식
    @JoinColumn(name = "writer_id", nullable = false)
    private User writer;

    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private LocalTime startTime;

    @Column(nullable = false)
    private LocalTime endTime;

    @Column
    private String description;

    @Column(nullable = false)
    private int rating;

    @Column(nullable = false)
    private LocalDate date;

//    @CreationTimestamp
//    @Column(nullable = false, updatable = false)
//    private LocalDateTime createTime;


    public Exercise(User writer, String category, LocalTime startTime, LocalTime endTime, String description, int rating) {
        this.writer = writer;
        this.category = category;
        this.startTime = startTime;
        this.endTime = endTime;
        this.description = description;
        this.rating = rating;
    }


    public Exercise() {

    }
}
