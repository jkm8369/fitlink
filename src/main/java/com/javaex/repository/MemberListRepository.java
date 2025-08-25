package com.javaex.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class MemberListRepository {
	
	private final SqlSession sqlSession;
	private static final String NS = "memberList."; // <mapper namespace="memberList">

	public MemberListRepository(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	/** (A) 트레이너 담당 맴버리스트 조회 */
	public List<Map<String, Object>> selectMemberListForTrainer(int trainerId) {
		return sqlSession.selectList(NS + "selectMemberListForTrainer", trainerId);
	}

	/** (B) 모달용 단건 상세 조회 */
	public Map<String, Object> selectMemberDetail(int trainerId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		return sqlSession.selectOne(NS + "selectMemberDetail", p);
	}

	/** (C) 기본정보 수정: 이름/전화/생년월일 */
	public int updateUsersBasic(int memberId, String userName, String phoneNumber, String birthdate) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("userName", userName);
		p.put("phoneNumber", phoneNumber);
		p.put("birthdate", birthdate); // YYYY-MM-DD
		return sqlSession.update(NS + "updateUsersBasic", p);
	}

	/** (D) 프로필 업서트: 직업/상담일/목표/메모 */
	public int upsertMemberProfile(int memberId, String job, String consultDate, String goal, String memo) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("job", job);
		p.put("consultDate", consultDate); // YYYY-MM-DD (nullable)
		p.put("goal", goal);
		p.put("memo", memo);
		return sqlSession.insert(NS + "upsertMemberProfile", p);
	}

	/** (E) PT 등록횟수 추가구매 기록 */
	public int insertPtContract(int trainerId, int memberId, int totalSessions) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		p.put("totalSessions", totalSessions);
		return sqlSession.insert(NS + "insertPtContract", p);
	}

	/** (F) 회원 삭제 */
	public int deleteMember(int memberId) {
		return sqlSession.delete(NS + "deleteMember", memberId);
	}
	
}
