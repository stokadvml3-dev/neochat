CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(20) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(10) NOT NULL DEFAULT 'user',
  banned BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS messages (
  id SERIAL PRIMARY KEY,
  sender_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  receiver_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  read_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS captchas (
  id VARCHAR(32) PRIMARY KEY,
  answer TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_messages_conv ON messages (sender_id, receiver_id, created_at);
CREATE INDEX IF NOT EXISTS idx_captchas_expires ON captchas (expires_at);

INSERT INTO users (username, password_hash, role, banned)
VALUES ('admin', '$2a$12$0LtU2HmUYlLvHIY1OBLUBuRqW9qkuzdLd6RFkhi5pFvWLC5q2nLcG', 'admin', false)
ON CONFLICT (username) DO NOTHING;
