package com.javaex.apiController;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.service.InbodyService;
import com.javaex.util.JsonResult;
import com.javaex.vo.InbodyVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping(value="/api/inbody")
public class InbodyApiController {
	
	@Autowired
	private InbodyService inbodyService;
	
	// 인바디 목록 가져오기 (페이징)
    @GetMapping("/list")
    public JsonResult getList(@RequestParam("userId") int userId,
                              @RequestParam(value = "crtPage", defaultValue = "1") int crtPage) {
        Map<String, Object> listMap = inbodyService.exeGetList(userId, crtPage);
        
        return JsonResult.success(listMap);
    }

    // 인바디 상세 정보 가져오기
    @GetMapping("/{inbodyId}")
    public JsonResult getInbody(@PathVariable("inbodyId") int inbodyId) {
        InbodyVO inbodyVO = inbodyService.exeGetInbody(inbodyId);
        
        if (inbodyVO != null) {
            return JsonResult.success(inbodyVO);
        } else {
            return JsonResult.fail("데이터를 찾을 수 없습니다.");
        }
    }

    // 인바디 이미지 업로드 및 분석
    @PostMapping("/upload")
    public JsonResult upload(@RequestParam("file") MultipartFile file, HttpSession session) {
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        
        if (authUser == null) {
            return JsonResult.fail("로그인이 필요합니다.");
        }

        // 서비스의 OCR 처리 메소드 호출 (현재는 임시 데이터로 동작)
        InbodyVO newInbodyVO = inbodyService.exeUploadAndAnalyze(file, authUser.getUserId());
        
        return JsonResult.success(newInbodyVO);
    }

    // 인바디 기록 삭제
    @DeleteMapping("/{inbodyId}")
    public JsonResult delete(@PathVariable("inbodyId") int inbodyId) {
        int count = inbodyService.exeDelete(inbodyId);
        
        if (count > 0) {
            return JsonResult.success(inbodyId);
        } else {
            return JsonResult.fail("삭제에 실패했습니다.");
        }
    }
	
	
}
