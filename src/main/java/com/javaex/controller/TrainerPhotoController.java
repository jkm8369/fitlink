package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class TrainerPhotoController {
	
	@GetMapping("/trainer/photo")
	public String trainerPhotoPage(HttpSession session,
	                               @RequestParam(value="memberId", required=false) Integer memberId,
	                               Model model) {
	    UserVO authUser = (UserVO) session.getAttribute("authUser");
	    if (authUser == null) return "redirect:/user/loginform";

	    if (memberId == null) return "redirect:/trainer/member-list";

	    model.addAttribute("memberId", memberId);
	    model.addAttribute("trainerId", authUser.getUserId());
	    return "trainer/photo";
	}
	 
}
