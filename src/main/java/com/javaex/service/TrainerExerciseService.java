package com.javaex.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.TrainerExerciseRepository;
import com.javaex.vo.TrainerExerciseVO;

@Service
public class TrainerExerciseService {

	@Autowired
	private TrainerExerciseRepository trainerExerciseRepository;
	
	
	public List<TrainerExerciseVO> exeSelectListByUser(int userId) {
		System.out.println("TrainerExerciseService.exeSelectListByUser()");
		
		List<TrainerExerciseVO> exerciseList = trainerExerciseRepository.selectListByUser(userId);
		
		return exerciseList;
	}
	
	
}
