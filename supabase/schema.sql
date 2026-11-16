-- Dream Board 2026–27: private by default, with optional public read-only sharing.
create table if not exists public.boards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  month_key text not null,
  title text not null,
  theme jsonb not null default '{}'::jsonb,
  content jsonb not null default '{"items":[]}'::jsonb,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, month_key)
);
alter table public.boards enable row level security;
create policy "Owners can read their boards" on public.boards for select to authenticated using ((select auth.uid()) = user_id);
create policy "Anyone can read explicitly shared boards" on public.boards for select to anon, authenticated using (is_public = true);
create policy "Owners can create boards" on public.boards for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Owners can update their boards" on public.boards for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Owners can delete their boards" on public.boards for delete to authenticated using ((select auth.uid()) = user_id);
create index if not exists boards_user_month_idx on public.boards(user_id, month_key);
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('dream-board-images','dream-board-images',false,10485760,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do nothing;
create policy "Users can view own dream board images" on storage.objects for select to authenticated using (bucket_id='dream-board-images' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "Users can upload own dream board images" on storage.objects for insert to authenticated with check (bucket_id='dream-board-images' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "Users can update own dream board images" on storage.objects for update to authenticated using (bucket_id='dream-board-images' and (storage.foldername(name))[1]=(select auth.uid())::text) with check (bucket_id='dream-board-images' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "Users can delete own dream board images" on storage.objects for delete to authenticated using (bucket_id='dream-board-images' and (storage.foldername(name))[1]=(select auth.uid())::text);