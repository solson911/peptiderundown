// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://peptiderundown.com',
  integrations: [
    sitemap({
      customPages: [],
      i18n: {
        defaultLocale: 'en',
        locales: {
          en: 'en-US',
        },
      },
      // SEO optimization: add lastmod, changefreq, priority
      serialize(item) {
        // Set priority based on content type
        if (item.url === 'https://peptiderundown.com/') {
          item.priority = 1.0;
          item.changefreq = 'daily';
        } else if (item.url.includes('/articles/') && !item.url.endsWith('/articles/')) {
          // Individual articles - high priority
          item.priority = 0.8;
          item.changefreq = 'weekly';
        } else if (item.url.includes('/articles/')) {
          // Articles index page
          item.priority = 0.9; 
          item.changefreq = 'daily';
        } else if (item.url.includes('/news/')) {
          // News content - time sensitive
          item.priority = 0.7;
          item.changefreq = 'monthly';
        } else {
          // Other pages
          item.priority = 0.5;
          item.changefreq = 'monthly';
        }
        
        // Add last modified date (use current date for now, can be improved with actual dates)
        item.lastmod = new Date().toISOString().split('T')[0];
        
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
