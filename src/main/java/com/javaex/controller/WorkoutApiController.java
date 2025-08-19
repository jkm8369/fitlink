package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.WorkoutService;
import com.javaex.util.JsonResult;
import com.javaex.vo.UserVO;
import com.javaex.vo.WorkoutVO;

import jakarta.servlet.http.HttpSession;

@RestController   //@Controller + @ReponseBody
@RequestMapping(value="/api/workout")
public class WorkoutApiController {
	
	@Autowired
	private WorkoutService workoutService;
	
	//-- 운동 추가 (AJAX)
	@PostMapping(value="/add")
	public JsonResult add(@ModelAttribute WorkoutVO workoutVO, HttpSession session) {
		System.out.println("WorkoutApiController.add()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		workoutVO.setUserId(authUser.getUserId());
		
		WorkoutVO wVO = workoutService.exeWorkoutAddKey(workoutVO);
		
		if(wVO != null) {
			return JsonResult.success(wVO);
		} else {
			return JsonResult.fail("저장에 실패");
		}
			
	}
	
	//-- 운동 삭제 (AJAX)
	@DeleteMapping(value="/remove/{logId}")
	public JsonResult remove(@PathVariable("logId") int logId) {
		
		System.out.println("WorkoutApiController.remove()" + logId);
		
		int count = workoutService.exeWorkoutRemove(logId);
		
		if(count == 1) {
			return JsonResult.success(count);
		} else {
			return JsonResult.fail("삭제에 실패");
		}
		
		
	}
	
	
	
	
}
