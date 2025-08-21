package com.javaex.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.MemberExerciseService;
import com.javaex.vo.MemberExerciseVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/member/exercise")
public class MemberExerciseController {

	@Autowired
	private MemberExerciseService memberExerciseService;
	
	@GetMapping(value="")
	public String exercise(HttpSession session, Model model) {
		System.out.println("MemberExerciseController.exercise()");
		
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		int userId = authUser.getUserId();
		
		Map<String, List<MemberExerciseVO>> exerciseMap = memberExerciseService.exeExerciseListGroup(userId);
		
		model.addAttribute("exerciseMap", exerciseMap);
		
		return "member/exercise";
	}
	
	@GetMapping(value = "/list")
    public String exerciseList() {
        System.out.println("MemberExerciseController.exerciseList()");
        
        return "member/exercise-list";
    }
	
	
	
}
