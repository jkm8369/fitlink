package com.javaex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.WorkoutService;
import com.javaex.vo.UserVO;
import com.javaex.vo.WorkoutVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/workout")
public class WorkoutController {

	@Autowired
	private WorkoutService workoutService;
	
	//-- 운동일지 리스트
	@GetMapping(value="")
	public String workout(HttpSession session, Model model) {
		System.out.println("WorkoutController.workout()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		if(authUser == null) {
			return "redirect:/user/loginform";
		} else {
			int userId = authUser.getUserId();
			List<WorkoutVO> workoutList = workoutService.exeGetWorkoutList(userId);
			
			model.addAttribute("workoutList", workoutList);
			
			return "member/workout";
		}
		
		
	}
	
}
