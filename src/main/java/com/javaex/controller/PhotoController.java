package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class PhotoController {
	
	/** 회원 사진 페이지 */
	@GetMapping("/member/photo")
	public String memberPhotoPage(HttpSession session, Model model) {
		// 세션에서 로그인 회원 확인
		UserVO authUser = (UserVO) session.getAttribute("authUser");
		if (authUser == null) {
			// 로그인 안된 경우 → 로그인 페이지로 리다이렉트
			return "redirect:/user/loginform";
		}

		// 로그인 회원ID JSP에 전달
		model.addAttribute("memberId", authUser.getUserId());

		// /WEB-INF/views/member/photo.jsp 반환
		return "member/photo";
	}
}
