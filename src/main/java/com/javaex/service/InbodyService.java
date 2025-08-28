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
     * [추가] 사용자가 직접 입력한 값으로 인바디 전체 데이터를 계산하고 저장합니다.
     * @param inputVO 키, 체중, 골격근량, 체지방량, 인바디점수가 담긴 VO
     * @param authUser 로그인한 사용자 정보
     * @return 저장된 전체 인바디 정보가 담긴 VO
     */
 	public InbodyVO exeManualAdd(InbodyVO inputVO, UserVO authUser) {
        System.out.println("InbodyService.exeManualAdd() - Final Version");

        // 0. 계산에 필요한 사용자 정보 조회 (userRepository에 selectUserByNo가 있다고 가정)
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

        // 지방 및 근육 조절량 계산
        double idealWeight = (height - 100) * 0.9;
        double idealFatRatio = "male".equalsIgnoreCase(gender) ? 0.15 : 0.23; // 남성 15%, 여성 23% 목표
        double idealFatMass = idealWeight * idealFatRatio;
        
        double fatControl = Math.round((fatMass - idealFatMass) * 10.0) / 10.0;
        // 근육 조절량은 우선 0으로 설정 (근육량 유지를 기본 목표로)
        fullData.setFatControlKg(fatControl * -1); // 빼야 할 양이므로 음수로 표현
        fullData.setMuscleControlKg(0.0);
        
        // C-I-D 체형 타입 (간단한 로직)
        double stdWeight = heightM * heightM * 22; // 표준 BMI 22 기준
	    double stdMuscle = stdWeight * 0.45; // 표준 근육량 (체중의 45%)
	    if (muscleMass > stdMuscle && pbf < idealFatRatio * 100) {
	        fullData.setCidType("D"); // 근육형
	    } else if (pbf > idealFatRatio * 100) {
	        fullData.setCidType("C"); // 비만형
	    } else {
	        fullData.setCidType("I"); // 표준형
	    }

        // 3. 영양 정보 자동 계산 (나이, 성별 반영)
        // 기초대사량(BMR) - 미플린-세인트 지어 공식
        double bmr;
        if ("male".equalsIgnoreCase(gender)) {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        }
        int targetCalories = (int)(bmr * 1.375); // 활동대사량 (가벼운 활동)
        fullData.setTargetCalories(targetCalories);

        // 권장 단백질 섭취량
        fullData.setRequiredProteinG((int)(weight * 0.8));

        // 탄단지 비율 (5:3:2)에 따른 칼로리 및 그램 계산
        fullData.setCarbRatio(50);
        fullData.setProteinRatio(30);
        fullData.setFatRatio(20);

        int carbKcal = (int)(targetCalories * 0.5);
        int proteinKcal = (int)(targetCalories * 0.3);
        int fatKcal = (int)(targetCalories * 0.2);
        
        fullData.setTargetCarbKcal(carbKcal);
        fullData.setTargetProteinKcal(proteinKcal);
        fullData.setTargetFatKcal(fatKcal);
        
        int carbG = (int)(carbKcal / 4.0);
        int proteinG = (int)(proteinKcal / 4.0);
        int fatG = (int)(fatKcal / 9.0);
        
        fullData.setTargetCarbG(carbG);
        fullData.setTargetProteinG(proteinG);
        fullData.setTargetFatG(fatG);

        // 아침/점심/저녁 식단 자동 계산 (칼로리 3:4:3 비율로 분배)
	    // 아침 (30%)
	    fullData.setBreakfastKcal((int)(targetCalories * 0.3));
	    fullData.setBreakfastCarbG((int)(carbG * 0.3));
	    fullData.setBreakfastProteinG((int)(proteinG * 0.3));
	    fullData.setBreakfastFatG((int)(fatG * 0.3));
	    // 점심 (40%)
	    fullData.setLunchKcal((int)(targetCalories * 0.4));
	    fullData.setLunchCarbG((int)(carbG * 0.4));
	    fullData.setLunchProteinG((int)(proteinG * 0.4));
	    fullData.setLunchFatG((int)(fatG * 0.4));
	    // 저녁 (30%)
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
 	
 	

