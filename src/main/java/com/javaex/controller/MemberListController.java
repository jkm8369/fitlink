package com.javaex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.MemberListService;
import com.javaex.vo.MemberVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/trainer/member-list")
public class MemberListController {

	private final MemberListService service;

	@Autowired
	public MemberListController(MemberListService service) {
		this.service = service;
	}

    @GetMapping
    public String page(HttpSession session, Model model) {
        // 세션에서 로그인 사용자(authUser) 직접 가져오기
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        
        if (authUser == null) {
            // 비로그인 → 로그인 페이지로
            return "redirect:/user/loginform";
        }

        int trainerId = authUser.getUserId();
        List<MemberVO> rows = service.getMemberListForTrainer(trainerId);

        model.addAttribute("rows", rows);
        model.addAttribute("trainerId", trainerId); // JSP에서 필요하면 사용

        // /WEB-INF/views/trainer/member-list.jsp
        return "trainer/member-list";
    }
}