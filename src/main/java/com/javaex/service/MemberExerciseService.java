package com.javaex.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javaex.repository.MemberExerciseRepository;
import com.javaex.vo.MemberExerciseListVO;
import com.javaex.vo.MemberExerciseVO;

@Service
public class MemberExerciseService {

	@Autowired
	private MemberExerciseRepository memberExerciseRepository;

	// -- 사용자 부위별 운동 목록
	public Map<String, List<MemberExerciseVO>> exeGetExerciseListGroup(int userId) {
		System.out.println("memberExerciseService.exeGetExerciseListGroup()");

		Map<String, List<MemberExerciseVO>> groupedMap = new LinkedHashMap<>(); // LinkedHashMap --> map과 달리 순서를 보장해준다

		// 사용자가 실제로 등록한 운동 부위 목록만 먼저 가져오기
		List<String> bodyParts = memberExerciseRepository.selectBodyPartsByUser(userId);

		// db에서 가져온 목록 반복문
		for (String part : bodyParts) {

			// db에 넘겨줄 파라미터 담기
			Map<String, Object> params = new HashMap<>();
			params.put("userId", userId);
			params.put("bodyPart", part);

			// 특정 부위의 운동 리스트 가져오기
			List<MemberExerciseVO> exerciseList = memberExerciseRepository.selectListByUserAndPart(params);

			// 결과 Map에 추가
			groupedMap.put(part, exerciseList);

		}

		return groupedMap;
	}

	// -- 운동 수정 페이지
	public Map<String, Object> exeGetExerciseEditData(int userId, String bodyPart) {
		System.out.println("MemberExerciseService.exeGetExerciseEditData()");

		// 현재 부위의 모든 운동 목록
		List<MemberExerciseVO> allExercisesInPart = memberExerciseRepository.selectAllByPart(bodyPart);

		// 현재 부위에서 사용자가 선택한 운동 목록
		Map<String, Object> params = new HashMap<>();
		params.put("bodyPart", bodyPart);
		params.put("userId", userId);

		List<MemberExerciseVO> userSelectedExercisesInPart = memberExerciseRepository.selectListByUserAndPart(params);

		// 상단 탭 모든 운동 부위 리스트
		List<String> bodyParts = memberExerciseRepository.selectAllBodyParts();

		// 모든 운동 목록과 사용자가 선택한 목록 (체크박스)
		Set<Integer> selectedIds = new HashSet<>();

		for (MemberExerciseVO vo : userSelectedExercisesInPart) {
			selectedIds.add(vo.getExerciseId());
		}

		List<MemberExerciseListVO> combinedList = new ArrayList<>();

		for (MemberExerciseVO vo : allExercisesInPart) {
			MemberExerciseListVO listVO = new MemberExerciseListVO();

			listVO.setExerciseId(vo.getExerciseId());
			listVO.setExerciseName(vo.getExerciseName());

			if (selectedIds.contains(vo.getExerciseId())) {
				listVO.setChecked(true);
			} else {
				listVO.setChecked(false);
			}

			combinedList.add(listVO);
		}

		// jsp에서 사용 할 모든 데이터를 Map에 담기
		Map<String, Object> result = new HashMap<>();

		result.put("bodyPartTabs", bodyParts);
		result.put("currentBodyPart", bodyPart);
		result.put("myExerciseList", userSelectedExercisesInPart);
		result.put("allExerciseList", combinedList);

		return result;

	}

	/**
	 * [추가] 사용자의 운동 선택 목록을 업데이트(저장)합니다.
	 * 
	 * @Transactional: 이 메소드 내의 모든 DB 작업이 하나의 묶음처럼 동작하게 합니다. (하나라도 실패하면 모두 원래대로 되돌림)
	 */
	@Transactional
	public void exeUpdateUserExercises(int userId, String bodyPart, List<Integer> checkedIds) {
		System.out.println("ExerciseService.exeUpdateUserExercises()");

		// 1. 이 부위('가슴')에 대한 사용자의 기존 선택 기록을 모두 삭제합니다.
		Map<String, Object> deleteParams = new HashMap<>();
		deleteParams.put("userId", userId);
		deleteParams.put("bodyPart", bodyPart);
		memberExerciseRepository.deleteUserExercisesByPart(deleteParams);

		// 2. (만약 새로 체크한 항목이 있다면) 체크된 운동 ID 목록을 하나씩 DB에 새로 추가합니다.
		if (checkedIds != null) {
			for (Integer exerciseId : checkedIds) {
				Map<String, Object> insertParams = new HashMap<>();
				insertParams.put("userId", userId);
				insertParams.put("exerciseId", exerciseId);
				memberExerciseRepository.insertUserExercise(insertParams);
			}
		}
	}

}
