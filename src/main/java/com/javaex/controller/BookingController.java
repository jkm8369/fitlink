package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookingController {

	/** 회원 예약 페이지 */
	@GetMapping("/member/booking")
	public String memberBookingPage(HttpSession session, Model model) {
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		Integer memberId = authUser.getUserId();
		model.addAttribute("memberId", memberId);
		
		return "member/booking";
	}
}
