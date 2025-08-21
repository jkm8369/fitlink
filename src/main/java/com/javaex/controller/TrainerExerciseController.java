package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.javaex.service.TrainerExerciseService;

@Controller
public class TrainerExerciseController {

	@Autowired
	private TrainerExerciseService trainerExerciseService;
	
	
	
}
