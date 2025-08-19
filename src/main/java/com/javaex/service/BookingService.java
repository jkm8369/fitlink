package com.javaex.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javaex.repository.BookingRepository;

/**
 * Service = 화면 요구를 달성하기 위해 Repository들을 조합하고 검증/계산/트랜잭션을 담당.
 */
@Service
public class BookingService {

	private final BookingRepository repo;

	public BookingService(BookingRepository repo) {
		this.repo = repo;
	}

	/**
	 * [슬롯 조회] - 파라미터: memberId(로그인 회원 ID), dateStr("YYYY-MM-DD") - 처리 순서: (1) 회원의
	 * 담당 트레이너 찾기 (2) 근무칸(시간, avail_id) 목록 가져오기 (3) 이미 예약된 근무칸(avail_id) 목록 가져오기 (4)
	 * 06~22시 루프를 돌면서, 각 시간의 상태를 만들어 "slots" 리스트로 구성 - 반환: { ok, date, trainerId,
	 * slots:[{hour, availabilityId, status}...] }
	 */
	public Map<String, Object> getSlots(int memberId, String dateStr) {
		// --- (0) 날짜 문자열 형식 빠른 검증 ---
		// "YYYY-MM-DD" 형식이 아니면 바로 에러를 돌려줍니다.
		if (!isValidYmd(dateStr)) {
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "날짜 형식이 올바르지 않습니다. (예: 2025-07-09)");
			return err;
		}

		// --- (1) 담당 트레이너 찾기 (회원 1명 ↔ 트레이너 1명 전제) ---
		Integer trainerId = repo.selectTrainerIdByMemberId(memberId);
		if (trainerId == null) {
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "담당 트레이너가 없습니다.");
			return err;
		}

		// --- (2) 날짜 파싱 (LocalDate 사용 X) ---
		// valueOf("YYYY-MM-DD") 만 쓰면 끝. 가장 쉬운 방법입니다.
		Date workDate = Date.valueOf(dateStr);

		// --- (3) 근무칸(시간, avail_id) 조회 ---
		// working 의 각 행은 {"hour": Integer, "availabilityId": Integer} 형태의 맵입니다.
		List<Map<String, Object>> working = repo.selectSlotsByTrainerAndDate(trainerId, workDate);

		// --- (4) 이미 예약된 근무칸(avail_id)들 조회 → Set 으로 보관 ---
		List<Integer> bookedList = repo.selectBookedAvailabilityIds(trainerId, workDate);
		Set<Integer> booked = new HashSet<Integer>();
		if (bookedList != null)
			booked.addAll(bookedList);

		// --- (5) 빠른 조회를 위해 hour → availabilityId 매핑 테이블 만들기 ---
		// (Stream/람다 안 쓰고 for문으로 안전하게)
		Map<Integer, Integer> hourToAvailId = new HashMap<Integer, Integer>();
		if (working != null) {
			for (Map<String, Object> row : working) {
				Integer hour = toInt(row.get("hour"));
				Integer availId = toInt(row.get("availabilityId"));
				if (hour != null && availId != null) {
					hourToAvailId.put(hour, availId);
				}
			}
		}

		// --- (6) 06~22 시간대 루프 돌며 결과 슬롯 구성 ---
		List<Map<String, Object>> slots = new ArrayList<Map<String, Object>>();
		for (int h = 6; h <= 22; h++) {
			Integer availId = hourToAvailId.get(h);

			Map<String, Object> slot = new HashMap<String, Object>();
			slot.put("hour", h); // 화면에서 "HH:00"로 표시할 숫자
			slot.put("availabilityId", availId);

			if (availId == null) {
				// 근무칸 자체가 없음 → BLOCKED(선택 불가)
				slot.put("status", "BLOCKED");
			} else if (booked.contains(availId)) {
				// 근무칸은 있지만 이미 예약됨 → BOOKED(선택 불가)
				slot.put("status", "BOOKED");
			} else {
				// 근무칸이 있고 예약도 안 됨 → AVAILABLE(선택 가능)
				slot.put("status", "AVAILABLE");
			}
			slots.add(slot);
		}

		// --- (7) 최종 응답 맵 구성 (Map.of 안 씀: JDK8 호환) ---
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("ok", true);
		res.put("date", dateStr);
		res.put("trainerId", trainerId);
		res.put("slots", slots);
		return res;
	}

	/**
	 * [예약 - 단건] (라디오 방식 또는 한 칸만 허용) - availabilityId 하나만 받아 예약 저장 - DB 제약에 의해: ·
	 * 근무시간 외(FK 실패) → 예외 · 중복 예약(UNIQUE(availability_id)) → 예외
	 */
	@Transactional
	public Map<String, Object> reserveOne(int memberId, int availabilityId, String memo) {
		try {
			int n = repo.insertReservation(memberId, availabilityId, memo); // 성공 시 1
			Map<String, Object> ok = new HashMap<String, Object>();
			ok.put("ok", n == 1);
			return ok;
		} catch (DuplicateKeyException e) {
			// UNIQUE(availability_id) 충돌 → 이미 누군가 예약
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "이미 예약된 시간입니다.");
			return err;
		} catch (DataIntegrityViolationException e) {
			// FK 실패 → 근무시간 외
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "근무시간 이외에는 예약할 수 없습니다.");
			return err;
		}
	}

	/**
	 * [예약 - 여러 개] (체크박스 여러 칸 한 번에) - availabilityIds 리스트를 받아 일괄 INSERT - 모두 성공해야
	 * true로 간주 (개수 비교)
	 */
	@Transactional
	public Map<String, Object> reserveBulk(int memberId, List<Integer> availabilityIds, String memo) {
		if (availabilityIds == null || availabilityIds.isEmpty()) {
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "선택된 시간이 없습니다.");
			return err;
		}
		try {
			int n = repo.insertReservationBatch(memberId, availabilityIds, memo);
			Map<String, Object> ok = new HashMap<String, Object>();
			ok.put("ok", n == availabilityIds.size()); // 모두 성공했는지 확인
			return ok;
		} catch (DuplicateKeyException e) {
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "선택한 시간 중 이미 예약된 시간이 있습니다.");
			return err;
		} catch (DataIntegrityViolationException e) {
			Map<String, Object> err = new HashMap<String, Object>();
			err.put("ok", false);
			err.put("msg", "근무시간 이외의 시간이 포함되어 있습니다.");
			return err;
		}
	}

	// ===================== 유틸 메서드 =====================

	/** "YYYY-MM-DD" 간단 형식 체크(정규식). 숫자 자릿수만 확인(존재하지 않는 날짜 검증은 생략). */
	private static boolean isValidYmd(String s) {
		if (s == null)
			return false;
		return s.matches("^\\d{4}-\\d{2}-\\d{2}$");
	}

	/** Object → Integer 안전 변환 (Integer/Long/문자열 모두 처리) */
	private static Integer toInt(Object obj) {
		if (obj == null)
			return null;
		if (obj instanceof Integer)
			return (Integer) obj;
		if (obj instanceof Long)
			return ((Long) obj).intValue();
		try {
			return Integer.valueOf(String.valueOf(obj));
		} catch (Exception e) {
			return null;
		}
	}
}
