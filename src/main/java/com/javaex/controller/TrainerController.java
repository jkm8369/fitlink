package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/trainer")
public class TrainerController {
	
	@GetMapping("/schedule")
	public String showSchedulePage() {

		return "trainer/schedule";
		
	}
}
