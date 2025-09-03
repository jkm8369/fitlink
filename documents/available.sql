CREATE TABLE availability (
  availability_id     INT AUTO_INCREMENT PRIMARY KEY,
  trainer_id          INT NOT NULL,
  available_datetime  DATETIME NOT NULL,
  UNIQUE KEY uq_avail_trainer_dt (trainer_id, available_datetime),
  KEY idx_avail_trainer_dt (trainer_id, available_datetime),
  CONSTRAINT fk_avail_trainer
    FOREIGN KEY (trainer_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 조회
SELECT *
FROM availability;

DELETE FROM availability
WHERE availability_id = 17;

ALTER TABLE availability DROP INDEX idx_avail_trainer_dt;
CREATE UNIQUE INDEX uq_avail_trainer_dt ON availability (trainer_id, available_datetime);

ALTER TABLE availability
RENAME INDEX uq_avail_trainer_dt TO idx_avail_trainer_dt;

CREATE INDEX idx_avail_trainer_workdate
ON availability (trainer_id, (DATE(available_datetime)));

SHOW INDEX FROM availability;

EXPLAIN
SELECT a.availability_id
FROM availability a
WHERE a.trainer_id = 1
  AND a.available_datetime BETWEEN '2025-08-26 00:00:00' AND '2025-08-28 23:59:59';
  
  EXPLAIN
SELECT a.availability_id
FROM availability a
WHERE a.trainer_id = 1
  AND DATE(a.available_datetime) = '2025-08-27';
  
-- 유니크 인덱스의 이름을 매퍼가 기대하는 이름으로 변경
ALTER TABLE availability
RENAME INDEX uq_avail_trainer_dt TO idx_avail_trainer_dt;

-- 최종 확인
SHOW INDEX FROM availability;


