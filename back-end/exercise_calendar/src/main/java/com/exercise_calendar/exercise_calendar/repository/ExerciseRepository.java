package com.exercise_calendar.exercise_calendar.repository;

import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, Long> {
    @Query("SELECT e FROM Exercise e WHERE e.writer = :user AND DATE(e.createTime) = :date")
    List<Exercise> findByWriterAndDate(@Param("user") User user, @Param("date") LocalDate date);

    @Query("SELECT e FROM Exercise e WHERE e.writer = :user")
    List<Exercise> findByUser(@Param("user") User user);
}
