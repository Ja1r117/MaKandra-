-- MaKandra — Complete Database Schema
-- This file contains the complete schema for the MaKandra platform.
-- Run this to initialize a new database:
--
--   mysql -u <user> -p -e "CREATE DATABASE IF NOT EXISTS makandra"
--   mysql -u <user> -p makandra < sql/005_schema.sql

-- ── roles ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roles (
  id          INT          AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50)  NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ── users ──────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id                   INT          AUTO_INCREMENT PRIMARY KEY,
  name                 VARCHAR(200) NOT NULL,
  first_name           VARCHAR(100) NULL,
  last_name            VARCHAR(100) NULL,
  email                VARCHAR(255) NOT NULL UNIQUE,
  password             VARCHAR(255) NOT NULL,
  role                 VARCHAR(50)  NOT NULL DEFAULT 'klant',
  role_id              INT          NULL,
  district                VARCHAR(100) NULL,
  category             VARCHAR(100) NULL,
  experience           VARCHAR(255) NULL,
  bio                  TEXT         NULL,
  hourly_rate          DECIMAL(10,2) NULL,
  phone                VARCHAR(50)  NULL,
  working_hours        VARCHAR(500) NULL,
  is_available         TINYINT(1)   NOT NULL DEFAULT 1,
  dnd_mode             TINYINT(1)   NOT NULL DEFAULT 0,
  profile_picture      VARCHAR(500) NULL,
  email_verified       TINYINT(1)   NOT NULL DEFAULT 1,
  verification_token   VARCHAR(64)  NULL,
  is_admin             TINYINT(1)   NOT NULL DEFAULT 0,
  pw_change_token      VARCHAR(64)  NULL,
  pw_change_hash       VARCHAR(255) NULL,
  pw_change_expires    DATETIME     NULL,
  created_at           TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_role_id
    FOREIGN KEY (role_id) REFERENCES roles(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_users_email (email),
  INDEX idx_users_role (role)
);

-- ── provider_profiles ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS provider_profiles (
  user_id       INT            PRIMARY KEY,
  category      VARCHAR(100)   NULL,
  experience    VARCHAR(255)   NULL,
  hourly_rate   DECIMAL(10,2)  NULL,
  phone         VARCHAR(50)    NULL,
  working_hours VARCHAR(500)   NULL,
  is_available  TINYINT(1)     NOT NULL DEFAULT 1,
  CONSTRAINT fk_pp_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ── bookings ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bookings (
  id                INT          AUTO_INCREMENT PRIMARY KEY,
  klant_id          INT          NOT NULL,
  dienstverlener_id INT          NOT NULL,
  date              DATE         NOT NULL,
  time              TIME         NULL,
  duration_minutes  INT          NOT NULL DEFAULT 60,
  message           TEXT         NULL,
  status            ENUM('pending','accepted','completed','declined','cancelled')
                                 NOT NULL DEFAULT 'pending',
  created_at        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bk_klant
    FOREIGN KEY (klant_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_bk_dv
    FOREIGN KEY (dienstverlener_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_bk_dv (dienstverlener_id),
  INDEX idx_bk_klant (klant_id),
  INDEX idx_bk_date (date)
);

-- ── reviews ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
  id          INT       AUTO_INCREMENT PRIMARY KEY,
  reviewer_id INT       NOT NULL,
  provider_id INT       NOT NULL,
  score       INT       NOT NULL,
  text        TEXT      NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_rv_reviewer
    FOREIGN KEY (reviewer_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rv_provider
    FOREIGN KEY (provider_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_rv_provider (provider_id),
  INDEX idx_rv_reviewer (reviewer_id)
);

-- ── notifications ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
  id         INT          AUTO_INCREMENT PRIMARY KEY,
  user_id    INT          NOT NULL,
  message    TEXT         NOT NULL,
  is_read    TINYINT(1)   NOT NULL DEFAULT 0,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notif_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_notif_user (user_id),
  INDEX idx_notif_created (created_at)
);

-- ── portfolio ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS portfolio (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  user_id      INT          NOT NULL,
  file_path    VARCHAR(500) NOT NULL,
  file_type    ENUM('image','video') NOT NULL DEFAULT 'image',
  caption      VARCHAR(255) NULL,
  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_portfolio_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_portfolio_user (user_id)
);

-- ── jobs ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS jobs (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  klant_id     INT          NOT NULL,
  title        VARCHAR(255) NOT NULL,
  description  TEXT         NULL,
  category     VARCHAR(100) NOT NULL,
  district        VARCHAR(100) NULL,
  budget       VARCHAR(100) NULL,
  date_needed  DATE         NULL,
  status       ENUM('open','closed','in_progress','completed','cancelled')
                           NOT NULL DEFAULT 'open',
  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_jobs_klant
    FOREIGN KEY (klant_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_jobs_klant (klant_id),
  INDEX idx_jobs_category (category),
  INDEX idx_jobs_status (status)
);

-- ── job_responses ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS job_responses (
  id                INT          AUTO_INCREMENT PRIMARY KEY,
  job_id            INT          NOT NULL,
  dienstverlener_id INT          NOT NULL,
  message           TEXT         NULL,
  created_at        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_jr_job
    FOREIGN KEY (job_id) REFERENCES jobs(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_jr_dv
    FOREIGN KEY (dienstverlener_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_jr_job (job_id),
  INDEX idx_jr_dv (dienstverlener_id)
);

-- ── messages ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS messages (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  sender_id    INT          NOT NULL,
  receiver_id  INT          NOT NULL,
  message      TEXT         NOT NULL,
  is_read      TINYINT(1)   NOT NULL DEFAULT 0,
  created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_msg_sender
    FOREIGN KEY (sender_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_msg_receiver
    FOREIGN KEY (receiver_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_msg_sender (sender_id),
  INDEX idx_msg_receiver (receiver_id),
  INDEX idx_msg_created (created_at)
);

-- ── user_roles (for future multi-role support) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS user_roles (
  user_id    INT NOT NULL,
  role_id    INT NOT NULL,
  granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_ur_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ur_role
    FOREIGN KEY (role_id) REFERENCES roles(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);
