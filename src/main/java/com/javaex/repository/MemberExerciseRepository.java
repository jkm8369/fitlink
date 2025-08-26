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
	
	// -- 모든 운동 부위 리스트 가져오기
	public List<String> selectAllBodyParts() {
		System.out.println("MemberExerciseRepository.selectAllBodyParts()");
		
		List<String> bodyPart = sqlSession.selectList("memberExercise.selectAllBodyParts");
		
		return bodyPart;
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
	
	
	
    // -- 특정 부위에 대한 사용자의 운동 선택 기록을 모두 삭제
    public void deleteUserExercisesByPart(Map<String, Object> params) {
        System.out.println("ExerciseRepository.deleteUserExercisesByPart()");
        
        sqlSession.delete("memberExercise.deleteUserExercisesByPart", params);
    }

   
    // -- 사용자가 선택한 운동을 하나 추가  
    public void insertUserExercise(Map<String, Object> params) {
        System.out.println("ExerciseRepository.insertUserExercise()");
        
        sqlSession.insert("memberExercise.insertUserExercise", params);
    }
	
    // -- 새로운 운동 종류 1개 추가
    public int insertExercise(MemberExerciseVO memberExerciseVO) {
        System.out.println("ExerciseRepository.insertExercise()");
        
        int addExercise = sqlSession.insert("memberExercise.insertExercise", memberExerciseVO);
        
        return addExercise;
    }
    
    // -- 운동 ID와 생성자 ID를 조건으로 exercise 테이블에서 데이터를 삭제하는 메소드
    public int deleteExerciseByIdAndCreator(Map<String, Object> params) {
        System.out.println("MemberExerciseRepository.deleteExerciseByIdAndCreator()");
        
        int removeExercise = sqlSession.delete("memberExercise.deleteExerciseByIdAndCreator", params);
        
        return removeExercise;
    }
    
    
}
