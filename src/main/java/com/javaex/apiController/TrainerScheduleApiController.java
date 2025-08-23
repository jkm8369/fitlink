package com.javaex.apiController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.repository.TrainerScheduleRepository;

/**
 * TrainerScheduleApiController는 트레이너 페이지의 일정 관련 API를 제공합니다.
 *
 * <p>
 * FullCalendar에서 사용할 이벤트 조회, 모달에서 사용할 시간 목록 조회, 근무시간 등록 및 삭제를 처리하는 엔드포인트를
 * 정의합니다. 반환 타입은 주로 Map이나 List로, Jackson이 JSON으로 변환하도록 합니다.
 * </p>
 */
@RestController
@RequestMapping("/api/trainer/schedule")
public class TrainerScheduleApiController {
	private final TrainerScheduleRepository trainerScheduleRepository;

	@Autowired
	public TrainerScheduleApiController(TrainerScheduleRepository trainerScheduleRepository) {
		this.trainerScheduleRepository = trainerScheduleRepository;
	}

	/** 예약된 건만 리스트 (트레이너 하단 표) */
	@GetMapping("/bookings")
	public List<Map<String, Object>> getTrainerBookings(@RequestParam("trainerId") int trainerId,
			@RequestParam("start") String start, @RequestParam("end") String end) {
		Map<String, Object> param = new HashMap<>();
		param.put("trainerId", trainerId);
		param.put("start", start);
		param.put("end", end);
		return trainerScheduleRepository.selectTrainerBookings(param);
	}

	/** 슬롯+예약 상태 (FullCalendar 이벤트) */
	@GetMapping("/slots")
	public List<Map<String, Object>> getTrainerSlots(@RequestParam("trainerId") int trainerId,
			@RequestParam("start") String start, @RequestParam("end") String end) {
		Map<String, Object> param = new HashMap<>();
		param.put("trainerId", trainerId);
		param.put("start", start);
		param.put("end", end);
		return trainerScheduleRepository.selectTrainerSlotsWithStatus(param);
	}

	/** 특정일 시(hour)별 슬롯 상태 */
	@GetMapping("/slots/day")
	public List<Map<String, Object>> getDaySlots(@RequestParam("trainerId") int trainerId,
			@RequestParam("date") String date) {
		Map<String, Object> param = new HashMap<>();
		param.put("trainerId", trainerId);
		param.put("workDate", date);
		return trainerScheduleRepository.selectDaySlotsWithStatus(param);
	}

	/** 근무시간 등록 */
	@PostMapping("/availability")
	public ResponseEntity<Map<String, Object>> insertAvailabilities(@RequestBody Map<String, Object> body) {
		Integer trainerId = (Integer) body.get("trainerId");
		@SuppressWarnings("unchecked")
		List<String> datetimes = (List<String>) body.get("datetimes");

		Map<String, Object> param = new HashMap<>();
		param.put("trainerId", trainerId);

		int inserted = 0;
		if (datetimes != null && datetimes.size() > 1) {
			param.put("datetimes", datetimes);
			inserted = trainerScheduleRepository.insertAvailabilityBatch(param);
		} else if (datetimes != null && datetimes.size() == 1) {
			param.put("availableDatetime", datetimes.get(0));
			inserted = trainerScheduleRepository.insertAvailability(param);
		}
		Map<String, Object> resp = new HashMap<>();
		resp.put("inserted", inserted);
		return ResponseEntity.ok(resp);
	}

	/** 단일 근무시간 삭제 */
	@DeleteMapping("/availability")
	public ResponseEntity<Map<String, Object>> deleteAvailability(@RequestParam("id") int id) {
		Map<String, Object> param = new HashMap<>();
		param.put("availabilityId", id);
		int deleted = trainerScheduleRepository.deleteAvailabilityById(param);
		Map<String, Object> resp = new HashMap<>();
		resp.put("deleted", deleted);
		return ResponseEntity.ok(resp);
	}

	/** 특정일 여러 근무시간 삭제 */
	@PostMapping("/availability/delete")
	public ResponseEntity<Map<String, Object>> deleteAvailabilities(@RequestBody Map<String, Object> body) {
		Integer trainerId = (Integer) body.get("trainerId");
		@SuppressWarnings("unchecked")
		List<String> datetimes = (List<String>) body.get("datetimes");

		Map<String, Object> param = new HashMap<>();
		param.put("trainerId", trainerId);
		param.put("datetimes", datetimes);

		int deleted = trainerScheduleRepository.deleteAvailabilityByDatetimes(param);

		Map<String, Object> resp = new HashMap<>();
		resp.put("deleted", deleted);
		return ResponseEntity.ok(resp);
	}
	
    /** 트레이너 강제 예약취소 (본인 소유 예약만, 시간제한/회원검증 없이 삭제) */
    @DeleteMapping("/reservation")
    public ResponseEntity<Map<String, Object>> forceCancelReservation(
            @RequestParam("reservationId") int reservationId,
            @RequestParam("trainerId") int trainerId
    ) {
        Map<String, Object> param = new HashMap<>();
        param.put("reservationId", reservationId);
        param.put("trainerId", trainerId);

        int deleted = trainerScheduleRepository.deleteReservationByTrainer(param);
        Map<String, Object> resp = new HashMap<>();
        resp.put("ok", deleted > 0);
        resp.put("deleted", deleted);
        return ResponseEntity.ok(resp);
    }
}
