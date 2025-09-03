package com.javaex.vo;

public class MemberExerciseVO {

	private int exerciseId;
    private String bodyPart;
    private String exerciseName;
    private Integer creatorId;   // null 허용하기 위해 Integer 사용
    private Integer memberId;
    private Integer forUserId;  // 이 운동이 지정된 사용자의 ID
    
	public MemberExerciseVO() {
		super();
	}

	public MemberExerciseVO(int exerciseId, String bodyPart, String exerciseName, Integer creatorId, Integer memberId) {
		super();
		this.exerciseId = exerciseId;
		this.bodyPart = bodyPart;
		this.exerciseName = exerciseName;
		this.creatorId = creatorId;
		this.memberId = memberId;
	}

	public int getExerciseId() {
		return exerciseId;
	}

	public void setExerciseId(int exerciseId) {
		this.exerciseId = exerciseId;
	}

	public String getBodyPart() {
		return bodyPart;
	}

	public void setBodyPart(String bodyPart) {
		this.bodyPart = bodyPart;
	}

	public String getExerciseName() {
		return exerciseName;
	}

	public void setExerciseName(String exerciseName) {
		this.exerciseName = exerciseName;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public Integer getForUserId() {
	    return forUserId;
	}

	public void setForUserId(Integer forUserId) {
	    this.forUserId = forUserId;
	}

	@Override
	public String toString() {
		return "MemberExerciseVO [exerciseId=" + exerciseId + ", bodyPart=" + bodyPart + ", exerciseName="
				+ exerciseName + ", creatorId=" + creatorId + ", memberId=" + memberId + ", forUserId=" + forUserId
				+ "]";
	}
	
	
}
