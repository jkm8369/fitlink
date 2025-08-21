package com.javaex.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.javaex.vo.MemberExerciseVO;

@Repository
public class MemberExerciseRepository {

	@Autowired
	private SqlSession sqlSession;
	
	// -- 사용자가 선택한 운동 부위만 가져오기
	public List<String> selectBodyPartsByUser (int userId) {
		System.out.println("memberExerciseRepository.selectBodyPartsByUser");
		
		List<String> bodyPartList = sqlSession.selectList("memberExercise.selectBodyPartsByUser", userId);
		
		return bodyPartList;
	}
	
	
	
	// -- 사용자 특정 부위 리스트 가져오기
	public List<MemberExerciseVO> selectListByUserAndPart (Map<String, Object> params) {
		System.out.println("memberExerciseRepository.selectListByUserAndPart()");
		
		List<MemberExerciseVO> exerciseList= sqlSession.selectList("memberExercise.selectListByUserAndPart", params);
		
		return exerciseList;
	}
	
	// -- 특정 부위의 모든 운동 리스트 가져오기
	public List<MemberExerciseVO> selectAllByPart(String bodyPart) {
		System.out.println("MemberExerciseRepository.selectAllByPart()");
		
		
		List<MemberExerciseVO> exerciseList = sqlSession.selectList("memberExercise.selectAllByPart", bodyPart);
		
		return exerciseList;
	}
	
	
}
