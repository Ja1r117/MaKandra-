# Cerebrum

> OpenWolf's learning memory. Updated automatically as the AI learns from interactions.
> Do not edit manually unless correcting an error.
> Last updated: 2026-05-14

## User Preferences

<!-- How the user likes things done. Code style, tools, patterns, communication. -->

## Key Learnings

- **Project:** MaKandra-
- **Description:** In deze repository wordt alle code upload die hoort bij dit project. Suriname service-marketplace (klant / dienstverlener roles). Dutch UI.
- **Architecture:** Single HTML page (`index.html` + `script.js`) + Express backend (`backend/server.js`). No bundler — plain ES modules via `<script type="module">`.
- **DB init pattern:** server.js runs all `CREATE TABLE IF NOT EXISTS` + `ALTER TABLE ADD COLUMN` statements inside an IIFE before `app.listen()`. All new tables must be added there.
- **Auth buttons pattern:** All modal form buttons use `onclick=` HTML attributes, not addEventListener. The DOMContentLoaded block only adds listeners for overlay/tab switches.
- **Error display pattern in forms:** Error divs start as `class="form-error hidden"`. To show: remove 'hidden' + set textContent. To hide: add 'hidden'. Both steps are required.

## Do-Not-Repeat

<!-- Mistakes made and corrected. Each entry prevents the same mistake recurring. -->
<!-- Format: [YYYY-MM-DD] Description of what went wrong and what to do instead. -->

[2026-05-24] **Double event handlers on auth buttons.** All three form buttons (`handleLogin`, `handleSignup`, `handleProviderSignup`) already have `onclick=` in index.html. Do NOT add `addEventListener('click', ...)` for the same buttons in script.js — doing so fires the handler twice per click, causing double API calls and ER_DUP_ENTRY on signup.

[2026-05-24] **DB init block must include ALL tables the server queries.** `bookings`, `reviews`, and `notifications` were queried throughout server.js but never created in the init block. Always add `CREATE TABLE IF NOT EXISTS` for every table referenced in any route, before the server starts listening.

[2026-05-24] **`errEl.classList.remove('hidden')` must be called before showing form errors.** If an error div starts with `class="form-error hidden"`, setting only `errEl.textContent` leaves it invisible. Always remove the 'hidden' class when displaying an error, and add it back on success.

[2026-05-24] **Multer upload destination directory must be created programmatically.** If `backend/uploads/` doesn't exist, Multer throws ENOENT. Use `fs.mkdirSync(uploadsDir, { recursive: true })` at server startup — never assume the directory already exists.

## Decision Log

<!-- Significant technical decisions with rationale. Why X was chosen over Y. -->
