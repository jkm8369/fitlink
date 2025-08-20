package com.javaex.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.BookingService;
import com.javaex.vo.CalendarEventVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/member/booking")
public class BookingController {

	private final BookingService service;

	public BookingController(BookingService service) {
		this.service = service;
	}

	/**
	 * ✅ 슬롯 조회: 모달 열릴 때 호출 프론트: GET /api/member/booking/slots?date=2025-07-09 응답: {
	 * ok, date, trainerId, slots:[{hour, availabilityId, status}] }
	 */
	@GetMapping("/slots")
	public Map<String, Object> slots(@RequestParam String date, HttpSession session) {
		// 로그인 시 세션에 저장해둔 회원 ID를 사용한다고 가정
		// (초기 개발 중이라면 테스트용으로 임시 값을 넣어도 됩니다)
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");
		if (memberId == null) {
			// ★ 개발 중 임시: 로그인 연동 전이면 주석 해제하여 강제 세팅해도 됨
			// memberId = 101;
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");
		}
		return service.getSlots(memberId, date);
	}

	/**
	 * ✅ 단건 예약: 라디오/한 칸만 선택일 때 사용 프론트 바디: { "availabilityId": 123, "memo": "" }
	 */
	@PostMapping("/reserve")
	public Map<String, Object> reserveOne(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");
		if (memberId == null)
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");

		int availabilityId = ((Number) body.get("availabilityId")).intValue();
		String memo = (String) body.getOrDefault("memo", "");
		return service.reserveOne(memberId, availabilityId, memo);
	}

	/**
	 * ✅ 여러 개 예약: 체크박스 여러 칸 선택일 때 사용 프론트 바디: { "availabilityIds": [101,102], "memo":
	 * "" }
	 */
	@PostMapping("/reserve-bulk")
	public Map<String, Object> reserveBulk(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");
		if (memberId == null)
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");

		@SuppressWarnings("unchecked")
		List<Integer> availabilityIds = (List<Integer>) body.get("availabilityIds");
		String memo = (String) body.getOrDefault("memo", "");
		return service.reserveBulk(memberId, availabilityIds, memo);
	}

	@GetMapping({ "/events", "/bookings" })
	public Object memberEvents(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");
		if (memberId == null) {
			// 개발 중 테스트용: 필요 시 쿼리 파라미터로 임시 memberId 받게 하고 싶다면 확장 가능
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");
		}
		List<CalendarEventVO> list = service.getMemberEvents(memberId, start, end);
		return list; // 스프링이 배열(JSON)로 직렬화 → FullCalendar가 바로 읽음
	}

	// ================== [예약 취소] POST /api/member/booking/cancel ==================
	// - 본인(memberId)의 예약만 취소 가능
	// - 상태가 BOOKED 인 예약만 취소 가능
	// - 수업 시작 24시간 이전이어야 취소 가능
	// - 성공 시 {success:true}, 실패 시 {success:false, message:"사유"} 반환
	@PostMapping("/cancel")
	public Map<String, Object> cancel(@RequestBody Map<String, Object> body, HttpSession session) {
		// 1) 로그인 회원 ID 확인 (세션에서 가져옴)
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");
		if (memberId == null) {
			return Map.of("success", false, "message", "로그인이 필요합니다.");
		}

		// 2) 요청 바디에서 reservationId 읽기 (숫자로 안전 변환)
		Integer reservationId = (body.get("reservationId") instanceof Number)
				? ((Number) body.get("reservationId")).intValue()
				: null;

		if (reservationId == null) {
			return Map.of("success", false, "message", "잘못된 요청입니다.");
		}

		// 3) 서비스 호출 → DB 단에서 모든 조건(본인/BOOKED/24시간 이전) 검사 후 취소 시도
		boolean ok = service.cancelReservationForMember(reservationId, memberId);

		// 4) 결과 반환
		return ok ? Map.of("success", true) : Map.of("success", false, "message", "수업 시작 24시간 이내거나 취소할 수 없는 예약입니다.");
	}

}
