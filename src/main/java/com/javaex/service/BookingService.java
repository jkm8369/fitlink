package com.javaex.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.javaex.repository.BookingRepository;

/**
 * BookingService - 회원 예약/조회 비즈니스 로직 담당 - 대부분 Repository 호출만 감싸는 얇은 계층
 */
@Service
public class BookingService {
	private final BookingRepository repo;
	private final UserService userService; // ✅ 담당 트레이너 조회용

	public BookingService(BookingRepository repo, UserService userService) { // ✅ 생성자에 추가
		this.repo = repo;
		this.userService = userService;
	}

	/** 달력에 표시할 내 예약 이벤트 조회 */
	public List<Map<String, Object>> myEvents(int memberId, String start, String end) {
		return repo.selectMyCalendarEvents(memberId, start, end);
	}

	/** 담당 트레이너의 특정일 슬롯 조회 (모달 버튼 상태용) */
	public List<Map<String, Object>> daySlots(int trainerId, String date) {
		return repo.selectSlotsByTrainerAndDate(trainerId, date);
	}

	/** ✅ 내 PT 리스트 조회 (총/사용/잔여 계산해서 필드 주입) */
	public List<Map<String, Object>> myPtList(int memberId) {
		// 1) 기본 리스트 (예약 내역)
		List<Map<String, Object>> rows = repo.selectMyPtList(memberId);

		// 2) 담당 트레이너 찾기 (없으면 그대로 반환)
		Map<String, Object> tr = userService.selectTrainerByMemberId(memberId);
		if (tr == null || tr.get("trainerId") == null) {
			return rows; // 담당 미배정: 화면은 '-'로 표시됨
		}
		int trainerId = ((Number) tr.get("trainerId")).intValue();

		// 3) DB에서 총 세션(최근 계약 1건)과 사용(예약 수) 가져와 계산
		Integer total = repo.findTotalSessions(memberId, trainerId); // null 가능
		if (total == null)
			total = 0;

		int used = repo.countMemberReservations(memberId, trainerId); // BOOKED/COMPLETED 수
		int remain = Math.max(total - used, 0);

		// 4) 화면에서 쓰는 키로 각 행에 주입
		for (Map<String, Object> row : rows) {
			row.put("totalSessions", total);
			row.put("completedCount", used);
			row.put("remainingCount", remain);
		}
		return rows;
	}

	/** 예약 생성 */
	public void book(int memberId, int availabilityId) {
		repo.insertReservation(memberId, availabilityId);
	}

	/** 예약 취소 */
	public void cancel(int memberId, int reservationId) {
		repo.deleteReservation(memberId, reservationId);
	}
}
