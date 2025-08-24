package com.javaex.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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

	// -- 사용자 부위별 운동 목록
	@GetMapping(value = "")
	public String exercise(HttpSession session, Model model) {
		System.out.println("MemberExerciseController.exercise()");

		UserVO authUser = (UserVO) session.getAttribute("authUser");

		int userId = authUser.getUserId();

		Map<String, List<MemberExerciseVO>> exerciseMap = memberExerciseService.exeGetExerciseListGroup(userId);

		model.addAttribute("exerciseMap", exerciseMap);

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

	/**
	 * [추가] (회원용) 운동 종류 선택을 저장하는 메소드
	 */
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
			// [수정] 리다이렉트할 URL의 한글 파라미터를 UTF-8 방식으로 직접 인코딩합니다.
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
