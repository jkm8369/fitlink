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
    
	private static final String NS = "trainer.schedule.";
	
	@Autowired
    private SqlSession sqlSession;

    /** 조회: 해당 날짜의 근무시간 리스트 (예: [9,10,14]) */
    public List<Integer> selectHoursByDate(int trainerId, LocalDate workDate) {
        Map<String, Object> p = new HashMap<>();
        p.put("trainerId", trainerId);
        p.put("workDate", workDate);
        return sqlSession.selectList(NS + "selectHoursByDate", p);
        // → schedule.xml 의 <select id="selectHoursByDate"> 실행
    }

    /** 삭제: 해당 날짜 전체 삭제 */
    public int deleteByDate(int trainerId, LocalDate workDate) {
        Map<String, Object> p = new HashMap<>();
        p.put("trainerId", trainerId);
        p.put("workDate", workDate);
        return sqlSession.delete(NS + "deleteByDate", p);
    }

    /** 저장: 여러 시간 다건 insert (XML의 foreach 사용) */
    public int insertHours(int trainerId, LocalDate workDate, List<Integer> hours) {
        Map<String, Object> p = new HashMap<>();
        p.put("trainerId", trainerId);
        p.put("workDate", workDate);
        p.put("hours", hours);
        return sqlSession.insert(NS + "insertHours", p);
    }
}
