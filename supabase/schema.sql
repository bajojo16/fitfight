-- FitFight schema
-- Run in Supabase SQL editor (Dashboard → SQL Editor)

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── PROFILES ────────────────────────────────────────────────────────────────
create table profiles (
  id           uuid references auth.users on delete cascade primary key,
  username     text unique,
  weight_kg    numeric(5,2),
  weight_class text,                          -- flyweight, featherweight, etc.
  goal         text check (goal in ('cut','maintain','bulk')),
  focus        text[] default '{"fitness","diet","boxing"}',
  created_at   timestamptz default now()
);

alter table profiles enable row level security;
create policy "Users manage own profile"
  on profiles for all using (auth.uid() = id);

-- Auto-create profile on signup
create function handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into profiles (id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- ─── FITNESS MODULE ───────────────────────────────────────────────────────────
create table workout_sessions (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid references profiles(id) on delete cascade not null,
  date       date not null,
  type       text check (type in ('strength','cardio','mixed')) not null,
  duration_min int,
  notes      text,
  effort     int check (effort between 1 and 5),
  created_at timestamptz default now()
);

create table workout_exercises (
  id                 uuid primary key default uuid_generate_v4(),
  session_id         uuid references workout_sessions(id) on delete cascade not null,
  name               text not null,
  sets               int,
  reps               int,
  weight_kg          numeric(5,2),
  duration_sec       int,   -- for cardio exercises
  distance_km        numeric(6,3)
);

alter table workout_sessions enable row level security;
alter table workout_exercises enable row level security;

create policy "Users manage own workout sessions"
  on workout_sessions for all using (auth.uid() = user_id);
create policy "Users manage own workout exercises"
  on workout_exercises for all
  using (exists (
    select 1 from workout_sessions s
    where s.id = session_id and s.user_id = auth.uid()
  ));

-- ─── DIET MODULE ──────────────────────────────────────────────────────────────
create table daily_weights (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid references profiles(id) on delete cascade not null,
  date       date not null,
  weight_kg  numeric(5,2) not null,
  created_at timestamptz default now(),
  unique(user_id, date)
);

create table meals (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid references profiles(id) on delete cascade not null,
  date         date not null,
  name         text not null,              -- "Déjeuner", "Post-training", etc.
  calories     int,
  protein_g    numeric(6,1),
  carbs_g      numeric(6,1),
  fat_g        numeric(6,1),
  notes        text,
  created_at   timestamptz default now()
);

create table meal_items (
  id          uuid primary key default uuid_generate_v4(),
  meal_id     uuid references meals(id) on delete cascade not null,
  food_name   text not null,
  quantity_g  numeric(7,1),
  calories    int,
  protein_g   numeric(6,1),
  carbs_g     numeric(6,1),
  fat_g       numeric(6,1)
);

alter table daily_weights enable row level security;
alter table meals          enable row level security;
alter table meal_items     enable row level security;

create policy "Users manage own weights" on daily_weights for all using (auth.uid() = user_id);
create policy "Users manage own meals"   on meals         for all using (auth.uid() = user_id);
create policy "Users manage own meal items" on meal_items for all
  using (exists (select 1 from meals m where m.id = meal_id and m.user_id = auth.uid()));

-- ─── BOXING MODULE ────────────────────────────────────────────────────────────
create table boxing_sessions (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid references profiles(id) on delete cascade not null,
  date         date not null,
  type         text check (type in ('bag','sparring','padwork','shadow','other')) not null,
  rounds       int not null,
  round_min    int default 3,
  rest_min     int default 1,
  combos       text[],                    -- combinations drilled
  sparring_partner text,
  effort       int check (effort between 1 and 5),
  technical    int check (technical between 1 and 5),
  notes        text,
  created_at   timestamptz default now()
);

alter table boxing_sessions enable row level security;
create policy "Users manage own boxing sessions"
  on boxing_sessions for all using (auth.uid() = user_id);

-- ─── INDEXES ──────────────────────────────────────────────────────────────────
create index on workout_sessions (user_id, date desc);
create index on meals            (user_id, date desc);
create index on boxing_sessions  (user_id, date desc);
create index on daily_weights    (user_id, date desc);
