package com.javaex.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.InbodyRepository;
import com.javaex.repository.UserRepository;
import com.javaex.vo.InbodyVO;
import com.javaex.vo.UserVO;

@Service
public class InbodyService {

	@Autowired
	private InbodyRepository inbodyRepository;

	@Autowired
	private UserRepository userRepository;

	// 특정 회원의 인바디 기록 목록과 페이징 정보를 가져오기
	public Map<String, Object> exeGetList(int userId, int crtPage) {
		// System.out.println("InbodyService.exeGetList()");

		// 한페이지 리스트 출력 갯수
		int listCnt = 5;

		// 페이지당 버튼 갯수
		int pageBtnCount = 5;

		// 페이징 계산
		int startRownum = (crtPage - 1) * listCnt;

		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("startRownum", startRownum);
		params.put("listCnt", listCnt);

		List<InbodyVO> inbodyList = inbodyRepository.selectListByUserId(params);

		// 페이징 버튼 계산
		int totalCount = inbodyRepository.selectTotalCount(userId);

		int endPageBtnNo = (int) Math.ceil((double) crtPage / pageBtnCount) * pageBtnCount;
		int startPageBtnNo = endPageBtnNo - (pageBtnCount - 1);

		boolean prev = startPageBtnNo != 1;
		boolean next = endPageBtnNo * listCnt < totalCount;

		if (next == false) {
			endPageBtnNo = (int) Math.ceil((double) totalCount / listCnt);
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("inbodyList", inbodyList);
		resultMap.put("prev", prev);
		resultMap.put("next", next);
		resultMap.put("startPageBtnNo", startPageBtnNo);
		resultMap.put("endPageBtnNo", endPageBtnNo);
		resultMap.put("totalCount", totalCount);

		return resultMap;
	}

	// 특정 인바디 기록의 상세 정보 가져오기
	public InbodyVO exeGetInbody(int inbodyId) {
		System.out.println("InbodyService.exeGetInbody()");

		return inbodyRepository.selectOneByInbodyId(inbodyId);
	}

	// 특정 인바디 기록 삭제
	public int exeDelete(int inbodyId) {
		// [CHECK 2] 서비스 메소드가 잘 호출되었는지 확인
		// System.out.println("[CHECK 2] InbodyService: exeDelete 호출됨 (ID: " + inbodyId
		// + ")");

		return inbodyRepository.delete(inbodyId);
	}

	// -- 트레이너가 특정 회원을 조회할 권한이 있는지 확인하는 보안 메소드
	public boolean exeCheckAuth(int memberId, int trainerId) {
		// System.out.println("WorkoutService.exeCheckAuth()");
		Map<String, Object> params = new HashMap<>();
		params.put("memberId", memberId);
		params.put("trainerId", trainerId);

		// DB에 두 ID의 관계가 등록되어 있는지 확인합니다.
		int count = userRepository.checkMemberAssignment(params);

		return count > 0; // 1 이상이면(관계가 존재하면) true를 반환
	}

	/**
	 * [최종 완성본] 사용자가 직접 입력한 값으로 인바디 전체 데이터를 계산하고 저장합니다. - 그램(g)을 먼저 계산하고 칼로리를 역산하여,
	 * 끼니별 데이터 정합성까지 완벽하게 해결
	 * 
	 * @param inputVO  키, 체중, 골격근량, 체지-방량, 인바디점수가 담긴 VO
	 * @param authUser 로그인한 사용자 정보
	 * @return 저장된 전체 인바디 정보가 담긴 VO
	 */
	public InbodyVO exeManualAdd(InbodyVO inputVO, UserVO authUser) {
		// System.out.println("InbodyService.exeManualAdd() - Final Data Consistency
		// Version");

		int targetUserId;
		if ("trainer".equals(authUser.getRole()) && inputVO.getUserId() > 0) {
			// 트레이너가 등록하고, 요청에 회원 ID가 있으면 그 ID를 사용
			targetUserId = inputVO.getUserId();
		} else {
			// 그 외의 경우(회원 본인 등록 등)에는 로그인한 사용자 ID를 사용
			targetUserId = authUser.getUserId();
		}

		// 사용자 정보를 targetUserId 기준으로 조회
		UserVO fullUserVO = userRepository.selectUserByNo(targetUserId);
		int age = java.time.LocalDate.now().getYear() - Integer.parseInt(fullUserVO.getBirthDate().substring(0, 4));
		String gender = fullUserVO.getGender();

		InbodyVO fullData = new InbodyVO();
		fullData.setUserId(targetUserId); // 결정된 targetUserId를 사용

		fullData.setRecordDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

		fullData.setHeight(inputVO.getHeight());
		fullData.setWeightKg(inputVO.getWeightKg());
		fullData.setMuscleMassKg(inputVO.getMuscleMassKg());
		fullData.setFatMassKg(inputVO.getFatMassKg());
		fullData.setInbodyScore(inputVO.getInbodyScore());
		fullData.setVisceralFatLevel(inputVO.getVisceralFatLevel());

		// ... (2. 주요 지표 계산 ~ CID 유형 판단 코드는 이전과 동일)
		double height = fullData.getHeight();
		double weight = fullData.getWeightKg();
		double muscleMass = fullData.getMuscleMassKg();
		double fatMass = fullData.getFatMassKg();

		double heightM = height / 100.0;
		double bmi = weight / (heightM * heightM);
		fullData.setBmi(Math.round(bmi * 10.0) / 10.0);

		double pbf = (fatMass / weight) * 100;
		fullData.setPercentBodyFat(Math.round(pbf * 10.0) / 10.0);

		double idealBmi = "male".equalsIgnoreCase(gender) ? 22 : 21;

		double idealMuscleRatio = "male".equalsIgnoreCase(gender) ? 0.45 : 0.40;
	    
		double idealFatRatio = "male".equalsIgnoreCase(gender) ? 0.15 : 0.23;

		double idealWeight = idealBmi * (heightM * heightM);
		double stdMuscle = idealWeight * idealMuscleRatio;
		double stdFat = idealWeight * idealFatRatio;

		// ======================= 체성분 조절 계산 =======================

		// 지방 조절량: 현재 - 표준 → 감량해야 할 양 (음수면 0)
		double fatControl = fatMass - stdFat;
		if (fatControl < 0) fatControl = 0;
		fatControl = Math.round(fatControl * 10.0) / 10.0;
		fullData.setFatControlKg(fatControl);

		// 근육 조절량: 표준 - 현재 → 증량해야 할 양 (음수면 0)
		double muscleControl = stdMuscle - muscleMass;
		if (muscleControl < 0) muscleControl = 0;
		muscleControl = Math.round(muscleControl * 10.0) / 10.0;
		fullData.setMuscleControlKg(muscleControl);

		// 안전장치: 혹시라도 음수가 내려가면 0으로 강제
		fullData.setFatControlKg(Math.max(0.0, fullData.getFatControlKg()));
		fullData.setMuscleControlKg(Math.max(0.0, fullData.getMuscleControlKg()));

		// C형(비만) 판별을 D형(근육)보다 먼저 하도록 순서를 변경
		// 이렇게 하면, 근육과 지방이 모두 많은 사용자가 D형이 아닌 C형으로 정확하게 분류되어
		// '체지방 감량'이라는 더 시급한 목표를 제시받게 됩니다.
		// stdFat * 1.1: 표준 체지방량의 110%를 의미하는 경계값
		if (fatMass >= stdFat * 1.1) {
			fullData.setCidType("C"); // 1순위: 체지방이 표준의 110% 이상이면 'C형'

			// ※ stdMuscle * 1.1: 표준 근육량의 110%를 의미하는 경계값입니다.
		} else if (muscleMass >= stdMuscle * 1.1) {
			fullData.setCidType("D"); // 2순위: (비만이 아니면서) 근육량이 표준의 110% 이상이면 'D형'

		} else {
			fullData.setCidType("I"); // 3순위: 위 두 조건에 해당하지 않으면 'I형'
		}

		// ... (3. 목표 칼로리 및 비율 설정 코드는 이전과 동일)
		double bmr;
		if ("male".equalsIgnoreCase(gender)) {
			bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
		} else {
			bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
		}

		double maintenanceCalories = bmr * 1.375;
		int targetCalories = 0;

		fullData.setRequiredProteinG((int) (weight * 0.8));

		switch (fullData.getCidType()) {
		case "C":
			targetCalories = (int) (maintenanceCalories - 500);
			fullData.setCarbRatio(40);
			fullData.setProteinRatio(40);
			fullData.setFatRatio(20);
			break;
		case "D":
			targetCalories = (int) (maintenanceCalories + 300);
			fullData.setCarbRatio(50);
			fullData.setProteinRatio(25);
			fullData.setFatRatio(25);
			break;
		default:
			targetCalories = (int) maintenanceCalories;
			fullData.setCarbRatio(50);
			fullData.setProteinRatio(30);
			fullData.setFatRatio(20);
			break;
		}

		// =======================================================================
		// 그램(g)을 먼저 계산하고, 칼로리는 그램을 기준으로 역산
		// =======================================================================

		// 1. 일일 총 목표 그램(g) 계산
		double totalCarbKcal = targetCalories * (fullData.getCarbRatio() / 100.0);
		double totalProteinKcal = targetCalories * (fullData.getProteinRatio() / 100.0);
		double totalFatKcal = targetCalories - totalCarbKcal - totalProteinKcal;

		double totalCarbG = totalCarbKcal / 4;
		double totalProteinG = totalProteinKcal / 4;
		double totalFatG = totalFatKcal / 9;

		fullData.setTargetCarbG(totalCarbG);
		fullData.setTargetProteinG(totalProteinG);
		fullData.setTargetFatG(totalFatG);

		fullData.setTargetCarbKcal(totalCarbG * 4);
		fullData.setTargetProteinKcal(totalProteinG * 4);
		fullData.setTargetFatKcal(totalFatG * 9);
		fullData.setTargetCalories((totalCarbG * 4) + (totalProteinG * 4) + (totalFatG * 9));

		// 2. 끼니별 그램(g) 분배 (오차 보정)
		double breakfastCarbG = totalCarbG * 0.3;
		double lunchCarbG = totalCarbG * 0.4;
		double dinnerCarbG = totalCarbG - breakfastCarbG - lunchCarbG;
		fullData.setBreakfastCarbG(breakfastCarbG);
		fullData.setLunchCarbG(lunchCarbG);
		fullData.setDinnerCarbG(dinnerCarbG);

		double breakfastProteinG = totalProteinG * 0.3;
		double lunchProteinG = totalProteinG * 0.4;
		double dinnerProteinG = totalProteinG - breakfastProteinG - lunchProteinG;
		fullData.setBreakfastProteinG(breakfastProteinG);
		fullData.setLunchProteinG(lunchProteinG);
		fullData.setDinnerProteinG(dinnerProteinG);

		double breakfastFatG = totalFatG * 0.3;
		double lunchFatG = totalFatG * 0.4;
		double dinnerFatG = totalFatG - breakfastFatG - lunchFatG;
		fullData.setBreakfastFatG(breakfastFatG);
		fullData.setLunchFatG(lunchFatG);
		fullData.setDinnerFatG(dinnerFatG);

		// 3. 분배된 그램(g)을 기준으로 각 끼니별 칼로리 역산
		fullData.setBreakfastKcal((breakfastCarbG * 4) + (breakfastProteinG * 4) + (breakfastFatG * 9));
		fullData.setLunchKcal((lunchCarbG * 4) + (lunchProteinG * 4) + (lunchFatG * 9));
		fullData.setDinnerKcal((dinnerCarbG * 4) + (dinnerProteinG * 4) + (dinnerFatG * 9));

		// 4. DB에 저장
		inbodyRepository.insert(fullData);

		// 5. 저장된 전체 데이터를 다시 조회하여 반환
		return fullData;
	}
}
