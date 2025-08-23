package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookingController {
	
    /** 회원 예약 페이지 */
    @GetMapping("/member/booking")
    public String memberBookingPage(HttpSession session, Model model) {
        if (session.getAttribute("memberId") == null) {
            session.setAttribute("memberId", 6); // 개발용
        }
        model.addAttribute("memberId", session.getAttribute("memberId"));
        return "member/booking"; // /WEB-INF/views/member/booking.jsp
    }
   
}
