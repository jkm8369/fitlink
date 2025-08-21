package com.javaex.repository;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.javaex.vo.TrainerExerciseVO;

@Repository
public class TrainerExerciseRepository {

	@Autowired
	private SqlSession sqlSession;
	
	public List<TrainerExerciseVO> selectListByUser(int userId) {
		System.out.println("TrainerExerciseRepository.selectListByUser()");
		
		List<TrainerExerciseVO> exerciseList= sqlSession.selectList("trainerExercise.selectListByUser", userId);
		
		return exerciseList;
	}
	
}
