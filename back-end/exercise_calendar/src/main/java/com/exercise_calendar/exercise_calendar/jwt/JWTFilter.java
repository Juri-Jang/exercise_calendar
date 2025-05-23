package com.exercise_calendar.exercise_calendar.jwt;

import com.exercise_calendar.exercise_calendar.dto.CustomUserDetails;
import com.exercise_calendar.exercise_calendar.entity.User;
import com.exercise_calendar.exercise_calendar.model.Role;
import com.exercise_calendar.exercise_calendar.repository.UserRepository;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.io.PrintWriter;

public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;


    public JWTFilter(JWTUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException{
        // 헤더에서 access키에 담긴 토큰을 꺼냄
        String accessToken = request.getHeader("access");

                // 토큰이 없다면 다음 필터로 넘김
                // 토큰이 담기지 않았다는 것은 인증이 필요한 요청이 아닐 수 있기 때문
                if (accessToken == null) {

                    filterChain.doFilter(request, response);

                    return;
                }

                // 토큰 만료 여부 확인, 만료시 다음 필터로 넘기지 않음
                try {
                    jwtUtil.isExpired(accessToken);
                } catch (ExpiredJwtException e) {

                    //response body
                    PrintWriter writer = response.getWriter();
                    writer.print("access token expired");

                    //response status code
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                // 토큰이 access인지 확인 (발급시 페이로드에 명시)
                String category = jwtUtil.getCategory(accessToken);

                if (!category.equals("access")) {

                    //response body
                    PrintWriter writer = response.getWriter();
                    writer.print("invalid access token");

                    //response status code
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    return;
                }

                // username, role 값을 획득
                String username = jwtUtil.getUsername(accessToken);
                String role = jwtUtil.getRole(accessToken);

                // username을 통해 User 객체 조회
                User userEntity = new User();
                userEntity.setUsername(username);
                userEntity.setRole(Role.valueOf(role));
                CustomUserDetails customUserDetails = new CustomUserDetails(userEntity);


                Authentication authToken = new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(authToken);

                filterChain.doFilter(request, response);
    }
}
