package com.javaex.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javaex.repository.MemberListRepository;

@Service
public class MemberListService {

	private final MemberListRepository repo;

	public MemberListService(MemberListRepository repo) {
		this.repo = repo;
	}

	/** (A) 트레이너 담당 맴버리스트 조회 */
	public List<Map<String, Object>> getMemberListForTrainer(int trainerId) {
		return repo.selectMemberListForTrainer(trainerId);
	}

	/** (B) 모달용 단건 상세 조회 */
	public Map<String, Object> getMemberDetail(int trainerId, int memberId) {
		return repo.selectMemberDetail(trainerId, memberId);
	}

	/** (C) 기본정보 수정: 단건 UPDATE */
	public void updateBasic(int memberId, String userName, String phoneNumber, String birthdate) {
		repo.updateUsersBasic(memberId, userName, phoneNumber, birthdate);
	}

	/** (D) 프로필 업서트: INSERT or UPDATE */
	public void saveProfile(int memberId, String job, String consultDate, String goal, String memo) {
		repo.upsertMemberProfile(memberId, job, consultDate, goal, memo);
	}

	/**
	 * (E) PT 등록횟수 추가구매 - 구매이력 보존을 위한 누적 INSERT - 여러 테이블을 같이 변경하는 상황을
	 * 대비하여 @Transactional 권장
	 */
	@Transactional
	public void addPtContract(int trainerId, int memberId, int totalSessions) {
		repo.insertPtContract(trainerId, memberId, totalSessions);
	}

	/** (F) 회원 삭제 */
	public void deleteMember(int memberId) {
		repo.deleteMember(memberId);
	}
	
}
