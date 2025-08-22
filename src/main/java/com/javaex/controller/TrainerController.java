package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaex.service.TrainerScheduleService;

import jakarta.servlet.http.HttpSession;

/**
 * TrainerScheduleController는 트레이너가 자신의 근무 일정과 예약 현황을
 * JSP 페이지로 확인하고 관리할 수 있도록 하는 뷰 컨트롤러입니다.
 *
 * <p>이 컨트롤러는 단순히 뷰 이름을 리턴하며, 필요한 데이터는
 * 서비스 계층을 통해 모델(Model)에 추가합니다. 현재는 데이터 로딩을
 * 프런트에서 AJAX로 처리할 수 있도록 최소한의 속성만 설정합니다.</p>
 */
@Controller
@RequestMapping("/trainer/schedule")
public class TrainerController {

    private final TrainerScheduleService trainerScheduleService;

	@Autowired
    public TrainerController(TrainerScheduleService trainerScheduleService) {
        this.trainerScheduleService = trainerScheduleService;
    }

    /**
     * 트레이너 일정 조회 페이지를 표시합니다.
     *
     * <p>로그인된 트레이너 ID를 세션에서 가져와 모델에 추가합니다. 실제 데이터 로딩은
     * JavaScript + API 방식으로 수행하므로 여기서는 기본값만 세팅합니다.</p>
     *
     * @param session 로그인 정보를 담은 세션
     * @param model JSP에 전달할 모델
     * @return schedule.jsp 이름
     */
    @GetMapping("")
    public String showSchedule(HttpSession session, Model model) {
        // 예: 세션에 "trainerId"가 저장되어 있다고 가정
        Object trainerId = session.getAttribute("trainerId");
        // TrainerId를 모델에 추가하여 JSP에서 사용할 수 있게 함
        model.addAttribute("trainerId", trainerId);
        return "schedule"; // /WEB-INF/views/schedule.jsp 로 해석됨 (ViewResolver에 따라)
    }

    /**
     * 근무시간 등록 페이지를 표시합니다.
     *
     * <p>schedule-insert.jsp는 트레이너가 근무시간을 선택할 수 있는 모달/폼을 제공하는 페이지입니다.</p>
     *
     * @return schedule-insert.jsp 이름
     */
    @GetMapping("/insert")
    public String showScheduleInsertPage() {
        return "schedule-insert";
    }
}
