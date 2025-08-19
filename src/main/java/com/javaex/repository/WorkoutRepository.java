package com.javaex.repository;

import java.util.List;

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
		System.out.println("WorkoutRepository.selectList()");
		
		List<WorkoutVO> workoutList = sqlSession.selectList("workout.workoutSelectList", userId);
		
		return workoutList;
	}
	
	public WorkoutVO workoutSelectOne(int logId) {
		System.out.println("WorkoutRepository.workoutSelectOne()");
		
		WorkoutVO wVO = sqlSession.selectOne("workout.workoutSelectOne", logId);
		
		return wVO;
	}
	
	//-- 운동 추가
	public int workoutInsertKey(WorkoutVO workoutVO) {
		System.out.println("WorkoutRepository.workoutInsertKey()");
		
		int count = sqlSession.insert("workout.insertKey", workoutVO);
		
		return count;
	}
	
	//-- 운동 삭제
	public int workoutRemove(int logId) {
		System.out.println("WorkoutRepository.workoutRemove()");
		
		
		int count = sqlSession.delete("workout.workoutRemove", logId);
		
		return count;
	}
	
}
