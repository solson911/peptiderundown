// Image sitemap for better image SEO
// NOTE: We no longer use src/content collections. Articles live in src/pages/articles/
// and hero images live in public/images/articles/. This generator uses the image
// filenames as the source of truth and maps them to /articles/<slug>/.

import fs from 'node:fs';
import path from 'node:path';

export async function GET() {
  const ROOT = process.cwd();
  const IMAGES_DIR = path.join(ROOT, 'public', 'images', 'articles');
  const ARTICLES_DIR = path.join(ROOT, 'src', 'pages', 'articles');

  let files = [];
  try {
    files = fs.readdirSync(IMAGES_DIR);
  } catch {
    files = [];
  }

  const imageEntries = [];

  for (const file of files) {
    // Skip non-image files
    if (!file.match(/\.(png|jpe?g|webp|gif)$/i)) continue;

    const slug = file.replace(/\.(png|jpe?g|webp|gif)$/i, '');

    // Only include images that correspond to a real article page
    const md = path.join(ARTICLES_DIR, `${slug}.md`);
    const astro = path.join(ARTICLES_DIR, `${slug}.astro`);
    if (!fs.existsSync(md) && !fs.existsSync(astro)) continue;

    imageEntries.push({
      loc: `https://peptiderundown.com/articles/${slug}/`,
      image: `https://peptiderundown.com/images/articles/${file}`
    });
  }

  // Stable output ordering
  imageEntries.sort((a, b) => a.loc.localeCompare(b.loc));

  const xml = `<?xml version="1.0" encoding="UTF-8"?>\n` +
`<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"\n` +
`        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">\n` +
imageEntries.map(entry =>
`  <url>\n` +
`    <loc>${entry.loc}</loc>\n` +
`    <image:image>\n` +
`      <image:loc>${entry.image}</image:loc>\n` +
`    </image:image>\n` +
`  </url>`
).join('\n') +
`\n</urlset>\n`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml',
      'Cache-Control': 'public, max-age=3600'
    }
  });
}