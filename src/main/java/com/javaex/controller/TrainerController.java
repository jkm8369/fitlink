package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/trainer")
public class TrainerController {

    // 공용: 세션에서 ID 보장 (if/else 버전)
    private int ensureId(HttpSession session, String who, Integer forceId) {
        boolean isTrainer = "trainer".equalsIgnoreCase(who);

        String key;
        int def;
        if (isTrainer) {
            key = "trainerId";
            def = 1; // 기본 트레이너
        } else {
            key = "memberId";
            def = 3; // 기본 회원
        }

        if (forceId != null) {
            session.setAttribute(key, forceId);
        }

        Object v = session.getAttribute(key);
        if (v instanceof Integer) {
            return (Integer) v;
        }

        session.setAttribute(key, def);
        return def;
    }

    /** 트레이너 스케줄 페이지 */
    @GetMapping("/schedule")
    public String showSchedule(@RequestParam(required = false) Integer forceId,
                               HttpSession session, Model model) {
        int trainerId = ensureId(session, "trainer", forceId);
        model.addAttribute("trainerId", trainerId);
        return "trainer/schedule";
    }

    /** 트레이너 회원관리 페이지 */
    @GetMapping("/members")
    public String trainerMembersPage(@RequestParam(required = false) Integer forceId,
                                     HttpSession session, Model model) {
        int trainerId = ensureId(session, "trainer", forceId);
        model.addAttribute("trainerId", trainerId);
        return "trainer/members";
    }
}
