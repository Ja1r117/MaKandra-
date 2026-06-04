import express from 'express';
import cors from 'cors';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import 'dotenv/config';

import { db } from './config/db.js';
import { runDbInit }    from './utils/dbInit.js';
import { notFound }     from './middlewares/notFound.js';
import { errorHandler } from './middlewares/errorHandler.js';

import authRoutes          from './routes/auth.js';
import userRoutes          from './routes/users.js';
import providerRoutes      from './routes/providers.js';
import bookingRoutes       from './routes/bookings.js';
import messageRoutes       from './routes/messages.js';
import notificationRoutes  from './routes/notifications.js';
import reviewRoutes        from './routes/reviews.js';
import uploadRoutes        from './routes/upload.js';
import adminRoutes         from './routes/admin.js';
import jobRoutes           from './routes/jobs.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// ── Ensure public/img directory exists ────────────────────────────────────────
const publicImgDir = path.join(__dirname, 'public', 'img');
if (!fs.existsSync(publicImgDir)) {
  fs.mkdirSync(publicImgDir, { recursive: true });
  console.log('Created public/img directory:', publicImgDir);
}

// ── App setup ─────────────────────────────────────────────────────────────────
const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// ── Root redirect → SPA ───────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'html', 'index.html'));
});

app.get('/html/index.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'html', 'index.html'));
});

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/',       authRoutes);
app.use('/',       userRoutes);
app.use('/',       providerRoutes);
app.use('/',       bookingRoutes);
app.use('/',       messageRoutes);
app.use('/',       notificationRoutes);
app.use('/',       reviewRoutes);
app.use('/',       uploadRoutes);
app.use('/admin',  adminRoutes);
app.use('/',       jobRoutes);

// ── Error handlers (must be last) ────────────────────────────────────────────
app.use(notFound);
app.use(errorHandler);

// ── DB INIT — runs fully before server starts ─────────────────────────────────
(async () => {
  try {
    await runDbInit();
    console.log('DB init complete — server starting.');
  } catch (e) {
    console.error('DB init error:', e.message);
  }

  app.listen(3000, () => console.log('Server running on http://localhost:3000'));
})();
