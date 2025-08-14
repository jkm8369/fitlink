/***************************************************
			web 계정에서 사용 - board
***************************************************/

-- web_db 사용
use web_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table board;

-- board(게시판)테이블 생성
create table board(
	no			int				primary key		auto_increment,
	user_no		int				not null,
    title		varchar(500)	not null,
    content		text,
    hit			int,
    reg_date	datetime		not null,
    constraint board_fk foreign key(user_no)
    references users(no)
)
;

-- 전체조회
select no,
	   title,
       content,
       hit,
       reg_date as regDate,
       user_no as userNo
from board
;

-- 데이터 등록
insert into board
values(null, '1', '첫번째 게시물제목', '첫번째 게시물내용', '0', now());

insert into board
values(null, '2', '두번째 게시물제목', '두번째 게시물내용', '0', now());

insert into board
values(null, '3', '세번째 게시물제목', '세번째 게시물내용', '0', now());

-- 전체 조회
select *
from board
;

select *
from users
;


select b.no,
       b.title,
       b.content,
       b.hit,
       date_format(b.reg_date, "%Y-%m-%d") as regDate,
       u.no as userNo,
       u.name as userName
from users u, board b
where u.no = b.user_no
;

select u.name as userName,
	   b.hit,
       date_format(b.reg_date, "%Y-%m-%d") as regDate,
       b.title,
       b.content
from users u, board b
where u.no= b.user_no
and b.no = 3
;

delete from users
where no = 3
and password = 1111
;




