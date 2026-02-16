// Image sitemap for better image SEO
export async function GET() {
  // Get all article files to extract image data
  const articles = import.meta.glob('../content/articles/*.md');
  const imageEntries = [];

  for (const path in articles) {
    const article = await articles[path]();
    const slug = path.split('/').pop().replace('.md', '');
    
    if (article.frontmatter?.image) {
      imageEntries.push({
        loc: `https://peptiderundown.com/articles/${slug}/`,
        image: `https://peptiderundown.com${article.frontmatter.image}`,
        title: article.frontmatter.title,
        caption: article.frontmatter.description
      });
    }
  }

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
${imageEntries.map(entry => `  <url>
    <loc>${entry.loc}</loc>
    <image:image>
      <image:loc>${entry.image}</image:loc>
      <image:title>${entry.title}</image:title>
      <image:caption>${entry.caption}</image:caption>
    </image:image>
  </url>`).join('\n')}
</urlset>`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml'
    }
  });
}