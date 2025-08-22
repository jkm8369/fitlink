package com.javaex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.TrainerScheduleRepository;

/**
 * TrainerScheduleService는 트레이너 일정 관리와 관련된 비즈니스 로직을 담당합니다.
 *
 * <p>레포지토리에서 DB 작업을 수행하지만, 컨트롤러와 레포지토리 사이의 중간 계층으로서
 * 파라미터 구성과 간단한 처리 로직을 제공합니다. 필요에 따라 트랜잭션 처리나
 * 추가 검증 로직을 이곳에 넣을 수 있습니다.</p>
 */
@Service
public class TrainerScheduleService {
	/**
     * DB 접근을 담당하는 레포지토리 빈
     *
     * <p>사용자에게서 요청받은 이름에 맞춰 TrainerScheduleRepository 타입으로 변경했습니다.
     * 해당 클래스는 SqlSession을 이용해 mapper XML을 호출하는 구현체여야 합니다.</p>
     */
    private final TrainerScheduleRepository trainerScheduleRepository;

    @Autowired
    public TrainerScheduleService(TrainerScheduleRepository trainerScheduleRepository) {
        this.trainerScheduleRepository = trainerScheduleRepository;
    }

    /**
     * 트레이너 예약 목록을 조회합니다.
     */
    public List<Map<String, Object>> getTrainerBookings(int trainerId, String start, String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerBookings(param);
    }

    /**
     * 트레이너의 모든 근무 슬롯과 예약 여부를 조회합니다.
     */
    public List<Map<String, Object>> getTrainerSlots(int trainerId, String start, String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerSlotsWithStatus(param);
    }

    /**
     * 특정 날짜의 근무시간별 예약 상태를 조회합니다.
     */
    public List<Map<String, Object>> getDaySlots(int trainerId, String date) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        return trainerScheduleRepository.selectDaySlotsWithStatus(param);
    }

    /**
     * 다수의 근무시간을 등록합니다.
     *
     * <p>datetimes가 1개인 경우 단건 insert, 2개 이상인 경우 batch insert를 사용합니다.</p>
     */
    public int registerAvailabilities(int trainerId, List<String> datetimes) {
        if (datetimes == null || datetimes.isEmpty()) {
            return 0;
        }
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        int inserted;
        if (datetimes.size() > 1) {
            param.put("datetimes", datetimes);
            inserted = trainerScheduleRepository.insertAvailabilityBatch(param);
        } else {
            param.put("availableDatetime", datetimes.get(0));
            inserted = trainerScheduleRepository.insertAvailability(param);
        }
        return inserted;
    }

    /**
     * 단일 근무시간을 삭제합니다.
     */
    public int removeAvailability(int id) {
        Map<String, Object> param = new HashMap<>();
        param.put("availabilityId", id);
        return trainerScheduleRepository.deleteAvailabilityById(param);
    }

    /**
     * 특정 날짜의 다중 근무시간을 삭제합니다.
     */
    public int removeAvailabilitiesByDate(int trainerId, String date, List<Integer> hours) {
        if (hours == null || hours.isEmpty()) {
            return 0;
        }
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        param.put("hours", hours);
        return trainerScheduleRepository.deleteAvailabilityByDateHours(param);
    }
}
