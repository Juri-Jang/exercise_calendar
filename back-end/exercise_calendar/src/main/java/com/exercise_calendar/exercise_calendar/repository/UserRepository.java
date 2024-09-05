package com.exercise_calendar.exercise_calendar.repository;

import com.exercise_calendar.exercise_calendar.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository  extends JpaRepository<User, Integer> {
    Optional<User> findByUserid(String userid);
}
