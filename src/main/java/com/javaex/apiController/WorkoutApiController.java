package com.javaex.apiController;

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
	
	//-- 운동 추가 (ajax)
	@PostMapping(value="/add")
	public JsonResult add(@RequestBody WorkoutVO workoutVO, HttpSession session) {
		//System.out.println("WorkoutApiController.add()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		// workoutVO에 userId가 없으면(회원이 직접 기록), 세션의 ID를 사용합
		// 만약 workoutVO에 userId가 있으면(트레이너가 대리 기록), 그 ID를 그대로 사용
		if (workoutVO.getUserId() == 0) {
			workoutVO.setUserId(authUser.getUserId());
		}
		// 기록자는 항상 로그인한 사람입니다.
		workoutVO.setWriterId(authUser.getUserId());
		
		WorkoutVO wVO = workoutService.exeGetWorkoutAddKey(workoutVO);
		
		if(wVO != null) {
			return JsonResult.success(wVO);
		} else {
			return JsonResult.fail("저장에 실패했습니다.");
		}
			
	}
	
	//-- 운동 삭제 (AJAX)
	@DeleteMapping(value="/remove/{logId}")
	public JsonResult remove(@PathVariable("logId") int logId) {
		
		//System.out.println("WorkoutApiController.remove()" + logId);
		
		int count = workoutService.exeGetWorkoutRemove(logId);
		
		if(count == 1) {
			return JsonResult.success(count);
		} else {
			return JsonResult.fail("삭제에 실패했습니다.");
		}
		
		
	}
	
	//-- 사용자가 선택한 운동 목록 전체 가져오기
	@GetMapping(value="/user-exercises")
	public JsonResult UserExercises(@RequestParam(value="memberId", required=false, defaultValue="0") int memberId,
									HttpSession session) {
		//System.out.println("WorkoutApiController.UserExercises()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int targetUserId;
		if (memberId > 0) {
			// memberId가 있으면(트레이너가 회원 조회) 그 회원의 ID를 사용
			targetUserId = memberId;
		} else {
			// memberId가 없으면(회원 본인 조회) 로그인한 사용자의 ID를 사용
			targetUserId = authUser.getUserId();
		}
		
		List<WorkoutVO> exerciseList = workoutService.exeGetUserExercises(targetUserId);
		
		return JsonResult.success(exerciseList);
	}
	
	// -- 특정 날짜 운동일지 리스트
	@GetMapping(value="/logs")
	public JsonResult logsByDate(@RequestParam("logDate") String logDate, 
								 @RequestParam(value="memberId", required=false, defaultValue="0") int memberId,
								 HttpSession session) {
		//System.out.println("WorkoutApiController.logsByDate()" + logDate);
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int targetUserId;
		
		if(memberId > 0) {
			// 만약 memberId가 0보다 크면 (즉, 유효한 회원 ID가 전달되었으면)
			targetUserId = memberId;
		} else {
			// 그렇지 않으면 (memberId가 0이면)
		    targetUserId = authUser.getUserId(); // 현재 로그인한 사용자의 ID를 사용한다
		}
		
		List<WorkoutVO> workoutList = workoutService.exeGetWorkoutLogsByDate(targetUserId, logDate);
		
		return JsonResult.success(workoutList);
	}
	
	// -- 특정 월 운동 기록이 있는 날짜 리스트
	@GetMapping(value="/logged-dates")
	public JsonResult loggedDates(@RequestParam("year") int year,
								  @RequestParam("month") int month,
								  @RequestParam(value="memberId", required=false, defaultValue="0") int memberId,
								  HttpSession session) {
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int targetUserId;
		
		if(memberId > 0) {
			targetUserId = memberId;
		} else {
			targetUserId = authUser.getUserId();
		}
		
		// "2025-08" 형식으로 문자열 조합
		String yearMonth = year + "-" + String.format("%02d", month);
		
		List<String> loggedDateList = workoutService.exeGetLoggedDates(targetUserId, yearMonth);
		
		return JsonResult.success(loggedDateList);
	}
	
	
}
