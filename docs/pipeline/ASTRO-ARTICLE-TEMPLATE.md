# Astro Article Template (High-Quality Standard)

All new PeptideRundown articles MUST be created as `.astro` files using this template. Do NOT create `.md` files for new articles. The `.astro` format enables the custom CSS design system that defines the site's professional quality standard.

**Reference articles to study before writing:**
- `peptides-vs-sarms-vs-steroids.astro` (comparison format)
- `bpc-157-complete-guide.astro` (compound guide format)
- `semax-complete-guide.astro` (nootropic guide format)

**Location:** `site/src/pages/articles/[slug].astro`

---

## Complete File Structure

Every `.astro` article has three parts:

1. **Astro frontmatter** (imports, metadata, date formatting)
2. **rawCSS** (the complete CSS design system, copy verbatim)
3. **rawHTML** (article content using the design system's HTML classes)
4. **Astro template** (the standard wrapper: image hero, header, disclaimer, content area, sidebar)

---

## Part 1: Astro Frontmatter

```astro
---
import Base from '../../layouts/Base.astro';

export const frontmatter = {
  title: "Compound Name: Clear Descriptive Title",
  description: "SEO description, 150-160 chars, primary keyword near front.",
  image: "/images/articles/slug-name.webp",
  date: "YYYY-MM-DD",
  category: "Peptide Guides",
  author: "PeptideRundown Team"
};
const formattedDate = new Date(frontmatter.date).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
```

**Category options:** "Peptide Guides", "Comparisons", "How-To", "Safety"

---

## Part 2: CSS Design System

Copy this entire block into every article. Do not modify it.

```javascript
const rawCSS = `
:root{--bg:#F3F2EE;--ink:#18182A;--body:#3C3C52;--blue:#2956A6;--blue-lt:#E8EEF9;--teal:#187A62;--teal-lt:#E4F5EF;--amber:#B48118;--amber-lt:#FFF7E5;--red:#B53A3A;--red-lt:#FDEEEC;--plum:#6E3B8A;--plum-lt:#F3ECF8;--card:#FFFFFF;--bdr:#D9D6CE;--mut:#86869A;--sub:#EDECE8;}
.c{max-width:760px;margin:0 auto;padding:48px 24px 80px;}
h2{font-family:'Lora',serif;font-size:1.8rem;color:var(--ink);margin:56px 0 16px;line-height:1.3;}
h3{font-family:'Lora',serif;font-size:1.25rem;color:var(--ink);margin:34px 0 10px;line-height:1.35;}
h4{font-family:'Lora',serif;font-size:1.05rem;color:var(--ink);margin:24px 0 8px;}
p{margin-bottom:18px;}
strong{color:var(--ink);}
a{color:var(--blue);}
.hero{background:linear-gradient(135deg,#0A1628 0%,#112240 40%,#1A3A5C 100%);padding:64px 40px 52px;border-radius:16px;margin-bottom:36px;position:relative;overflow:hidden;}
.hero::before{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg width='80' height='80' viewBox='0 0 80 80' xmlns='http://www.w3.org/2000/svg'%3E%3Ccircle cx='40' cy='40' r='18' fill='none' stroke='%23ffffff' stroke-opacity='0.02' stroke-width='1'/%3E%3Ccircle cx='40' cy='40' r='8' fill='none' stroke='%23ffffff' stroke-opacity='0.015' stroke-width='0.5'/%3E%3C/svg%3E");}
.hero-k{font-size:11px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;color:rgba(255,255,255,.35);margin-bottom:14px;position:relative;}
.hero h1{font-family:'Lora',serif;font-size:clamp(1.8rem,4.5vw,2.5rem);color:#fff;line-height:1.22;max-width:640px;font-weight:600;position:relative;}
.hero .sub{color:rgba(255,255,255,.55);font-size:14.5px;margin-top:18px;max-width:560px;line-height:1.7;position:relative;}
.hero .pills{display:flex;gap:8px;flex-wrap:wrap;margin-top:20px;position:relative;}
.hero .pill{font-size:10.5px;font-weight:700;letter-spacing:1px;text-transform:uppercase;padding:4px 12px;border-radius:20px;border:1px solid rgba(255,255,255,.15);color:rgba(255,255,255,.5);}
@media(max-width:600px){.hero{padding:40px 24px 36px;}}
.d{border-left:3px solid var(--blue);background:var(--blue-lt);padding:20px 24px;margin:26px 0;border-radius:0 8px 8px 0;}
.d .s{font-weight:600;color:var(--blue);font-size:11px;letter-spacing:1.2px;text-transform:uppercase;margin-bottom:5px;}
.d p{margin-bottom:0;color:#1E3362;}
.d-t{border-left-color:var(--teal);background:var(--teal-lt);}.d-t .s{color:var(--teal);}.d-t p{color:#14503E;}
.d-a{border-left-color:var(--amber);background:var(--amber-lt);}.d-a .s{color:var(--amber);}.d-a p{color:#5A4010;}
.d-r{border-left-color:var(--red);background:var(--red-lt);}.d-r .s{color:var(--red);}.d-r p{color:#5A2020;}
.d-p{border-left-color:var(--plum);background:var(--plum-lt);}.d-p .s{color:var(--plum);}.d-p p{color:#3E2050;}
.sr{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:14px;margin:30px 0;}
.sb{background:var(--card);border:1px solid var(--bdr);border-radius:10px;padding:18px;text-align:center;}
.sb .v{font-family:'Lora',serif;font-size:1.7rem;line-height:1;margin-bottom:4px;}
.sb .v.c1{color:var(--blue);}.sb .v.c2{color:var(--teal);}.sb .v.c3{color:var(--plum);}.sb .v.c4{color:var(--amber);}
.sb .l{font-size:11px;color:var(--mut);font-weight:600;text-transform:uppercase;letter-spacing:.4px;line-height:1.35;}
.tbl{width:100%;border-collapse:collapse;margin:28px 0;font-size:13.5px;background:var(--card);border-radius:10px;overflow:hidden;border:1px solid var(--bdr);}
.tbl thead{background:var(--ink);color:#fff;}
.tbl th{padding:12px 14px;text-align:left;font-weight:600;font-size:10.5px;text-transform:uppercase;letter-spacing:.5px;}
.tbl td{padding:11px 14px;border-bottom:1px solid var(--bdr);line-height:1.5;}
.tbl tbody tr:nth-child(even){background:var(--sub);}
.tbl tbody tr:last-child td{border-bottom:none;}
.tbl .g{color:var(--teal);font-weight:600;}.tbl .r{color:var(--red);font-weight:600;}.tbl .y{color:var(--amber);font-weight:500;}
.cd{background:var(--card);border:1px solid var(--bdr);border-radius:12px;padding:26px;margin:24px 0;position:relative;overflow:hidden;}
.cd::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%;}
.cd.cb::before{background:var(--blue);}.cd.ct::before{background:var(--teal);}.cd.cp::before{background:var(--plum);}.cd.ca::before{background:var(--amber);}.cd.cr::before{background:var(--red);}
.cd .tg{display:inline-block;font-size:10px;font-weight:700;letter-spacing:1.2px;text-transform:uppercase;padding:3px 10px;border-radius:4px;margin-bottom:10px;}
.cd.cb .tg{background:var(--blue-lt);color:var(--blue);}.cd.ct .tg{background:var(--teal-lt);color:var(--teal);}.cd.cp .tg{background:var(--plum-lt);color:var(--plum);}.cd.ca .tg{background:var(--amber-lt);color:var(--amber);}.cd.cr .tg{background:var(--red-lt);color:var(--red);}
.cd h3{margin-top:0;font-size:1.15rem;}
.svg-box{background:var(--card);border:1px solid var(--bdr);border-radius:12px;padding:24px 16px 16px;margin:28px 0;overflow-x:auto;}
.svg-box .st{font-family:'Lora',serif;font-size:1.05rem;color:var(--ink);text-align:center;margin-bottom:4px;}
.svg-box .ss{font-size:12px;color:var(--mut);text-align:center;margin-bottom:16px;}
.svg-box svg{width:100%;height:auto;display:block;margin:0 auto;}
.g2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin:28px 0;}
.g3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;margin:28px 0;}
@media(max-width:600px){.g2,.g3{grid-template-columns:1fr;}}
.mc{background:var(--card);border:1px solid var(--bdr);border-radius:10px;padding:20px;}
.mc h4{font-family:'Lora',serif;font-size:1.05rem;color:var(--ink);margin-bottom:8px;}
.mc p{font-size:14px;margin-bottom:0;}
.sep{border:none;border-top:1px solid var(--bdr);margin:48px 0;}
.disc{background:var(--sub);border-radius:10px;padding:22px 24px;margin:40px 0;font-size:13px;color:var(--mut);line-height:1.7;}
.disc strong{color:var(--ink);font-size:11px;letter-spacing:1px;text-transform:uppercase;}
.faq{margin:28px 0;}
.faq details{background:var(--card);border:1px solid var(--bdr);border-radius:8px;margin-bottom:10px;overflow:hidden;}
.faq summary{padding:16px 20px;font-weight:600;color:var(--ink);cursor:pointer;font-size:15px;list-style:none;display:flex;justify-content:space-between;align-items:center;}
.faq summary::after{content:'+';font-size:18px;color:var(--mut);transition:transform .2s;}
.faq details[open] summary::after{content:'\\u2212';}
.faq .fa{padding:0 20px 16px;font-size:14.5px;line-height:1.7;}
`;
```

**Note on hero gradient colors:** You may vary the `.hero` gradient per article to create visual distinction. Use dark, professional tones. Examples:
- Navy/blue: `#0A1628, #112240, #1A3A5C` (nootropics, general)
- Navy/teal: `#1A1A2E, #16213E, #0F3460` (comparisons)
- Navy/green: `#0D1F2D, #132941, #1A3A2E` (healing, clinical)

---

## Part 3: HTML Content (rawHTML)

The `rawHTML` template string contains all article content using the CSS classes above. Here is the required structure and every available component.

### Required Content Structure

```html
const rawHTML = `
<div class="c">

<!-- GRADIENT HERO (required) -->
<div class="hero">
  <div class="hero-k">Category &middot; Subcategory</div>
  <h1>Article Title Here</h1>
  <p class="sub">One to two sentence subtitle explaining what this article covers and why it matters.</p>
  <div class="pills">
    <span class="pill">Tag One</span>
    <span class="pill">Tag Two</span>
    <span class="pill">Tag Three</span>
  </div>
</div>

<!-- STAT STRIPS (required, 3-4 stats) -->
<div class="sr">
  <div class="sb"><div class="v c1">VALUE</div><div class="l">Label<br>Line Two</div></div>
  <div class="sb"><div class="v c2">VALUE</div><div class="l">Label<br>Line Two</div></div>
  <div class="sb"><div class="v c3">VALUE</div><div class="l">Label<br>Line Two</div></div>
  <div class="sb"><div class="v c4">VALUE</div><div class="l">Label<br>Line Two</div></div>
</div>

<!-- INTRO PARAGRAPHS -->
<p>Opening paragraph. Hook the reader.</p>
<p>Second paragraph expanding the hook.</p>

<!-- EDUCATIONAL DISCLAIMER CALLOUT -->
<div class="d">
  <div class="s">What This Guide Covers</div>
  <p>Brief disclaimer about educational purpose.</p>
</div>

<!-- SECTION SEPARATOR (use between major sections) -->
<hr class="sep">

<!-- SECTIONS: Use <h2> for major sections, <h3> for subsections -->
<h2>Section Title</h2>
<p>Narrative content here.</p>

<!-- Continue with article body using components below... -->

<!-- MEDICAL DISCLAIMER (required, near bottom) -->
<div class="disc">
  <strong>Medical Disclaimer</strong><br>
  This article is for educational and informational purposes only...
</div>

<!-- REFERENCES (required) -->
<h3 style="margin-top:40px;font-size:1rem;">References</h3>
<p style="font-size:12.5px;color:var(--mut);line-height:1.8;">
Author et al. Title. <em>Journal.</em> Year;Vol:Pages. <a href="https://pubmed.ncbi.nlm.nih.gov/PMID/">PubMed</a><br>
</p>

<!-- RELATED READING (required) -->
<p style="margin-top:32px;"><strong>Related reading:</strong></p>
<p style="font-size:14px;">
<a href="/articles/slug-1">Title 1</a> &nbsp;&middot;&nbsp;
<a href="/articles/slug-2">Title 2</a>
</p>

<p style="font-size:13px;color:var(--mut);margin-top:8px;">For compound profiles and sourcing info, visit <a href="https://peptidearc.com">PeptideArc</a>.</p>

</div>
`;
```

---

## Component Reference (HTML Examples)

### Callout Boxes (5 color variants)

```html
<!-- Blue (default, informational) -->
<div class="d">
  <div class="s">Label Text</div>
  <p>Content here.</p>
</div>

<!-- Teal (positive, key finding) -->
<div class="d-t">
  <div class="s">Key Finding</div>
  <p>Content here.</p>
</div>

<!-- Amber (caution, warning) -->
<div class="d-a">
  <div class="s">Important Note</div>
  <p>Content here.</p>
</div>

<!-- Red (danger, contraindication) -->
<div class="d-r">
  <div class="s">Warning</div>
  <p>Content here.</p>
</div>

<!-- Plum (insight, context) -->
<div class="d-p">
  <div class="s">Context</div>
  <p>Content here.</p>
</div>
```

### Color-Coded Cards (5 color variants)

```html
<!-- Blue card -->
<div class="cd cb">
  <div class="tg">Tag Label</div>
  <h3>Card Title</h3>
  <p style="font-size:14px;margin-bottom:0;">Card content with <strong>bold terms</strong>.</p>
</div>

<!-- Other colors: ct (teal), cp (plum), ca (amber), cr (red) -->
```

### Styled Tables

```html
<table class="tbl">
<thead><tr><th>Column 1</th><th>Column 2</th><th>Column 3</th></tr></thead>
<tbody>
<tr><td><strong>Row label</strong></td><td>Value</td><td class="g">Positive value</td></tr>
<tr><td><strong>Row label</strong></td><td>Value</td><td class="y">Neutral value</td></tr>
<tr><td><strong>Row label</strong></td><td>Value</td><td class="r">Negative value</td></tr>
</tbody>
</table>
```

**Status color classes for table cells:**
- `class="g"` = teal/positive
- `class="y"` = amber/neutral
- `class="r"` = red/negative

### Grid Layouts (2-column and 3-column)

```html
<!-- 2-column grid (responsive, collapses on mobile) -->
<div class="g2">
  <div class="mc">
    <h4 style="color:var(--blue);">Card Title</h4>
    <p>Card content.</p>
  </div>
  <div class="mc">
    <h4 style="color:var(--teal);">Card Title</h4>
    <p>Card content.</p>
  </div>
</div>

<!-- 3-column grid -->
<div class="g3">
  <div class="mc">
    <h4 style="color:var(--blue);">Title</h4>
    <p>Content.</p>
  </div>
  <div class="mc">
    <h4 style="color:var(--plum);">Title</h4>
    <p>Content.</p>
  </div>
  <div class="mc">
    <h4 style="color:var(--amber);">Title</h4>
    <p>Content.</p>
  </div>
</div>
```

### SVG Diagram Box

```html
<div class="svg-box">
  <div class="st">Diagram Title</div>
  <div class="ss">Subtitle or legend text</div>
  <svg viewBox="0 0 700 280" xmlns="http://www.w3.org/2000/svg">
    <!-- SVG content here -->
  </svg>
</div>
```

### FAQ Accordion

```html
<div class="faq">
  <details>
    <summary>Question text here?</summary>
    <div class="fa">Answer text here.</div>
  </details>
  <details>
    <summary>Another question?</summary>
    <div class="fa">Another answer.</div>
  </details>
</div>
```

### Section Separator

```html
<hr class="sep">
```

Use between major `<h2>` sections.

---

## Part 4: Astro Template (Standard Wrapper)

This goes at the bottom of every `.astro` file after the closing `---`. Copy it exactly, only changing the sidebar "Related Guides" links to match the article topic.

```astro
---

<Base title={frontmatter.title} description={frontmatter.description} ogImage={frontmatter.image}>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 py-12 md:flex md:gap-8">
    <article class="md:flex-1 min-w-0">
      <div class="mb-8 -mx-4 sm:mx-0">
        <img src={frontmatter.image} alt={frontmatter.title} class="w-full rounded-none sm:rounded-2xl shadow-lg object-cover max-h-96" loading="eager" />
      </div>
      <header class="mb-10">
        <span class="inline-block px-3 py-1 text-xs font-bold text-primary bg-primary/10 rounded-full mb-4 uppercase tracking-wide">{frontmatter.category}</span>
        <h1 class="text-3xl sm:text-4xl lg:text-5xl font-extrabold leading-tight text-text mb-4">{frontmatter.title}</h1>
        <p class="text-lg text-text-muted leading-relaxed mb-6">{frontmatter.description}</p>
        <div class="flex items-center gap-4 text-sm text-text-muted border-t border-gray-200 pt-4">
          <span>By <strong class="text-text">{frontmatter.author}</strong></span>
          <span>&bull;</span>
          <time datetime={frontmatter.date}>{formattedDate}</time>
        </div>
      </header>
      <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-10 text-sm text-amber-800">
        <strong>&#9888;&#65039; Medical Disclaimer:</strong> This article is for educational purposes only and is not medical advice. Always consult a qualified healthcare provider before starting any peptide protocol.
      </div>
      <style set:html={rawCSS} />
      <div class="prose prose-lg prose-slate max-w-none prose-headings:font-bold prose-headings:text-text prose-h2:text-2xl prose-h2:mt-14 prose-h2:mb-6 prose-h3:text-xl prose-h3:mt-10 prose-h3:mb-4 prose-a:text-primary prose-a:no-underline hover:prose-a:underline prose-strong:text-text prose-blockquote:border-primary prose-blockquote:bg-primary/5 prose-blockquote:rounded-r-lg prose-img:rounded-xl prose-img:shadow-lg article-content">
        <div class="c" set:html={rawHTML} />
      </div>
    </article>
    <aside class="w-full md:w-64 shrink-0 mt-10 md:mt-0 md:sticky md:top-20 md:self-start">
      <div class="space-y-6">
        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
          <h3 class="text-sm font-bold text-text uppercase tracking-wide mb-3">Quick Info</h3>
          <div class="flex items-center gap-2 mb-2">
            <span class="text-xs text-text-muted">Category:</span>
            <span class="px-2 py-0.5 text-xs font-bold text-primary bg-primary/10 rounded-full">{frontmatter.category}</span>
          </div>
          <div class="flex items-center gap-2 mb-2">
            <span class="text-xs text-text-muted">Updated:</span>
            <span class="text-xs font-medium text-text">{formattedDate}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-text-muted">Author:</span>
            <span class="text-xs font-medium text-text">{frontmatter.author}</span>
          </div>
        </div>
        <div class="bg-gradient-to-br from-primary/5 to-transparent rounded-2xl border border-primary/10 p-5">
          <h3 class="text-sm font-bold text-primary mb-2">Our Standards</h3>
          <ul class="text-xs text-text-muted space-y-1.5">
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">&#10003;</span> PubMed-cited research</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">&#10003;</span> No vendor affiliations</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">&#10003;</span> Regularly updated</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">&#10003;</span> Reviewed for accuracy</li>
          </ul>
        </div>
        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
          <h3 class="text-sm font-bold text-text uppercase tracking-wide mb-3">Related Guides</h3>
          <div class="space-y-3">
            <!-- CUSTOMIZE THESE 4 LINKS per article -->
            <a href="/articles/RELATED-1" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">Related Guide Title 1</a>
            <a href="/articles/RELATED-2" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">Related Guide Title 2</a>
            <a href="/articles/RELATED-3" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">Related Guide Title 3</a>
            <a href="/articles/RELATED-4" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">Related Guide Title 4</a>
          </div>
          <a href="/articles" class="block mt-4 text-xs font-bold text-primary hover:underline">View all guides &rarr;</a>
        </div>
        <div class="bg-gradient-to-br from-surface-dark to-primary-dark rounded-2xl p-5 text-center">
          <p class="text-sm font-bold text-white mb-2">New to Peptides?</p>
          <p class="text-xs text-gray-300 mb-3">Start with the basics.</p>
          <a href="/articles/what-are-peptides-beginners-guide" class="inline-block px-4 py-2 text-xs font-bold bg-primary text-white rounded-lg hover:bg-primary-light transition-colors">Read Beginner's Guide</a>
        </div>
      </div>
    </aside>
  </div>
</Base>
```

---

## Formatting Rules (MANDATORY)

These rules apply to ALL content within rawHTML:

- **No em dashes.** NEVER use em dashes in any form (the character, &mdash;, or &#8212;). Use commas, periods, colons, semicolons, or parentheses instead.
- **No emoji** in article content.
- **No banned words:** delve, leverage, robust, utilize, landscape, navigate.
- **70% narrative, 30% structured content** (tables, lists, cards). Articles should read like articles, not outlines.
- **Max 2-sentence paragraphs.** Most should be 1 sentence.
- **Conversational tone** with contractions (it's, don't, won't).
- **PubMed citations required.** Link to PubMed for research claims. Format: `(<a href="https://pubmed.ncbi.nlm.nih.gov/PMID/">Author et al., Year</a>)`
- **Cross-links required.** Link to related articles on the site and to PeptideArc.
- **Use HTML entities** for special characters: `&ndash;` (en dash for ranges like 4&ndash;7), `&middot;` (middle dot for separators), `&bull;` (bullet).
- **Featured image required.** Generate via OpenAI gpt-image-1 (1536x1024, webp). Save to `/public/images/articles/[slug].webp`. Use abstract prompts to avoid content filter blocks. Include "no text, no labels, no words" in every prompt.

---

## Recommended Article Sections (in order)

1. Gradient Hero (with pills)
2. Stat Strips (3-4 key metrics)
3. Intro paragraphs + disclaimer callout
4. Compound Overview (card with compound profile)
5. How It Works (mechanisms with SVG diagram)
6. Benefits/Evidence table
7. Variants or Dosing Forms (if applicable)
8. Dosing Protocols (tables)
9. Clinical Research (cards + narrative)
10. Comparison vs. Alternative (table)
11. Stacking (table)
12. Side Effects (table + contraindications callout)
13. Cycling (table)
14. Who Might Benefit (grid cards)
15. Legal Status (grid cards)
16. FAQ (accordion)
17. Bottom Line (teal summary callout + closing paragraphs)
18. Medical Disclaimer
19. References
20. Related Reading + PeptideArc link

Not every article needs every section. Use judgment based on the compound and content type.

---

## Image Generation

Use the project's `gen-image.py` (OpenRouter, Gemini 3 Pro Image, ~$0.14/image). It writes directly to `site/public/images/articles/{slug}.webp` at the correct 1536x1024 dimensions.

```bash
python3 tools/gen-image.py \
  --slug SLUG \
  --prompt "abstract molecular visualization with [topic-relevant description], scientific aesthetic, no text, no labels, no words"
```

**CRITICAL — sandbox gotcha:** Run this as a single, standalone command. Do NOT chain it with `&&` to other commands (`cd`, `git add`, etc.). The openclaw exec sandbox rejects chained interpreter invocations with `"complex interpreter invocation detected"` and image generation will silently fail, leaving the article with a broken hero image. Run each subsequent step (`cd`, `git add`, `git commit`, `git push`) as separate exec calls.

After generation, verify with:
```bash
bash tools/check-article-images.sh SLUG
```

This guard exits non-zero if the article frontmatter references an image file that does not exist on disk. If it fails, fix the image before committing.

---

## Deployment

```bash
cd <peptiderundown repo root>
git add src/pages/articles/[slug].astro public/images/articles/[slug].webp
git commit -m "Add [article-title] guide"
git push origin main
```

Cloudflare Pages auto-deploys on push to main.
