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
		int targetUserId = authUser.getUserId();
		
		Map<String, Object> workoutData = workoutService.exeGetWorkoutData(targetUserId);
		
		model.addAttribute("workoutData", workoutData);
		
		return "member/workout";
	}
	
	
	// -- 트레이너가 담당 회원의 운동일지를 볼 때 사용
	
	@GetMapping(value="/member/{memberId}")
	public String workoutByTrainer(@PathVariable("memberId") int memberId, HttpSession session, Model model) {
		System.out.println("WorkoutController.workoutByTrainer() for trainer");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		// 트레이너가 이 회원을 볼 권한이 있는지 확인
		boolean hasAuth = workoutService.exeCheckAuth(memberId, authUser.getUserId());
		
		if(!hasAuth) {
			// 권한이 없으면 회원 목록 페이지로 돌려보냄
			return "redirect:/trainer/members";
		}
		
		Map<String, Object> workoutData = workoutService.exeGetWorkoutData(memberId);
		
		model.addAttribute("workoutData", workoutData);
		
		// JSP가 동적 링크를 만들 수 있도록, 현재 보고 있는 회원의 정보를 모델에 담아줌
		model.addAttribute("currentMember", workoutData.get("memberInfo"));
		
		return "member/workout";
	}
	
	/**
	 * 운동일지 페이지에 필요한 데이터를 준비하고 뷰를 반환하는 공통 헬퍼 메소드입니다.
	 */
	private String getWorkoutPage(UserVO authUser, int targetUserId, Model model) {
		
		Map<String, Object> workoutData = workoutService.exeGetWorkoutData(targetUserId);
		model.addAttribute("workoutData", workoutData);
		
		if ("trainer".equals(authUser.getRole())) {
			model.addAttribute("currentMember", workoutData.get("memberInfo"));
		}
		
		return "member/workout";
	}
	
}
