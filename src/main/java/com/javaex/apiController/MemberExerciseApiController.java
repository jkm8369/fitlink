package com.javaex.apiController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.MemberExerciseService;
import com.javaex.util.JsonResult;
import com.javaex.vo.MemberExerciseVO;

@RestController
@RequestMapping("/api/exercise")
public class MemberExerciseApiController {

    @Autowired
    private MemberExerciseService memberExerciseService;

    /**
     * 새로운 운동 종류를 DB에 추가하는 API
     * @param exerciseVO JSON으로 받은 운동 정보 (bodyPart, exerciseName)
     * @return 성공 여부와 추가된 운동 정보를 담은 JsonResult
     */
    @PostMapping("/add")
    public JsonResult addExercise(@RequestBody MemberExerciseVO memberExerciseVO) {
        System.out.println("ExerciseApiController.addExercise()");
        
        try {
            MemberExerciseVO newExercise = memberExerciseService.exeAddExercise(memberExerciseVO);
            if (newExercise != null) {
                return JsonResult.success(newExercise);
            } else {
                return JsonResult.fail("운동 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            // 데이터베이스 제약 조건 위반 등 예외 처리
            return JsonResult.fail("이미 등록된 운동이거나 오류가 발생했습니다.");
        }
    }
}