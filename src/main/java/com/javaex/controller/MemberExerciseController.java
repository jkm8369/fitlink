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
		System.out.println("MemberExerciseController.exercise() member");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		// 공통 메소드를 호출하여 페이지를 구성
		return getExercisePage(authUser, authUser.getUserId(), model);
	}
	
	
	// -- 트레이너가 담당 회원의 운동 종류 목록을 볼 때 사용하는 메소드
	@GetMapping(value = "/member/{memberId}")
	public String exerciseByTrainer(@PathVariable("memberId") int memberId, HttpSession session, Model model) {
		System.out.println("MemberExerciseController.exerciseByTrainer() for trainer");
		
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		
		// 트레이너가 이 회원을 볼 권한이 있는지 확인
		boolean hasAuth = memberExerciseService.exeCheckAuth(memberId, authUser.getUserId());
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
		
		// 공통 메소드를 호출하여 페이지를 구성
		return getExercisePage(authUser, memberId, model);
	}

	/**
	 * [추가] 운동 종류 페이지에 필요한 데이터를 준비하고 뷰를 반환하는 공통 헬퍼 메소드입니다.
	 * @param authUser      현재 로그인한 사용자 정보 (회원 또는 트레이너)
	 * @param targetUserId  데이터를 조회할 대상의 ID
	 * @param model         JSP로 데이터를 전달할 모델 객체
	 * @return              보여줄 JSP 뷰의 이름
	 */
	private String getExercisePage(UserVO authUser, int targetUserId, Model model) {
		
		// 1. 서비스에서 운동 종류 데이터를 가져옵니다.
		Map<String, List<MemberExerciseVO>> exerciseMap = memberExerciseService.exeGetExerciseListGroup(targetUserId);
		model.addAttribute("exerciseMap", exerciseMap);
		
		// 2. 만약 로그인한 사용자가 트레이너라면,
		//    사이드 메뉴가 동적으로 바뀌도록 현재 보고 있는 회원의 정보를 모델에 추가합니다.
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
		System.out.println("MemberExerciseController.memberExerciseList()");

		UserVO authUser = (UserVO) session.getAttribute("authUser");

		int userId = authUser.getUserId();

		// 수정 페이지에 필요한 모든 데이터 가져오기
		Map<String, Object> exerciseData = memberExerciseService.exeGetExerciseEditData(userId, bodyPart);

		// 받아온 데이터를 모델에 담아 jsp로 전달
		model.addAttribute("exerciseData", exerciseData);

		return "member/exercise-list";
	}

	
	// 회원용 운동 종류 선택을 저장하는 메소드
	@PostMapping(value = "/update-member")
	public String updateUserExercises(@RequestParam("bodyPart") String bodyPart,
			@RequestParam(value = "exerciseIds", required = false) List<Integer> exerciseIds, HttpSession session) {
		System.out.println("ExerciseController.updateUserExercises()");

		UserVO authUser = (UserVO) session.getAttribute("authUser");
		if (authUser == null) {
			return "redirect:/user/loginform";
		}

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
	
	

}
