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

/**
 * ✅ 뷰 컨트롤러(View Controller) - JSP(화면 파일)의 경로를 반환하는 컨트롤러입니다. - 여기서는 "페이지 이동"만
 * 담당하고, 데이터(JSON) 응답은 하지 않습니다.
 */
@Controller
@RequestMapping("/member")
public class MemberController {

	private final BookingService bookingService;

	public MemberController(BookingService bookingService) {
		this.bookingService = bookingService;
	}

	/** 상단 달력 + 하단 리스트 페이지 */
	@GetMapping("/booking-status")
	public String showBookingStatus(HttpSession session, Model model) {
		// [개발용 임시 로그인] 운영에서는 제거
		if (session.getAttribute("LOGIN_USER_ID") == null) {
			session.setAttribute("LOGIN_USER_ID", 1);
		}
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");

		// 공용 VO(ScheduleRowVO)로 회원의 예약 리스트 조회 (name=트레이너 이름)
		List<ScheduleRowVO> rows = bookingService.listRowsForMember(memberId);
		model.addAttribute("rows", rows); // ★ JSP에서 items="${rows}" 사용
		
		return "member/booking-status";
	}

	/**
	 * 모달(iframe) 페이지 - /member/booking-insert?date=YYYY-MM-DD
	 */
	@GetMapping("/booking-insert")
	public String showBookingInsertPage(@RequestParam(name = "date", required = false) String date, HttpSession session,
			Model model) {

		if (session.getAttribute("LOGIN_USER_ID") == null) {
			session.setAttribute("LOGIN_USER_ID", 1);
		}

		if (date == null || date.isBlank()) {
			String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
			return "redirect:/member/booking-insert?date=" + today;
		}

		model.addAttribute("date", date);
		return "member/booking-insert";
	}
}
