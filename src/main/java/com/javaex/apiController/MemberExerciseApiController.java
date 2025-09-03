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
     * @param exerciseVO JSON으로 받은 운동 정보 (bodyPart, exerciseName, 트레이너가 추가 시 memberId 포함)
     * @return 성공 여부와 추가된 운동 정보를 담은 JsonResult
     */
    @PostMapping("/add")
    public JsonResult addExercise(@RequestBody MemberExerciseVO memberExerciseVO, HttpSession session) {
        System.out.println("MemberExerciseApiController.addExercise()");

        // --- 여기부터 수정 ---

        // 1. 세션에서 현재 로그인한 사용자 정보를 가져옵니다.
        UserVO authUser = (UserVO) session.getAttribute("authUser");

        // 2. memberExerciseVO에 creatorId를 현재 로그인한 사용자(트레이너)의 ID로 설정합니다.
        memberExerciseVO.setCreatorId(authUser.getUserId());

        // --- 수정 끝 ---

        MemberExerciseVO vo = memberExerciseService.exeAddExercise(memberExerciseVO);

        return JsonResult.success(vo);
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