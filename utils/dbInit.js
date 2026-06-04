import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import bcrypt from 'bcryptjs';
import { db } from '../config/db.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export async function runDbInit() {
  // ── Create tables from schema file ──────────────────────────────────────────
  const schemaSQL = fs.readFileSync(
    path.join(__dirname, '../sql/005_schema.sql'),
    'utf8'
  );
  const statements = schemaSQL
    .split(';')
    .map(s => s.trim())
    .filter(s => s.length > 0 && !s.startsWith('--'));

  for (const stmt of statements) {
    await db.query(stmt);
  }

  // ── Seed required roles ──────────────────────────────────────────────────────
  await db.query(`INSERT IGNORE INTO roles (name, description) VALUES
    ('klant',          'Klant — boekt diensten van dienstverleners'),
    ('dienstverlener', 'Dienstverlener — biedt diensten aan op het platform'),
    ('admin',          'Beheerder — beheert het platform en alle gebruikers')`);

  // ── Schema compatibility shims (safe to re-run) ──────────────────────────────
  const alterCols = [
    'ALTER TABLE users ADD COLUMN district           VARCHAR(100) NULL',
    'ALTER TABLE users ADD COLUMN dnd_mode           TINYINT(1)   NOT NULL DEFAULT 0',
    'ALTER TABLE users ADD COLUMN is_available        TINYINT(1)   NOT NULL DEFAULT 1',
    'ALTER TABLE users ADD COLUMN email_verified     TINYINT(1)   NOT NULL DEFAULT 1',
    'ALTER TABLE users ADD COLUMN verification_token  VARCHAR(64)  NULL',
    'ALTER TABLE users ADD COLUMN is_admin            TINYINT(1)   NOT NULL DEFAULT 0',
    'ALTER TABLE users ADD COLUMN pw_change_token     VARCHAR(64)  NULL',
    'ALTER TABLE users ADD COLUMN pw_change_hash      VARCHAR(255) NULL',
    'ALTER TABLE users ADD COLUMN pw_change_expires   DATETIME     NULL',
    'ALTER TABLE users ADD COLUMN first_name          VARCHAR(100) NULL AFTER name',
    'ALTER TABLE users ADD COLUMN last_name           VARCHAR(100) NULL AFTER first_name',
    'ALTER TABLE users ADD COLUMN role_id             INT NULL',
  ];
  for (const sql of alterCols) {
    try { await db.query(sql); } catch { /* column already exists */ }
  }

  // messages: handle renamed column from 005_schema older versions
  try { await db.query('ALTER TABLE messages DROP FOREIGN KEY fk_msg_recipient'); } catch { /* FK not present */ }
  try { await db.query('ALTER TABLE messages CHANGE COLUMN recipient_id receiver_id INT NOT NULL'); } catch { /* already correct */ }

  // jobs: handle renamed column from 005_schema older versions
  try { await db.query('ALTER TABLE jobs DROP FOREIGN KEY fk_jobs_user'); } catch { /* FK not present */ }
  try { await db.query('ALTER TABLE jobs CHANGE COLUMN user_id klant_id INT NOT NULL'); } catch { /* already correct */ }

  try { await db.query('ALTER TABLE jobs ADD COLUMN budget VARCHAR(100) NULL'); } catch { /* already exists */ }
  try { await db.query('ALTER TABLE jobs ADD COLUMN date_needed DATE NULL'); } catch { /* already exists */ }
  try {
    await db.query("ALTER TABLE jobs MODIFY COLUMN status ENUM('open','closed','in_progress','completed','cancelled') NOT NULL DEFAULT 'open'");
  } catch { /* already correct */ }
  try {
    await db.query("ALTER TABLE bookings MODIFY COLUMN status ENUM('pending','accepted','completed','declined','cancelled') NOT NULL DEFAULT 'pending'");
  } catch { /* already correct */ }

  // ── Data fixes ───────────────────────────────────────────────────────────────
  try { await db.query('UPDATE users SET email_verified = 1 WHERE email_verified IS NULL OR email_verified = 0'); } catch { /* skip */ }

  try {
    await db.query("UPDATE users SET profile_picture = REPLACE(profile_picture, '/uploads/', '/img/') WHERE profile_picture LIKE '/uploads/%'");
    await db.query("UPDATE portfolio SET file_path = REPLACE(file_path, '/uploads/', '/img/') WHERE file_path LIKE '/uploads/%'");
  } catch { /* skip */ }

  try {
    await db.query(`UPDATE users
      SET first_name = TRIM(SUBSTRING_INDEX(name, ' ', 1)),
          last_name  = NULLIF(TRIM(SUBSTRING(name, CHAR_LENGTH(SUBSTRING_INDEX(name, ' ', 1)) + 2)), '')
      WHERE first_name IS NULL AND name IS NOT NULL AND name != ''`);
  } catch { /* skip */ }

  try {
    await db.query(`UPDATE users u JOIN roles r ON r.name = u.role SET u.role_id = r.id WHERE u.role_id IS NULL`);
  } catch { /* skip */ }

  try {
    await db.query(`INSERT INTO provider_profiles
        (user_id, category, experience, hourly_rate, phone, working_hours, is_available)
      SELECT id, category, experience, hourly_rate, phone, working_hours, COALESCE(is_available, 1)
      FROM users WHERE role = 'dienstverlener'
      ON DUPLICATE KEY UPDATE
        category=VALUES(category), experience=VALUES(experience),
        hourly_rate=VALUES(hourly_rate), phone=VALUES(phone),
        working_hours=VALUES(working_hours), is_available=VALUES(is_available)`);
  } catch { /* skip */ }

  // Fix seed data with invalid bcrypt hashes
  try {
    const [badRows] = await db.query(
      "SELECT COUNT(*) AS cnt FROM users WHERE password LIKE '$2a$10$abcdefghijklmnopqrstuvwxyz%'"
    );
    if (badRows[0].cnt > 0) {
      const fixedHash = await bcrypt.hash('MaKandra2024!', 10);
      await db.query(
        "UPDATE users SET password = ? WHERE password LIKE '$2a$10$abcdefghijklmnopqrstuvwxyz%'",
        [fixedHash]
      );
      console.log(`Fixed ${badRows[0].cnt} seed user(s) with invalid password hashes. Test password: MaKandra2024!`);
    }
  } catch { /* skip */ }
}
