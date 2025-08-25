package com.javaex.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.javaex.repository.BookingRepository;


@Service
public class BookingService {
    private final BookingRepository repo;
    private final UserService userService;

    public BookingService(BookingRepository repo, UserService userService) {
        this.repo = repo;
        this.userService = userService;
    }

    /** 달력 이벤트 */
    public List<Map<String, Object>> myEvents(int memberId, String start, String end) {
        return repo.selectMyCalendarEvents(memberId, start, end);
    }

    /** 담당 트레이너의 특정일 슬롯 */
    public List<Map<String, Object>> daySlots(int trainerId, String date) {
        return repo.selectSlotsByTrainerAndDate(trainerId, date);
    }

    /** ⬇️ 핵심: DB에서 행별 누적을 계산하므로 그대로 반환 */
    public List<Map<String, Object>> myPtList(int memberId) {
        return repo.selectMyPtList(memberId);
    }

    /** 예약 생성 */
    public void book(int memberId, int availabilityId) {
        repo.insertReservation(memberId, availabilityId);
    }

    /** 예약 취소 */
    public void cancel(int memberId, int reservationId) {
        repo.deleteReservation(memberId, reservationId);
    }
}