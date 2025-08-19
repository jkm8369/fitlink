package com.javaex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	public JsonResult add(@RequestBody WorkoutVO workoutVO, HttpSession session) {
		//System.out.println("WorkoutApiController.add()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		workoutVO.setUserId(authUser.getUserId());
		workoutVO.setWriterId(authUser.getUserId());
		
		System.out.println(authUser.getUserId());
		
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
		
		//System.out.println("WorkoutApiController.remove()" + logId);
		
		int count = workoutService.exeWorkoutRemove(logId);
		
		if(count == 1) {
			return JsonResult.success(count);
		} else {
			return JsonResult.fail("삭제에 실패");
		}
		
		
	}
	
	//-- 사용자가 선택한 운동 목록 전체 가져오기
	@GetMapping(value="/user-exercises")
	public JsonResult UserExercises(HttpSession session) {
		//System.out.println("WorkoutApiController.UserExercises()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		List<WorkoutVO> exerciseList = workoutService.exeUserExercises(authUser.getUserId());
		
		return JsonResult.success(exerciseList);
	}
	
	// -- 특정 날짜 운동일지 리스트
	@GetMapping(value="/logs")
	public JsonResult logsByDate(@RequestParam("logDate") String logDate, HttpSession session) {
		//System.out.println("WorkoutApiController.logsByDate()" + logDate);
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int userId = authUser.getUserId();
		
		List<WorkoutVO> workoutList = workoutService.exeWorkoutLogsByDate(userId, logDate);
		
		return JsonResult.success(workoutList);
	}
	
	
	
	
}
