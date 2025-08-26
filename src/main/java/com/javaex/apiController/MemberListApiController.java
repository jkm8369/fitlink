package com.javaex.apiController;

import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

	// ------------------------------------------------------------
	// [상세 조회]
	// ------------------------------------------------------------
	@GetMapping("/{memberId}")
	public Map<String, Object> detail(@PathVariable int memberId, @SessionAttribute("trainerId") Integer trainerId) {
		MemberVO vo = service.getMemberDetail(trainerId, memberId);
		return Map.of("ok", true, "data", vo);
	}

	// ------------------------------------------------------------
	// [기본정보 저장] (이름/전화/생년월일)
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/basic")
	public Map<String, Object> saveBasic(@PathVariable int memberId, @RequestParam String userName,
			@RequestParam String phoneNumber, @RequestParam String birthdate) {
		service.updateUsersBasic(memberId, userName, phoneNumber, birthdate);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [프로필 저장] (직업/상담일/운동목적/메모)
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
			@SessionAttribute("trainerId") Integer trainerId) {
		service.addPtContract(trainerId, memberId, totalSessions);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [삭제=연결 해제] (POST 호환)
	// ------------------------------------------------------------
	@PostMapping("/{memberId}/delete")
	public Map<String, Object> deleteByPost(@PathVariable int memberId,
			@SessionAttribute("trainerId") Integer trainerId) {
		service.unlinkMember(trainerId, memberId);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [삭제=연결 해제] (HTTP DELETE)
	// ------------------------------------------------------------
	@DeleteMapping("/{memberId}")
	public Map<String, Object> delete(@PathVariable int memberId, @SessionAttribute("trainerId") Integer trainerId) {
		service.unlinkMember(trainerId, memberId);
		return Map.of("ok", true);
	}

	// ------------------------------------------------------------
	// [회원 생성 + 트레이너 배정]
	// ------------------------------------------------------------
	@PostMapping
	public Map<String, Object> create(@RequestBody Map<String, Object> body,
			@SessionAttribute("trainerId") Integer trainerId) {
		int userId = service.createMemberAndAssignTrainer(trainerId, body);
		return Map.of("ok", true, "userId", userId, "trainerId", trainerId);
	}

}
