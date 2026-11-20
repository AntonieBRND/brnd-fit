// Maakt index.html uit src/app.html.
// Gebruik: node tools/build.mjs
import { readFileSync, writeFileSync } from 'node:fs';
const root = new URL('../', import.meta.url);
const src = readFileSync(new URL('src/app.html', root), 'utf8');
const head = '<!doctype html>\n<html lang="nl"><head><meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">\n<meta name="theme-color" content="#05070c">\n<meta name="apple-mobile-web-app-capable" content="yes">\n<meta name="mobile-web-app-capable" content="yes">\n<meta name="apple-mobile-web-app-title" content="BRND FIT">\n<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">\n<link rel="preload" as="image" href="icons/brnd-fit-logo.png">\n<link rel="manifest" href="manifest.webmanifest">\n<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">\n<script src="https://cdn.jsdelivr.net/npm/gsap@3.13.0/dist/gsap.min.js"></script>\n<script src="config.js"></script>\n<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.118.0/dist/umd/supabase.min.js"></script>\n<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>\n</head><body>\n';
writeFileSync(new URL('index.html', root), head + src + '\n</body></html>\n');
console.log('index.html gebouwd');
