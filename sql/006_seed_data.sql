-- MaKandra — Seed Data
-- Passwords are placeholder hashes; server.js replaces them with bcrypt('MaKandra2024!', 10)
-- on first startup. Test login password for all seed accounts: MaKandra2024!
--
--   mysql -u <user> -p makandra < sql/005_schema.sql
--   mysql -u <user> -p makandra < sql/006_seed_data.sql

-- ── Seed roles ─────────────────────────────────────────────────────────────────
INSERT IGNORE INTO roles (name, description) VALUES
  ('klant',          'Klant — boekt diensten van dienstverleners'),
  ('dienstverlener', 'Dienstverlener — biedt diensten aan op het platform'),
  ('admin',          'Beheerder — beheert het platform en alle gebruikers');

-- ── Seed users ─────────────────────────────────────────────────────────────────
-- Placeholder hash is detected and replaced at server startup (see server.js)
INSERT IGNORE INTO users
  (name, first_name, last_name, email, password, role, role_id,
   district, category, experience, bio, hourly_rate, phone, working_hours,
   profile_picture, email_verified, is_admin)
VALUES
  -- Dienstverleners (role_id=2)
  ('Pieter de Schilder',  'Pieter',  'de Schilder', 'pieter@makandra.nl',  '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Paramaribo', 'Schilderwerk',    '10 jaar', 'Professioneel schilder met 10 jaar ervaring. Gespecialiseerd in binnen- en buitenwerk.',                    45.00, '597-8123456', 'Ma-Vr 08:00-17:00', NULL, 1, 0),
  ('Jaap Timmerman',      'Jaap',    'Timmerman',   'jaap@makandra.nl',    '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Paramaribo', 'Timmerwerk',      '15 jaar', 'Expert timmerwerk in duurzaam hout. Keukens, kasten, vloeren.',                                               50.00, '597-8234567', 'Ma-Vr 07:00-16:00', NULL, 1, 0),
  ('Sofia Schoonmaken',   'Sofia',   'Schoonmaken', 'sofia@makandra.nl',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Wanica',     'Schoonmaak',      '5 jaar',  'Grondige en betrouwbare huishoudelijke schoonmaak, ook kantoren.',                                             25.00, '597-8345678', 'Ma-Vr 09:00-17:00', NULL, 1, 0),
  -- Klant (role_id=1)
  ('Marieke Brunings',    'Marieke', 'Brunings',    'marieke@example.com', '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'klant',          1, 'Paramaribo', NULL,              NULL,      'Op zoek naar betrouwbare diensten in Suriname.',                                                               NULL,  NULL,          NULL,                NULL, 1, 0),
  -- Admin (role_id=3)
  ('Henk Admin',          'Henk',    'Admin',       'admin@makandra.nl',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'admin',          3, 'Paramaribo', NULL,              NULL,      'Platform administrator.',                                                                                      NULL,  NULL,          NULL,                NULL, 1, 1),
  -- More dienstverleners
  ('Carola Hoveniers',    'Carola',  'Hoveniers',   'carola@makandra.nl',  '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Commewijne', 'Hovenierwerk',    '8 jaar',  'Tuinaanleg en onderhoud, inclusief gazon, beplanting en irrigatie.',                                           40.00, '597-8456789', 'Di-Vr 10:00-16:00', NULL, 1, 0),
  ('Ramon Electricien',   'Ramon',   'Electricien', 'ramon@makandra.nl',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Paramaribo', 'Elektriciteit',   '12 jaar', 'Gecertificeerd elektricien. Installaties, storingen, zonnepanelen.',                                           60.00, '597-8567890', 'Ma-Za 08:00-18:00', NULL, 1, 0),
  ('Ingrid Fotograaf',    'Ingrid',  'Fotograaf',   'ingrid@makandra.nl',  '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Paramaribo', 'Fotografie',      '7 jaar',  'Professionele fotograaf voor evenementen, portretten en productfotografie.',                                    75.00, '597-8678901', 'Ma-Zo op afspraak', NULL, 1, 0),
  ('Dennis Loodgieter',   'Dennis',  'Loodgieter',  'dennis@makandra.nl',  '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Nickerie',   'Loodgieterswerk', '9 jaar',  'Leidingwerk, kraan reparaties, badkamermontage en dakgoten.',                                                  55.00, '597-8789012', 'Ma-Vr 07:30-17:00', NULL, 1, 0),
  ('Priya Coach',         'Priya',   'Coach',       'priya@makandra.nl',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Paramaribo', 'Coaching',        '6 jaar',  'Life coach en personal trainer. Individuele en groepssessies beschikbaar.',                                    80.00, '597-8890123', 'Ma-Vr 09:00-20:00', NULL, 1, 0),
  ('Kevin Bouwer',        'Kevin',   'Bouwer',      'kevin@makandra.nl',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'dienstverlener', 2, 'Wanica',     'Bouw & Constructie', '20 jaar', 'Aannemer voor kleine en middelgrote bouwprojecten. Uitbouwen, verbouwen, fundering.',                       90.00, '597-8901234', 'Ma-Za 06:00-17:00', NULL, 1, 0),
  -- Second klant for more diverse bookings
  ('Johan Klant2',        'Johan',   'Klant2',      'johan@example.com',   '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890', 'klant',          1, 'Wanica',     NULL,              NULL,      'Particulier klant.',                                                                                           NULL,  NULL,          NULL,                NULL, 1, 0);

-- ── Seed provider profiles ─────────────────────────────────────────────────────
-- user_id matches the auto-increment IDs from the users insert above (fresh DB)
INSERT IGNORE INTO provider_profiles (user_id, category, experience, hourly_rate, phone, working_hours, is_available) VALUES
  (1,  'Schilderwerk',    '10 jaar', 45.00, '597-8123456', 'Ma-Vr 08:00-17:00', 1),
  (2,  'Timmerwerk',      '15 jaar', 50.00, '597-8234567', 'Ma-Vr 07:00-16:00', 1),
  (3,  'Schoonmaak',      '5 jaar',  25.00, '597-8345678', 'Ma-Vr 09:00-17:00', 1),
  (6,  'Hovenierwerk',    '8 jaar',  40.00, '597-8456789', 'Di-Vr 10:00-16:00', 1),
  (7,  'Elektriciteit',   '12 jaar', 60.00, '597-8567890', 'Ma-Za 08:00-18:00', 1),
  (8,  'Fotografie',      '7 jaar',  75.00, '597-8678901', 'Ma-Zo op afspraak', 1),
  (9,  'Loodgieterswerk', '9 jaar',  55.00, '597-8789012', 'Ma-Vr 07:30-17:00', 1),
  (10, 'Coaching',        '6 jaar',  80.00, '597-8890123', 'Ma-Vr 09:00-20:00', 1),
  (11, 'Bouw & Constructie', '20 jaar', 90.00, '597-8901234', 'Ma-Za 06:00-17:00', 1);

-- ── Seed bookings (accepted = contributes to vertrouwenscore) ──────────────────
INSERT IGNORE INTO bookings (klant_id, dienstverlener_id, date, time, duration_minutes, message, status) VALUES
  -- Pieter (id=1): 3 accepted bookings from klant 4 and 12
  (4,  1, DATE_ADD(CURDATE(), INTERVAL -30 DAY), '10:00:00', 240, 'Schilderwerk woonkamer',       'accepted'),
  (4,  1, DATE_ADD(CURDATE(), INTERVAL -15 DAY), '09:00:00', 480, 'Schilderwerk slaapkamer',      'accepted'),
  (12, 1, DATE_ADD(CURDATE(), INTERVAL -7 DAY),  '08:00:00', 360, 'Buitengevel schilderen',       'accepted'),
  -- Jaap (id=2): 5 accepted bookings
  (4,  2, DATE_ADD(CURDATE(), INTERVAL -45 DAY), '09:00:00', 480, 'Boekenkast reparatie',         'accepted'),
  (4,  2, DATE_ADD(CURDATE(), INTERVAL -20 DAY), '08:00:00', 600, 'Nieuwe keukenkasten',          'accepted'),
  (12, 2, DATE_ADD(CURDATE(), INTERVAL -10 DAY), '07:00:00', 480, 'Vloer leggen',                 'accepted'),
  (12, 2, DATE_ADD(CURDATE(), INTERVAL -5 DAY),  '09:00:00', 240, 'Deur plaatsen',                'accepted'),
  (4,  2, DATE_ADD(CURDATE(), INTERVAL -3 DAY),  '10:00:00', 120, 'Reparatie trap',               'accepted'),
  -- Kevin (id=11): 8 accepted bookings (highest score)
  (4,  11, DATE_ADD(CURDATE(), INTERVAL -60 DAY), '06:00:00', 480, 'Fundering leggen',            'accepted'),
  (12, 11, DATE_ADD(CURDATE(), INTERVAL -50 DAY), '07:00:00', 600, 'Uitbouw bijkeuken',           'accepted'),
  (4,  11, DATE_ADD(CURDATE(), INTERVAL -40 DAY), '06:00:00', 480, 'Muren metselen',              'accepted'),
  (12, 11, DATE_ADD(CURDATE(), INTERVAL -30 DAY), '08:00:00', 360, 'Dak reparatie',               'accepted'),
  (4,  11, DATE_ADD(CURDATE(), INTERVAL -20 DAY), '06:00:00', 480, 'Badkamer renovatie',          'accepted'),
  (12, 11, DATE_ADD(CURDATE(), INTERVAL -10 DAY), '07:00:00', 600, 'Garage verbouwing',           'accepted'),
  (4,  11, DATE_ADD(CURDATE(), INTERVAL -5 DAY),  '06:00:00', 480, 'Tuinmuur bouwen',             'accepted'),
  (12, 11, DATE_ADD(CURDATE(), INTERVAL -2 DAY),  '08:00:00', 240, 'Carport fundament',           'accepted'),
  -- Ramon (id=7): 6 accepted bookings
  (4,  7, DATE_ADD(CURDATE(), INTERVAL -35 DAY),  '08:00:00', 240, 'Stopcontacten plaatsen',      'accepted'),
  (12, 7, DATE_ADD(CURDATE(), INTERVAL -25 DAY),  '09:00:00', 480, 'Zonnepanelen installatie',    'accepted'),
  (4,  7, DATE_ADD(CURDATE(), INTERVAL -18 DAY),  '08:00:00', 120, 'Groepenkast vervangen',       'accepted'),
  (12, 7, DATE_ADD(CURDATE(), INTERVAL -12 DAY),  '08:00:00', 240, 'Verlichting renovatie',       'accepted'),
  (4,  7, DATE_ADD(CURDATE(), INTERVAL -6 DAY),   '09:00:00', 120, 'Storing oplossen',            'accepted'),
  (12, 7, DATE_ADD(CURDATE(), INTERVAL -1 DAY),   '08:00:00', 360, 'Airco aansluiting',           'accepted'),
  -- Sofia (id=3): 2 accepted bookings
  (4,  3, DATE_ADD(CURDATE(), INTERVAL -14 DAY),  '14:00:00', 120, 'Huisschoonmaak',              'accepted'),
  (12, 3, DATE_ADD(CURDATE(), INTERVAL -7 DAY),   '10:00:00', 180, 'Kantoor schoonmaak',          'accepted'),
  -- Pending bookings (do NOT count toward score)
  (4,  6, DATE_ADD(CURDATE(), INTERVAL 7 DAY),    '10:00:00', 120, 'Tuin onderhoud',              'pending'),
  (4,  8, DATE_ADD(CURDATE(), INTERVAL 3 DAY),    '14:00:00', 120, 'Familiefoto shoot',           'pending');

-- ── Seed reviews ───────────────────────────────────────────────────────────────
INSERT IGNORE INTO reviews (reviewer_id, provider_id, score, text) VALUES
  (4,  1,  88, 'Uitstekend werk! Pieter is professioneel en zorgvuldig. Zou hem zeker aanbevelen.'),
  (12, 1,  92, 'Schilderwerk perfect afgewerkt. Op tijd en nette werkplek achtergelaten.'),
  (4,  2,  85, 'Goed timmerwerk. Project is op tijd afgerond en netjes uitgevoerd.'),
  (12, 2,  90, 'Jaap heeft onze keuken fantastisch verbouwd. Heel tevreden!'),
  (4,  2,  78, 'Prettige samenwerking, eerlijk in zijn prijzen.'),
  (4,  11, 96, 'Kevin is een echte vakman. Uitbouw perfect gebouwd, geen enkele klacht.'),
  (12, 11, 98, 'Beste aannemer van Suriname. Al het werk van hoge kwaliteit.'),
  (4,  11, 94, 'Snel, betrouwbaar en eerlijk geprijsd. Absoluut aanbevolen!'),
  (12, 11, 91, 'Renovatie badkamer is prachtig geworden. Zeker 5 sterren waard.'),
  (4,  7,  87, 'Ramon heeft onze zonnepanelen vakkundig geïnstalleerd.'),
  (12, 7,  83, 'Snelle service en goede uitleg. Groepenkast nu volledig vernieuwd.'),
  (4,  7,  89, 'Altijd bereikbaar en eerlijk advies. Echte professional.'),
  (4,  3,  80, 'Sofia is grondig en betrouwbaar. Huis was spic en span.'),
  (12, 3,  75, 'Goed werk geleverd voor een eerlijke prijs.');

-- ── Seed notifications ─────────────────────────────────────────────────────────
INSERT IGNORE INTO notifications (user_id, message, is_read) VALUES
  (1,  'Nieuwe boeking aanvraag van Marieke',         0),
  (2,  'Je boeking is geaccepteerd door Jaap!',       1),
  (4,  'Je review is geplaatst bij Pieter.',           1),
  (11, 'Nieuwe boeking aanvraag voor fundament.',     0);

-- ── Seed jobs ──────────────────────────────────────────────────────────────────
INSERT IGNORE INTO jobs (klant_id, title, description, category, district, budget, status) VALUES
  (4,  'Badkamer renovatie',  'Zoek professionele hulp bij badkamer renovatie. Budget SRD 5000.', 'Loodgieterswerk', 'Paramaribo', 'SRD 5000', 'open'),
  (4,  'Huis schilderen',     'Voor- en achtergevel + 3 kamers binnenshuis schilderen.',          'Schilderwerk',    'Paramaribo', 'SRD 2500', 'open'),
  (12, 'Tuin aanleggen',      'Nieuw aanleggen tuin met gazon, beplanting en verlichteing.',      'Hovenierwerk',    'Wanica',     'SRD 3000', 'open');

-- ── Verify data ────────────────────────────────────────────────────────────────
SELECT 'Roles:'            AS section, COUNT(*) AS count FROM roles
UNION ALL
SELECT 'Users:',                        COUNT(*) FROM users
UNION ALL
SELECT 'Provider Profiles:',            COUNT(*) FROM provider_profiles
UNION ALL
SELECT 'Bookings (accepted):',          COUNT(*) FROM bookings WHERE status = 'accepted'
UNION ALL
SELECT 'Reviews:',                      COUNT(*) FROM reviews
UNION ALL
SELECT 'Notifications:',                COUNT(*) FROM notifications
UNION ALL
SELECT 'Jobs:',                         COUNT(*) FROM jobs;
