package com.exercise_calendar.exercise_calendar.jwt;

import com.exercise_calendar.exercise_calendar.entity.Refresh;
import com.exercise_calendar.exercise_calendar.repository.RefreshRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.InputStream;
import java.util.*;

public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;
    private final RefreshRepository refreshRepository;

    public LoginFilter(AuthenticationManager authenticationManager, JWTUtil jwtUtil, RefreshRepository refreshRepository) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.refreshRepository = refreshRepository;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        String username = null;
        String password = null;

        if ("application/json".equals(request.getContentType())) {
            // JSON 형태의 요청 처리
            try {
                InputStream inputStream = request.getInputStream();
                ObjectMapper objectMapper = new ObjectMapper();
                Map<String, String> credentials = objectMapper.readValue(inputStream, Map.class);

                username = credentials.get("username");
                password = credentials.get("password");

                System.out.println("JSON 요청 - 로그인 시도: " + username + " / " + password);

            } catch (IOException | java.io.IOException e) {
                throw new AuthenticationServiceException("로그인 요청 중 JSON 처리 에러", e);
            }
        } else {
            // 기존 방식 (form-data 등) 처리
            username = obtainUsername(request);
            password = obtainPassword(request)  ;
            System.out.println("폼 요청 - 로그인 시도: " + username + " / " + password);
        }

        // 스프링 시큐리티에서 username과 password를 검증하기 위해서는 token에 담아야 함
        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(username, password, null);

        // token을 통해 인증 매니저에게 인증 요청
        return authenticationManager.authenticate(authToken);
    }


    // 로그인 성공 (JWT 발급)
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) throws java.io.IOException {
        //유저 정보
        String username = authentication.getName();

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
        GrantedAuthority auth = iterator.next();
        String role = auth.getAuthority();

        //토큰 생성
        String access = jwtUtil.createJwt("access", username, role, 600000L); //10분
        String refresh = jwtUtil.createJwt("refresh", username, role, 86400000L); //24시간

        //Refresh 토큰 저장
        addRefreshEntity(username, refresh, 86400000L);

        //응답 설정
        response.setHeader("access", access); //응답 헤더에 설정
        response.addCookie(createCookie("refresh", refresh)); //응답 쿠키에 설정
        response.setStatus(HttpStatus.OK.value());
    }


    //로그인 실패
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws java.io.IOException {
        response.getWriter().write("{\"message\":\"fail\"}");
        response.setStatus(401);
    }

    private void addRefreshEntity(String username, String refresh, Long expiredMs) {

        Date date = new Date(System.currentTimeMillis() + expiredMs);

        Refresh refreshEntity = new Refresh();
        refreshEntity.setUsername(username);
        refreshEntity.setRefresh(refresh);
        refreshEntity.setExpiration(date.toString());

        refreshRepository.save(refreshEntity);
    }

    private Cookie createCookie(String key, String value) {

        Cookie cookie = new Cookie(key, value);
        cookie.setMaxAge(24*60*60);
        //cookie.setSecure(true);
        //cookie.setPath("/");
        cookie.setHttpOnly(true);

        return cookie;
    }
}