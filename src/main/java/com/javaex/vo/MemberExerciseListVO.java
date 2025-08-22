package com.javaex.vo;

public class MemberExerciseListVO {

	private int exerciseId;
	private String exerciseName;
	private boolean checked;
	
	public MemberExerciseListVO() {
		super();
	}

	public MemberExerciseListVO(int exerciseId, String exerciseName, boolean checked) {
		super();
		this.exerciseId = exerciseId;
		this.exerciseName = exerciseName;
		this.checked = checked;
	}

	public int getExerciseId() {
		return exerciseId;
	}

	public void setExerciseId(int exerciseId) {
		this.exerciseId = exerciseId;
	}

	public String getExerciseName() {
		return exerciseName;
	}

	public void setExerciseName(String exerciseName) {
		this.exerciseName = exerciseName;
	}

	public boolean isChecked() {
		return checked;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	@Override
	public String toString() {
		return "MemberExerciseListVO [exerciseId=" + exerciseId + ", exerciseName=" + exerciseName + ", checked="
				+ checked + "]";
	}
	
	
	
}
