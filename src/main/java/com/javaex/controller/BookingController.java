package com.javaex.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.BookingService;

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
}
