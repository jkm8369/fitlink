package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.javaex.service.WorkoutService;

@Controller
public class WorkoutController {

	@Autowired
	private WorkoutService workoutService;
	
	@RequestMapping(value="/workout", method= {RequestMethod.GET, RequestMethod.POST})
	public String login() {
		
		
		return "";
	}
	
	
	
}
