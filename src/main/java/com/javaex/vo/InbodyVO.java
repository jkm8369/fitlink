package com.javaex.vo;

public class InbodyVO {
	
	// 필드
    private int inbodyId;
    private String recordDate;
    private String imageUrl;
    private double weightKg;
    private double muscleMassKg;
    private double fatMassKg;
    private double bmi;
    private double percentBodyFat;
    private String cidType;
    private int visceralFatLevel;
    private double fatControlKg;
    private double muscleControlKg;
    private String upperLowerBalance;
    private String leftRightBalance;
    private double targetCalories;
    private double requiredProteinG;
    private double carbRatio;
    private double proteinRatio;
    private double fatRatio;
    private double targetCarbKcal;
    private double targetProteinKcal;
    private double targetFatKcal;
    private double targetCarbG;
    private double targetProteinG;
    private double targetFatG;
    private double breakfastKcal;
    private double breakfastCarbG;
    private double breakfastProteinG;
    private double breakfastFatG;
    private double lunchKcal;
    private double lunchCarbG;
    private double lunchProteinG;
    private double lunchFatG;
    private double dinnerKcal;
    private double dinnerCarbG;
    private double dinnerProteinG;
    private double dinnerFatG;
    private int userId;
    private int inbodyScore;
    
    //생성자
	public InbodyVO() {
		super();
	}

	public InbodyVO(int inbodyId, String recordDate, String imageUrl, double weightKg, double muscleMassKg,
			double fatMassKg, double bmi, double percentBodyFat, String cidType, int visceralFatLevel,
			double fatControlKg, double muscleControlKg, String upperLowerBalance, String leftRightBalance,
			double targetCalories, double requiredProteinG, double carbRatio, double proteinRatio, double fatRatio,
			double targetCarbKcal, double targetProteinKcal, double targetFatKcal, double targetCarbG,
			double targetProteinG, double targetFatG, double breakfastKcal, double breakfastCarbG,
			double breakfastProteinG, double breakfastFatG, double lunchKcal, double lunchCarbG, double lunchProteinG,
			double lunchFatG, double dinnerKcal, double dinnerCarbG, double dinnerProteinG, double dinnerFatG,
			int userId, int inbodyScore) {
		super();
		this.inbodyId = inbodyId;
		this.recordDate = recordDate;
		this.imageUrl = imageUrl;
		this.weightKg = weightKg;
		this.muscleMassKg = muscleMassKg;
		this.fatMassKg = fatMassKg;
		this.bmi = bmi;
		this.percentBodyFat = percentBodyFat;
		this.cidType = cidType;
		this.visceralFatLevel = visceralFatLevel;
		this.fatControlKg = fatControlKg;
		this.muscleControlKg = muscleControlKg;
		this.upperLowerBalance = upperLowerBalance;
		this.leftRightBalance = leftRightBalance;
		this.targetCalories = targetCalories;
		this.requiredProteinG = requiredProteinG;
		this.carbRatio = carbRatio;
		this.proteinRatio = proteinRatio;
		this.fatRatio = fatRatio;
		this.targetCarbKcal = targetCarbKcal;
		this.targetProteinKcal = targetProteinKcal;
		this.targetFatKcal = targetFatKcal;
		this.targetCarbG = targetCarbG;
		this.targetProteinG = targetProteinG;
		this.targetFatG = targetFatG;
		this.breakfastKcal = breakfastKcal;
		this.breakfastCarbG = breakfastCarbG;
		this.breakfastProteinG = breakfastProteinG;
		this.breakfastFatG = breakfastFatG;
		this.lunchKcal = lunchKcal;
		this.lunchCarbG = lunchCarbG;
		this.lunchProteinG = lunchProteinG;
		this.lunchFatG = lunchFatG;
		this.dinnerKcal = dinnerKcal;
		this.dinnerCarbG = dinnerCarbG;
		this.dinnerProteinG = dinnerProteinG;
		this.dinnerFatG = dinnerFatG;
		this.userId = userId;
		this.inbodyScore = inbodyScore;
	}

	//메소드 gs
	public int getInbodyId() {
		return inbodyId;
	}

	public void setInbodyId(int inbodyId) {
		this.inbodyId = inbodyId;
	}

