package com.javaex.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.WorkoutRepository;
import com.javaex.vo.WorkoutVO;

@Service
public class WorkoutService {

	@Autowired
	private WorkoutRepository workoutRepository;
	
	//-- 운동일지 리스트
	public List<WorkoutVO> exeGetWorkoutList(int userId) {
		System.out.println("WorkoutService.exeGetWorkoutList()");
		
		List<WorkoutVO> workoutList = workoutRepository.workoutSelectList(userId);
		
		return workoutList;
	}
	
	//-- 운동 추가
	public WorkoutVO exeWorkoutAddKey(WorkoutVO workoutVO) {
		System.out.println("WorkoutService.exeWorkoutAddKey()");
		
		int count = workoutRepository.workoutInsertKey(workoutVO);
		
		int logId = workoutVO.getLogId();
		
		WorkoutVO wVO = workoutRepository.workoutSelectOne(logId);
		
		return wVO;
	}
	
	
	
	//-- 운동 삭제
	public int exeWorkoutRemove(int logId) {
		System.out.println("WorkoutService.exeWorkoutRemove()");
		
		int count = workoutRepository.workoutRemove(logId);
		
		return count;
	}
	
	
	
}
