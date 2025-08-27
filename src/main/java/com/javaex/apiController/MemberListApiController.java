package com.javaex.apiController;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.javaex.service.MemberListService;
import com.javaex.vo.MemberVO;

@RestController
@RequestMapping("/api/trainer/member-list")
public class MemberListApiController {

	private final MemberListService service;

	public MemberListApiController(MemberListService service) {
		this.service = service;
	}

	/** 세션 trainerId 없을 때 개발용 기본값(1) */
	private int trainer(Integer trainerId) {
		return (trainerId != null) ? trainerId : 1;
	}

	// ------------------------------------------------------------
	// [리스트 조회] 내 회원만
	// ------------------------------------------------------------
	@GetMapping
	public Map<String, Object> list(@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		List<MemberVO> rows = service.getMemberListForTrainer(trainer(trainerId));
		return Map.of("ok", true, "data", rows);
	}

	// ------------------------------------------------------------
	// [상세 조회] (소유 검증 포함)
	// ------------------------------------------------------------
	@GetMapping("/{memberId}")
	public Map<String, Object> detail(@PathVariable int memberId,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		MemberVO vo = service.getMemberDetail(trainer(trainerId), memberId);
		return Map.of("ok", true, "data", vo);
	}

	// ------------------------------------------------------------
	// [편집용 상세] (소유 검증 포함) - edit 모달에서 사용
	// ------------------------------------------------------------
	@GetMapping("/{memberId}/edit")
	public Map<String, Object> detailForEdit(@PathVariable int memberId,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		Map<String, Object> data = service.getMemberDetailForEdit(trainer(trainerId), memberId);
		return Map.of("ok", true, "data", data);
	}

	// ------------------------------------------------------------
	// [기본정보 저장] (users: 이름/전화/생년월일)
	// - birth는 'YYYY-MM-DD' 등 컨트롤러 앞단에서 변환 권장
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/basic")
	public Map<String, Object> saveBasic(@PathVariable int memberId, @RequestParam String userName,
			@RequestParam String phoneNumber, @RequestParam String birth) {
		service.updateUserBasic(memberId, userName, phoneNumber, birth);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [프로필 저장] (member_profile: 직업/상담일/운동목적/메모)
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/profile")
	public Map<String, Object> saveProfile(@PathVariable int memberId, @RequestParam(required = false) String job,
			@RequestParam(required = false) String consultDate, @RequestParam(required = false) String goal,
			@RequestParam(required = false) String memo) {
		service.saveProfile(memberId, job, consultDate, goal, memo);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [PT 계약 추가]
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/pt-contract")
	public Map<String, Object> addPt(@PathVariable int memberId, @RequestParam int totalSessions,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		service.addPtContract(trainer(trainerId), memberId, totalSessions);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [배정(등록)] 기존 가입 회원을 loginId로 배정
	// - 신규 생성 절대 금지
	// - 반환 code: OK_ASSIGNED / ALREADY_ASSIGNED_THIS / ASSIGNED_OTHER / NOT_FOUND
	// ------------------------------------------------------------
	@PostMapping("/assign")
	public Map<String, Object> assignByLoginId(@RequestParam String loginId,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		String code = service.assignExistingMemberByLoginId(trainer(trainerId), loginId);
		return Map.of("ok", true, "code", code);
	}

	// (선택) 등록 모달 미리보기: loginId로 회원 기본정보 조회
	@GetMapping("/lookup")
	public Map<String, Object> lookupByLoginId(@RequestParam String loginId) {
		Map<String, Object> data = service.getUserBasicByLoginId(loginId);
		return Map.of("ok", data != null, "data", data);
	}

	// ------------------------------------------------------------
	// [배정 해제] — 이력 보존 (예약/계약 삭제 안 함)
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/unassign")
	public Map<String, Object> unassignByPost(@PathVariable int memberId,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		service.unassignMember(trainer(trainerId), memberId);
		return Map.of("ok", true);
	}

	@DeleteMapping("/{memberId}")
	public Map<String, Object> unassign(@PathVariable int memberId,
			@SessionAttribute(value = "trainerId", required = false) Integer trainerId) {
		service.unassignMember(trainer(trainerId), memberId);
		return Map.of("ok", true);
	}
}