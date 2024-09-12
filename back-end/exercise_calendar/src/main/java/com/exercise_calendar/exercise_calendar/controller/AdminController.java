package com.exercise_calendar.exercise_calendar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@ResponseBody //특정 문자열 반환하는 컨트롤러
public class AdminController {

    @GetMapping("/admin")
    public String adminP(){
        return "admin contorller";
    }

}
