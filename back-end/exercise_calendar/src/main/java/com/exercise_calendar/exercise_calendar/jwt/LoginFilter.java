package com.exercise_calendar.exercise_calendar.jwt;

import com.exercise_calendar.exercise_calendar.dto.CustomUserDetails;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.InputStream;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;

    public LoginFilter(AuthenticationManager authenticationManager, JWTUtil jwtUtil) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
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


    //로그인 성공 (JWT 발급)
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) {

        //UserDetails
        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();

        String username = customUserDetails.getUsername();

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
        GrantedAuthority auth = iterator.next();

        String role = auth.getAuthority();

        String token = jwtUtil.createJwt(username, role, 60*60*10L); //jwt 생성
        System.out.println("JWT Token: " + token); // JWT 토큰을 로그로 출력

        response.addHeader("Authorization", "Bearer " + token);//Bearer 접두사 꼭 붙여야함

    }

    //로그인 실패
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) {
        response.setStatus(401);
    }
}