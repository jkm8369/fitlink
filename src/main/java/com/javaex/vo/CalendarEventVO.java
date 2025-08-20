package com.javaex.vo;

import java.time.LocalDateTime;

public class CalendarEventVO {
	private Integer id; // 예약(또는 예약PK)
	private String title = ""; // 시간만 표시하므로 빈 문자열
	private LocalDateTime start; // 시작 시각
	private LocalDateTime end; // 종료 시각
	private boolean allDay = false; // 종일 여부

	// (재사용 대비) 식별자/이름 필드 - 지금은 안 써도 OK
	private Integer trainerId;
	private Integer memberId;
	private String trainerName;
	private String memberName;

	public CalendarEventVO() {
	}

	// ---- getter/setter ----
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public LocalDateTime getStart() {
		return start;
	}

	public void setStart(LocalDateTime start) {
		this.start = start;
	}

	public LocalDateTime getEnd() {
		return end;
	}

	public void setEnd(LocalDateTime end) {
		this.end = end;
	}

	public boolean isAllDay() {
		return allDay;
	}

	public void setAllDay(boolean allDay) {
		this.allDay = allDay;
	}

	public Integer getTrainerId() {
		return trainerId;
	}

	public void setTrainerId(Integer trainerId) {
		this.trainerId = trainerId;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public String getTrainerName() {
		return trainerName;
	}

	public void setTrainerName(String trainerName) {
		this.trainerName = trainerName;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
}
