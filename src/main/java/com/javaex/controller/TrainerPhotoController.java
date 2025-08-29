package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.javaex.service.MemberExerciseService;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class TrainerPhotoController {
	
	@Autowired
	private	MemberExerciseService memberExerciseService;
	
	@GetMapping("/trainer/photo/{memberId}")
	public String trainerPhotoPage(HttpSession session,
	                               @PathVariable int memberId,
	                               Model model) {
	    UserVO authUser = (UserVO) session.getAttribute("authUser");
	    if (authUser == null) return "redirect:/user/loginform";

	    
	    UserVO userVO = memberExerciseService.exeGetMemberInfo(memberId);
	    
	    
	    model.addAttribute("currentMember", userVO);
	    model.addAttribute("trainerId", authUser.getUserId());
	    return "trainer/photo";
	}

}
