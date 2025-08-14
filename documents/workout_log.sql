/*******************************************************
workout_log
*******************************************************/
-- 데이터 베이스 사용
use project_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table workout_log;

-- 테이블 생성
create table workout_log(
	log_id		int		primary key		auto_increment
    ,log_date   date 
    ,weight     decimal(5, 2)
    ,reps       int     
    ,created_at datetime
    ,log_type   enum('NORMAL', '1RM')
);

-- 추가
insert into workout_log
value(null, 'scheduled')
;

-- 조회
select 	*
from 	workout_log
;