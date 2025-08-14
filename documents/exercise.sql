/*******************************************************
exercise
*******************************************************/
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table exercise;

-- 테이블 생성
create table exercise(
	exercise_id		int		primary key		auto_increment
    ,body_part		varchar(50)
	,exercise_name		varchar(100)
);

-- 추가
insert into exercise
value(null, 'scheduled')
;

-- 조회
select 	*
from 	exercise
;