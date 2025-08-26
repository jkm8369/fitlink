package com.javaex.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.WorkoutService;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/workout")
public class WorkoutController {

	@Autowired
	private WorkoutService workoutService;
	
	
	// -- 일반 회원이 자신의 운동 종류 목록을 볼 때 사용 
	@GetMapping(value="")
	public String workout(HttpSession session, Model model) {
		System.out.println("WorkoutController.workout() for member");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		return getWorkoutPage(authUser, authUser.getUserId(), model);
	}
	
	
	// -- 트레이너가 담당 회원의 운동일지를 볼 때 사용
	@GetMapping(value="/member/{memberId}")
	public String workoutByTrainer(@PathVariable("memberId") int memberId, HttpSession session, Model model) {
		System.out.println("WorkoutController.workoutByTrainer() for trainer");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		boolean hasAuth = workoutService.exeCheckAuth(memberId, authUser.getUserId());
		
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
		
		return getWorkoutPage(authUser, memberId, model);
	}
	
	/**
	 * 운동일지 페이지에 필요한 데이터를 준비하고 뷰를 반환하는 공통 헬퍼 메소드입니다.
	 */
	private String getWorkoutPage(UserVO authUser, int targetUserId, Model model) {
		
		//서비스에 targetUserId를 전달하여 필요한 데이터를 가져옴
		Map<String, Object> workoutData = workoutService.exeGetWorkoutData(targetUserId);
		model.addAttribute("workoutData", workoutData);
		
		// 만약 로그인한 사용자가 트레이너라면, 사이드 메뉴가 동적으로 바뀌도록 현재 보고 있는 회원의 정보('currentMember')를 모델에 추가
		if ("trainer".equals(authUser.getRole())) {
			model.addAttribute("currentMember", workoutData.get("memberInfo"));
		}
		
		// 최종적으로 보여줄 jsp 페이지의 경로를 반환
		return "member/workout";
	}
	
}
