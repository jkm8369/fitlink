package com.javaex.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

/**
 * BookingRepository - 회원 예약/조회 관련 DB 접근 전담 클래스 - BookingMapper.xml 과 연결됨
 * (namespace="booking") - 컨트롤러 → 서비스 → Repository → MyBatis XML → DB 흐름
 */
@Repository
public class BookingRepository {
	private static final String NS = "booking.";
	private final SqlSessionTemplate sql;

	public BookingRepository(SqlSessionTemplate sql) {
		this.sql = sql;
	}

	/** 특정 회원의 달력 이벤트 조회 (기간 내 예약만) */
	public List<Map<String, Object>> selectMyCalendarEvents(int memberId, String start, String end) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("start", start);
		p.put("end", end);
		return sql.selectList(NS + "selectMyCalendarEvents", p);
	}

	/** 담당 트레이너의 특정 날짜 슬롯 상태 조회 (모달용) */
	public List<Map<String, Object>> selectSlotsByTrainerAndDate(int trainerId, String date) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("date", date);
		return sql.selectList(NS + "selectSlotsByTrainerAndDate", p);
	}

	/** 특정 회원의 PT 리스트(등록/수업/잔여 집계 포함) 조회 */
	public List<Map<String, Object>> selectMyPtList(int memberId) {
		return sql.selectList(NS + "selectMyPtList", memberId);
	}

	/** 예약 생성 (BOOKED 상태로 insert) */
	public int insertReservation(int memberId, int availabilityId) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("availabilityId", availabilityId);
		return sql.insert(NS + "insertReservation", p);
	}

	/** 예약 취소 (BOOKED 상태만 삭제 가능) */
	public int deleteReservation(int memberId, int reservationId) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("reservationId", reservationId);
		return sql.delete(NS + "deleteReservation", p);
	}

    /** 멤버-트레이너 최근 계약의 total_sessions */
    public Integer findTotalSessions(int memberId, int trainerId) {
        Map<String, Object> p = new HashMap<>();
        p.put("memberId", memberId);
        p.put("trainerId", trainerId);
        return sql.selectOne(NS + "findTotalSessions", p);
    }

    /** 멤버-트레이너의 예약 수(BOOKED/COMPLETED) */
    public int countMemberReservations(int memberId, int trainerId) {
        Map<String, Object> p = new HashMap<>();
        p.put("memberId", memberId);
        p.put("trainerId", trainerId);
        return sql.selectOne(NS + "countMemberReservations", p);
    }
}
