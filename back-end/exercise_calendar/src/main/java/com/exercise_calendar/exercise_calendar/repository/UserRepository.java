package com.exercise_calendar.exercise_calendar.repository;

import com.exercise_calendar.exercise_calendar.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository  extends JpaRepository<User, Integer> {

}
