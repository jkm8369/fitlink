package com.javaex.repository;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleRepository {
    
	private static final String NS = "trainer.schedule."; // MyBatis XML의 <mapper namespace="trainer.schedule">에 맞춘 prefix
 	
	@Autowired
	private SqlSession sqlSession; // org.apache.ibatis.session.SqlSession: Mapper 없이 직접 id로 쿼리 호출

	/** 조회: 해당 날짜의 근무시간 리스트 (예: [9,10,14]) */
	public List<Integer> selectHoursByDate(int trainerId, LocalDate workDate) {
	    Map<String, Object> p = new HashMap<>(); // 파라미터 바인딩용 맵
	    p.put("trainerId", trainerId);           // 트레이너 ID
	    p.put("workDate", workDate);             // 근무 날짜 (java.time.LocalDate)
	    return sqlSession.selectList(NS + "selectHoursByDate", p); // schedule.xml의 <select id="selectHoursByDate"> 실행 → List<Integer>
	    // ※ LocalDate ↔ DATE 매핑은 JDBC 드라이버/마이바티스 타입핸들러에서 처리
	}

	/** 삭제: 해당 날짜 전체 삭제 */
	public int deleteByDate(int trainerId, LocalDate workDate) {
	    Map<String, Object> p = new HashMap<>();
	    p.put("trainerId", trainerId); // 트레이너 ID
	    p.put("workDate", workDate);   // 근무 날짜
	    return sqlSession.delete(NS + "deleteByDate", p); // 삭제된 행 수 반환
	}

	/** 저장: 여러 시간 다건 insert (XML의 <foreach> 사용) */
	public int insertHours(int trainerId, LocalDate workDate, List<Integer> hours) {
	    Map<String, Object> p = new HashMap<>();
	    p.put("trainerId", trainerId); // 트레이너 ID
	    p.put("workDate", workDate);   // 근무 날짜
	    p.put("hours", hours);         // 시(hour) 리스트 (예: [9,10,14])
	    return sqlSession.insert(NS + "insertHours", p); // 삽입된 행 수(N) 반환 (XML에서 <foreach collection="hours">)
	    // 주의: hours가 null/빈 리스트면 SQL VALUES가 비어 오류가 날 수 있으니, 필요 시 호출부에서 빈 목록 체크 권장
	}

}
