package com.javaex.controller;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
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

	private final BookingService service; // 비즈니스 로직 담당 서비스 빈

	public BookingController(BookingService service) {
		this.service = service; // 생성자 주입
	}

	/**
	 * [Member] 예약 슬롯 조회 (모달 오픈 시)
	 * - GET /api/member/booking/slots?date=YYYY-MM-DD
	 * - Return: { ok, date, trainerId, slots:[{ hour, availabilityId, status }] }
	 */
	@GetMapping("/slots")
	public Map<String, Object> slots(@RequestParam String date, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID"); // 세션에서 로그인 회원 ID 조회
		if (memberId == null) {                                             // 미로그인 시
			// memberId = 101; // (개발용) 필요 시 임시값 주입
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");      // 실패 응답
		}
		return service.getSlots(memberId, date);                             // 서비스에 위임하여 슬롯 조립/검증 후 반환
	}

	/**
	 * [Member] 예약 생성 (단건)
	 * - POST /api/member/booking/reserve
	 * - Body: { "availabilityId": number, "memo": string? }
	 */
	@PostMapping("/reserve")
	public Map<String, Object> reserveOne(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID"); // 세션 인증
		if (memberId == null) return Map.of("ok", false, "msg", "로그인이 필요합니다."); // 인증 실패

		int availabilityId = ((Number) body.get("availabilityId")).intValue(); // Number → int 안전 변환
		String memo = (String) body.getOrDefault("memo", "");                   // 메모는 선택값 → 기본값 ""
		return service.reserveOne(memberId, availabilityId, memo);              // 단건 예약 처리 결과 리턴
	}

	/**
	 * [Member] 예약 생성 (다건)
	 * - POST /api/member/booking/reserve-bulk
	 * - Body: { "availabilityIds": number[], "memo": string? }
	 */
	@PostMapping("/reserve-bulk")
	public Map<String, Object> reserveBulk(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");     // 세션 인증
		if (memberId == null) return Map.of("ok", false, "msg", "로그인이 필요합니다."); // 인증 실패

		@SuppressWarnings("unchecked")
		List<Integer> availabilityIds = (List<Integer>) body.get("availabilityIds"); // 선택된 슬롯 배열
		String memo = (String) body.getOrDefault("memo", "");                         // 메모 기본값 ""
		return service.reserveBulk(memberId, availabilityIds, memo);                  // 다건 예약 처리 결과 리턴
	}

	/**
	 * [Member] 내 예약 이벤트 조회 (FullCalendar)
	 * - GET /api/member/booking/events  (또는 /bookings)
	 * - Query: start=ISO8601, end=ISO8601
	 * - Return: CalendarEventVO[]
	 */
	@GetMapping({ "/events", "/bookings" })
	public Object memberEvents(
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start, // 조회 시작(포함)
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end,   // 조회 끝(미포함)
			HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID"); // 세션 인증
		if (memberId == null) {                                             // 미로그인 시
			return Map.of("ok", false, "msg", "로그인이 필요합니다.");      // 실패 응답
		}
		List<CalendarEventVO> list = service.getMemberEvents(memberId, start, end); // 기간 내 이벤트 조회
		return list;                                                                // 배열 형태 JSON으로 직렬화 → FC에서 바로 사용
	}

	/**
	 * [Member] 예약 취소
	 * - POST /api/member/booking/cancel
	 * - Body: { "reservationId": number }
	 * - Rule: 본인 예약 + 상태=BOOKED + 시작 24시간 이전
	 * - Return: { success: boolean, message?: string }
	 */
	@PostMapping("/cancel")
	public Map<String, Object> cancel(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("LOGIN_USER_ID");          // 세션 인증
		if (memberId == null) return Map.of("success", false, "message", "로그인이 필요합니다."); // 인증 실패

		Integer reservationId = (body.get("reservationId") instanceof Number)        // reservationId 존재 & 숫자인지 확인
				? ((Number) body.get("reservationId")).intValue()
				: null;
		if (reservationId == null) {                                                 // 유효성 실패
			return Map.of("success", false, "message", "잘못된 요청입니다.");
		}

		boolean ok = service.cancelReservationForMember(reservationId, memberId);    // 서비스에서 조건 검증+취소 시도
		return ok ? Map.of("success", true)                                          // 성공 응답
		          : Map.of("success", false, "message", "수업 시작 24시간 이내거나 취소할 수 없는 예약입니다."); // 실패 사유
	}

	/**
	 * [Trainer] 트레이너 달력 이벤트 조회 (FullCalendar)
	 * - GET /api/member/booking/trainer-events
	 * - Query: start=ISO8601(오프셋 포함), end=ISO8601(오프셋 포함), trainerId?(optional)
	 * - Return: CalendarEventVO[]
	 */
	@GetMapping("/trainer-events")
	public List<CalendarEventVO> trainerEvents(
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime start, // 예: 2025-08-01T00:00:00+09:00
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime end,   // 동일 형식
			HttpSession session,
			@RequestParam(value = "trainerId", required = false) Integer trainerIdParam) {
		Integer trainerId = (Integer) session.getAttribute("LOGIN_USER_ID"); // 세션의 트레이너(로그인 사용자) ID
		if (trainerId == null) trainerId = trainerIdParam;                   // 쿼리 파라미터로 대체 허용
		if (trainerId == null) return java.util.List.of();                   // 최종적으로 없으면 빈 배열 반환

		LocalDateTime s = start.toLocalDateTime();                           // OffsetDateTime → LDT (DB 로컬 기준)
		LocalDateTime e = end.toLocalDateTime();                             // 동일
		return service.getTrainerEvents(trainerId, s, e);                    // 기간 내 트레이너 이벤트 리스트 반환
	}



}
