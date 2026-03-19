// Foundation Capstone — API service starter code
// Your job: write the Dockerfile and wire this into compose.yml
// You do NOT need to modify this file

const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

// In-memory fallback when DATABASE_URL is not set
const memoryItems = [{ id: 1, name: 'sample-item' }];

// PostgreSQL connection pool — only active when DATABASE_URL is set
const pool = process.env.DATABASE_URL
  ? new Pool({ connectionString: process.env.DATABASE_URL })
  : null;

// Initialize the database table if using PostgreSQL
async function initDb() {
  if (!pool) return;
  await pool.query(`
    CREATE TABLE IF NOT EXISTS items (
      id   SERIAL PRIMARY KEY,
      name TEXT NOT NULL
    )
  `);
  const count = await pool.query('SELECT COUNT(*) FROM items');
  if (count.rows[0].count === '0') {
    await pool.query("INSERT INTO items (name) VALUES ('sample-item')");
  }
}

app.get('/health', (_req, res) => {
  res.json({ status: 'healthy' });
});

app.get('/api/items', async (_req, res) => {
  if (pool) {
    const result = await pool.query('SELECT * FROM items ORDER BY id');
    return res.json(result.rows);
  }
  res.json(memoryItems);
});

app.post('/api/items', async (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'name is required' });
  if (pool) {
    const result = await pool.query(
      'INSERT INTO items (name) VALUES ($1) RETURNING *',
      [name]
    );
    return res.status(201).json(result.rows[0]);
  }
  const item = { id: memoryItems.length + 1, name };
  memoryItems.push(item);
  res.status(201).json(item);
});

initDb()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`API listening on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Failed to initialize:', err.message);
    process.exit(1);
  });
