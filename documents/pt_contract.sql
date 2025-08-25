CREATE TABLE pt_contract (
  contract_id    INT AUTO_INCREMENT PRIMARY KEY,
  member_id      INT NOT NULL,
  trainer_id     INT NOT NULL,
  total_sessions INT NOT NULL CHECK (total_sessions > 0),
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_pt_contract_member_trainer (member_id, trainer_id),
  CONSTRAINT fk_pt_contract_member
    FOREIGN KEY (member_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pt_contract_trainer
    FOREIGN KEY (trainer_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT *
FROM pt_contract;