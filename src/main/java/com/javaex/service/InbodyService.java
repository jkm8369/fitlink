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
        System.out.println("InbodyService.exeGetList()");

        //한페이지 리스트 출력 갯수
        int listCnt = 5;
        
        //페이지당 버튼 갯수
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
        System.out.println("[CHECK 2] InbodyService: exeDelete 호출됨 (ID: " + inbodyId + ")");
        
        return inbodyRepository.delete(inbodyId);
    }
    
    // -- 트레이너가 특정 회원을 조회할 권한이 있는지 확인하는 보안 메소드
 	public boolean exeCheckAuth(int memberId, int trainerId) {
 		System.out.println("WorkoutService.exeCheckAuth()");
 		Map<String, Object> params = new HashMap<>();
 		params.put("memberId", memberId);
 		params.put("trainerId", trainerId);
 		
 		// DB에 두 ID의 관계가 등록되어 있는지 확인합니다.	
 		int count = userRepository.checkMemberAssignment(params);
 		
 		return count > 0; // 1 이상이면(관계가 존재하면) true를 반환
 	}
    
 	/**
     * [최종 업그레이드] 사용자가 직접 입력한 값으로 인바디 전체 데이터를 계산하고 저장합니다.
     * - 근육 조절량을 표준과 비교하여 현실적인 목표 제시
     * - CID 유형과 목표(감량/유지/증량)에 따라 목표 칼로리 및 탄단지 비율을 동적으로 계산
     * @param inputVO 키, 체중, 골격근량, 체지방량, 인바디점수가 담긴 VO
     * @param authUser 로그인한 사용자 정보
     * @return 저장된 전체 인바디 정보가 담긴 VO
     */
 	public InbodyVO exeManualAdd(InbodyVO inputVO, UserVO authUser) {
        System.out.println("InbodyService.exeManualAdd() - Advanced Logic Version");

        // 0. 계산에 필요한 사용자 정보 조회
        UserVO fullUserVO = userRepository.selectUserByNo(authUser.getUserId());
        int age = java.time.LocalDate.now().getYear() - Integer.parseInt(fullUserVO.getBirthDate().substring(0, 4));
        String gender = fullUserVO.getGender();

        // 1. VO 객체 생성 및 기본 정보 설정
        InbodyVO fullData = new InbodyVO();
        fullData.setUserId(authUser.getUserId());
        fullData.setRecordDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        
        // 모달에서 직접 입력받은 값 설정
        fullData.setHeight(inputVO.getHeight());
        fullData.setWeightKg(inputVO.getWeightKg());
        fullData.setMuscleMassKg(inputVO.getMuscleMassKg());
        fullData.setFatMassKg(inputVO.getFatMassKg());
        fullData.setInbodyScore(inputVO.getInbodyScore());
        fullData.setVisceralFatLevel(inputVO.getVisceralFatLevel());

        // 2. 주요 지표 자동 계산
        double height = fullData.getHeight();
        double weight = fullData.getWeightKg();
        double muscleMass = fullData.getMuscleMassKg();
        double fatMass = fullData.getFatMassKg();
        
        // BMI (체질량지수)
        double heightM = height / 100.0;
        double bmi = weight / (heightM * heightM);
        fullData.setBmi(Math.round(bmi * 10.0) / 10.0);

        // 체지방률
        double pbf = (fatMass / weight) * 100;
        fullData.setPercentBodyFat(Math.round(pbf * 10.0) / 10.0);
        
        // =======================================================================
        // 지방 및 근육 조절량 계산 로직
        // =======================================================================
        
        // 성별에 따른 표준 값 설정
        double idealBmi = "male".equalsIgnoreCase(gender) ? 22 : 21;
        double idealMuscleRatio = "male".equalsIgnoreCase(gender) ? 0.45 : 0.40;
        double idealFatRatio = "male".equalsIgnoreCase(gender) ? 0.15 : 0.23;

        // 표준 체중, 표준 골격근량, 표준 체지방량 계산
        double idealWeight = idealBmi * (heightM * heightM);
        double stdMuscle = idealWeight * idealMuscleRatio;
        double stdFat = idealWeight * idealFatRatio;
        
        // 지방 조절량 계산 (현재값 - 목표값, 빼야 할 경우 음수)
        double fatControl = fatMass - stdFat;
        fullData.setFatControlKg(Math.round(fatControl * 10.0) / 10.0);
        
        // 근육 조절량 계산 (목표값 - 현재값, 늘려야 할 경우 양수)
        double muscleControl = stdMuscle - muscleMass;
        // 근육이 표준보다 많으면 0으로, 부족하면 늘려야 할 양을 양수로 표시
        fullData.setMuscleControlKg(Math.round(Math.max(0, muscleControl) * 10.0) / 10.0);
        
        // CID 유형 판단 로직
        if (muscleMass >= stdMuscle * 1.1) { // 표준보다 10% 이상 많으면 D형
            fullData.setCidType("D");
        } else if (fatMass >= stdFat * 1.1) { // 표준보다 10% 이상 많으면 C형
            fullData.setCidType("C");
        } else {
            fullData.setCidType("I");
        }
        
        // =======================================================================
        // CID 유형별 목표 칼로리 및 탄단지 비율 설정
        // =======================================================================
        
        // 3. 영양 정보 자동 계산
        // 기초대사량(BMR) - 미플린-세인트 지어 공식
        double bmr;
        if ("male".equalsIgnoreCase(gender)) {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        }
        
        // 활동대사량(유지 칼로리) 계산 (가벼운 활동 기준)
        double maintenanceCalories = bmr * 1.375;
        int targetCalories = 0;

        fullData.setRequiredProteinG((int)(weight * 0.8));
        // CID 유형에 따라 목표 칼로리 및 탄단지 비율 차등 적용
        switch (fullData.getCidType()) {
            case "C": // 비만형 -> 감량 목표
                targetCalories = (int)(maintenanceCalories - 500);
                fullData.setCarbRatio(40);
                fullData.setProteinRatio(40);
                fullData.setFatRatio(20);
                break;
            case "D": // 근육형 -> 증량/강화 목표
                targetCalories = (int)(maintenanceCalories + 300);
                fullData.setCarbRatio(50);
                fullData.setProteinRatio(25);
                fullData.setFatRatio(25);
                break;
            default: // "I" 표준형 -> 유지 목표
                targetCalories = (int)maintenanceCalories;
                fullData.setCarbRatio(50);
                fullData.setProteinRatio(30);
                fullData.setFatRatio(20);
                break;
        }
        fullData.setTargetCalories(targetCalories);

        // 설정된 비율에 따른 칼로리 및 그램 계산
        int carbKcal = (int)(targetCalories * (fullData.getCarbRatio() / 100.0));
        int proteinKcal = (int)(targetCalories * (fullData.getProteinRatio() / 100.0));
        int fatKcal = (int)(targetCalories * (fullData.getFatRatio() / 100.0));
        
        fullData.setTargetCarbKcal(carbKcal);
        fullData.setTargetProteinKcal(proteinKcal);
        fullData.setTargetFatKcal(fatKcal);
        
        int carbG = carbKcal / 4;
        int proteinG = proteinKcal / 4;
        int fatG = fatKcal / 9;
        
        fullData.setTargetCarbG(carbG);
        fullData.setTargetProteinG(proteinG);
        fullData.setTargetFatG(fatG);

        // 아침/점심/저녁 식단 자동 계산 (칼로리 3:4:3 비율로 분배)
	    fullData.setBreakfastKcal((int)(targetCalories * 0.3));
	    fullData.setBreakfastCarbG((int)(carbG * 0.3));
	    fullData.setBreakfastProteinG((int)(proteinG * 0.3));
	    fullData.setBreakfastFatG((int)(fatG * 0.3));
	    
	    fullData.setLunchKcal((int)(targetCalories * 0.4));
	    fullData.setLunchCarbG((int)(carbG * 0.4));
	    fullData.setLunchProteinG((int)(proteinG * 0.4));
	    fullData.setLunchFatG((int)(fatG * 0.4));
	    
	    fullData.setDinnerKcal((int)(targetCalories * 0.3));
	    fullData.setDinnerCarbG((int)(carbG * 0.3));
	    fullData.setDinnerProteinG((int)(proteinG * 0.3));
	    fullData.setDinnerFatG((int)(fatG * 0.3));

        // 4. DB에 저장
        inbodyRepository.insert(fullData);
        
        // 5. 저장된 전체 데이터를 다시 조회하여 반환
        return inbodyRepository.selectOneByInbodyId(fullData.getInbodyId());
    }
}
 	
 	

