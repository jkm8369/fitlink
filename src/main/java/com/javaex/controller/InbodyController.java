package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.InbodyService;
import com.javaex.service.UserService;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/inbody")
public class InbodyController {

	@Autowired
	private InbodyService inbodyService;
	
	@Autowired
	private UserService userService;
	
	// 회원이 본인 인바디 페이지를 볼 때
    @GetMapping("")
    public String inbody(HttpSession session, Model model) {
        System.out.println("InbodyController.inbody() for member");
        
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        
        return getInbodyPage(authUser, authUser.getUserId(), model);
    }

    // 트레이너가 회원의 인바디 페이지를 볼 때
    @GetMapping("/member/{memberId}")
    public String inbodyByTrainer(@PathVariable("memberId") int memberId, HttpSession session, Model model) {
        System.out.println("InbodyController.inbodyByTrainer() for trainer");
        
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        
        // 트레이너가 해당 회원을 볼 권한이 있는지 확인
        boolean hasAuth = inbodyService.exeCheckAuth(memberId, authUser.getUserId());
		
		if(!hasAuth) {
			return "redirect:/trainer/members";
		}
        
        return getInbodyPage(authUser, memberId, model);
    }

    
    // 인바디 페이지에 필요한 데이터를 준비하고 뷰를 반환하는 공통 메소드
    private String getInbodyPage(UserVO authUser, int targetUserId, Model model) {
        System.out.println("InbodyController.getInbodyPage()");
    	
        if ("trainer".equals(authUser.getRole())) {
            // 트레이너가 볼 때, 사이드 메뉴에 표시할 회원 정보를 모델에 추가
            UserVO currentMember = userService.exeGetMemberInfo(targetUserId);
            model.addAttribute("currentMember", currentMember);
        }
        
        return "member/inbody";
    }
}
