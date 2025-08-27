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

	// 상태코드(간단 문자열) — 프론트/컨트롤러에서 그대로 분기하기 쉬움
	public static final String OK_ASSIGNED = "OK_ASSIGNED";
	public static final String ALREADY_ASSIGNED_THIS = "ALREADY_ASSIGNED_THIS";
	public static final String ASSIGNED_OTHER = "ASSIGNED_OTHER";
	public static final String NOT_FOUND = "NOT_FOUND";
	public static final String INVALID_ROLE = "INVALID_ROLE";

	public MemberListService(MemberListRepository repo) {
		this.repo = repo;
	}

	// -------------------- 조회 --------------------
	/** 트레이너 담당 회원 리스트 */
	public List<MemberVO> getMemberListForTrainer(int trainerId) {
		return repo.selectMemberListForTrainer(trainerId);
	}

	/** 상세(소유 검증 포함) */
	public MemberVO getMemberDetail(int trainerId, int memberId) {
		return repo.selectMemberDetail(trainerId, memberId);
	}

	/** (편집 모달) 내 회원 상세 */
	public Map<String, Object> getMemberDetailForEdit(int trainerId, int memberId) {
		return repo.selectMemberDetailForEdit(trainerId, memberId);
	}

	// -------------------- 수정/저장 --------------------
	/** 기본정보 업데이트 (users) — 매퍼의 updateUserBasic에 맞춤 */
	public void updateUserBasic(int memberId, String userName, String phoneNumber, String birth /* YYYY-MM-DD 권장 */) {
		repo.updateUserBasic(memberId, userName, phoneNumber, birth);
	}

	/** 프로필 upsert (member_profile) */
	public void saveProfile(int memberId, String job, String consultDate, String goal, String memo) {
		repo.upsertMemberProfile(memberId, job, consultDate, goal, memo);
	}

	/** PT 계약 추가 */
	@Transactional
	public void addPtContract(int trainerId, int memberId, int totalSessions) {
		repo.insertPtContract(trainerId, memberId, totalSessions);
	}

	// -------------------- 배정/해제 --------------------
	/**
	 * (등록 버튼) 기존 가입 회원을 배정 — loginId 기반 정책: - 신규 생성 금지 - 이미 내 회원이면
	 * ALREADY_ASSIGNED_THIS - 타 트레이너 소속이면 ASSIGNED_OTHER
	 */
	@Transactional
	public String assignExistingMemberByLoginId(int trainerId, String loginId) {
		Map<String, Object> user = repo.selectUserBasicByLoginId(loginId);
		if (user == null) {
			return NOT_FOUND; // 해당 loginId 없음
		}
		// role 검증 (selectUserBasicByLoginId가 role='member'로 제한되어 있지만 방어적으로 체크)
		Object assignedTrainerId = user.get("assignedTrainerId");
		Integer memberId = ((Number) user.get("memberId")).intValue();

		// 이미 배정된 경우 분기
		if (assignedTrainerId != null) {
			int assigned = ((Number) assignedTrainerId).intValue();
			if (assigned == trainerId) {
				return ALREADY_ASSIGNED_THIS;
			} else {
				return ASSIGNED_OTHER;
			}
		}

		// 배정 시도 (매퍼에서 role='member' AND assigned_trainer_id IS NULL 보장)
		int updated = repo.assignTrainer(memberId, trainerId);
		if (updated == 1) {
			return OK_ASSIGNED;
		}
		// 동시성 등으로 0행이면 재확인
		Map<String, Object> recheck = repo.selectUserBasicByLoginId(loginId);
		Object reAssigned = (recheck != null) ? recheck.get("assignedTrainerId") : null;
		if (reAssigned != null && ((Number) reAssigned).intValue() == trainerId) {
			return ALREADY_ASSIGNED_THIS;
		}
		return ASSIGNED_OTHER; // 혹은 기타 사유로 누군가가 선점
	}

	/**
	 * 배정 해제 — 기본 플로우: 이력 보존(예약/계약 삭제하지 않음) 필요시 별도의 초기화 기능에서 삭제 처리 권장
	 */
	@Transactional
	public void unassignMember(int trainerId, int memberId) {
		int updated = repo.unassignTrainer(memberId, trainerId);
		if (updated == 0) {
			throw new IllegalStateException("해제 실패: 내 회원이 아니거나 이미 해제됨");
		}
	}

	// ---- 필요 시 별도 초기화용(주의: 데이터 삭제) ----
	@Transactional
	public void cleanupMemberDataForTrainer(int trainerId, int memberId) {
		repo.deleteReservationsByMemberAndTrainer(trainerId, memberId);
		repo.deletePtContractsByMemberAndTrainer(trainerId, memberId);
	}

	// -------------------- 등록 모달 보조 --------------------
	/** 등록 모달: loginId로 기본정보 미리보기 */
	public Map<String, Object> getUserBasicByLoginId(String loginId) {
		return repo.selectUserBasicByLoginId(loginId);
	}
}
