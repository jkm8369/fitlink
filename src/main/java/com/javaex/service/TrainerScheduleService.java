package com.javaex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.TrainerScheduleRepository;

@Service
public class TrainerScheduleService {
    private final TrainerScheduleRepository trainerScheduleRepository;

    @Autowired
    public TrainerScheduleService(TrainerScheduleRepository trainerScheduleRepository) {
        this.trainerScheduleRepository = trainerScheduleRepository;
    }

    public List<Map<String, Object>> getTrainerBookings(int trainerId, String start, String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerBookings(param);
    }

    public List<Map<String, Object>> getTrainerSlots(int trainerId, String start, String end) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("start", start);
        param.put("end", end);
        return trainerScheduleRepository.selectTrainerSlotsWithStatus(param);
    }

    public List<Map<String, Object>> getDaySlots(int trainerId, String date) {
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        return trainerScheduleRepository.selectDaySlotsWithStatus(param);
    }

    public int registerAvailabilities(int trainerId, List<String> datetimes) {
        if (datetimes == null || datetimes.isEmpty()) return 0;

        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);

        if (datetimes.size() > 1) {
            param.put("datetimes", datetimes);
            return trainerScheduleRepository.insertAvailabilityBatch(param);
        } else {
            param.put("availableDatetime", datetimes.get(0));
            return trainerScheduleRepository.insertAvailability(param);
        }
    }

    public int removeAvailability(int id) {
        Map<String, Object> param = new HashMap<>();
        param.put("availabilityId", id);
        return trainerScheduleRepository.deleteAvailabilityById(param);
    }

    public int removeAvailabilitiesByDate(int trainerId, String date, List<Integer> hours) {
        if (hours == null || hours.isEmpty()) return 0;
        Map<String, Object> param = new HashMap<>();
        param.put("trainerId", trainerId);
        param.put("workDate", date);
        param.put("hours", hours);
        return trainerScheduleRepository.deleteAvailabilityByDateHours(param);
    }
}