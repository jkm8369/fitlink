/*******************************************************
pt_members
*******************************************************/
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table pt_members;

-- 테이블 생성
create table pt_members(
	contract_id        INT             PRIMARY KEY	AUTO_INCREMENT
    ,total_sessions    INT             NOT NULL DEFAULT 0
    ,job               VARCHAR(50)     NULL
    ,consultation_date DATE            NOT NULL
    ,fitness_goal      VARCHAR(255)    NULL
);

-- 추가
insert into pt_members
value(null, 30, '학생', '2025-08-13', '다이어트')
;

-- 조회
select 	*
from 	pt_members
;