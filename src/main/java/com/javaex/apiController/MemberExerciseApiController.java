package com.javaex.apiController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.MemberExerciseService;
import com.javaex.util.JsonResult;
import com.javaex.vo.MemberExerciseVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

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
    public JsonResult addExercise(@RequestBody MemberExerciseVO memberExerciseVO, HttpSession session) {
        //System.out.println("ExerciseApiController.addExercise()");
        
        UserVO authUser = (UserVO)session.getAttribute("authUser");
        
        try {
            MemberExerciseVO newExercise = memberExerciseService.exeAddExercise(memberExerciseVO, authUser.getUserId());
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
    
    @DeleteMapping("/delete/{exerciseId}")
    public JsonResult deleteExercise(@PathVariable("exerciseId") int exerciseId, HttpSession session) {
        //System.out.println("ExerciseApiController.deleteExercise(): " + exerciseId);

        // 세션에서 현재 로그인한 사용자 정보를 가져옵니다.
        UserVO authUser = (UserVO) session.getAttribute("authUser");

        // exercise 테이블에서 직접 운동을 삭제하는 서비스 메소드를 호출
        // 이 때, 현재 로그인한 사용자의 ID(authUser.getUserId())를 넘겨주어
        // 운동을 등록한 사람(creator_id)과 동일한 경우에만 삭제가 되도록 함
        boolean isDeleted = memberExerciseService.exeDeleteExercise(exerciseId, authUser.getUserId());


        if (isDeleted) {
            // 삭제에 성공하면, 삭제된 ID를 데이터로 함께 보내줌
            return JsonResult.success(exerciseId);
        } else {
            // 삭제에 실패하면(권한이 없거나, 해당 운동이 없거나 등) 실패 메시지를 보냄
            return JsonResult.fail("운동 삭제에 실패했습니다. 본인이 등록한 운동만 삭제할 수 있습니다.");
        }
    }
}