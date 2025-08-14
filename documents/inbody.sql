/*******************************************************
inbody
*******************************************************/
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table inbody;

-- 테이블 생성
create table inbody(
	inbody_id            INT             PRIMARY KEY AUTO_INCREMENT
    ,record_date         DATE
    ,image_url           VARCHAR(255)
    -- ========== 기본 체성분 분석 ==========
    ,weight_kg           DECIMAL(5, 2)
    ,muscle_mass_kg      DECIMAL(5, 2)
    ,fat_mass_kg         DECIMAL(5, 2)
    ,bmi                 DECIMAL(4, 2)
    ,percent_body_fat    DECIMAL(4, 2)
    -- ========== 비만 진단 ==========
    ,cid_type            ENUM('C', 'I', 'D')
    ,visceral_fat_level  INT            
    -- ========== 신체 균형 및 조절 ==========
    ,fat_control_kg      DECIMAL(4, 1)
    ,muscle_control_kg   DECIMAL(4, 1)
    ,upper_lower_balance ENUM('BALANCED', 'UPPER_DEVELOPED', 'LOWER_DEVELOPED')
    ,left_right_balance  ENUM('BALANCED', 'LEFT_DOMINANT', 'RIGHT_DOMINANT')
    -- ========== 영양 정보 (전체 목표) ==========
    ,target_calories     DECIMAL(7, 2)
    ,required_protein_g  DECIMAL(7, 2)
    ,carb_ratio          DECIMAL(5, 2)
    ,protein_ratio       DECIMAL(5, 2)
    ,fat_ratio           DECIMAL(5, 2)
    ,target_carb_kcal    DECIMAL(7, 2)
    ,target_protein_kcal DECIMAL(7, 2)
    ,target_fat_kcal     DECIMAL(7, 2)
    ,target_carb_g       DECIMAL(7, 2)
    ,target_protein_g    DECIMAL(7, 2)
    ,target_fat_g        DECIMAL(7, 2)
    -- ========== 영양 정보 (아침) ==========
    ,breakfast_kcal      DECIMAL(7, 2)
    ,breakfast_carb_g    DECIMAL(7, 2)
    ,breakfast_protein_g DECIMAL(7, 2)
    ,breakfast_fat_g     DECIMAL(7, 2)
    -- ========== 영양 정보 (점심) ==========
    ,lunch_kcal          DECIMAL(7, 2)
    ,lunch_carb_g        DECIMAL(7, 2)
    ,lunch_protein_g     DECIMAL(7, 2)
    ,lunch_fat_g         DECIMAL(7, 2)
    -- ========== 영양 정보 (저녁) ==========
    ,dinner_kcal         DECIMAL(7, 2)
    ,dinner_carb_g       DECIMAL(7, 2)
    ,dinner_protein_g    DECIMAL(7, 2)
    ,dinner_fat_g        DECIMAL(7, 2)
);

-- 추가
insert into inbody
value(null)
;

-- 조회
select 	*
from 	inbody
;