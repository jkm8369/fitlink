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
@RequestMapping("/trainer")
public class TrainerController {

	private final TrainerScheduleService trainerScheduleService;

	@Autowired
	public TrainerController(TrainerScheduleService trainerScheduleService) {
		this.trainerScheduleService = trainerScheduleService;
	}

	/** 트레이너 스케줄 페이지 */
	@GetMapping("/schedule")
	public String showSchedule(HttpSession session, Model model) {
		if (session.getAttribute("trainerId") == null) {
			session.setAttribute("trainerId", 5); // 개발용
		}
		model.addAttribute("trainerId", session.getAttribute("trainerId"));
		return "trainer/schedule";
	}

	/** 트레이너 회원관리 페이지 */
	@GetMapping("/members")
	public String trainerMembersPage(HttpSession session, Model model) {
		if (session.getAttribute("trainerId") == null) {
			session.setAttribute("trainerId", 5);
		}
		model.addAttribute("trainerId", session.getAttribute("trainerId"));
		return "trainer/members";
	}

	/** 근무시간 등록 페이지(두번째 모달 전용 뷰라면 유지/미사용이면 제거 가능) */
	@GetMapping("/schedule/insert")
	public String showScheduleInsertPage() {
		return "schedule-insert";
	}
}
