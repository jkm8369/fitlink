use fitlink_db;

SELECT *
FROM users;

CREATE TABLE users (
  user_id             INT AUTO_INCREMENT PRIMARY KEY,
  login_id            VARCHAR(50)  NOT NULL,
  password            VARCHAR(255) NULL,
  user_name           VARCHAR(50)  NOT NULL,
  phone_number        VARCHAR(20)  NULL,
  birthdate           DATE         NULL,
  gender              ENUM('male','female') NULL,
  role                ENUM('member','trainer') NOT NULL,
  assigned_trainer_id INT NULL,
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_users_login (login_id),
  KEY idx_users_assigned_trainer (assigned_trainer_id),
  CONSTRAINT fk_users_assigned_trainer
    FOREIGN KEY (assigned_trainer_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'aws_fitlink_db' AND TABLE_NAME = 'users';

