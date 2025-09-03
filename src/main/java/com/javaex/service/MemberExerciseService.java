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
		// System.out.println("memberExerciseService.exeGetExerciseListGroup()");

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
		// System.out.println("MemberExerciseService.exeGetExerciseEditData()");

		// 1. 현재 부위의 모든 운동 목록 (이제 creator_id 포함)
		// creator_id가 null이거나 현재 로그인한 사용자의 ID와 같은 운동만 가져옴
		Map<String, Object> exerciseParams = new HashMap<>();
		exerciseParams.put("bodyPart", bodyPart);
		exerciseParams.put("userId", userId);
		List<MemberExerciseVO> allExercisesInPart = memberExerciseRepository.selectAllByPart(exerciseParams);

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
		// System.out.println("ExerciseService.exeUpdateUserExercises()");

		// 1. DB에 저장된, 현재 사용자가 선택한 해당 부위의 운동 목록을 가져옵니다.
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("bodyPart", bodyPart);
		List<MemberExerciseVO> previouslySelectedExercises = memberExerciseRepository.selectListByUserAndPart(params);

		// 2. 새로 체크된 운동 ID 목록을 Set으로 변환하여 검색 속도를 높입니다.
		// 만약 JSP에서 아무것도 체크하지 않고 저장하면 checkedIds가 null로 넘어올 수 있으므로,
		// null일 경우에는 비어있는 Set을 생성합니다.
		Set<Integer> newlyCheckedIds = (checkedIds != null) ? new HashSet<>(checkedIds) : new HashSet<>();

		// 3. 기존에 선택되었던 운동 목록(previouslySelectedExercises)을 하나씩 확인하면서
		// 새로 체크된 목록(newlyCheckedIds)에 없는 운동은 DB에서 삭제합니다.
		for (MemberExerciseVO exercise : previouslySelectedExercises) {
			if (!newlyCheckedIds.contains(exercise.getExerciseId())) {
				// 이 운동은 새로 체크된 목록에 없으므로 삭제 대상입니다.
				Map<String, Object> deleteParams = new HashMap<>();
				deleteParams.put("userId", userId);
				deleteParams.put("exerciseId", exercise.getExerciseId());
				memberExerciseRepository.deleteUserExerciseSelection(deleteParams);
			}
		}

		// 4. 새로 체크된 운동 ID 목록을 하나씩 확인하면서
		// 기존에 이미 선택되어 있었는지 확인하고, 없었던 운동만 DB에 새로 추가합니다.
		if (checkedIds != null) {
			for (Integer exerciseId : checkedIds) {
				// previouslySelectedExercises 목록에 현재 exerciseId가 없는 경우에만 추가
				boolean alreadyExists = false;
				for (MemberExerciseVO prevExercise : previouslySelectedExercises) {
					if (prevExercise.getExerciseId() == exerciseId) {
						alreadyExists = true;
						break;
					}
				}

				if (!alreadyExists) {
					// 이 운동은 새로 추가된 것이므로 DB에 INSERT 합니다.
					Map<String, Object> insertParams = new HashMap<>();
					insertParams.put("userId", userId);
					insertParams.put("exerciseId", exerciseId);
					memberExerciseRepository.insertUserExercise(insertParams);
				}
			}
		}
	}

	@Transactional // exercise 와 selected_exercises 두 테이블을 함께 수정하므로 트랜잭션 처리
	// -- 새로운 운동 종류 1개 추가
	public MemberExerciseVO exeAddExercise(MemberExerciseVO memberExerciseVO) {
	    System.out.println("MemberExerciseService.addExercise()");

	    // 1. 새로운 운동을 exercise 테이블에 추가합니다.
	    // insert -> insertExercise로 메소드명 수정
	    memberExerciseRepository.insertExercise(memberExerciseVO);
	    
	    // 2. (선택사항) 새로 추가된 운동을 해당 운동을 추가한 사용자(트레이너)의
	    //    '선택한 운동 목록'에도 바로 추가해주는 로직입니다.
	    //    이렇게 하면, 운동을 추가한 후 트레이너가 바로 해당 운동을 체크된 상태로 볼 수 있습니다.
	    Map<String, Object> params = new HashMap<>();
	    params.put("userId", memberExerciseVO.getCreatorId());
	    params.put("exerciseId", memberExerciseVO.getExerciseId());
	    memberExerciseRepository.insertUserExercise(params);


	    // 3. 컨트롤러에 추가된 운동 정보를 반환합니다.
	    // (selectOne 메소드가 없으므로, exerciseId가 포함된 VO를 그대로 반환)
	    return memberExerciseVO;
	}

	@Transactional
	// exercise 테이블과 selected_exercises 테이블에 모두 영향을 주므로 트랜잭션 처리
	public boolean exeDeleteExercise(int exerciseId, int currentUserId) {
		// System.out.println("MemberExerciseService.exeDeleteExercise()");

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
		// System.out.println("MemberExerciseService.exeCheckAuth()");

		Map<String, Object> params = new HashMap<>();

		params.put("memberId", memberId);
		params.put("trainerId", trainerId);

		int count = userRepository.checkMemberAssignment(params);

		return count > 0;
	}

	// --특정 회원의 기본 정보를 조회 (jsp에서 이름 표시용)
	public UserVO exeGetMemberInfo(int memberId) {
		// System.out.println("MemberExerciseService.exeGetMemberInfo()");
		return userRepository.selectUserByNo(memberId);
	}

	// 사용자가 방금 추가한 운동을 바로 선택한 목록(selected_exercises)에도 추가
	@Transactional
	public void exeSelectAddedExercise(int userId, int exerciseId) {
		Map<String, Object> insertParams = new HashMap<>();
		insertParams.put("userId", userId);
		insertParams.put("exerciseId", exerciseId);
		memberExerciseRepository.insertUserExercise(insertParams);
	}

	// 사용자가 '삭제' 버튼을 누른 운동을 selected_exercises 테이블에서만 삭제
	// exercise 테이블의 원본 데이터는 보존
	@Transactional
	public boolean exeDeleteUserExerciseSelection(int userId, int exerciseId) {
		Map<String, Object> deleteParams = new HashMap<>();
		deleteParams.put("userId", userId);
		deleteParams.put("exerciseId", exerciseId);
		int deletedRows = memberExerciseRepository.deleteUserExerciseSelection(deleteParams);
		return deletedRows > 0;
	}

}