	public String getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public double getWeightKg() {
		return weightKg;
	}

	public void setWeightKg(double weightKg) {
		this.weightKg = weightKg;
	}

	public double getMuscleMassKg() {
		return muscleMassKg;
	}

	public void setMuscleMassKg(double muscleMassKg) {
		this.muscleMassKg = muscleMassKg;
	}

	public double getFatMassKg() {
		return fatMassKg;
	}

	public void setFatMassKg(double fatMassKg) {
		this.fatMassKg = fatMassKg;
	}

	public double getBmi() {
		return bmi;
	}

	public void setBmi(double bmi) {
		this.bmi = bmi;
	}

	public double getPercentBodyFat() {
		return percentBodyFat;
	}

	public void setPercentBodyFat(double percentBodyFat) {
		this.percentBodyFat = percentBodyFat;
	}

	public String getCidType() {
		return cidType;
	}

	public void setCidType(String cidType) {
		this.cidType = cidType;
	}

	public int getVisceralFatLevel() {
		return visceralFatLevel;
	}

	public void setVisceralFatLevel(int visceralFatLevel) {
		this.visceralFatLevel = visceralFatLevel;
	}

	public double getFatControlKg() {
		return fatControlKg;
	}

	public void setFatControlKg(double fatControlKg) {
		this.fatControlKg = fatControlKg;
	}

	public double getMuscleControlKg() {
		return muscleControlKg;
	}

	public void setMuscleControlKg(double muscleControlKg) {
		this.muscleControlKg = muscleControlKg;
	}

	public String getUpperLowerBalance() {
		return upperLowerBalance;
	}

	public void setUpperLowerBalance(String upperLowerBalance) {
		this.upperLowerBalance = upperLowerBalance;
	}

	public String getLeftRightBalance() {
		return leftRightBalance;
	}

	public void setLeftRightBalance(String leftRightBalance) {
		this.leftRightBalance = leftRightBalance;
	}

	public double getTargetCalories() {
		return targetCalories;
	}

	public void setTargetCalories(double targetCalories) {
		this.targetCalories = targetCalories;
	}

	public double getRequiredProteinG() {
		return requiredProteinG;
	}

	public void setRequiredProteinG(double requiredProteinG) {
		this.requiredProteinG = requiredProteinG;
	}

	public double getCarbRatio() {
		return carbRatio;
	}

	public void setCarbRatio(double carbRatio) {
		this.carbRatio = carbRatio;
	}

	public double getProteinRatio() {
		return proteinRatio;
	}

	public void setProteinRatio(double proteinRatio) {
		this.proteinRatio = proteinRatio;
	}

	public double getFatRatio() {
		return fatRatio;
	}

	public void setFatRatio(double fatRatio) {
		this.fatRatio = fatRatio;
	}

	public double getTargetCarbKcal() {
		return targetCarbKcal;
	}

	public void setTargetCarbKcal(double targetCarbKcal) {
		this.targetCarbKcal = targetCarbKcal;
	}

	public double getTargetProteinKcal() {
		return targetProteinKcal;
	}

	public void setTargetProteinKcal(double targetProteinKcal) {
		this.targetProteinKcal = targetProteinKcal;
	}

	public double getTargetFatKcal() {
		return targetFatKcal;
	}

	public void setTargetFatKcal(double targetFatKcal) {
		this.targetFatKcal = targetFatKcal;
	}

	public double getTargetCarbG() {
		return targetCarbG;
	}

	public void setTargetCarbG(double targetCarbG) {
		this.targetCarbG = targetCarbG;
	}

	public double getTargetProteinG() {
		return targetProteinG;
	}

	public void setTargetProteinG(double targetProteinG) {
		this.targetProteinG = targetProteinG;
	}

	public double getTargetFatG() {
		return targetFatG;
	}

	public void setTargetFatG(double targetFatG) {
		this.targetFatG = targetFatG;
	}

	public double getBreakfastKcal() {
		return breakfastKcal;
	}

	public void setBreakfastKcal(double breakfastKcal) {
		this.breakfastKcal = breakfastKcal;
	}

	public double getBreakfastCarbG() {
		return breakfastCarbG;
	}

