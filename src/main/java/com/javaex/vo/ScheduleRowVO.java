package com.javaex.vo;

public class ScheduleRowVO {
	// 필드
	private Integer no; // 예약 PK
	private String date; // "yyyy.MM.dd"
	private String time; // "HH:mm"
	private String name; // 상대 이름 (회원 or 트레이너)
	private Integer memberId;// (트레이너 페이지에서 합계 계산/취소 등에 유용)

	// 선택: 행마다 합계도 내려주면 트레이너 페이지에서 편함
	private Integer total; // 등록일수
	private Integer used; // 수업일수
	private Integer remain; // 잔여 = total - used (0 미만이면 0)
	private Boolean cancelable;

	// 메소드
	public ScheduleRowVO() {
	}

	public Integer getNo() {
		return no;
	}

	public void setNo(Integer no) {
		this.no = no;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public Integer getUsed() {
		return used;
	}

	public void setUsed(Integer used) {
		this.used = used;
	}

	public Integer getRemain() {
		return remain;
	}

	public void setRemain(Integer remain) {
		this.remain = remain;
	}

	public Boolean getCancelable() {
		return cancelable;
	}

	public void setCancelable(Boolean cancelable) {
		this.cancelable = cancelable;
	}
}
