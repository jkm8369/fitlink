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
	private static final String NS = "booking."; // MyBatis XML의 <mapper namespace="booking">에 맞춘 prefix (쿼리 id 앞에 붙임)
	private final SqlSessionTemplate sql;         // MyBatis 쿼리 실행기 (스프링이 주입)

	public BookingRepository(SqlSessionTemplate sql) {
		this.sql = sql; // 생성자 주입
	}

	/** 회원의 담당 트레이너 조회 */
	public Integer selectTrainerIdByMemberId(int memberId) {
		return sql.selectOne(NS + "selectTrainerIdByMemberId", memberId); // (단건) trainer_id 반환, 없으면 null
	}

	/** 특정 날짜의 근무칸 목록 (hour, availabilityId) */
	public List<Map<String, Object>> selectSlotsByTrainerAndDate(int trainerId, Date workDate) {
		Map<String, Object> p = new HashMap<>(); // 파라미터 맵 구성
		p.put("trainerId", trainerId);           // 트레이너 ID
		p.put("workDate", workDate);             // 근무 날짜 (YYYY-MM-DD)
		return sql.selectList(NS + "selectSlotsByTrainerAndDate", p); // [hour, availabilityId] 리스트
	}

	/** 이미 예약된 근무칸(avail_id) 목록 */
	public List<Integer> selectBookedAvailabilityIds(int trainerId, Date workDate) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);  // 트레이너 ID
		p.put("workDate", workDate);    // 날짜
		return sql.selectList(NS + "selectBookedAvailabilityIds", p); // BOOKED/ATTENDED 상태의 availability_id들
	}

	/** 예약(단건) */
	public int insertReservation(int memberId, int availabilityId, String memo) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);         // 예약자 회원 ID
		p.put("availabilityId", availabilityId); // 근무칸(슬롯) PK
		p.put("memo", memo);                 // 메모(선택)
		return sql.insert(NS + "insertReservation", p); // 성공 시 1 (행 수)
	}

	/** 예약(여러 개: 체크박스 선택) availabilityIds가 비어있으면 0 리턴 */
	public int insertReservationBatch(int memberId, List<Integer> availabilityIds, String memo) {
		if (availabilityIds == null || availabilityIds.isEmpty())
			return 0; // 선택된 슬롯이 없으면 바로 0 반환 (쿼리 호출 안 함)
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);            // 예약자 회원 ID
		p.put("availabilityIds", availabilityIds); // 다건 슬롯 PK 목록
		p.put("memo", memo);                    // 메모(선택)
		return sql.insert(NS + "insertReservationBatch", p); // 삽입된 개수(N) 반환
	}

	public List<CalendarEventVO> selectMemberEventsByRange(int memberId, LocalDateTime start, LocalDateTime end) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId); // 회원 ID
		p.put("start", start);       // 조회 시작 시각(포함) — XML에서 >= 로 비교
		p.put("end", end);           // 조회 끝 시각(미포함) — XML에서 <  로 비교
		return sql.selectList(NS + "selectMemberEventsByRange", p); // FullCalendar용 이벤트 목록
	}

	/** 리스트 */
	public List<ScheduleRowVO> selectScheduleRowsForMember(int memberId) {
		return sql.selectList(NS + "selectScheduleRowsForMember", memberId); // 회원 스케줄/잔여/취소가능 여부 포함 리스트
	}

	public List<ScheduleRowVO> selectScheduleRowsForTrainer(int trainerId) {
		return sql.selectList(NS + "selectScheduleRowsForTrainer", trainerId); // 트레이너 입장의 예약 리스트
	}

	// (선택) 잔여 체크용
	public Integer selectTotalSessions(int memberId) {
		return sql.selectOne(NS + "selectTotalSessions", memberId); // 총 세션 수 (pt_member.total_sessions)
	}

	public Integer countUsedByMember(int memberId) {
		return sql.selectOne(NS + "countUsedByMember", memberId); // 사용 세션 수(BOOKED/ATTENDED 카운트)
	}

	// import java.util.HashMap;
	// import java.util.Map;
	// import org.mybatis.spring.SqlSessionTemplate;
	// 위 import 들은 파일 상단에 이미 있을 수도 있어요.

	public int deleteReservationOfMember(int reservationId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("reservationId", reservationId); // 취소할 예약 PK
		p.put("memberId", memberId);           // 본인 확인용 회원 ID
		return sql.delete("booking.deleteReservationOfMember", p); // 조건(본인+BOOKED+24시간 이전) 만족 시 1
	}

	public java.util.List<CalendarEventVO> selectTrainerEventsByRange(int trainerId, java.time.LocalDateTime start,
			java.time.LocalDateTime end) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId); // 트레이너 ID
		p.put("start", start);         // 조회 시작(포함)
		p.put("end", end);             // 조회 끝(미포함)
		return sql.selectList("booking.selectTrainerEventsByRange", p); // 트레이너 달력 이벤트 목록
	}
}
