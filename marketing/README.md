# Envelope — Marketing Site

Astro 5 + Tailwind v4 + MDX. Static site, deployed to Vercel.

## Develop

```bash
npm install
npm run dev          # http://localhost:4321
npm run build        # static output to dist/
npm run preview      # serve built site
```

## Structure

- `src/pages/` — file-based routes (`index`, `pricing`, `privacy`, `terms`, `blog/`)
- `src/components/` — shared Astro components
- `src/layouts/Layout.astro` — base HTML, meta, nav, footer
- `src/content/blog/` — MDX blog posts (schema in `src/content.config.ts`)
- `src/styles/global.css` — Tailwind import + brand tokens
- `public/` — static assets served at root

## Waitlist (Supabase)

The hero + bottom CTA forms POST to a Supabase `waitlist` table via the REST API.

1. Apply migration `supabase/migrations/00035_create_waitlist.sql` to the project.
2. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
3. Fill in:
   - `PUBLIC_SUPABASE_URL` — project URL from Supabase dashboard
   - `PUBLIC_SUPABASE_ANON_KEY` — anon/public API key
4. Set the same env vars in Vercel project settings for production.

RLS allows anonymous inserts only. Reads/updates/deletes require `service_role`.

## Deploy

Vercel auto-detects Astro. Set **Root Directory** to `marketing` in project settings. Push to deploy.
