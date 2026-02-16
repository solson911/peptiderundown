# FILE LOCATIONS - SINGLE SOURCE OF TRUTH

## 🎯 **CRITICAL: WHERE TO EDIT ARTICLES**

### ✅ **CORRECT LOCATION (ONLY ONE):**
```
/home/claw/.openclaw/workspace/projects/peptide-site/site/src/pages/articles/
```

**This is the ONLY place articles exist. Period.**

### ❌ **DO NOT EDIT (ELIMINATED):**
```
/home/claw/.openclaw/workspace/projects/peptide-site/site/src/content/articles/  ❌ GONE
```
This directory has been moved to `_content_backup_20260216_1454/` and should NEVER be referenced again.

---

## 📁 **COMPLETE FILE STRUCTURE**

```
peptide-site/
├── site/
│   ├── src/
│   │   ├── pages/
│   │   │   ├── articles/           ← ✅ EDIT ARTICLES HERE
│   │   │   │   ├── article1.md     ← Individual articles
│   │   │   │   ├── article2.md     
│   │   │   │   └── ...
│   │   │   ├── news/               ← ✅ EDIT NEWS HERE
│   │   │   │   ├── news1.md
│   │   │   │   └── ...
│   │   │   └── index.astro         ← Homepage
│   │   ├── layouts/                ← Astro layouts
│   │   └── styles/                 ← CSS files
│   ├── public/                     ← Static assets
│   └── package.json
├── scripts/                        ← Helper scripts
│   ├── verify-deploy.sh           ← Deployment verification
│   └── task-manager.sh            ← Agent coordination
├── _content_backup_20260216_1454/ ← ❌ OLD BACKUP (ignore)
└── *.md                           ← Documentation
```

---

## 📝 **AGENT INSTRUCTIONS**

### ✅ **FOR ARTICLES:**
```bash
# Edit this file:
/home/claw/.openclaw/workspace/projects/peptide-site/site/src/pages/articles/{article-slug}.md

# Deploy:
cd /home/claw/.openclaw/workspace/projects/peptide-site/site
git add -A && git commit -m "Update article" && git push

# Verify:
cd /home/claw/.openclaw/workspace/projects/peptide-site
./scripts/verify-deploy.sh {article-slug}
```

### ✅ **FOR NEWS:**
```bash
# Edit this file:
/home/claw/.openclaw/workspace/projects/peptide-site/site/src/pages/news/{news-slug}.md
```

### ❌ **NEVER DO THIS:**
- Do NOT reference `src/content/articles/` (doesn't exist)
- Do NOT create duplicate files
- Do NOT claim success without running verification

---

## 🔒 **FRONTMATTER TEMPLATE**

**Every article in `src/pages/articles/` must use this exact frontmatter:**

```yaml
---
layout: ../../layouts/Article.astro
title: "Article Title"
description: "SEO description"
image: /images/articles/article-slug.webp
date: 2026-MM-DD
category: "Peptide Guides" | "Comparisons" | "How-To" | "Safety"
tags: ["tag1", "tag2", "tag3"]
author: "PeptideRundown Team"
---
```

---

## 🚨 **ELIMINATION CONFIRMATION**

### ✅ **COMPLETED:**
- ✅ Moved `src/content/` to `_content_backup_20260216_1454/`
- ✅ Updated ALL dispatch templates to reference single location
- ✅ Verified micro-dosing article working with new system
- ✅ Created verification and coordination scripts

### 🔍 **VERIFICATION:**
```bash
# Confirm no dual structure exists:
ls -la /home/claw/.openclaw/workspace/projects/peptide-site/site/src/

# Should show:
# ✅ pages/     (contains articles)
# ❌ content/   (should NOT exist)
```

---

## 💡 **WHY THIS MATTERS**

**Before (Broken):**
- 2 locations: `src/content/` + `src/pages/`
- Agents confused about which to edit
- Inconsistent content between locations
- Wasted tokens on duplicate work
- Deployment failures from editing wrong files

**After (Fixed):**
- 1 location: `src/pages/` only
- Zero confusion
- Zero duplicates  
- Zero wasted work
- Reliable deployments

---

## 🎯 **GOLDEN RULE**

**If you need to edit an article: `src/pages/articles/{slug}.md`**  
**That's it. Nothing else exists.**