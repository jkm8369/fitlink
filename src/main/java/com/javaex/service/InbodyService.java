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

@Service
public class InbodyService {

	@Autowired
	private InbodyRepository inbodyRepository;
	
	@Autowired
	private UserRepository userRepository;

    /**
     * 특정 회원의 인바디 기록 목록과 페이징 정보를 가져옵니다.
     * @param userId 회원 ID
     * @param crtPage 현재 페이지 번호
     * @return 인바디 목록과 페이징 정보를 담은 Map
     */
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
    
    
    // 인바디 직접 등록
    public InbodyVO exeAdd(InbodyVO inbodyVO) {
        System.out.println("InbodyService.exeAdd()");

        // [수정] 측정 시간을 현재 시간으로 설정
        // recordDate는 날짜만 넘어오므로, 현재 시간을 조합하여 DATETIME 형식에 맞게 만듭니다.
        String currentDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        inbodyVO.setRecordDate(currentDateTime);

        // [수정] 영양 정보 계산 로직 (나중에 추가할 위치)
        // TODO: inbodyVO의 체중, 근육량 등을 기반으로 일일 권장 섭취량 등을 계산하는 로직 추가

        // DB에 저장
        int newInbodyId = inbodyRepository.insert(inbodyVO);
        
        // 저장된 전체 데이터를 다시 조회하여 반환
        return inbodyRepository.selectOneByInbodyId(newInbodyId);
    }

    
    // 특정 인바디 기록 삭제
    public int exeDelete(int inbodyId) {
        System.out.println("InbodyService.exeDelete()");
        
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
    
}
