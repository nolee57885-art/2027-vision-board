# Dream Board 2026–27

A private-by-default monthly vision board scrapbook for December 2026 through December 2027.

## Stack
React + Vite, Supabase Auth, Postgres with row-level security, and private Supabase Storage.

## Setup
1. Create a Supabase project.
2. Run `supabase/schema.sql` in the Supabase SQL Editor.
3. Copy `.env.example` to `.env.local` and fill in the project URL and publishable key.
4. Run `npm install`, then `npm run dev`.

Never put a Supabase service-role/secret key in frontend environment variables.

## Sharing
Boards are private by default. Turning on "Share board" makes that individual board publicly readable. Do not add sensitive personal information to a shared board. Image uploads remain in private storage.

## Build
`npm run build`