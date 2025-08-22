/* =========================================================
  3) 예약 (reservation)
     - "어떤 회원이(pt_member.member_id) 어떤 근무칸(trainer_availability.avail_id)을
        예약했는가"를 저장
     - 근무시간 외 예약 금지: availability_id FK로 보장
     - 같은 근무칸에 중복 예약 금지: UNIQUE(availability_id)
========================================================= */
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table reservation;

-- 테이블 생성
CREATE TABLE reservation (
  /* 예약 PK */
  reservation_id  BIGINT PRIMARY KEY AUTO_INCREMENT,

  /* 예약한 회원 (users.user_id) */
  member_id       INT NOT NULL,                -- FK: users(user_id)

  /* 예약된 근무칸 (trainer_availability.avail_id)
     → 여기서 트레이너/날짜/시간을 조인으로 항상 일관되게 가져옴 */
  availability_id INT NOT NULL,                -- FK: trainer_availability(avail_id)

  /* 상태:
       BOOKED    = 예약됨(미진행)
       ATTENDED  = 출석/수업 완료
       CANCELLED = 예약 취소
       NOSHOW    = 노쇼 (정책에 따라 차감 포함/제외 선택)
  */
  status ENUM('BOOKED','ATTENDED','CANCELLED','NOSHOW') NOT NULL DEFAULT 'BOOKED',

  /* 메모(선택) */
  memo VARCHAR(255) NULL,

  /* 같은 근무칸은 1명만 예약 허용 (중복 예약 방지) */
  UNIQUE KEY uq_one_booking_per_slot (availability_id),

  /* 조회 최적화 */
  INDEX idx_member (member_id),
  INDEX idx_avail  (availability_id),

  /* FK: 존재하는 회원/근무칸만 참조 가능 */
  CONSTRAINT fk_resv_member FOREIGN KEY (member_id)       REFERENCES users(user_id),
  CONSTRAINT fk_resv_avail  FOREIGN KEY (availability_id) REFERENCES trainer_availability(avail_id)
);

-- 조회
select 	*
from 	reservation
;

-- 삭제
DELETE FROM reservation
WHERE reservation_id = 65
;

ALTER TABLE reservation
 DROP INDEX uq_one_booking_per_slot;
 
ALTER TABLE reservation
ADD UNIQUE KEY uq_active_slot
  (
    (CASE WHEN status IN ('BOOKED','ATTENDED') THEN availability_id ELSE NULL END)
  );


select	CONCAT(
			CASE 
				WHEN t.work_hour = 24 THEN '24:00'
				ELSE CONCAT(LPAD(t.work_hour, 2, '0'), ':00')
			END,
			' ',
			u.user_name
		) AS title,
        t.work_date start,
        t.avail_id,
		t.trainer_id,
        t.work_date,
        t.work_hour,
        r.reservation_id,
        r.member_id,
        r.availability_id,
        r.status,
        u.user_name
from Trainer_Availability t, reservation r, users u
where t.avail_id = r.availability_id 
and u.user_id = r.member_id
and t.trainer_id = 4
and r.status ='BOOKED'
;


select	t.avail_id,
		t.trainer_id,
        t.work_date,
        t.work_hour,
        r.reservation_id,
        r.member_id,
        r.availability_id,
        r.status,
        u.user_name
from Trainer_Availability t, reservation r, users u
where t.avail_id = r.availability_id 
and u.user_id = r.member_id
and t.trainer_id = 4
and r.status ='BOOKED'
;
