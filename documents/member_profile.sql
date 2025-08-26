CREATE TABLE member_profile (
  member_id    INT PRIMARY KEY,
  job          VARCHAR(50)  NULL,
  consult_date DATE         NULL,
  goal         VARCHAR(100) NULL,
  memo         VARCHAR(500) NULL,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_member_profile_member
    FOREIGN KEY (member_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT *
FROM member_profile;