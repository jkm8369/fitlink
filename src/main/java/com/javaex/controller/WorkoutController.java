package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.javaex.service.WorkoutService;

@Controller
public class WorkoutController {

	@Autowired
	private WorkoutService workoutService;
	
	
	
}
