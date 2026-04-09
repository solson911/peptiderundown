> **STOP. READ FIRST.**
>
> All new PeptideRundown articles MUST be `.astro` files built from
> **`ASTRO-ARTICLE-TEMPLATE.md`** - that is the canonical source of truth for
> file structure, frontmatter, the CSS design system, required visual
> components, and the `<Base>` wrapper. Do NOT create `.md` articles. The
> `.md` format is **deprecated** and any new `.md` article will look broken
> next to the rest of the site (no hero, no stat strips, no callouts, no
> styled tables).
>
> This style guide covers **prose-level rules** (banned words, sentence style,
> tone, paragraph rhythm) that apply *inside* the `rawHTML` block of an
> `.astro` article. It is supplementary, not standalone. Also see
> **`CONTENT-MANAGEMENT.md`** for content policy and protected articles, and
> **`ARTICLE-DISPATCH-PROMPT.md`** for the writer-agent dispatch contract.

---

# PeptideRundown Writing Style Guide

## Absolute Bans
- No em dashes (—) ever
- No "delve into" / "dive into" / "deep dive"
- No "in the realm of" / "in the world of"
- No "it's worth noting that"
- No "Importantly," / "Interestingly," as sentence starters
- No "landscape" (unless talking about actual land)
- No "navigate" (unless talking about actual directions)
- No "leverage" as a verb
- No "robust"
- No "utilize" (just say "use")
- No "Furthermore" / "Moreover"
- No "game-changer"
- No "comprehensive" (overused AI word)
- No starting paragraphs with "So,"
- No overly parallel sentence structures (three things in a row, same format)
- No exclamation points in informational content

## Writing Style
- Vary sentence length (short punchy ones mixed with longer ones)
- Use contractions naturally
- Occasionally start sentences with "And" or "But"
- Be slightly imperfect, less polished, more human
- Use specific examples instead of vague generalities
- Tone: Authoritative but accessible, like explaining to a smart friend
- Cite real PubMed studies with links where possible
- Reference peptidearc.com for compound details when relevant

## Frontmatter

See `ASTRO-ARTICLE-TEMPLATE.md` Part 1. Articles use Astro `export const frontmatter = { ... }` syntax, not YAML. Categories: `"Peptide Guides"`, `"Comparisons"`, `"How-To"`, `"Safety"`.

## Article Structure
- 2,000-4,000 words
- Include medical disclaimer (handled by Article.astro layout)
- Use H2 for main sections, H3 for subsections
- Include FAQ section at bottom
- Cite studies with PubMed links

## Content Layout Rules
- **ALWAYS add a blank line before every heading** (H2, H3, H4, etc.). This improves readability and spacing. No exceptions.
- **ALWAYS add a blank line between paragraphs** - double-spaced paragraphs are essential for readability. Never have paragraphs directly touching each other.
- **USE horizontal rules (---) strategically** to break up walls of text:
  - Before each new peptide/compound section (BPC-157, TB-500, etc.)
  - Between major topic changes within articles
  - Before FAQ sections
  - Between protocol/dosing sections
  - When transitioning between comparison items
- **Generous spacing** between paragraphs and sections. Dense walls of text kill readability.
- **Link to research** wherever possible. PubMed links, DOIs, actual study references inline.
- **Break up long sections** with subheadings, callout boxes, or images.
- **Paragraph length:** 2-4 sentences max. Short paragraphs are easier to scan.
- **Remove "comprehensive"** from all article titles, descriptions, and body text.

## List Usage and Bold Text Balance
- **AVOID excessive bold lead-ins** - they create choppy, outline-like text that's hard to read naturally
- **Use simple bullet points** without bold lead-ins for most lists:
  ```
  ✅ Good:
  • Reduces appetite through GLP-1 receptor activation
  • Slows gastric emptying for prolonged satiety
  • Improves insulin sensitivity in muscle tissue
  
  ❌ Too bold-heavy:
  **Appetite reduction** - Reduces appetite through GLP-1 receptor activation
  **Gastric effects** - Slows gastric emptying for prolonged satiety
  **Insulin sensitivity** - Improves insulin sensitivity in muscle tissue
  ```
- **Prioritize flowing narrative** over list format - aim for 70% paragraphs, 30% lists
- **Reserve bold text** for:
  - First mention of key peptides in a section
  - Critical safety warnings
  - Dosage numbers that need emphasis
- **Natural paragraph flow example:**
  ```
  BPC-157 works through multiple pathways to promote healing. The peptide stimulates 
  angiogenesis, helping form new blood vessels that deliver nutrients to damaged tissue. 
  It also modulates inflammatory responses, reducing harmful inflammation while preserving 
  beneficial healing signals.
  
  Clinical applications show particular promise for digestive issues. Users report 
  improvements in IBS symptoms, reduced acid reflux, and faster recovery from 
  gastrointestinal inflammation.
  
  Dosing protocols for BPC-157 typically start conservatively. Most users begin with 
  250-500 mcg daily, divided into two doses taken on an empty stomach.
  ```

## Paragraph Spacing Requirements
- **MANDATORY: Blank line between every paragraph** - improves scanning and readability
- **Example of correct spacing:**
  ```
  ✅ Good (double-spaced):
  This is the first paragraph about peptides and their benefits.
  
  This is the second paragraph explaining mechanisms of action.
  
  This third paragraph covers dosing protocols.
  
  ❌ Bad (single-spaced):
  This is the first paragraph about peptides and their benefits.
  This is the second paragraph explaining mechanisms of action.
  This third paragraph covers dosing protocols.
  ```

## Visual Formatting Requirements
- **Avoid walls of text** - the biggest readability killer
- **Add horizontal rules (---) before new compounds/peptides**:
  ```
  Previous content about general topic.

  ---

  ## BPC-157 Benefits

  Content about BPC-157...

  ---

  ## TB-500 Protocol  

  Content about TB-500...
  ```
- **Use callout boxes** for important notes (💡 ⚡ ⚠️ 📊)
- **Bold key terms** on first mention in each section
- **Tables for comparisons** - much better than paragraph lists
- **Short paragraphs** - 2-3 sentences maximum
