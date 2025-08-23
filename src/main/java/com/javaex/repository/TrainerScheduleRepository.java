package com.javaex.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * TrainerScheduleRepositoryImpl는 MyBatis XML 매퍼를 직접 호출하여
 * 트레이너 일정(근무시간/예약) 관련 데이터 접근을 제공합니다.
 *
 * <p>인터페이스 기반의 Mapper 없이 SqlSession을 직접 사용하기 때문에,
 * mapper XML의 namespace와 id를 문자열로 지정합니다. 각 메서드는
 * XML에 정의한 SQL id를 그대로 호출하며, 파라미터는 Map 형태로 넘깁니다.</p>
 */
@Repository
public class TrainerScheduleRepository {
    private final SqlSession sqlSession;

    @Autowired
    public TrainerScheduleRepository(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    /** 트레이너의 예약 현황 리스트 조회 */
    public List<Map<String, Object>> selectTrainerBookings(Map<String, Object> params) {
        return sqlSession.selectList("trainerSchedule.selectTrainerBookings", params);
    }

    /** 트레이너 근무 슬롯과 예약 여부 조회 */
    public List<Map<String, Object>> selectTrainerSlotsWithStatus(Map<String, Object> params) {
        return sqlSession.selectList("trainerSchedule.selectTrainerSlotsWithStatus", params);
    }

    /** 특정 날짜의 근무시간별 예약 가능 상태 조회 */
    public List<Map<String, Object>> selectDaySlotsWithStatus(Map<String, Object> params) {
        return sqlSession.selectList("trainerSchedule.selectDaySlotsWithStatus", params);
    }

    /** 단일 근무시간 등록 */
    public int insertAvailability(Map<String, Object> params) {
        return sqlSession.insert("trainerSchedule.insertAvailability", params);
    }

    /** 여러 근무시간 등록 */
    public int insertAvailabilityBatch(Map<String, Object> params) {
        return sqlSession.insert("trainerSchedule.insertAvailabilityBatch", params);
    }

    /** 단일 근무시간 삭제 */
    public int deleteAvailabilityById(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteAvailabilityById", params);
    }

    /** 특정 날짜의 여러 시간대 삭제 */
    public int deleteAvailabilityByDateHours(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteAvailabilityByDateHours", params);
    }

    /** 특정 날짜/시간 문자열 기반 여러 근무 삭제 */
    public int deleteAvailabilityByDatetimes(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteAvailabilityByDatetimes", params);
    }

    /**
     * 트레이너가 소유한 예약을 강제로 취소합니다.
     * (회원 ID나 24시간 제한을 확인하지 않음, trainerId + reservationId만 검증)
     */
    public int deleteReservationByTrainer(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteReservationByTrainer", params);
    }
}
