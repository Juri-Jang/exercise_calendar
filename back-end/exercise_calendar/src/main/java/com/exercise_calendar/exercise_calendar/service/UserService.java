package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    public String saveUser(User user) {
        userRepository.save(user);
        return "회원가입이 성공적으로 되었습니다.";
    }
}
