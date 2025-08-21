package com.javaex.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaex.service.ScheduleService;

@Controller
@RequestMapping("/api/trainer")
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService; // 근무시간(Availability) 비즈니스 로직을 담당하는 서비스

	// ======================================================================
	// [Trainer] 일일 근무시간 조회 API
	// - Endpoint : GET /api/trainer/{trainerId}/availability
	// - Query    : date=YYYY-MM-DD (ISO, 예: 2025-07-09)
	// - Return   : [9,10,14] 형태의 시(hour) 리스트
	// ======================================================================
	@ResponseBody
	@GetMapping("/{trainerId}/availability")
	public List<Integer> getDaily(
	        @PathVariable int trainerId,                                                     // URL 경로에서 트레이너 ID 추출
	        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {   // 쿼리스트링 date를 ISO(LocalDate)로 파싱
	    return scheduleService.getDailyHours(trainerId, date);                               // 서비스 호출 → 해당 날짜의 근무시간 목록 반환
	}

	// ======================================================================
	// [Trainer] 일일 근무시간 저장 API
	// - Endpoint : POST /api/trainer/{trainerId}/availability
	// - Body     : { "date":"2025-07-10", "hours":[9,10,14] }  (ISO 날짜 + 시 리스트)
	// - Return   : { "ok": true }
	// - 동작 개요: 해당 날짜 기존 근무칸 삭제 후, 전달된 hours로 일괄 INSERT (서비스 내부 정책에 따름)
	// ======================================================================
	@PostMapping("/{trainerId}/availability")
	@ResponseBody
	public Map<String, Object> saveDaily(
	        @PathVariable int trainerId,                                // URL 경로에서 트레이너 ID 추출
	        @RequestBody Map<String, Object> body) {                    // JSON 본문을 맵으로 수신

	    LocalDate date = LocalDate.parse((String) body.get("date"));    // "date" 문자열을 ISO 포맷으로 LocalDate 파싱 (예외 시 400 가능)
	    @SuppressWarnings("unchecked")
	    List<Integer> hours = (List<Integer>) body.get("hours");        // "hours" 배열을 Integer 리스트로 캐스팅 (널/빈 리스트는 서비스에서 처리 권장)

	    scheduleService.saveDailyHours(trainerId, date, hours);         // 서비스에 저장 위임 (예: 삭제→삽입 트랜잭션)
	    return Map.of("ok", true);                                      // 성공 응답 (세부 결과/개수 등은 필요 시 확장)
	}

	/*
	 * 참고/주의
	 * - @Autowired 필드 주입 대신 생성자 주입을 권장하지만(테스트 용이성), 현재 로직엔 영향 없음.
	 * - LocalDate.parse는 "YYYY-MM-DD" 형식만 허용 → 프론트에서 ISO 포맷 보장 필요.
	 * - 유효성 검증(예: hours 값 범위 0~23, 중복/정렬, 과거일 허용 여부 등)은 서비스 계층에서 처리 권장.
	 * - 예외 처리(잘못된 형식/널 값)에 대한 4xx/5xx 응답 규격은 @ControllerAdvice로 일괄 처리하면 깔끔함.
	 */

	
}