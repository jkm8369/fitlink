package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.TrainerScheduleService;

import jakarta.servlet.http.HttpSession;

/**
 * TrainerScheduleController는 트레이너가 자신의 근무 일정과 예약 현황을 JSP 페이지로 확인하고 관리할 수 있도록 하는
 * 뷰 컨트롤러입니다.
 *
 * <p>
 * 이 컨트롤러는 단순히 뷰 이름을 리턴하며, 필요한 데이터는 서비스 계층을 통해 모델(Model)에 추가합니다. 현재는 데이터 로딩을
 * 프런트에서 AJAX로 처리할 수 있도록 최소한의 속성만 설정합니다.
 * </p>
 */
@Controller
@RequestMapping("/trainer/schedule")
public class TrainerController {

	private final TrainerScheduleService trainerScheduleService;

	@Autowired
	public TrainerController(TrainerScheduleService trainerScheduleService) {
		this.trainerScheduleService = trainerScheduleService;
	}

	/**
	 * 트레이너 일정 조회 페이지를 표시합니다. 로그인 구현 전에는 trainerId가 세션에 없을 경우 테스트용으로 1을 설정합니다.
	 */
	@GetMapping
	public String showSchedule(HttpSession session, Model model) {
		// 개발 중에는 세션에 trainerId가 없으면 임시로 1을 넣어 줍니다.
		if (session.getAttribute("trainerId") == null) {
			session.setAttribute("trainerId", 1);
		}
		Object trainerId = session.getAttribute("trainerId");
		model.addAttribute("trainerId", trainerId);
		return "trainer/schedule";
	}

	/**
	 * 근무시간 등록 페이지를 표시합니다.
	 */
	@GetMapping("/insert")
	public String showScheduleInsertPage() {
		return "schedule-insert";
	}
}
