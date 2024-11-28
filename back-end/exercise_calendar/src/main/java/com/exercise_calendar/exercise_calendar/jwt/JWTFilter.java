package com.exercise_calendar.exercise_calendar.jwt;

import com.exercise_calendar.exercise_calendar.dto.CustomUserDetails;
import com.exercise_calendar.exercise_calendar.entity.User;
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

public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;

    public JWTFilter(JWTUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        //request에서 Authorization 헤더를 찾음
        String token= request.getHeader("Authorization");

        //Autorization 헤더 검증
        //JWT 토큰 없으면 다음 필터로 이동
        if(token == null || !token.startsWith("Bearer ")) {
            System.out.println("token null");
            //토큰이 유효하지 않아 다음 필터로 값 전달
            filterChain.doFilter(request, response);

             //메소드 종료(필수)
            return;
        }
        //Bearer 제거 후 순수 토큰만 획득
        token = token.split(" ")[1];

        //토큰 만료 검증
        //JWT 만료 됐으면 다음 필터로 이동
//        if(jwtUtil.isExpired(token)){
//            System.out.println("token expired");
//            filterChain.doFilter(request, response);
//            //조건이 해당되면 메소드 종료(필수)
//            return;
//        }

        try {
            jwtUtil.isExpired(token);
        } catch (ExpiredJwtException e) {
            response.getWriter().write("access token is expired");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String category = jwtUtil.getCategory(token);

        // 카테고리 검사(access)
        if (!category.equals("access")){
            response.getWriter().write("invalid access token");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }


        //최종적으로 토큰 검증 완료
        //토큰에서 username과 role 획득
        String username = jwtUtil.getUsername(token);
        String role = jwtUtil.getRole(token);

        //검증된 user 정보 새로 생성
        //user 엔티티를 생성하여 값 셋팅
        User user = new User();
        user.setUsername(username);
        user.setPassword("temppassword"); //임시 비번
        user.setRole(role);

        //UserDetails에 검증 완료된 회원 정보 전달
        CustomUserDetails customUserDetails = new CustomUserDetails(user);

        //Spring Security 컨텍스트에 인증된 사용자 정보 저장(Security 인증 토큰 생성)
        Authentication authToken = new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());

        //세션에 사용자 등록
        SecurityContextHolder.getContext().setAuthentication(authToken);

        // 필터 체인에서 다음 필터로 이동
        //필터 체인?
        filterChain.doFilter(request, response);
    }
}
