package com.javaex.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.javaex.vo.MemberVO;

@Repository
public class MemberListRepository {

	private final SqlSession sqlSession;
	private static final String NS = "memberList.";

	public MemberListRepository(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	// -------------------- SELECT (조회) --------------------
	/** 트레이너 담당 회원 리스트 조회 */
	public List<MemberVO> selectMemberListForTrainer(int trainerId) {
		return sqlSession.selectList(NS + "selectMemberListForTrainer", trainerId);
	}

	/** 특정 회원 상세 조회 (트레이너 소유 검증 포함) */
	public MemberVO selectMemberDetail(int trainerId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		return sqlSession.selectOne(NS + "selectMemberDetail", p);
	}

	/** (편집모달) 내 회원 상세 조회 */
	public Map<String, Object> selectMemberDetailForEdit(int trainerId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		return sqlSession.selectOne(NS + "selectMemberDetailForEdit", p);
	}

	/** 등록 모달: loginId로 기본정보 조회 */
	public Map<String, Object> selectUserBasicByLoginId(String loginId) {
		return sqlSession.selectOne(NS + "selectUserBasicByLoginId", loginId);
	}

	// -------------------- DML (데이터 조작) --------------------
	/** [UPDATE] 회원 기본정보 수정 (users: 이름/전화/생년월일) */
	public int updateUserBasic(int memberId, String userName, String phoneNumber, String birth) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("memberName", userName);
		p.put("phoneNumber", phoneNumber);
		p.put("birth", birth); // 컨트롤러/서비스에서 'YYYY-MM-DD' 등으로 변환해 전달
		return sqlSession.update(NS + "updateUserBasic", p);
	}

	/** [INSERT or UPDATE] 회원 프로필 저장 (member_profile) */
	public int upsertMemberProfile(int memberId, String job, String consultDate, String goal, String memo) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("job", job);
		p.put("consultDate", consultDate);
		p.put("goal", goal);
		p.put("memo", memo);
		return sqlSession.insert(NS + "upsertMemberProfile", p);
	}

	/** [INSERT] PT 계약 생성 (pt_contract) */
	public int insertPtContract(int trainerId, int memberId, int totalSessions) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		p.put("totalSessions", totalSessions);
		return sqlSession.insert(NS + "insertPtContract", p);
	}

	/** [UPDATE] 트레이너 배정 (users.assigned_trainer_id 설정) */
	public int assignTrainer(int memberId, int trainerId) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId); // 매퍼 조건: role='member' AND assigned_trainer_id IS NULL
		p.put("trainerId", trainerId);
		return sqlSession.update(NS + "assignTrainer", p);
	}

	/** [UPDATE] 트레이너 배정 해제 (내 회원만) */
	public int unassignTrainer(int memberId, int trainerId) {
		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("trainerId", trainerId);
		return sqlSession.update(NS + "unassignTrainer", p);
	}

	/** [DELETE] 예약 삭제 (해당 트레이너 것만) — 별도 초기화 기능에서만 사용 */
	public int deleteReservationsByMemberAndTrainer(int trainerId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		return sqlSession.delete(NS + "deleteReservationsByMemberAndTrainer", p);
	}

	/** [DELETE] 회원 프로필 삭제 — 별도 초기화 기능 */
	public int deleteMemberProfile(int memberId) {
		return sqlSession.delete(NS + "deleteMemberProfile", memberId);
	}

	/** [DELETE] PT 계약 삭제 (해당 트레이너 것만) — 별도 초기화 기능 */
	public int deletePtContractsByMemberAndTrainer(int trainerId, int memberId) {
		Map<String, Object> p = new HashMap<>();
		p.put("trainerId", trainerId);
		p.put("memberId", memberId);
		return sqlSession.delete(NS + "deletePtContractsByMemberAndTrainer", p);
	}
}