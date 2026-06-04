-- MaKandra — Complete Database Schema
-- Generated from live database. Run on a fresh DB:
--
--   mysql -u <user> -p -e "CREATE DATABASE IF NOT EXISTS makandra"
--   mysql -u <user> -p makandra < sql/005_schema.sql

-- ── roles ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roles (
  id          INT          AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50)  NOT NULL UNIQUE,
  description VARCHAR(255) DEFAULT NULL,
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── users ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id                 INT           AUTO_INCREMENT PRIMARY KEY,
  name               VARCHAR(250)  NOT NULL,
  first_name         VARCHAR(100)  DEFAULT NULL,
  last_name          VARCHAR(100)  DEFAULT NULL,
  email              VARCHAR(250)  NOT NULL,
  password           VARCHAR(255)  NOT NULL,
  role               ENUM('klant','dienstverlener') DEFAULT 'klant',
  created_at         TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  category           VARCHAR(100)  DEFAULT NULL,
  experience         TEXT          DEFAULT NULL,
  bio                TEXT          DEFAULT NULL,
  hourly_rate        DECIMAL(10,2) DEFAULT NULL,
  district           VARCHAR(100)  DEFAULT NULL,
  phone              VARCHAR(50)   DEFAULT NULL,
  working_hours      VARCHAR(200)  DEFAULT NULL,
  profile_picture    TEXT          DEFAULT NULL,
  dnd_mode           TINYINT(1)    NOT NULL DEFAULT 0,
  email_verified     TINYINT(1)    NOT NULL DEFAULT 0,
  verification_token VARCHAR(64)   DEFAULT NULL,
  is_admin           TINYINT(1)    NOT NULL DEFAULT 0,
  pw_change_token    VARCHAR(64)   DEFAULT NULL,
  pw_change_hash     VARCHAR(255)  DEFAULT NULL,
  pw_change_expires  DATETIME      DEFAULT NULL,
  is_available       TINYINT(1)    NOT NULL DEFAULT 1,
  role_id            INT           DEFAULT NULL,
  UNIQUE KEY uq_email (email),
  INDEX idx_role     (role),
  INDEX idx_is_admin (is_admin),
  INDEX idx_category (category),
  INDEX idx_district (district)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── provider_profiles ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS provider_profiles (
  user_id       INT            PRIMARY KEY,
  category      VARCHAR(100)   DEFAULT NULL,
  experience    VARCHAR(255)   DEFAULT NULL,
  hourly_rate   DECIMAL(10,2)  DEFAULT NULL,
  phone         VARCHAR(50)    DEFAULT NULL,
  working_hours VARCHAR(500)   DEFAULT NULL,
  is_available  TINYINT(1)     NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── bookings ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bookings (
  id                INT       AUTO_INCREMENT PRIMARY KEY,
  klant_id          INT       NOT NULL,
  dienstverlener_id INT       NOT NULL,
  date              DATE      NOT NULL,
  time              TIME      DEFAULT NULL,
  duration_minutes  INT       NOT NULL DEFAULT 60,
  message           TEXT      DEFAULT NULL,
  status            ENUM('pending','accepted','completed','declined','cancelled') NOT NULL DEFAULT 'pending',
  created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_bk_dv    (dienstverlener_id),
  INDEX idx_bk_klant (klant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── reviews ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
  id          INT       AUTO_INCREMENT PRIMARY KEY,
  reviewer_id INT       NOT NULL,
  provider_id INT       NOT NULL,
  score       SMALLINT  NOT NULL,
  text        TEXT      NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_rv_reviewer (reviewer_id),
  INDEX idx_rv_provider (provider_id),
  CONSTRAINT fk_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reviews_provider FOREIGN KEY (provider_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_score            CHECK (score BETWEEN 1 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── notifications ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
  id         INT       AUTO_INCREMENT PRIMARY KEY,
  user_id    INT       NOT NULL,
  message    TEXT      NOT NULL,
  is_read    TINYINT   DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_notif_user (user_id),
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── portfolio ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS portfolio (
  id         INT          AUTO_INCREMENT PRIMARY KEY,
  user_id    INT          NOT NULL,
  file_path  VARCHAR(500) NOT NULL,
  file_type  ENUM('image','video') NOT NULL DEFAULT 'image',
  caption    VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── jobs ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS jobs (
  id          INT           AUTO_INCREMENT PRIMARY KEY,
  klant_id    INT           NOT NULL,
  title       VARCHAR(255)  NOT NULL,
  description TEXT          DEFAULT NULL,
  category    VARCHAR(100)  NOT NULL,
  district    VARCHAR(100)  DEFAULT NULL,
  budget      DECIMAL(10,2) DEFAULT NULL,
  date_needed DATE          DEFAULT NULL,
  status      ENUM('open','closed','in_progress','completed','cancelled') NOT NULL DEFAULT 'open',
  created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_jobs_status   (status),
  INDEX idx_jobs_category (category),
  INDEX idx_jobs_district (district),
  INDEX idx_jobs_date     (date_needed),
  CONSTRAINT fk_jobs_klant FOREIGN KEY (klant_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── job_responses ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS job_responses (
  id                INT  AUTO_INCREMENT PRIMARY KEY,
  job_id            INT  NOT NULL,
  dienstverlener_id INT  NOT NULL,
  message           TEXT DEFAULT NULL,
  status            ENUM('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_job_provider (job_id, dienstverlener_id),
  INDEX idx_jr_job (job_id),
  INDEX idx_jr_dv  (dienstverlener_id),
  CONSTRAINT fk_jobresponses_job           FOREIGN KEY (job_id)            REFERENCES jobs(id)  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_jobresponses_dienstverlener FOREIGN KEY (dienstverlener_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── messages ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS messages (
  id          INT       AUTO_INCREMENT PRIMARY KEY,
  sender_id   INT       NOT NULL,
  receiver_id INT       NOT NULL,
  message     TEXT      NOT NULL,
  is_read     TINYINT(1) NOT NULL DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_chat     (sender_id, receiver_id),
  INDEX idx_chat_rev (receiver_id, sender_id),
  CONSTRAINT fk_messages_sender   FOREIGN KEY (sender_id)   REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_messages_receiver FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ── user_roles ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_roles (
  user_id    INT NOT NULL,
  role_id    INT NOT NULL,
  granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
