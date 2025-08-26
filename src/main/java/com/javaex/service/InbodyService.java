package com.javaex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.repository.InbodyRepository;
import com.javaex.vo.InbodyVO;

@Service
public class InbodyService {

	@Autowired
	private InbodyRepository inbodyRepository;

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
        params.put("pageSize", listCnt);

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

        return resultMap;
    }

    
    // 특정 인바디 기록의 상세 정보 가져오기
    public InbodyVO exeGetInbody(int inbodyId) {
        System.out.println("InbodyService.exeGetInbody()");
        
        return inbodyRepository.selectOneByInbodyId(inbodyId);
    }
    
    
    // 인바디 이미지 등록, OCR 처리 및 DB 저장을 수행
    public InbodyVO exeUploadAndAnalyze(MultipartFile file, int userId) {
        System.out.println("InbodyService.exeUploadAndAnalyze()");

        // [1단계: 파일 저장] - 나중에 구현
        // 1. 파일을 서버에 저장하고, 저장된 경로(URL)를 얻습니다.
        // String imageUrl = fileService.save(file);
        
        // [2단계: OCR 분석] - 나중에 구현
        // 2. 저장된 이미지로 OCR 분석을 요청하고 텍스트를 추출합니다.
        // String ocrResultText = ocrService.analyze(imageUrl);
        
        // [3단계: 데이터 파싱 및 계산] - 나중에 구현
        // 3. 추출된 텍스트에서 필요한 데이터(체중, 근육량 등)를 파싱합니다.
        // 4. 파싱된 데이터로 영양 정보를 계산합니다.
        
        // [임시 데이터] - 기능 확인을 위해 임시 데이터를 사용합니다.
        InbodyVO inbodyVO = new InbodyVO();
        inbodyVO.setUserId(userId);
        inbodyVO.setRecordDate("2025-08-26"); // 오늘 날짜
        inbodyVO.setImageUrl("/upload/temp_inbody.jpg"); // 임시 이미지 경로
        inbodyVO.setInbodyScore(82);
        inbodyVO.setWeightKg(75.3);
        inbodyVO.setMuscleMassKg(35.1);
        inbodyVO.setFatMassKg(15.2);
        // ... (나머지 임시 데이터)

        // [4단계: DB 저장]
        int newInbodyId = inbodyRepository.insert(inbodyVO);
        
        // 저장된 전체 데이터를 다시 조회하여 반환
        return inbodyRepository.selectOneByInbodyId(newInbodyId);
    }

    
    // 특정 인바디 기록 삭제
    public int exeDelete(int inbodyId) {
        System.out.println("InbodyService.exeDelete()");
        
        return inbodyRepository.delete(inbodyId);
    }
    
}
