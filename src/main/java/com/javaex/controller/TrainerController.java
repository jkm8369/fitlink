package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/trainer")
public class TrainerController {

	// 스케줄 기본 페이지
	@GetMapping("/schedule")
	public String showSchedulePage() {
		// /WEB-INF/views/trainer/schedule.jsp
		return "trainer/schedule";
	}

	// 근무시간 모달(페이지)
	// 예: /trainer/schedule-insert?date=YYYY-MM-DD
	@GetMapping("/schedule-insert")
	public String showScheduleInsert() {
		// /WEB-INF/views/trainer/schedule-insert.jsp
		return "trainer/schedule-insert";
	}

}
