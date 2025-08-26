package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookingController {

    // 공용: 세션에서 ID 보장 (if/else 버전)
    private int ensureId(HttpSession session, String who, Integer forceId) {
        boolean isTrainer = "trainer".equalsIgnoreCase(who);

        String key;
        int def;
        if (isTrainer) {
            key = "trainerId";
            def = 1;
        } else {
            key = "memberId";
            def = 3;
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

    /** 회원 예약 페이지 */
    @GetMapping("/member/booking")
    public String memberBookingPage(@RequestParam(required=false) Integer forceId,
                                    HttpSession session, Model model) {
        int memberId = ensureId(session, "member", forceId);
        model.addAttribute("memberId", memberId);
        return "member/booking";
    }
}
