package com.javaex.repository;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.javaex.vo.CalendarEventVO;
import com.javaex.vo.ScheduleRowVO;

/**
 * Repository = DB 접근 전담 (DAO). - MyBatis의 SqlSessionTemplate 으로 XML의 SQL을 호출. -
 * 초보 포인트: "namespace.id" 로 XML의 쿼리를 찾는다고 기억하자.
 */
@Repository
public class BookingRepository {
	private static final String NS = "booking."; // XML <mapper namespace="booking">
	private final SqlSessionTemplate sql;

	public BookingRepository(SqlSessionTemplate sql) {
		this.sql = sql;
	}

	/** 회원의 담당 트레이너 조회 */
	public Integer selectTrainerIdByMemberId(int memberId) {
		return sql.selectOne(NS + "selectTrainerIdByMemberId", memberId);
	}

	/** 특정 날짜의 근무칸 목록 (hour, availabilityId) */
	public List<Map<String, Object>> selectSlotsByTrainerAndDate(int trainerId, Date workDate) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("workDate", workDate);
		return sql.selectList(NS + "selectSlotsByTrainerAndDate", p);
	}

	/** 이미 예약된 근무칸(avail_id) 목록 */
	public List<Integer> selectBookedAvailabilityIds(int trainerId, Date workDate) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("workDate", workDate);
		return sql.selectList(NS + "selectBookedAvailabilityIds", p);
	}

	/** 예약(단건) */
	public int insertReservation(int memberId, int availabilityId, String memo) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("availabilityId", availabilityId);
		p.put("memo", memo);
		return sql.insert(NS + "insertReservation", p); // 성공 시 1
	}

	/** 예약(여러 개: 체크박스 선택) availabilityIds가 비어있으면 0 리턴 */
	public int insertReservationBatch(int memberId, List<Integer> availabilityIds, String memo) {
		if (availabilityIds == null || availabilityIds.isEmpty())
			return 0;
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("availabilityIds", availabilityIds);
		p.put("memo", memo);
		return sql.insert(NS + "insertReservationBatch", p); // 성공 시 N(삽입 개수)
	}

	public List<CalendarEventVO> selectMemberEventsByRange(int memberId, LocalDateTime start, LocalDateTime end) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("start", start);
		p.put("end", end);
		return sql.selectList(NS + "selectMemberEventsByRange", p);
	}

	/** 리스트 */
	public List<ScheduleRowVO> selectScheduleRowsForMember(int memberId) {
		return sql.selectList(NS + "selectScheduleRowsForMember", memberId);
	}

	public List<ScheduleRowVO> selectScheduleRowsForTrainer(int trainerId) {
		return sql.selectList(NS + "selectScheduleRowsForTrainer", trainerId);
	}

	// (선택) 잔여 체크용
	public Integer selectTotalSessions(int memberId) {
		return sql.selectOne(NS + "selectTotalSessions", memberId);
	}

	public Integer countUsedByMember(int memberId) {
		return sql.selectOne(NS + "countUsedByMember", memberId);
	}

	// import java.util.HashMap;
	// import java.util.Map;
	// import org.mybatis.spring.SqlSessionTemplate;
	// 위 import 들은 파일 상단에 이미 있을 수도 있어요.

	public int cancelReservationOfMember(int reservationId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("reservationId", reservationId);
		p.put("memberId", memberId);
		// mybatis XML 의 <update id="cancelReservationOfMember"> 를 호출
		return sql.update("booking.cancelReservationOfMember", p);
	}

}
