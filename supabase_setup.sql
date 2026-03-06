-- =============================================
-- MyCoach3.0 — Supabase Database Setup
-- Run this in: Supabase > SQL Editor > New query
-- =============================================

-- 1. USERS TABLE
create table if not exists public.mc3_users (
  id uuid default gen_random_uuid() primary key,
  email text unique not null,
  name text not null,
  password_hash text,                          -- simple hash (no auth system)
  plan text default 'trial',
  trial_start timestamptz default now(),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. QUIZ ANSWERS TABLE
create table if not exists public.mc3_answers (
  id uuid default gen_random_uuid() primary key,
  user_email text not null references public.mc3_users(email) on delete cascade,
  goal text,
  level text,
  gender text,
  location text,
  frequency integer,
  weight numeric,
  height numeric,
  age integer,
  target_weight numeric,
  updated_at timestamptz default now()
);

-- 3. Enable Row Level Security (RLS) — open read/write for anon key (frontend-only app)
alter table public.mc3_users enable row level security;
alter table public.mc3_answers enable row level security;

-- Allow anon to do everything (since we have no auth system, app manages access)
create policy "allow_all_users" on public.mc3_users for all using (true) with check (true);
create policy "allow_all_answers" on public.mc3_answers for all using (true) with check (true);

-- 4. Index for fast email lookups
create index if not exists mc3_users_email_idx on public.mc3_users(email);
create index if not exists mc3_answers_email_idx on public.mc3_answers(user_email);

-- Done! Tables ready.
