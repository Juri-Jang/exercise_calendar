package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.ExerciseReqDto;
import com.exercise_calendar.exercise_calendar.entity.Exercise;
import com.exercise_calendar.exercise_calendar.repository.ExerciseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ExerciseService {
    @Autowired
    private ExerciseRepository exerciseRepository;

    public void register(ExerciseReqDto dto){
        Exercise exercise = new Exercise(dto.getCategory(), dto.getStartTime(), dto.getEndTime(), dto.getDescription(), dto.getRating());
        exerciseRepository.save(exercise);
    }
}
