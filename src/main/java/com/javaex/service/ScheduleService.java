package com.javaex.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javaex.repository.ScheduleRepository;

@Service
public class ScheduleService {
    @Autowired
    private ScheduleRepository scheduleRepository;

    // 조회: 해당 날짜의 근무시간 리스트
    public List<Integer> getDailyHours(int trainerId, LocalDate date) {
        return scheduleRepository.selectHoursByDate(trainerId, date);
    }

    // 저장: (모달 저장 시) 해당 날짜 전체 갈아끼우기
    @Transactional
    public void saveDailyHours(int trainerId, LocalDate date, List<Integer> hours) {
        scheduleRepository.deleteByDate(trainerId, date);
        if (hours != null && !hours.isEmpty()) {
            scheduleRepository.insertHours(trainerId, date, hours);
        }
    }
}
