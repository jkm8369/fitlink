package com.javaex.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.javaex.service.BookingService;
import com.javaex.vo.ScheduleRowVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MemberController {

	private final BookingService bookingService;                 // 예약/이벤트 비즈니스 로직 서비스

	public MemberController(BookingService bookingService) {
		this.bookingService = bookingService;                    // 생성자 주입
	}

	/**
	 * [Member] 예약 현황 페이지 (상단 달력 + 하단 리스트)
	 * - GET /member/booking-status
	 * - View: /WEB-INF/views/member/booking-status.jsp
	 */
	@GetMapping("/booking-status")
	public String showBookingStatus(HttpSession session, Model model) {
		// [개발용 임시 로그인] 운영에서는 제거하거나 인증 연동으로 대체
		if (session.getAttribute("LOGIN_USER_ID") == null) {
			session.setAttribute("LOGIN_USER_ID", 1);            // 개발 편의를 위한 임시 memberId 주입
		}
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID"); // 세션에서 회원 ID 획득

		// 공용 VO(ScheduleRowVO)로 회원의 예약 리스트 조회 (name=트레이너 이름)
		List<ScheduleRowVO> rows = bookingService.listRowsForMember(memberId); // 서비스 통해 리스트 조회
		model.addAttribute("rows", rows);                      // ★ JSP에서 items="${rows}" 로 순회

		return "member/booking-status";                        // 뷰 이름 반환
	}

	/**
	 * [Member] 예약 등록 모달(iframe) 페이지
	 * - GET /member/booking-insert?date=YYYY-MM-DD
	 * - View: /WEB-INF/views/member/booking-insert.jsp
	 */
	@GetMapping("/booking-insert")
	public String showBookingInsertPage(
			@RequestParam(name = "date", required = false) String date, // 선택 날짜(없으면 오늘로 리다이렉트)
			HttpSession session,
			Model model) {

		// [개발용 임시 로그인] 운영에서는 제거
		if (session.getAttribute("LOGIN_USER_ID") == null) {
			session.setAttribute("LOGIN_USER_ID", 1);          // 임시 memberId 주입
		}

		// date 파라미터가 없거나 공백이면 오늘 날짜로 리다이렉트
		if (date == null || date.isBlank()) {
			String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()); // 오늘(로컬) 날짜 문자열
			return "redirect:/member/booking-insert?date=" + today;   // 쿼리 파라미터 보정 후 재요청
		}

		model.addAttribute("date", date);                     // JSP에서 ${date}로 사용
		return "member/booking-insert";                       // 뷰 이름 반환
	}

}
