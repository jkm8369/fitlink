package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
public class BookingController {

    /** 회원 예약 페이지 */
    @GetMapping("/member/booking")
    public String memberBookingPage(
            @SessionAttribute("memberId") Integer memberId, // DevSessionAdvice가 보장
            Model model
    ) {
        model.addAttribute("memberId", memberId);
        return "member/booking";
    }
}
