package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/trainer")
public class TrainerController {

	// ======================================================================
	// [Trainer] 스케줄 기본 페이지
	// - Endpoint : GET /trainer/schedule
	// - View     : /WEB-INF/views/trainer/schedule.jsp
	// - 사용처    : 트레이너가 근무시간/예약 현황을 보는 메인 화면
	// ======================================================================
	@GetMapping("/schedule")
	public String showSchedulePage() {
		// /WEB-INF/views/trainer/schedule.jsp 로 포워딩
		return "trainer/schedule"; // 뷰 리졸버가 prefix/suffix 붙여 렌더링
	}

	// ======================================================================
	// [Trainer] 근무시간 등록 모달(페이지)
	// - Endpoint : GET /trainer/schedule-insert
	// - Query    : date=YYYY-MM-DD (예: 2025-07-09)  ← 필요 시 프론트에서 붙여 호출
	// - View     : /WEB-INF/views/trainer/schedule-insert.jsp
	// - 사용처    : 특정 날짜의 근무시간을 추가/수정하는 모달 콘텐츠
	// ======================================================================
	@GetMapping("/schedule-insert")
	public String showScheduleInsert() {
		// /WEB-INF/views/trainer/schedule-insert.jsp 로 포워딩
		return "trainer/schedule-insert"; // 날짜는 쿼리 파라미터로 JSP에서 사용
	}

}
