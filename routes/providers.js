import express from 'express';
import { db } from '../config/db.js';
import { verifyTokenOptional } from '../middlewares/auth.js';

const router = express.Router();

// GET platform stats
router.get('/stats', verifyTokenOptional, async (req, res) => {
  try {
    const [[{ dv_count }]]       = await db.query("SELECT COUNT(*) AS dv_count FROM users WHERE role = 'dienstverlener'");
    const [[{ voltooid_count }]] = await db.query("SELECT COUNT(*) AS voltooid_count FROM bookings WHERE status IN ('accepted','completed')");
    res.json({ dv_count, voltooid_count });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET categories with provider + booking counts
router.get('/categories', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT u.category,
              COUNT(DISTINCT u.id)  AS provider_count,
              COUNT(DISTINCT b.id)  AS booking_count,
              COUNT(DISTINCT j.id)  AS job_count
       FROM users u
       LEFT JOIN bookings b ON b.dienstverlener_id = u.id
       LEFT JOIN jobs j ON j.category = u.category AND j.status = 'open'
       WHERE u.role = 'dienstverlener' AND u.category IS NOT NULL AND u.category != ''
       GROUP BY u.category
       ORDER BY booking_count DESC`
    );
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET dienstverleners (optional district filter)
router.get('/dienstverleners', async (req, res) => {
  try {
    const { district } = req.query;
    let query = `
      SELECT u.id, u.name, u.first_name, u.last_name,
             u.email, u.category, u.experience, u.bio, u.hourly_rate, u.district,
             u.profile_picture, u.phone, u.working_hours, u.is_available,
             ROUND(AVG(r.score), 1)      AS avg_score,
             COUNT(DISTINCT r.id)        AS review_count,
             COALESCE((
               SELECT COUNT(DISTINCT b.klant_id)
               FROM bookings b
               WHERE b.dienstverlener_id = u.id AND b.status IN ('accepted','completed')
             ), 0)                       AS total_clients,
             CASE
               WHEN COUNT(DISTINCT r.id) = 0 THEN 0
               ELSE LEAST(100, ROUND(
                 ROUND(AVG(r.score)) * 0.8 +
                 LEAST(20, COALESCE((
                   SELECT COUNT(DISTINCT b2.klant_id)
                   FROM bookings b2
                   WHERE b2.dienstverlener_id = u.id AND b2.status IN ('accepted','completed')
                 ), 0))
               ))
             END                         AS vertrouwenscore
      FROM users u
      LEFT JOIN reviews r ON r.provider_id = u.id
      WHERE u.role = ?`;
    const params = ['dienstverlener'];
    if (district) { query += ' AND u.district = ?'; params.push(district); }
    query += ' GROUP BY u.id ORDER BY vertrouwenscore DESC, review_count DESC, u.id ASC';
    const [rows] = await db.query(query, params);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

export default router;
