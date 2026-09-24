-- 每周工作评价：Supabase 数据库结构
create table if not exists public.weekly_reviews (
  id uuid primary key default gen_random_uuid(),
  reviewer_name text not null check (reviewer_name in ('高泽雄','林少雄','蔡灿嵘','吴世友','陈炳煌')),
  week_start date not null,
  person_name text not null check (person_name in ('谈超','林耀威','张鑫达','林智杰','林国延','冯昱','陈奕明','王锦锋')),
  score smallint not null check (score between 1 and 5),
  comment text not null default '' check (char_length(comment) <= 500),
  updated_at timestamptz not null default now(),
  unique (reviewer_name, week_start, person_name)
);

alter table public.weekly_reviews enable row level security;

drop policy if exists "reviewers can read reviews" on public.weekly_reviews;
create policy "reviewers can read reviews"
on public.weekly_reviews for select to anon, authenticated using (true);

drop policy if exists "reviewers can insert own reviews" on public.weekly_reviews;
create policy "reviewers can insert own reviews"
on public.weekly_reviews for insert to anon, authenticated
with check (reviewer_name = current_setting('request.jwt.claims', true)::json->>'name');

drop policy if exists "reviewers can update own reviews" on public.weekly_reviews;
create policy "reviewers can update own reviews"
on public.weekly_reviews for update to anon, authenticated
using (reviewer_name = current_setting('request.jwt.claims', true)::json->>'name')
with check (reviewer_name = current_setting('request.jwt.claims', true)::json->>'name');
