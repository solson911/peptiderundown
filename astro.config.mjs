// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import sitemap from '@astrojs/sitemap';
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

// Build a map of article/news slug -> date from frontmatter at config load time
function buildDateMap() {
  const dateMap = {};
  const dirs = [
    { dir: 'src/pages/articles', prefix: '/articles/' },
    { dir: 'src/pages/news', prefix: '/news/' },
  ];
  for (const { dir, prefix } of dirs) {
    let files;
    try { files = readdirSync(dir); } catch { continue; }
    for (const file of files) {
      if (file === 'index.astro') continue;
      const content = readFileSync(join(dir, file), 'utf-8');
      const match = content.match(/date:\s*["']?(\d{4}-\d{2}-\d{2})["']?/);
      if (match) {
        const slug = file.replace(/\.(astro|md|mdx)$/, '');
        const url = `https://peptiderundown.com${prefix}${slug}/`;
        dateMap[url] = match[1];
      }
    }
  }
  return dateMap;
}
const dateMap = buildDateMap();

export default defineConfig({
  site: 'https://peptiderundown.com',
  trailingSlash: 'always',
  integrations: [
    sitemap({
      customPages: [],
      i18n: {
        defaultLocale: 'en',
        locales: {
          en: 'en-US',
        },
      },
      serialize(item) {
        if (item.url === 'https://peptiderundown.com/') {
          item.priority = 1.0;
          item.changefreq = 'daily';
        } else if (item.url.includes('/articles/') && !item.url.endsWith('/articles/')) {
          item.priority = 0.8;
          item.changefreq = 'weekly';
        } else if (item.url.includes('/articles/')) {
          item.priority = 0.9;
          item.changefreq = 'daily';
        } else if (item.url.includes('/news/')) {
          item.priority = 0.7;
          item.changefreq = 'monthly';
        } else {
          item.priority = 0.5;
          item.changefreq = 'monthly';
        }

        // Use actual article/news date if available, otherwise today
        item.lastmod = dateMap[item.url] || new Date().toISOString().split('T')[0];

        return item;
      },
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
    build: {
      rollupOptions: {
        external: ['/pagefind/pagefind.js']
      }
    }
  },
  markdown: {
    shikiConfig: {
      theme: 'github-light'
    }
  }
});
