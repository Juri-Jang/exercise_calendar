package com.exercise_calendar.exercise_calendar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:3000", "http://yourdomain.com") // 명시적으로 허용할 도메인을 지정
                .allowedOriginPatterns("http://*.yourdomain.com") // 또는 패턴으로 허용할 도메인을 설정
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowCredentials(true); // 자격 증명을 허용
    }
}
