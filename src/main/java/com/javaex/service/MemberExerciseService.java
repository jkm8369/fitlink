package com.javaex.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.MemberExerciseRepository;
import com.javaex.vo.MemberExerciseVO;

@Service
public class MemberExerciseService {

	@Autowired
	private MemberExerciseRepository memberExerciseRepository;
	
	public Map<String, List<MemberExerciseVO>> exeExerciseListGroup(int userId) {
		System.out.println("memberExerciseService.exeExerciseListGroup()");
		
		Map<String, List<MemberExerciseVO>> groupedMap = new LinkedHashMap<>();      //LinkedHashMap --> map과 달리 순서를 보장해준다
		
		//사용자가 실제로 등록한 운동 부위 목록만 먼저 가져오기
		List<String> bodyParts = memberExerciseRepository.selectBodyPartsByUser(userId);
		
		//db에서 가져온 목록 반복문
		for(String part : bodyParts) {
			
			//db에 넘겨줄 파라미터 담기
			Map<String, Object> params = new HashMap<>();
			params.put("userId", userId);
			params.put("bodyPart", part);
			
			//특정 부위의 운동 리스트 가져오기
			List<MemberExerciseVO> exerciseList = memberExerciseRepository.selectListByUserAndPart(params);
			
			//결과 Map에 추가
			groupedMap.put(part, exerciseList);
			
		}
		
		return groupedMap;
	}
	
	
	
	
	
	
}
