package com.exercise_calendar.exercise_calendar.controller;

import com.exercise_calendar.exercise_calendar.entity.RefreshEntity;
import com.exercise_calendar.exercise_calendar.jwt.JWTUtil;
import com.exercise_calendar.exercise_calendar.repository.RefreshRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Calendar;
import java.util.Date;


//Rotaion전략으로, 이전 refresh token은 서버에서 지우고 새로 발급된 토큰을 다시 저장
@RestController
public class ReissueController {
    @Autowired
    JWTUtil jwtUtil;

    @Autowired
    RefreshRepository refreshRepository;

    @PostMapping("/reissue")
    public ResponseEntity reissue(HttpServletRequest request, HttpServletResponse response){

        // get refresh
        String refresh = null;
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie:cookies){
            if (cookie.getName().equals("refresh")) refresh = cookie.getValue();
        }

        // check if refresh is null
        if (refresh == null)    return new ResponseEntity("refresh token null", HttpStatus.BAD_REQUEST);

        // expired check
        if (jwtUtil.isExpired(refresh)) return new ResponseEntity("refresh token is expired", HttpStatus.BAD_REQUEST);

        // check if category is refresh
        String category = jwtUtil.getCategory(refresh);
        if (!category.equals("refresh")) return new ResponseEntity("invalid refresh token", HttpStatus.BAD_REQUEST);

        // check if refresh is valid
        if (!refreshRepository.existsByRefresh(refresh))    return new ResponseEntity("invalid refresh token", HttpStatus.BAD_REQUEST);


        // crete new access token
        String username = jwtUtil.getUsername(refresh);
        String role = jwtUtil.getRole(refresh);
        String newAccess = jwtUtil.createJwt("access", username, role, 60L);
        String newRefresh = jwtUtil.createJwt("refresh", username, role, 43200000L);

        // rotate refresh
        refreshRepository.deleteByRefresh(refresh);
        addRefresh(username, newRefresh, 12*60);


        // return response
        response.addHeader("access", newAccess);
        response.addCookie(createCookie("refresh", newRefresh));
        return new ResponseEntity(HttpStatus.OK);
    }

    protected void addRefresh(String username, String refresh, int expiredMinute){
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, expiredMinute);
        Date date = calendar.getTime();

        RefreshEntity refreshEntity = new RefreshEntity();
        refreshEntity.setUsername(username);
        refreshEntity.setRefresh(refresh);
        refreshEntity.setExpiration(date.toString());

        refreshRepository.save(refreshEntity);
    }

    Cookie createCookie(String key, String value){
        Cookie cookie = new Cookie(key, value);
        cookie.setMaxAge(12*60*60); // 12h
        cookie.setHttpOnly(true);   //JS로 접근 불가, 탈취 위험 감소
        return cookie;
    }
}