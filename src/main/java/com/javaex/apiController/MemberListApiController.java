package com.javaex.apiController;

import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.MemberListService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/trainer/member-list")
public class MemberListApiController {

	private final MemberListService service;

	public MemberListApiController(MemberListService service) {
		this.service = service;
	}

	/** (B) 모달 오픈: 단건 상세 조회 */
	@GetMapping("/{memberId}")
	public Map<String, Object> detail(@PathVariable int memberId, HttpSession session) {
		Integer trainerId = (Integer) session.getAttribute("trainerId");
		if (trainerId == null)
			trainerId = 1; // 개발용
		return Map.of("ok", true, "data", service.getMemberDetail(trainerId, memberId));
	}

	/** (C) 기본정보 저장: 이름/전화/생년월일 */
	@PostMapping("/{memberId}/basic")
	public Map<String, Object> saveBasic(@PathVariable int memberId, @RequestParam String userName,
			@RequestParam String phoneNumber, @RequestParam String birthdate) {
		service.updateBasic(memberId, userName, phoneNumber, birthdate);
		return Map.of("ok", true);
	}

	/** (D) 프로필 저장: 직업/상담일/목표/메모 */
	@PostMapping("/{memberId}/profile")
	public Map<String, Object> saveProfile(@PathVariable int memberId, @RequestParam(required = false) String job,
			@RequestParam(required = false) String consultDate, // YYYY-MM-DD
			@RequestParam(required = false) String goal, @RequestParam(required = false) String memo) {
		service.saveProfile(memberId, job, consultDate, goal, memo);
		return Map.of("ok", true);
	}

	/**
	 * (E) PT 등록횟수 ‘추가 구매’ - 예: 30 입력 → pt_contract 에 30회짜리 계약 한 건 INSERT - 합계는 조회 시
	 * SUM으로 계산되어 리스트에 반영
	 */
	@PostMapping("/{memberId}/pt-contract")
	public Map<String, Object> addPt(@PathVariable int memberId, @RequestParam int totalSessions, HttpSession session) {
		Integer trainerId = (Integer) session.getAttribute("trainerId");
		if (trainerId == null)
			trainerId = 1;
		service.addPtContract(trainerId, memberId, totalSessions);
		return Map.of("ok", true);
	}

	/** (F) 회원 삭제: 아이콘 클릭 */
	@PostMapping("/{memberId}/delete")
	public Map<String,Object> deleteByPost(@PathVariable int memberId){
	    service.deleteMember(memberId);
	    return Map.of("ok", true);
    }

    @DeleteMapping("/{memberId}")
    public Map<String, Object> delete(@PathVariable int memberId) {
        System.out.println("[API] delete memberId=" + memberId);
        service.deleteMember(memberId);
        return Map.of("ok", true);
    }
}
