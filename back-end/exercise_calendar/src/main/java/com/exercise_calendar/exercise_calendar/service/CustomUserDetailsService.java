package com.exercise_calendar.exercise_calendar.service;

import com.exercise_calendar.exercise_calendar.dto.CustomUserDetails;
import com.exercise_calendar.exercise_calendar.dto.UserProfileResDto;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // DB에서 사용자 조회
        User userData = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with userid: " + username));
        return new CustomUserDetails(userData);
    }


    // 사용자 조회 - User 객체 반환
    private User getUserByUsername(String username) {
        UserDetails userDetails = loadUserByUsername(username);
        if (userDetails instanceof CustomUserDetails) {
            return ((CustomUserDetails) userDetails).getUser();
        }
        throw new IllegalArgumentException("Invalid user type");
    }


    // 사용자 로그인 조회
    public User getUser(String username) {
        UserDetails userData = loadUserByUsername(username);

        if (userData instanceof CustomUserDetails) {
            CustomUserDetails customUserDetails = (CustomUserDetails) userData;
            return customUserDetails.getUser();  // User 객체 반환
        }
        throw new IllegalArgumentException("Invalid user type");
    }

    //사용자 프로필 조회
    public UserProfileResDto getUserProfile(String username) {
        UserDetails userData = loadUserByUsername(username);

        if (userData instanceof CustomUserDetails) {
            CustomUserDetails customUserDetails = (CustomUserDetails) userData;
            User user = customUserDetails.getUser();

            return UserProfileResDto.builder()
                    .id(user.getId())
                    .username(user.getUsername())
                    .email(user.getEmail())
                    .name(user.getName())
                    .build();
        }
        throw new IllegalArgumentException("Invalid user type");
    }
}
