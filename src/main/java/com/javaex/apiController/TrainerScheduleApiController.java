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
import org.springframework.web.bind.annotation.SessionAttribute;

import com.javaex.repository.TrainerScheduleRepository;

@RestController
@RequestMapping("/api/trainer/schedule")
public class TrainerScheduleApiController {
    private final TrainerScheduleRepository trainerScheduleRepository;

    @Autowired
    public TrainerScheduleApiController(TrainerScheduleRepository trainerScheduleRepository) {
        this.trainerScheduleRepository = trainerScheduleRepository;
    }

    /** 예약된 건만 리스트 (트레이너 하단 표)
     *  - start, end 만 받고 trainerId는 세션에서 */
    @GetMapping("/bookings")
    public List<Map<String, Object>> getTrainerBookings(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {

        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerBookings(param);
    }

    /** 슬롯+예약 상태 (FullCalendar 이벤트)
     *  - start, end 만 받고 trainerId는 세션에서 */
    @GetMapping("/slots")
    public List<Map<String, Object>> getTrainerSlots(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {

        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerSlotsWithStatus(param);
    }

    /** 특정일 시(hour)별 슬롯 상태
     *  - date만 받고 trainerId는 세션에서 */
    @GetMapping("/slots/day")
    public List<Map<String, Object>> getDaySlots(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestParam("date") String date) {

        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        return trainerScheduleRepository.selectDaySlotsWithStatus(param);
    }

    /** 근무시간 등록
     *  - Body의 trainerId는 무시하고(또는 없어도 됨), 세션 trainerId 사용 */
    @PostMapping("/availability")
    public ResponseEntity<Map<String, Object>> insertAvailabilities(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestBody Map<String, Object> body) {

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
    public ResponseEntity<Map<String, Object>> deleteAvailability(
            @RequestParam("id") int id) {

        Map<String, Object> param = new HashMap<>();
        param.put("availabilityId", id);

        int deleted = trainerScheduleRepository.deleteAvailabilityById(param);

        Map<String, Object> resp = new HashMap<>();
        resp.put("deleted", deleted);
        return ResponseEntity.ok(resp);
    }

    /** 특정일 여러 근무시간 삭제
     *  - Body의 trainerId는 무시하고 세션 trainerId 사용 */
    @PostMapping("/availability/delete")
    public ResponseEntity<Map<String, Object>> deleteAvailabilities(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestBody Map<String, Object> body) {

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

    /** 트레이너 강제 예약취소 (본인 소유 예약만)
     *  - trainerId 파라미터 제거, 세션값 사용 */
    @DeleteMapping("/reservation")
    public ResponseEntity<Map<String, Object>> forceCancelReservation(
            @SessionAttribute("trainerId") Integer trainerId,
            @RequestParam("reservationId") int reservationId) {

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