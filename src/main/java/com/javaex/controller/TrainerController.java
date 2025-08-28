package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/trainer")
public class TrainerController {

	/** 스케줄 페이지 */
	@GetMapping("/schedule")
	public String showSchedule(HttpSession session, Model model) {
		UserVO authUser = (UserVO) session.getAttribute("authUser");

		Integer trainerId = authUser.getUserId(); // userId를 trainerId로 사용
		model.addAttribute("trainerId", trainerId);

		return "trainer/schedule";
	}

	/** 회원관리 페이지 */
	@GetMapping("/members")
	public String membersPage(HttpSession session, Model model) {
		UserVO authUser = (UserVO) session.getAttribute("authUser");

		Integer trainerId = authUser.getUserId();
		model.addAttribute("trainerId", trainerId);

		return "trainer/members";
	}
}
