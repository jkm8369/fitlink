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
        
		
		// 저장 후, 원래 보던 부위 페이지로 다시 돌아감
		return "redirect:/exercise/list-member?bodyPart=" + bodyPart;
	}

}
