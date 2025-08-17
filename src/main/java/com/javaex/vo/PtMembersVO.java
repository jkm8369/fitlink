package com.javaex.vo;

public class PtMembersVO {

	private int contractId;
	private int trainerId;
	private int memberId;
	private int totalSessions;
	private String job;
	private String consultation_date;
	private String fitnessGoal;
	
	public PtMembersVO() {
		super();
	}

	public PtMembersVO(int contractId, int trainerId, int memberId, int totalSessions, String job,
			String consultation_date, String fitnessGoal) {
		super();
		this.contractId = contractId;
		this.trainerId = trainerId;
		this.memberId = memberId;
		this.totalSessions = totalSessions;
		this.job = job;
		this.consultation_date = consultation_date;
		this.fitnessGoal = fitnessGoal;
	}

	public int getContractId() {
		return contractId;
	}

	public void setContractId(int contractId) {
		this.contractId = contractId;
	}

	public int getTrainerId() {
		return trainerId;
	}

	public void setTrainerId(int trainerId) {
		this.trainerId = trainerId;
	}

	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

	public int getTotalSessions() {
		return totalSessions;
	}

	public void setTotalSessions(int totalSessions) {
		this.totalSessions = totalSessions;
	}

	public String getJob() {
		return job;
	}

	public void setJob(String job) {
		this.job = job;
	}

	public String getConsultation_date() {
		return consultation_date;
	}

	public void setConsultation_date(String consultation_date) {
		this.consultation_date = consultation_date;
	}

	public String getFitnessGoal() {
		return fitnessGoal;
	}

	public void setFitnessGoal(String fitnessGoal) {
		this.fitnessGoal = fitnessGoal;
	}

	@Override
	public String toString() {
		return "PtMembersVO [contractId=" + contractId + ", trainerId=" + trainerId + ", memberId=" + memberId
				+ ", totalSessions=" + totalSessions + ", job=" + job + ", consultation_date=" + consultation_date
				+ ", fitnessGoal=" + fitnessGoal + "]";
	}
	
	
	
	
}
