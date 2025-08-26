package com.javaex.apiController;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.BookingService;
import com.javaex.service.UserService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/member/booking")
public class BookingApiController {

    private final BookingService bookingService;
    private final UserService userService;

    public BookingApiController(BookingService bookingService, UserService userService) {
        this.bookingService = bookingService;
        this.userService = userService;
    }

    // 공용: 세션에서 ID 보장 (if/else 버전)
    private int ensureId(HttpSession session, String who, Integer forceId) {
        boolean isTrainer = "trainer".equalsIgnoreCase(who);

        String key;
        int def;
        if (isTrainer) {
            key = "trainerId";
            def = 1;
        } else {
            key = "memberId";
            def = 3;
        }

        if (forceId != null) {
            session.setAttribute(key, forceId);
        }

        Object v = session.getAttribute(key);
        if (v instanceof Integer) {
            return (Integer) v;
        }

        session.setAttribute(key, def);
        return def;
    }

    /** 내 예약(달력 이벤트) */
    @GetMapping("/events")
    public List<Map<String, Object>> events(@RequestParam String start,
                                            @RequestParam String end,
                                            @RequestParam(required=false) Integer memberId,
                                            HttpSession session) {
        int mId = ensureId(session, "member", memberId);
        return bookingService.myEvents(mId, start, end);
    }

    /** 모달: 담당 트레이너의 특정일 슬롯 조회 */
    @GetMapping("/slots/day")
    public List<Map<String, Object>> daySlots(@RequestParam String date, HttpSession session) {
        int mId = ensureId(session, "member", null);
        Map<String, Object> trainer = userService.selectTrainerByMemberId(mId);
        if (trainer == null || trainer.get("trainerId") == null) {
            return Collections.emptyList();
        }
        int trainerId = ((Number) trainer.get("trainerId")).intValue();
        return bookingService.daySlots(trainerId, date);
    }

    /** 내 PT 리스트(하단 표) */
    @GetMapping("/pt/list")
    public List<Map<String, Object>> ptList(@RequestParam(required=false) Integer memberId,
                                            HttpSession session) {
        int mId = ensureId(session, "member", memberId);
        return bookingService.myPtList(mId);
    }

    /** 예약 생성 */
    @PostMapping
    public Map<String, Object> book(@RequestBody Map<String, Object> body,
                                    @RequestParam(required=false) Integer memberId,
                                    HttpSession session) {
        int mId = ensureId(session, "member", memberId);
        int availabilityId = (Integer) body.get("availabilityId");
        bookingService.book(mId, availabilityId);
        return Map.of("ok", true);
    }

    /** 예약 취소(BOOKED만) */
    @DeleteMapping("/{reservationId}")
    public Map<String, Object> cancel(@PathVariable int reservationId,
                                      @RequestParam(required=false) Integer memberId,
                                      HttpSession session) {
        int mId = ensureId(session, "member", memberId);
        bookingService.cancel(mId, reservationId);
        return Map.of("ok", true);
    }
}