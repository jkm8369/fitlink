package com.javaex.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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

    /** 특정 날짜의 여러 시간대 삭제(HOUR 기준) */
    public int deleteAvailabilityByDateHours(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteAvailabilityByDateHours", params);
    }

    /** 특정 날짜/시간 문자열 기반 여러 근무 삭제(예약 없는 슬롯만) */
    public int deleteAvailabilityByDatetimes(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteAvailabilityByDatetimes", params);
    }

    /** 트레이너 소유 예약 강제 취소 */
    public int deleteReservationByTrainer(Map<String, Object> params) {
        return sqlSession.delete("trainerSchedule.deleteReservationByTrainer", params);
    }
}