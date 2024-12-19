package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.model.Role;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

//    // ID 중복 확인
    public boolean isUseridTaken(String username){
        if(userRepository.findByUsername(username).isPresent()){
            System.out.println("중복된 아이디가 존재합니다.");
            return true;
        }else{
            System.out.println("중복 검사를 완료 했습니다.");
            return false;
        }
    }

    // 회원가입 로직
    public String registerUser(User user) {
        //비밀번호를 암호화하여 저장
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword); // 암호화된 비밀번호를 사용자 객체에 설정
        user.setRole(Role.USER);
        //DB에 사용자 정보 저장
        userRepository.save(user);
        return "회원가입이 성공적으로 되었습니다.";
    }

}
