package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
@RequestMapping("/trainer")
public class TrainerController {

    /** 트레이너 스케줄 페이지 */
    @GetMapping("/schedule")
    public String showSchedule(
            @SessionAttribute("trainerId") Integer trainerId, // DevSessionAdvice가 보장
            Model model
    ) {
        model.addAttribute("trainerId", trainerId);
        return "trainer/schedule";
    }

    /** 트레이너 회원관리 페이지 */
    @GetMapping("/members")
    public String trainerMembersPage(
            @SessionAttribute("trainerId") Integer trainerId, // DevSessionAdvice가 보장
            Model model
    ) {
        model.addAttribute("trainerId", trainerId);
        return "trainer/members";
    }
}
