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
import com.javaex.repository.UserRepository;
import com.javaex.vo.MemberExerciseListVO;
import com.javaex.vo.MemberExerciseVO;
import com.javaex.vo.UserVO;

@Service
public class MemberExerciseService {

	@Autowired
	private MemberExerciseRepository memberExerciseRepository;
	
	@Autowired
    private UserRepository userRepository;

	// -- 사용자 부위별 운동 목록
	public Map<String, List<MemberExerciseVO>> exeGetExerciseListGroup(int userId) {
		//System.out.println("memberExerciseService.exeGetExerciseListGroup()");

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
		//System.out.println("MemberExerciseService.exeGetExerciseEditData()");

		// 1. 현재 부위의 모든 운동 목록 (이제 creator_id 포함)
		List<MemberExerciseVO> allExercisesInPart = memberExerciseRepository.selectAllByPart(bodyPart);

		// 2. 사용자가 선택한 운동 ID 목록 (빠른 조회를 위해 Set 사용)
		Map<String, Object> userParams = new HashMap<>();

		userParams.put("bodyPart", bodyPart);
		userParams.put("userId", userId);

		List<MemberExerciseVO> userSelectedExercises = memberExerciseRepository.selectListByUserAndPart(userParams);

		Set<Integer> selectedIds = new HashSet<>();

		for (MemberExerciseVO vo : userSelectedExercises) {
			selectedIds.add(vo.getExerciseId());
		}

		// 3. '기본 운동'과 '사용자 추가 운동'으로 분리
		List<MemberExerciseListVO> systemExerciseList = new ArrayList<>();
		List<MemberExerciseListVO> customExerciseList = new ArrayList<>();

		for (MemberExerciseVO vo : allExercisesInPart) {
			MemberExerciseListVO listVO = new MemberExerciseListVO();

			listVO.setExerciseId(vo.getExerciseId());
			listVO.setExerciseName(vo.getExerciseName());
			listVO.setChecked(selectedIds.contains(vo.getExerciseId()));

			// creatorId가 null이면 기본 운동, 아니면 사용자 추가 운동
			if (vo.getCreatorId() == null) {
				systemExerciseList.add(listVO);
			} else {
				customExerciseList.add(listVO);
			}

		}

		// 4. 상단 탭에 표시될 모든 운동 부위 리스트
		List<String> bodyParts = memberExerciseRepository.selectAllBodyParts();

		// 5. JSP로 보낼 최종 데이터를 Map에 담기
		Map<String, Object> result = new HashMap<>();

		result.put("bodyPartTabs", bodyParts);
		result.put("currentBodyPart", bodyPart);
		result.put("myExerciseList", userSelectedExercises); // 내가 선택한 리스트
		result.put("systemExerciseList", systemExerciseList); // 분리된 기본 운동 리스트
		result.put("customExerciseList", customExerciseList); // 분리된 사용자 추가 운동 리스트

		return result;

	}

	/**
	 * [추가] 사용자의 운동 선택 목록을 업데이트(저장)합니다.
	 * 
	 * @Transactional: 이 메소드 내의 모든 DB 작업이 하나의 묶음처럼 동작하게 합니다. (하나라도 실패하면 모두 원래대로 되돌림)
	 */
	@Transactional
	public void exeUpdateUserExercises(int userId, String bodyPart, List<Integer> checkedIds) {
		//System.out.println("ExerciseService.exeUpdateUserExercises()");

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

	// -- 새로운 운동 종류 1개 추가
	public MemberExerciseVO exeAddExercise(MemberExerciseVO memberExerciseVO, int creatorId) {
		//System.out.println("ExerciseService.exeAddExercise()");

		// 파라미터로 받은 creatorId를 VO에 설정
		memberExerciseVO.setCreatorId(creatorId);

		// insert가 성공하면 exerciseVO 객체에 새로 생성된 exerciseId가 담깁니다.
		int count = memberExerciseRepository.insertExercise(memberExerciseVO);

		if (count > 0) {
			// 성공 시, ID가 포함된 exerciseVO를 반환합니다.
			return memberExerciseVO;
		} else {
			// 실패 시 null을 반환합니다.
			return null;
		}
	}
	
	@Transactional // exercise 테이블과 selected_exercises 테이블에 모두 영향을 주므로 트랜잭션 처리
    public boolean exeDeleteExercise(int exerciseId, int currentUserId) {
        //System.out.println("MemberExerciseService.exeDeleteExercise()");

        // DB에 넘길 파라미터를 Map에 담습니다.
        Map<String, Object> params = new HashMap<>();
        params.put("exerciseId", exerciseId);
        params.put("creatorId", currentUserId); // creator_id가 현재 로그인한 사용자와 일치해야만 합니다.

        // Repository를 통해 삭제를 시도하고, 삭제된 행의 수를 받습니다.
        int deletedRows = memberExerciseRepository.deleteExerciseByIdAndCreator(params);

        // 1개 행이 삭제되었다면 성공(true), 그렇지 않다면 실패(false)를 반환합니다.
        return deletedRows > 0;
    }
	
	
    // --트레이너가 특정 회원을 조회할 권한이 있는지 확인하는 보안 메소드
    public boolean exeCheckAuth(int memberId, int trainerId) {
        //System.out.println("MemberExerciseService.exeCheckAuth()");
        
        Map<String, Object> params = new HashMap<>();
        
        params.put("memberId", memberId);
        params.put("trainerId", trainerId);
        
        int count = userRepository.checkMemberAssignment(params);
        
        return count > 0;
    }
    

    // --특정 회원의 기본 정보를 조회 (jsp에서 이름 표시용)
    public UserVO exeGetMemberInfo(int memberId) {
        //System.out.println("MemberExerciseService.exeGetMemberInfo()");
        return userRepository.selectUserByNo(memberId);
    }
	
	
}
