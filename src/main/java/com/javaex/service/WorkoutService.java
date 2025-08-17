package com.javaex.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.WorkoutRepository;

@Service
public class WorkoutService {

	@Autowired
	private WorkoutRepository workoutRepository;
	
	
	
}
