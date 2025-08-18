package com.javaex.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaex.service.ScheduleService;

@Controller
@RequestMapping("/api/trainer")
public class ScheduleController {
	@Autowired
	private ScheduleService scheduleService;

	// [API] 근무시간 조회
	// GET /api/trainer/{trainerId}/availability?date=2025-07-09
	@ResponseBody
	@GetMapping("/{trainerId}/availability")
	public List<Integer> getDaily(@PathVariable int trainerId,
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
		return scheduleService.getDailyHours(trainerId, date);
	}

	// [API] 근무시간 저장
	// POST /api/trainer/{trainerId}/availability
	// Body: { "date":"2025-07-10", "hours":[9,10,14] }
	@PostMapping("/{trainerId}/availability")
	@ResponseBody
	public Map<String, Object> saveDaily(@PathVariable int trainerId, @RequestBody Map<String, Object> body) {
		LocalDate date = LocalDate.parse((String) body.get("date"));
		@SuppressWarnings("unchecked")
		List<Integer> hours = (List<Integer>) body.get("hours");
		scheduleService.saveDailyHours(trainerId, date, hours);
		return Map.of("ok", true);
	}
}