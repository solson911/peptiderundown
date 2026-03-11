import rss from '@astrojs/rss';
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

function getArticles() {
  const articles = [];
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

      const titleMatch = content.match(/title:\s*["']([^"']+)["']/);
      const descMatch = content.match(/description:\s*["']([^"']+)["']/);
      const dateMatch = content.match(/date:\s*["']?(\d{4}-\d{2}-\d{2})["']?/);

      if (titleMatch && dateMatch) {
        const slug = file.replace(/\.(astro|md|mdx)$/, '');
        articles.push({
          title: titleMatch[1],
          description: descMatch ? descMatch[1] : '',
          link: `${prefix}${slug}/`,
          pubDate: new Date(dateMatch[1]),
        });
      }
    }
  }

  return articles.sort((a, b) => b.pubDate.getTime() - a.pubDate.getTime());
}

export function GET(context) {
  return rss({
    title: 'PeptideRundown',
    description: 'Independent, science-based peptide education. Every article is cited with peer-reviewed research.',
    site: context.site,
    items: getArticles(),
    customData: '<language>en-us</language>',
  });
}
