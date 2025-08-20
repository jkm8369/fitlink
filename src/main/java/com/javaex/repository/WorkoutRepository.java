package com.javaex.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.javaex.vo.WorkoutVO;

@Repository
public class WorkoutRepository {

	@Autowired
	private SqlSession sqlSession;
	
	//-- 운동일지 리스트
	public List<WorkoutVO> workoutSelectList(int userId) {
		//System.out.println("WorkoutRepository.selectList()");
		
		List<WorkoutVO> workoutList = sqlSession.selectList("workout.workoutSelectList", userId);
		
		return workoutList;
	}
	
	//-- 사용자가 선택한 운동 목록 전체 가져오기
	public List<WorkoutVO> selectUserExercises(int userId) {
		//System.out.println("WorkoutRepository.selectUserExercises()");
		
		List<WorkoutVO> exerciseList = sqlSession.selectList("workout.selectUserExercises", userId);
		
		return exerciseList;
	}
	
	// -- 특정 날짜 운동일지 리스트
	public List<WorkoutVO> workoutSelectByDate(Map<String, Object> params) {
		//System.out.println("WorkoutRepository.workoutSelectByDate()");
		
		List<WorkoutVO> workoutList = sqlSession.selectList("workout.workoutSelectListByDate", params);
		
		return workoutList;
	}
	
	// -- 특정 월 운동 기록 있는 날짜 리스트
	public List<String> selectLoggedDates(Map<String, Object> params) {
		//System.out.println("WorkoutRepository.selectLoggedDates()");
		
		List<String> loggedDateList= sqlSession.selectList("workout.selectLoggedDates", params);
		
		return loggedDateList;
	}
	
	
	// -- logId로 회원 리스트 조회
	public WorkoutVO workoutSelectOne(int logId) {
		//System.out.println("WorkoutRepository.workoutSelectOne()");
		
		WorkoutVO wVO = sqlSession.selectOne("workout.workoutSelectOne", logId);
		
		return wVO;
	}
	
	//-- 운동 추가
	public int workoutInsertKey(WorkoutVO workoutVO) {
		//System.out.println("WorkoutRepository.workoutInsertKey()");
		
		int count = sqlSession.insert("workout.insertKey", workoutVO);
		
		return count;
	}
	
	//-- 운동 삭제
	public int workoutRemove(int logId) {
		//System.out.println("WorkoutRepository.workoutRemove()");
		
		
		int count = sqlSession.delete("workout.workoutRemove", logId);
		
		return count;
	}
	
}