	public void setBreakfastCarbG(double breakfastCarbG) {
		this.breakfastCarbG = breakfastCarbG;
	}

	public double getBreakfastProteinG() {
		return breakfastProteinG;
	}

	public void setBreakfastProteinG(double breakfastProteinG) {
		this.breakfastProteinG = breakfastProteinG;
	}

	public double getBreakfastFatG() {
		return breakfastFatG;
	}

	public void setBreakfastFatG(double breakfastFatG) {
		this.breakfastFatG = breakfastFatG;
	}

	public double getLunchKcal() {
		return lunchKcal;
	}

	public void setLunchKcal(double lunchKcal) {
		this.lunchKcal = lunchKcal;
	}

	public double getLunchCarbG() {
		return lunchCarbG;
	}

	public void setLunchCarbG(double lunchCarbG) {
		this.lunchCarbG = lunchCarbG;
	}

	public double getLunchProteinG() {
		return lunchProteinG;
	}

	public void setLunchProteinG(double lunchProteinG) {
		this.lunchProteinG = lunchProteinG;
	}

	public double getLunchFatG() {
		return lunchFatG;
	}

	public void setLunchFatG(double lunchFatG) {
		this.lunchFatG = lunchFatG;
	}

	public double getDinnerKcal() {
		return dinnerKcal;
	}

	public void setDinnerKcal(double dinnerKcal) {
		this.dinnerKcal = dinnerKcal;
	}

	public double getDinnerCarbG() {
		return dinnerCarbG;
	}

	public void setDinnerCarbG(double dinnerCarbG) {
		this.dinnerCarbG = dinnerCarbG;
	}

	public double getDinnerProteinG() {
		return dinnerProteinG;
	}

	public void setDinnerProteinG(double dinnerProteinG) {
		this.dinnerProteinG = dinnerProteinG;
	}

	public double getDinnerFatG() {
		return dinnerFatG;
	}

	public void setDinnerFatG(double dinnerFatG) {
		this.dinnerFatG = dinnerFatG;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getInbodyScore() {
		return inbodyScore;
	}

	public void setInbodyScore(int inbodyScore) {
		this.inbodyScore = inbodyScore;
	}

	//메소드 일반
	@Override
	public String toString() {
		return "InbodyVO [inbodyId=" + inbodyId + ", recordDate=" + recordDate + ", imageUrl=" + imageUrl
				+ ", weightKg=" + weightKg + ", muscleMassKg=" + muscleMassKg + ", fatMassKg=" + fatMassKg + ", bmi="
				+ bmi + ", percentBodyFat=" + percentBodyFat + ", cidType=" + cidType + ", visceralFatLevel="
				+ visceralFatLevel + ", fatControlKg=" + fatControlKg + ", muscleControlKg=" + muscleControlKg
				+ ", upperLowerBalance=" + upperLowerBalance + ", leftRightBalance=" + leftRightBalance
				+ ", targetCalories=" + targetCalories + ", requiredProteinG=" + requiredProteinG + ", carbRatio="
				+ carbRatio + ", proteinRatio=" + proteinRatio + ", fatRatio=" + fatRatio + ", targetCarbKcal="
				+ targetCarbKcal + ", targetProteinKcal=" + targetProteinKcal + ", targetFatKcal=" + targetFatKcal
				+ ", targetCarbG=" + targetCarbG + ", targetProteinG=" + targetProteinG + ", targetFatG=" + targetFatG
				+ ", breakfastKcal=" + breakfastKcal + ", breakfastCarbG=" + breakfastCarbG + ", breakfastProteinG="
				+ breakfastProteinG + ", breakfastFatG=" + breakfastFatG + ", lunchKcal=" + lunchKcal + ", lunchCarbG="
				+ lunchCarbG + ", lunchProteinG=" + lunchProteinG + ", lunchFatG=" + lunchFatG + ", dinnerKcal="
				+ dinnerKcal + ", dinnerCarbG=" + dinnerCarbG + ", dinnerProteinG=" + dinnerProteinG + ", dinnerFatG="
				+ dinnerFatG + ", userId=" + userId + ", inbodyScore=" + inbodyScore + "]";
	}
	
    
}   