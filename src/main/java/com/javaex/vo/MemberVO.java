package com.javaex.vo;

public class MemberVO {
	private Integer memberId;
	private String memberName;
	private String birth;
	private String job;
	private String consultDate;
	private String goal;
	private String memo;
	private String phoneNumber;

	private Integer ptRegisteredCnt; 	// 등록(합계)
	private Integer ptUsedCnt; 			// 사용(BOOKED/COMPLETED)
	private Integer ptRemainingCnt; 	// 잔여 = max(등록-사용,0)

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getJob() {
		return job;
	}

	public void setJob(String job) {
		this.job = job;
	}

	public String getConsultDate() {
		return consultDate;
	}

	public void setConsultDate(String consultDate) {
		this.consultDate = consultDate;
	}

	public String getGoal() {
		return goal;
	}

	public void setGoal(String goal) {
		this.goal = goal;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public Integer getPtRegisteredCnt() {
		return ptRegisteredCnt;
	}

	public void setPtRegisteredCnt(Integer ptRegisteredCnt) {
		this.ptRegisteredCnt = ptRegisteredCnt;
	}

	public Integer getPtUsedCnt() {
		return ptUsedCnt;
	}

	public void setPtUsedCnt(Integer ptUsedCnt) {
		this.ptUsedCnt = ptUsedCnt;
	}

	public Integer getPtRemainingCnt() {
		return ptRemainingCnt;
	}

	public void setPtRemainingCnt(Integer ptRemainingCnt) {
		this.ptRemainingCnt = ptRemainingCnt;
	}
}
