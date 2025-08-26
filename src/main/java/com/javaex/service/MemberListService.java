package com.javaex.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javaex.repository.MemberListRepository;
import com.javaex.vo.MemberVO;

@Service
public class MemberListService {

	private final MemberListRepository repo;

	public MemberListService(MemberListRepository repo) {
		this.repo = repo;
	}

	// 리스트
	public List<MemberVO> getMemberListForTrainer(int trainerId) {
		return repo.selectMemberListForTrainer(trainerId);
	}

	// 상세
	public MemberVO getMemberDetail(int trainerId, int memberId) {
		return repo.selectMemberDetail(trainerId, memberId);
	}

	// 기본정보 업데이트
	public void updateUsersBasic(int memberId, String userName, String phoneNumber, String birthdate) {
		repo.updateUsersBasic(memberId, userName, phoneNumber, birthdate);
	}

	// 프로필 upsert
	public void saveProfile(int memberId, String job, String consultDate, String goal, String memo) {
		repo.upsertMemberProfile(memberId, job, consultDate, goal, memo);
	}

	// PT 계약 추가
	@Transactional
	public void addPtContract(int trainerId, int memberId, int totalSessions) {
		repo.insertPtContract(trainerId, memberId, totalSessions);
	}

	// 연결 해제(예약 삭제 → 계약 삭제 → 배정 해제)
	@Transactional
	public void unlinkMember(int trainerId, int memberId) {
		repo.deleteReservationsByMemberAndTrainer(trainerId, memberId);
		repo.deletePtContractsByMemberAndTrainer(trainerId, memberId);
		int updated = repo.unassignTrainer(memberId, trainerId);
		if (updated == 0) {
			throw new IllegalStateException("연결 해제 실패: 소유권 불일치 또는 이미 해제됨");
		}
	}

	// 회원 생성 + 트레이너 배정
	@Transactional
	public int createMemberAndAssignTrainer(int trainerId, Map<String, Object> req) {
		int userId = repo.insertUser(req); // req.birthdate = "yyMMdd"
		repo.assignTrainer(userId, trainerId);
		return userId;
	}

	public Map<String, Object> getUserBasicByLoginId(String loginId) {
	    return repo.selectUserBasicByLoginId(loginId);
	}

}
