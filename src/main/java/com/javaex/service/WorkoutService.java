package com.javaex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.UserRepository;
import com.javaex.repository.WorkoutRepository;
import com.javaex.vo.UserVO;
import com.javaex.vo.WorkoutVO;


@Service
public class WorkoutService {

	@Autowired
	private WorkoutRepository workoutRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	
	// --운동 목록과 조회한 회원 정보도 함께 반환
	public Map<String, Object> exeGetWorkoutData(int targetUserId) {
		System.out.println("WorkoutService.exeGetWorkoutData()");
		
		// 1. 해당 회원의 운동일지 목록을 가져옵니다.
		List<WorkoutVO> workoutList = workoutRepository.workoutSelectList(targetUserId);
		
		// 2. 해당 회원의 기본 정보를 가져옵니다. (JSP에서 이름 등을 표시하기 위함)
		UserVO memberInfo = userRepository.selectUserByNo(targetUserId);
		
		// 3. 두 종류의 데이터를 하나의 Map에 담아 컨트롤러로 반환합니다.
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("workoutList", workoutList);
		resultMap.put("memberInfo", memberInfo);
		
		return resultMap;
	}
	
	// -- 트레이너가 특정 회원을 조회할 권한이 있는지 확인하는 보안 메소드
	public boolean exeCheckAuth(int memberId, int trainerId) {
		System.out.println("WorkoutService.exeCheckAuth()");
		
		Map<String, Object> params = new HashMap<>();
		
		params.put("memberId", memberId);
		params.put("trainerId", trainerId);
		
		// DB에 두 ID의 관계가 등록되어 있는지 확인합니다.
		int count = userRepository.checkMemberAssignment(params);
		
		return count > 0; // 1 이상이면(관계가 존재하면) true를 반환
	}
	
	//-- 사용자가 선택한 운동 목록 전체 가져오기
	public List<WorkoutVO> exeGetUserExercises(int userId) {
		//System.out.println("WorkoutService.exeGetUserExercises()");
		
		List<WorkoutVO> exerciseList = workoutRepository.selectUserExercises(userId);
		
		return exerciseList;
	}
	
	// -- 특정 날짜 운동일지 리스트
	public List<WorkoutVO> exeGetWorkoutLogsByDate(int userId, String logDate) {
		//System.out.println("WorkoutService.exeGetWorkoutLogsByDate()");
		
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("logDate", logDate);
		
		List<WorkoutVO> workoutList= workoutRepository.workoutSelectByDate(params);
		
		return workoutList;
	}
	
	//-- 특정 월에 운동 기록이 있는 날짜 목록 조회
	public List<String> exeGetLoggedDates(int userId, String yearMonth) {
		//System.out.println("WorkoutService.exeGetLoggedDates()");
		
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("yearMonth", yearMonth);
		
		List<String> loggedDateList = workoutRepository.selectLoggedDates(params);
		
		return loggedDateList;
	}
	
	
	//-- 운동 추가
	public WorkoutVO exeGetWorkoutAddKey(WorkoutVO workoutVO) {
		//System.out.println("WorkoutService.exeWorkoutAddKey()");
		
		int count = workoutRepository.workoutInsertKey(workoutVO);
		
		int logId = workoutVO.getLogId();
		
		WorkoutVO wVO = workoutRepository.workoutSelectOne(logId);
		
		return wVO;
	}
	
	
	
	//-- 운동 삭제
	public int exeGetWorkoutRemove(int logId) {
		//System.out.println("WorkoutService.exeWorkoutRemove()");
		
		int count = workoutRepository.workoutRemove(logId);
		
		return count;
	}
	
	
	
}
