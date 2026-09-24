-- 每周工作评价：Supabase 数据结构与权限
create table if not exists public.weekly_reviews (
  id uuid primary key default gen_random_uuid(),
  reviewer_id uuid references auth.users(id) not null default auth.uid(),
  reviewer_name text not null check (reviewer_name in ('高泽雄','林少雄','蔡灿嵘','吴世友','陈炳煌')),
  week_start date not null,
  person_name text not null check (person_name in ('谈超','林耀威','张鑫达','林智杰','林国延','冯昱','陈奕明','王锦锋')),
  score smallint not null check (score between 1 and 5),
  comment text not null default '' check (char_length(comment) <= 500),
  updated_at timestamptz not null default now(),
  unique (reviewer_name, week_start, person_name)
);

alter table public.weekly_reviews add column if not exists reviewer_id uuid references auth.users(id);
update public.weekly_reviews set reviewer_id = auth.uid() where reviewer_id is null;
alter table public.weekly_reviews alter column reviewer_id set default auth.uid();
alter table public.weekly_reviews enable row level security;

drop policy if exists "reviewers can read reviews" on public.weekly_reviews;
create policy "reviewers can read reviews" on public.weekly_reviews for select to authenticated using (true);

drop policy if exists "reviewers can insert own reviews" on public.weekly_reviews;
create policy "reviewers can insert own reviews" on public.weekly_reviews for insert to authenticated
with check (reviewer_id = auth.uid());

drop policy if exists "reviewers can update own reviews" on public.weekly_reviews;
create policy "reviewers can update own reviews" on public.weekly_reviews for update to authenticated
using (reviewer_id = auth.uid()) with check (reviewer_id = auth.uid());

-- 如果你的表已存在但缺少 reviewer_id，不需要执行 reviewer_id 版本；当前网页兼容原表结构。
-- 若希望之后按 auth.uid() 精细限制写入，可单独执行：
-- alter table public.weekly_reviews add column reviewer_id uuid references auth.users(id);


create table if not exists public.review_people (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

insert into public.review_people (name, sort_order) values
('谈超',1),('林耀威',2),('张鑫达',3),('林智杰',4),('林国延',5),('冯昱',6),('陈奕明',7),('王锦锋',8)
on conflict (name) do nothing;

alter table public.review_people enable row level security;
drop policy if exists "reviewers can read people" on public.review_people;
create policy "reviewers can read people" on public.review_people for select to authenticated using (true);
drop policy if exists "reviewers can manage people" on public.review_people;
create policy "reviewers can manage people" on public.review_people for all to authenticated using (true) with check (true);
