package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
@RequestMapping("/member")
public class PhotoController {
	
	@GetMapping("/photo")
	public String view(@SessionAttribute("memberId") int memberId,
	                   Model model) {

		model.addAttribute("userId", memberId);
	    return "member/photo";
	}
}
