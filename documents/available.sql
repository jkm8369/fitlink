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

ALTER TABLE availability DROP INDEX idx_avail_trainer_dt;
CREATE UNIQUE INDEX uq_avail_trainer_dt ON availability (trainer_id, available_datetime);
