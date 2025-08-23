package com.javaex.apiController;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.BookingService;
import com.javaex.service.UserService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/member/booking")
public class BookingApiController {

	private final BookingService bookingService;
	private final UserService userService;

	public BookingApiController(BookingService bookingService, UserService userService) {
		this.bookingService = bookingService;
		this.userService = userService;
	}

	/** 내 예약(달력 이벤트) */
	@GetMapping("/events")
	public List<Map<String, Object>> events(@RequestParam String start, @RequestParam String end, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("memberId");
		if (memberId == null)
			memberId = 6; // 개발용
		return bookingService.myEvents(memberId, start, end);
	}

	/** 모달: 담당 트레이너의 특정일 슬롯 조회 */
	@GetMapping("/slots/day")
	public List<Map<String, Object>> daySlots(@RequestParam String date, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("memberId");
		if (memberId == null)
			memberId = 6;

		Map<String, Object> trainer = userService.selectTrainerByMemberId(memberId);
		if (trainer == null || trainer.get("trainerId") == null) {
			return java.util.Collections.emptyList(); // 담당 미배정 시 빈 리스트
		}
		int trainerId = ((Number) trainer.get("trainerId")).intValue();
		return bookingService.daySlots(trainerId, date);
	}

	/** 내 PT 리스트(하단 표) */
	@GetMapping("/pt/list")
	public List<Map<String, Object>> ptList(HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("memberId");
		if (memberId == null)
			memberId = 6;
		return bookingService.myPtList(memberId);
	}

	/** 예약 생성 */
	@PostMapping
	public Map<String, Object> book(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("memberId");
		if (memberId == null)
			memberId = 6;
		int availabilityId = (Integer) body.get("availabilityId");
		bookingService.book(memberId, availabilityId);
		return Map.of("ok", true);
	}

	/** 예약 취소(BOOKED만) */
	@DeleteMapping("/{reservationId}")
	public Map<String, Object> cancel(@PathVariable int reservationId, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("memberId");
		if (memberId == null)
			memberId = 6;
		bookingService.cancel(memberId, reservationId);
		return Map.of("ok", true);
	}
}
