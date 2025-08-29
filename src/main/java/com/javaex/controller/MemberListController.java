package com.javaex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.javaex.service.MemberListService;
import com.javaex.vo.MemberVO;
import com.javaex.vo.UserVO;

@Controller
@RequestMapping("/trainer/member-list")
public class MemberListController {

	private final MemberListService service;

	@Autowired
	public MemberListController(MemberListService service) {
		this.service = service;
	}

	@GetMapping
	public String page(@SessionAttribute("authUser") UserVO authUser, Model model) {
		int trainerId = authUser.getUserId();
		List<MemberVO> rows = service.getMemberListForTrainer(trainerId);
		model.addAttribute("rows", rows);
		model.addAttribute("trainerId", trainerId);
		return "trainer/member-list";
	}
}