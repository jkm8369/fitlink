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

import com.javaex.service.MemberListService;
import com.javaex.vo.MemberVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/trainer/member-list")
public class MemberListApiController {

	private final MemberListService service;

	public MemberListApiController(MemberListService service) {
		this.service = service;
	}

	

	// ------------------------------------------------------------
	// [리스트 조회] 내 회원만
	// ------------------------------------------------------------
	@GetMapping
	public Map<String, Object> list (HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		List<MemberVO> rows = service.getMemberListForTrainer(trainerId);
		return Map.of("ok", true, "data", rows);
	}

	// ------------------------------------------------------------
	// [상세 조회] (소유 검증 포함)
	// ------------------------------------------------------------
	@GetMapping("/{memberId}")
	public Map<String, Object> detail(@PathVariable int memberId, HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		MemberVO vo = service.getMemberDetail(trainerId, memberId);
		return Map.of("ok", true, "data", vo);
	}

	// ------------------------------------------------------------
	// [편집용 상세] (소유 검증 포함) - edit 모달에서 사용
	// ------------------------------------------------------------
	@GetMapping("/{memberId}/edit")
	public Map<String, Object> detailForEdit(@PathVariable int memberId, HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		Map<String, Object> data = service.getMemberDetailForEdit(trainerId, memberId);
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
	public Map<String, Object> addPt(@PathVariable int memberId, @RequestParam int totalSessions, HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		service.addPtContract(trainerId, memberId, totalSessions);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [배정(등록)] 기존 가입 회원을 loginId로 배정
	// - 신규 생성 절대 금지
	// - 반환 code: OK_ASSIGNED / ALREADY_ASSIGNED_THIS / ASSIGNED_OTHER / NOT_FOUND
	// ------------------------------------------------------------
	@PostMapping("/assign")
	public Map<String, Object> assignByLoginId(@RequestParam String loginId, HttpSession session) {
		UserVO authUser =(UserVO) session.getAttribute("authUser");
		int trainerId = authUser.getUserId();
		
		// [문제 해결을 위한 디버깅 코드]
	    // 이 코드는 현재 로그인한 트레이너의 ID가 세션에서 올바르게 로드되었는지 확인하기 위해 추가되었습니다.
	    // 콘솔에서 "[MemberListApiController] trainerId from session: 3"과 같이 출력되어야 합니다.
	    System.out.println("[MemberListApiController] trainerId from session: " + trainerId);
		
		String code = service.assignExistingMemberByLoginId(trainerId, loginId);
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
	public Map<String, Object> unassignByPost(@PathVariable int memberId, HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		service.unassignMember(trainerId, memberId);
		return Map.of("ok", true);
	}

	@DeleteMapping("/{memberId}")
	public Map<String, Object> unassign(@PathVariable int memberId, HttpSession session) {
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int trainerId = authUser.getUserId();
		
		service.unassignMember(trainerId, memberId);
		return Map.of("ok", true);
	}
}