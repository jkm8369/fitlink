package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.javaex.service.UserService;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value= "/user")
public class UserController {

	@Autowired
	private UserService userService;
	
	 // -------------------------------
    // 1) 로그인 폼
    // -------------------------------
    @RequestMapping(value = "/loginform", method = { RequestMethod.GET, RequestMethod.POST })
    public String loginform(HttpSession session) {

        UserVO authUser = (UserVO) session.getAttribute("authUser");
        if (authUser != null) {
            
        	String role = "member"; // 기본값
            if (authUser.getRole() != null) {
                role = authUser.getRole().trim().toLowerCase(); // 'member' / 'trainer'
            }

            if ("trainer".equals(role)) {
                return "redirect:/trainer/schedule";
            
            } else {
                return "/member/workout";
            }
        }

        // 로그인 화면 열기
        return "/user/loginform";
    }

    // 모바일용 로그인 폼
    @RequestMapping(value = "/loginform/mobile", method = { RequestMethod.GET, RequestMethod.POST })
    public String loginformMobile() {
    	
        return "user/loginform-mobile";
    }
    
    // -------------------------------
    // 2) 로그인 처리
    // -------------------------------
    @RequestMapping(value = "/login", method = { RequestMethod.GET, RequestMethod.POST })
    public String login(@ModelAttribute UserVO userVO, HttpSession session) {

        UserVO authUser = userService.exeLogin(userVO);

        // 실패: 메인(또는 로그인폼)으로
        if (authUser == null) {
            return "redirect:/";
            // return "redirect:/user/loginform";
        }

        session.setAttribute("authUser", authUser);

        String role = "member";
        if (authUser.getRole() != null) {
            role = authUser.getRole().trim().toLowerCase(); // 'member' / 'trainer'
        }

        // 역할별 리다이렉트
        if ("trainer".equals(role)) {
            return "redirect:/trainer/schedule";   // 트레이너 스케줄

        } else {
            return "/member/workout";     // 회원 운동일지
        }
    }
    // -- 로그인처리 (모바일)
    @RequestMapping(value = "/login/mobile", method = { RequestMethod.GET, RequestMethod.POST })
    public String loginMobile(@ModelAttribute UserVO userVO, HttpSession session) {

        UserVO authUser = userService.exeLogin(userVO);

        // 실패: 메인(또는 로그인폼)으로
        if (authUser == null) {
            return "redirect:/";
            // return "redirect:/user/loginform/mobile";
        }

        session.setAttribute("authUser", authUser);

        String role = "member";
        if (authUser.getRole() != null) {
            role = authUser.getRole().trim().toLowerCase(); // 'member' / 'trainer'
        }

        // 역할별 리다이렉트
        if ("member".equals(role)) {
        	return "redirect:/workout/mobile";     // 회원 운동일지(모바일)
        } else {
        	return "redirect:/user/loginform/mobile";
        }
    }

    // -------------------------------
    // 3) 로그아웃
    // -------------------------------
    @RequestMapping(value = "/logout", method = { RequestMethod.GET, RequestMethod.POST })
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/loginform";
    }
}
