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
 * <p>FullCalendar에서 사용할 이벤트 조회, 모달에서 사용할 시간 목록 조회,
 * 근무시간 등록 및 삭제를 처리하는 엔드포인트를 정의합니다. 반환 타입은
 * 주로 Map이나 List로, Jackson이 JSON으로 변환하도록 합니다.</p>
 */
@RestController
@RequestMapping("/api/trainer/schedule")
public class TrainerScheduleApiController {

    private final TrainerScheduleRepository trainerScheduleRepository;

    @Autowired
    public TrainerScheduleApiController(TrainerScheduleRepository trainerScheduleRepository) {
        this.trainerScheduleRepository = trainerScheduleRepository;
    }

    
    /**
     * 예약된 건만 리스트를 조회합니다.
     *
     * <p>트레이너 페이지의 하단 표에 표시되는 데이터로, 예약이 존재하는 근무칸만을 반환합니다.
     * start와 end는 날짜/시간 범위를 나타냅니다.</p>
     *
     * @param trainerId 트레이너의 ID (필수)
     * @param start 검색 시작 시각(YYYY-MM-DD HH:MM:SS)
     * @param end 검색 종료 시각(YYYY-MM-DD HH:MM:SS)
     * @return 예약 리스트(JSON)
     */
    @GetMapping("/bookings")
    public List<Map<String, Object>> getTrainerBookings(
            @RequestParam("trainerId") int trainerId,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerBookings(param);
    }

    
    /**
     * 근무시간 슬롯과 예약 여부를 조회합니다.
     *
     * <p>FullCalendar의 이벤트를 구성하기 위해 빈 슬롯과 예약된 슬롯 모두를 반환합니다.</p>
     */
    @GetMapping("/slots")
    public List<Map<String, Object>> getTrainerSlots(
            @RequestParam("trainerId") int trainerId,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerSlotsWithStatus(param);
    }

    
    /**
     * 특정 날짜의 시(hour)별 슬롯 상태를 조회합니다.
     *
     * <p>트레이너 페이지의 \"근무시간 등록\" 모달에서 하루치 시간 버튼 목록을 생성할 때 사용합니다.</p>
     */
    @GetMapping("/slots/day")
    public List<Map<String, Object>> getDaySlots(
            @RequestParam("trainerId") int trainerId,
            @RequestParam("date") String date) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        return trainerScheduleRepository.selectDaySlotsWithStatus(param);
    }

    
    /**
     * 근무시간을 등록합니다.
     *
     * <p>배열 형태의 datetimes를 받아 여러 건을 한 번에 등록할 수 있습니다. 요청 본문은 JSON 형식으로
     * {\"trainerId\":1, \"datetimes\":[\"2025-07-09 12:00:00\", \"2025-07-09 13:00:00\"]} 형태여야 합니다.</p>
     */
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

    
    /**
     * 단일 근무시간을 삭제합니다.
     *
     * <p>예약이 없는 슬롯만 삭제할 수 있습니다. reservation 테이블의 외래키 제약을 위배하면
     * 예외가 발생할 수 있으므로, 프런트에서 먼저 예약 여부를 확인하는 것이 좋습니다.</p>
     */
    @DeleteMapping("/availability")
    public ResponseEntity<Map<String, Object>> deleteAvailability(@RequestParam("id") int id) {
        Map<String, Object> param = new HashMap<>();
        param.put("availabilityId", id);
        int deleted = trainerScheduleRepository.deleteAvailabilityById(param);
        Map<String, Object> resp = new HashMap<>();
        resp.put("deleted", deleted);
        return ResponseEntity.ok(resp);
    }

    
    /**
     * 특정 날짜의 여러 근무시간을 한 번에 삭제합니다.
     *
     * <p>요청 본문 JSON 형식은 {\"trainerId\":1, \"workDate\":\"2025-07-09\", \"hours\":[12,13,14]} 입니다.
     * 선택한 시간대에 예약이 있으면 삭제되지 않습니다.</p>
     */
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
}
