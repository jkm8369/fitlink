package com.javaex.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.javaex.service.MemberExerciseService;
import com.javaex.vo.MemberExerciseVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/exercise")
public class MemberExerciseController {

	@Autowired
	private MemberExerciseService memberExerciseService;

	
	// --일반 회원이 자신의 운동 종류 목록을 볼 때 사용 
	@GetMapping(value = "")
	public String exercise(HttpSession session, Model model) {
		//System.out.println("MemberExerciseController.exercise() member");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		// 공통 메소드를 호출하여 페이지를 구성
		return getExercisePage(authUser, authUser.getUserId(), model);
	}
	
	
	// -- 트레이너가 담당 회원의 운동 종류 목록을 볼 때 사용하는 메소드
	@GetMapping(value = "/member/{memberId}")
	public String exerciseByTrainer(@PathVariable("memberId") int memberId, 
									HttpSession session, 
									Model model) {
		//System.out.println("MemberExerciseController.exerciseByTrainer() for trainer");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		// 트레이너가 이 회원을 볼 권한이 있는지 확인
		boolean hasAuth = memberExerciseService.exeCheckAuth(memberId, authUser.getUserId());
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
		
		// 공통 메소드를 호출하여 페이지를 구성
		return getExercisePage(authUser, memberId, model);
	}

	
	// 운동 종류 페이지에 필요한 데이터를 준비하고 뷰를 반환하는 공통 헬퍼 메소드
	private String getExercisePage(UserVO authUser, int targetUserId, Model model) {
		
		// 1. 서비스에서 운동 종류 데이터를 가져옴
		Map<String, List<MemberExerciseVO>> exerciseMap = memberExerciseService.exeGetExerciseListGroup(targetUserId);
		model.addAttribute("exerciseMap", exerciseMap);
		
		// 2. 만약 로그인한 사용자가 트레이너라면,
		//    사이드 메뉴가 동적으로 바뀌도록 현재 보고 있는 회원의 정보를 모델에 추가
		if ("trainer".equals(authUser.getRole())) {
			UserVO currentMember = memberExerciseService.exeGetMemberInfo(targetUserId);
			model.addAttribute("currentMember", currentMember);
		}
		
		// 3. JSP 페이지 경로를 반환합니다.
		return "member/exercise";
	}
	
	// 회원용 운동 종류 수정 페이지
	@GetMapping(value = "/list-member")
	public String memberExerciseList(
			@RequestParam(value = "bodyPart", required = false, defaultValue = "가슴") String bodyPart,
			HttpSession session, Model model) {
		//System.out.println("MemberExerciseController.memberExerciseList()");

		UserVO authUser = (UserVO) session.getAttribute("authUser");

		return getExerciseListPage(authUser, authUser.getUserId(), bodyPart, model);
	}

	// 트레이너가 보는 회원 운동 종류 수정 페이지
	@GetMapping(value = "/list-member/member/{memberId}")
	public String memberExerciseListByTrainer(@PathVariable("memberId") int memberId,
			@RequestParam(value = "bodyPart", required = false, defaultValue = "가슴") String bodyPart,
			HttpSession session, Model model) {
		System.out.println("MemberExerciseController.memberExerciseListByTrainer()");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		boolean hasAuth = memberExerciseService.exeCheckAuth(memberId, authUser.getUserId());
		
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
		
		return getExerciseListPage(authUser, memberId, bodyPart, model);
	}
	
	// 운동 종류 수정 페이지 구성
	private String getExerciseListPage(UserVO authUser, int targetUserId, String bodyPart, Model model) {
		Map<String, Object> exerciseData = memberExerciseService.exeGetExerciseEditData(targetUserId, bodyPart);
		model.addAttribute("exerciseData", exerciseData);
		
		if("trainer".equals(authUser.getRole())) {
			UserVO currentMember = memberExerciseService.exeGetMemberInfo(targetUserId);
			model.addAttribute("currentMember", currentMember);
		}
		return "member/exercise-list";
	}
	
	// 회원용 본인 운동 선택 저장
	@PostMapping(value = "/update-member")
	public String updateUserExercises(@RequestParam("bodyPart") String bodyPart,
			@RequestParam(value = "exerciseIds", required = false) List<Integer> exerciseIds, HttpSession session) {
		//System.out.println("MemberExerciseController.updateUserExercises()");

		UserVO authUser = (UserVO) session.getAttribute("authUser");

		// 서비스에 업데이트 요청
		memberExerciseService.exeUpdateUserExercises(authUser.getUserId(), bodyPart, exerciseIds);

		try {
			// 리다이렉트할 URL의 한글 파라미터를 UTF-8 방식으로 직접 인코딩합니다.
			// 이렇게 하면 서버 설정과 관계없이 항상 안전하게 한글을 전달할 수 있습니다.
			String encodedBodyPart = URLEncoder.encode(bodyPart, StandardCharsets.UTF_8);
			return "redirect:/exercise/list-member?bodyPart=" + encodedBodyPart;

		} catch (Exception e) {
			// 인코딩 실패는 거의 발생하지 않지만, 만약을 대비해 에러를 출력하고 기본 페이지로 이동합니다.
			e.printStackTrace();
			return "redirect:/exercise/list-member";
		}
	}
	
	// -- 트레이너가 회원 운동 선택 저장
	@PostMapping(value = "/update-member/member/{memberId}")
	public String updateUserExercisesByTrainer(@PathVariable("memberId") int memberId,
			@RequestParam("bodyPart") String bodyPart,
			@RequestParam(value = "exerciseIds", required = false) List<Integer> exerciseIds, 
			HttpSession session) {
		//System.out.println("MemberExerciseController.updateUserExercisesByTrainer()");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		boolean hasAuth = memberExerciseService.exeCheckAuth(memberId, authUser.getUserId());
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
		
		memberExerciseService.exeUpdateUserExercises(memberId, bodyPart, exerciseIds);
		
		try {
			String encodedBodyPart = URLEncoder.encode(bodyPart, StandardCharsets.UTF_8);
			return "redirect:/exercise/list-member/member/" + memberId + "?bodyPart=" + encodedBodyPart;
		} catch (Exception e) {
			return "redirect:/trainer/members";
		}
	}
	

}
