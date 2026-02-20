// Compatibility sitemap endpoint.
// Many tools (and bots) look for /sitemap.xml by default.
// Since this site is built as static output, we emit a real XML sitemap index here
// (not a redirect) so Google Search Console can read it reliably.
export async function GET() {
  const xml = `<?xml version="1.0" encoding="UTF-8"?>` +
`<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">` +
`<sitemap><loc>https://peptiderundown.com/sitemap-0.xml</loc></sitemap>` +
`</sitemapindex>`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml',
      'Cache-Control': 'public, max-age=3600'
    }
  });
}
