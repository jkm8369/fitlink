package com.javaex.apiController;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
	// jsp에서 보내주는 userId 대신, 세션을 확인하여 조회할 대상을 결정
	@GetMapping("/list")
    public JsonResult getList(@RequestParam(value="userId", required=false, defaultValue="0") int userId,
                              @RequestParam(value = "crtPage", defaultValue = "1") int crtPage,
                              HttpSession session) {
    	
    	UserVO authUser = (UserVO) session.getAttribute("authUser");
    	int targetUserId;
    		
    	// jsp에서 userId를 보내줬고(트레이너가 회원 조회), 그 값이 유효하면 그 ID를 사용
    	if (userId > 0 && "trainer".equals(authUser.getRole())) {
    		targetUserId = userId;
    	} else { // 그 외의 경우(회원 본인 조회 등)는 로그인한 본인 ID를 사용
    		targetUserId = authUser.getUserId();
    	}
    	
        Map<String, Object> listMap = inbodyService.exeGetList(targetUserId, crtPage);
        
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

    // 인바디 기록 삭제
    @DeleteMapping("/{inbodyId}")
    public JsonResult delete(@PathVariable("inbodyId") int inbodyId) {
        // [CHECK 1] 컨트롤러에 요청이 잘 도착했는지 확인
        //System.out.println("[CHECK 1] InbodyApiController: 삭제 요청 받음 (ID: " + inbodyId + ")");
        
        int count = inbodyService.exeDelete(inbodyId);
        
        if (count > 0) {
            return JsonResult.success(inbodyId);
        } else {
            return JsonResult.fail("삭제에 실패했습니다.");
        }
    }
	
    // 인바디 수동 등록
    @PostMapping("/manual-add")
    public JsonResult manualAdd(@RequestBody InbodyVO inbodyVO, HttpSession session) {
        //System.out.println("InbodyApiController.manualAdd()");
        
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        if (authUser == null) {
            return JsonResult.fail("로그인이 필요합니다.");
        }

        // 서비스의 등록 메소드 호출
        InbodyVO newInbodyVO = inbodyService.exeManualAdd(inbodyVO, authUser);
        
        return JsonResult.success(newInbodyVO);
    }
    
}
