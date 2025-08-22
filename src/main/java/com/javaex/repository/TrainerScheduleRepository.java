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

	    /**
	     * 트레이너의 예약 현황 리스트를 조회합니다.
	     *
	     * <p>예약이 존재하는 슬롯만 반환하며, 매퍼 XML의 id = "trainerSchedule.selectTrainerBookings"
	     * 를 호출합니다. 파라미터 맵에는 trainerId, start, end 키가 필요합니다.</p>
	     *
	     * @param params 호출에 필요한 파라미터: trainerId(int), start(String), end(String)
	     * @return 결과 목록(Map의 List) – workDate, hourLabel, memberName, status 등을 포함
	     */
	    public List<Map<String, Object>> selectTrainerBookings(Map<String, Object> params) {
	        return sqlSession.selectList("trainerSchedule.selectTrainerBookings", params);
	    }

	    
	    /**
	     * 트레이너 근무 슬롯과 예약 여부를 조회합니다.
	     *
	     * <p>빈 슬롯도 함께 반환하며, slotStatus로 AVAILABLE/BOOKED/COMPLETED를 구분합니다.
	     * 매퍼 XML의 id = "trainerSchedule.selectTrainerSlotsWithStatus"를 호출합니다.</p>
	     *
	     * @param params trainerId(int), start(String), end(String) 을 포함하는 맵
	     * @return 각 slot 정보를 담은 Map의 List
	     */
	    public List<Map<String, Object>> selectTrainerSlotsWithStatus(Map<String, Object> params) {
	        return sqlSession.selectList("trainerSchedule.selectTrainerSlotsWithStatus", params);
	    }

	    
	    /**
	     * 특정 날짜의 근무시간별 예약 가능 상태를 조회합니다.
	     *
	     * <p>매퍼 XML의 id = "trainerSchedule.selectDaySlotsWithStatus"를 호출하여
	     * 하루 동안의 모든 시간대를 가져옵니다.</p>
	     *
	     * @param params trainerId(int), workDate(String, YYYY-MM-DD) 을 포함하는 맵
	     * @return availabilityId, hourLabel, slotStatus를 담은 List
	     */
	    public List<Map<String, Object>> selectDaySlotsWithStatus(Map<String, Object> params) {
	        return sqlSession.selectList("trainerSchedule.selectDaySlotsWithStatus", params);
	    }

	    
	    /**
	     * 단일 근무시간을 등록합니다.
	     *
	     * <p>매퍼 XML의 id = "trainerSchedule.insertAvailability"를 호출합니다.
	     * 중복된 slot이면 0, 새로 등록되면 1을 반환합니다.</p>
	     *
	     * @param params trainerId(int), availableDatetime(String)
	     * @return 삽입된 행 수
	     */
	    public int insertAvailability(Map<String, Object> params) {
	        return sqlSession.insert("trainerSchedule.insertAvailability", params);
	    }

	    
	    /**
	     * 여러 근무시간을 한 번에 등록합니다.
	     *
	     * <p>매퍼 XML의 id = "trainerSchedule.insertAvailabilityBatch"를 호출하여
	     * datetimes 리스트에 담긴 시각을 모두 INSERT IGNORE로 추가합니다.</p>
	     *
	     * @param params trainerId(int), datetimes(List<String>)
	     * @return 삽입된 행 수(중복된 slot은 삽입되지 않음)
	     */
	    public int insertAvailabilityBatch(Map<String, Object> params) {
	        return sqlSession.insert("trainerSchedule.insertAvailabilityBatch", params);
	    }

	    
	    /**
	     * 단일 근무시간을 삭제합니다.
	     *
	     * <p>매퍼 XML의 id = "trainerSchedule.deleteAvailabilityById"를 호출하여
	     * 해당 availability_id에 해당하는 slot을 삭제합니다.</p>
	     *
	     * @param params availabilityId(int)
	     * @return 삭제된 행 수
	     */
	    public int deleteAvailabilityById(Map<String, Object> params) {
	        return sqlSession.delete("trainerSchedule.deleteAvailabilityById", params);
	    }

	    
	    /**
	     * 특정 날짜의 여러 시간대를 한 번에 삭제합니다.
	     *
	     * <p>매퍼 XML의 id = "trainerSchedule.deleteAvailabilityByDateHours"를 호출합니다.
	     * 파라미터 맵에는 trainerId, workDate, hours(List<Integer>) 키가 있어야 합니다.</p>
	     *
	     * @param params trainerId(int), workDate(String), hours(List<Integer>)
	     * @return 삭제된 행 수
	     */
	    public int deleteAvailabilityByDateHours(Map<String, Object> params) {
	        return sqlSession.delete("trainerSchedule.deleteAvailabilityByDateHours", params);
	    }
}
