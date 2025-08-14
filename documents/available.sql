/*******************************************************
availability
*******************************************************/
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table availability;

-- 테이블 생성
create table availability(
	availability_id    	   int             primary key	auto_increment
    ,available_datetime    datetime        
);

-- 추가
insert into availability
value(null, now())
;

-- 조회
select 	*
from 	availability
;