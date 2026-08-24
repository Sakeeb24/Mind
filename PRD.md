# MindSpace — Product Requirement Document

> **Version**: 1.0 — August 2026
> **Status**: Pre-Development
> **Last Updated**: August 24, 2026

---

## Table of Contents

1. [Product Definition](#1-product-definition)
2. [Target Users](#2-target-users)
3. [Key Features](#3-key-features)
4. [Monetization Strategy](#4-monetization-strategy)
5. [Success Metrics & KPIs](#5-success-metrics--kpis)
6. [Constraints & Assumptions](#6-constraints--assumptions)

---

## 1. Product Definition

### 1.1 What Is MindSpace?

MindSpace is a free, cross-platform mobile application (Android + iOS) that serves as a document intelligence and study assistant for students. It enables users to upload, read, annotate, and interact with their PDF study materials using AI-powered summarization and question answering.

Think of it as **LiquidText, but completely free** — built on open-source and free-tier infrastructure so that no student is ever paywalled out of productivity tools.

### 1.2 Product Vision

> "Every student deserves a personal research assistant — and it should be free."

MindSpace eliminates the chaos of managing dozens of PDFs, lecture notes, and research articles. Students no longer need to read 200 pages to find one key insight. With a single tap, MindSpace reads their documents and answers their questions.

### 1.3 Core Purpose

| Problem | MindSpace Solution |
|---|---|
| Students juggle 10+ PDFs per semester with no organization | Folder-based document management with search |
| Reading dense academic papers is slow and exhausting | AI-powered summarization of chapters, sections, and paragraphs |
| Key information gets lost across hundreds of pages | Color-coded highlights and sticky notes anchored to specific passages |
| Students waste hours writing study notes manually | AI Q&A lets them ask questions and get answers with citations |
| Most document intelligence tools cost $10-30/month | Completely free — powered by NVIDIA Nemotron free tier |

### 1.4 Goals

**Business Goals**
- Acquire 10,000 active users within 6 months of launch
- Achieve 4.5+ star rating on both Google Play and App Store
- Reach 70% monthly retention at the 30-day mark
- Establish MindSpace as the leading free study assistant

**Product Goals**
- Sub-2-second cold start on mid-range devices (Snapdragon 660 / A11 Bionic)
- Zero data loss for annotations and notes (offline-first architecture)
- AI responses in under 5 seconds for summarization queries
- Support documents up to 200 pages without performance degradation

**User Goals**
- Upload and organize all semester materials in one app
- Get instant summaries of any chapter or section
- Ask natural language questions about their documents
- Highlight and annotate while reading — with full undo/redo
- Access documents offline during lectures and study sessions

---

## 2. Target Users

### 2.1 Primary Users

**Demographics**
- **Age**: 14–25 years
- **Education**: High school students, undergraduates, graduate students
- **Tech Comfort**: Moderate to high — native smartphone users
- **Budget**: Low to zero — unwilling or unable to pay for productivity software
- **Device Range**: Budget Android phones (2GB RAM) to latest iPhones

**Personas**

**Persona 1: Alex, the Overwhelmed Sophomore**
- Age: 20, Computer Science major
- Has 8 classes, each with 2-4 PDFs to read weekly
- Currently uses Google Drive to store PDFs but has no annotation or AI tools
- Needs: Quick summaries before class, organized folder system, highlight key concepts
- Pain Point: Spends 3+ hours per day just reading through dense material

**Persona 2: Maya, the Research Student**
- Age: 22, Biology graduate student
- Reading 15+ research papers per week
- Needs: AI Q&A to quickly find specific information, sticky notes for research insights
- Pain Point: Loses track of important findings across papers

**Persona 3: Jordan, the High Schooler**
- Age: 16, AP student taking 4 AP classes
- Uses phone for study (no laptop available at all times)
- Needs: Mobile-first experience, flashcards (V2), easy highlight colors
- Pain Point: Can't afford premium study tools

### 2.2 User Needs Matrix

| Need | How MindSpace Addresses It |
|---|---|
| Organize documents by subject | Folder system with color coding |
| Read PDFs on mobile | Smooth PDF viewer with zoom/pan |
| Find key information fast | AI summarization + Q&A |
| Take notes while reading | Sticky notes anchored to passages |
| Highlight important text | 4-color highlighting system |
| Work offline | Local Hive database for cached content |
| Access across devices | Supabase cloud sync (V2) |
| Study for exams | AI-generated flashcards + quizzes (V2) |

---

## 3. Key Features

### 3.1 MVP Features (Version 1 — Weeks 1–8)

| # | Feature | Description | Priority |
|---|---------|-------------|----------|
| 1 | **User Authentication** | Email/password sign-up + Google OAuth via Supabase Auth | P0 |
| 2 | **Document Upload** | Upload PDFs from device storage; max 50MB per file | P0 |
| 3 | **Document Viewer** | Smooth PDF rendering with pinch-to-zoom, page navigation | P0 |
| 4 | **Highlighting** | Select text → choose from 4 colors (yellow, green, blue, pink) | P0 |
| 5 | **Sticky Notes** | Tap anywhere on page → add text note anchored to that position | P0 |
| 6 | **AI Summarization** | One-click summary of chapter, section, or selected text | P0 |
| 7 | **AI Q&A Chat** | Chat interface; ask questions about the open document; get answers with page citations | P0 |
| 8 | **Folder Organization** | Create/rename/delete folders; move documents between folders | P1 |
| 9 | **Document Dashboard** | Grid/list view of all documents with thumbnails, last opened, document count | P1 |
| 10 | **Undo/Redo** | Full undo/redo stack for highlighting and note actions | P1 |

**Feature Details**

**User Authentication**
- Email + password registration with email verification
- Google Sign-In (one-tap on Android, Safari/Chrome on iOS)
- Password reset via email
- Session persistence (stay logged in across app restarts)
- Secure token storage using flutter_secure_storage

**Document Upload**
- Pick PDFs from device file system (document picker)
- Upload progress indicator with percentage
- File validation: PDF only, max 50MB, min 1 page
- Duplicate detection by file name + size
- Upload status stored locally for retry on connection failure

**Document Viewer**
- High-performance PDF rendering using pdfx package
- Pinch-to-zoom (0.5x to 5x)
- Single-finger swipe for page navigation
- Page indicator showing current/total pages
- Jump-to-page via page number input
- Thumbnail strip for quick navigation (optional, V1.1)
- Gesture: double-tap to highlight, long-press for context menu

**Highlighting**
- Text selection triggers highlight toolbar
- 4 color options: Yellow (#FFEB3B), Green (#66BB6A), Blue (#42A5F5), Pink (#EC407A)
- Highlights persist locally (Hive) and sync to cloud (Supabase)
- Tap highlight to edit/delete
- Highlight list view showing all highlights per document
- Search across highlights within a document

**Sticky Notes**
- Long-press on page → "Add Note" option
- Note appears as colored pin icon on the page
- Tap pin to expand full note content
- Notes support up to 500 characters
- Notes are anchored to page coordinates (x, y position)
- Edit/delete notes from the expanded view
- List view of all notes per document

**AI Summarization**
- Trigger: tap "Summarize" button on any page/selection
- Scope options: "This Page", "This Section" (detected by Nemotron-Parse), "My Selection"
- Processing indicator with estimated time
- Summary displayed in a bottom sheet with copy/share options
- Summary is cached locally to avoid re-processing
- Summary includes source page reference

**AI Q&A Chat**
- Dedicated chat interface (full screen or split view)
- Document context automatically loaded (active document)
- User types natural language question
- Nemotron 3 Ultra 550B processes question + document context
- Response includes answer text + page citation [Page X]
- Chat history preserved per document
- Supports follow-up questions within same context
- Typing indicator while AI processes

**Folder Organization**
- Default "All Documents" view (unfiltered)
- Create folders with custom name and optional color
- Nested folders (max 2 levels deep)
- Drag-and-drop to move documents between folders
- Folder document count badge
- Sort documents within folders by: name, date added, last opened, size

**Document Dashboard**
- Default view: grid of document cards
- Card shows: thumbnail of first page, title, date added, highlight/note count
- Toggle between grid and list view
- Sort by: recent, name, date added
- Search bar to filter documents by title
- Empty state illustration when no documents exist
- FAB (Floating Action Button) for quick upload

**Undo/Redo**
- Persistent undo/redo stack across session
- Applies to: highlights (add/delete/color change), notes (add/edit/delete)
- Undo/redo buttons in the annotation toolbar
- Stack depth: 50 actions
- Stack clears on document close (no cross-session undo)

### 3.2 Version 2 Features (Post-MVP)

| # | Feature | Description | Target |
|---|---------|-------------|--------|
| 11 | **Flashcards** | AI-generated flashcards from document content; spaced repetition algorithm | Month 3 |
| 12 | **Quiz Generator** | Multiple choice + short answer quizzes from uploaded material | Month 3 |
| 13 | **Collaboration** | Share documents + annotations with classmates via link or email | Month 4 |
| 14 | **Web Clipper** | Browser extension to save articles/PDFs directly to MindSpace | Month 5 |
| 15 | **Export** | Export highlighted notes as PDF, Word, or Markdown | Month 4 |
| 16 | **Multi-device Sync** | Full sync across phone + tablet + web | Month 5 |
| 17 | **Smart Search** | AI-powered search across all documents and notes | Month 3 |

---

## 4. Monetization Strategy

### 4.1 Core Philosophy

> MindSpace is **free forever** for core features. Students should never be locked out of studying.

Revenue is generated through optional premium enhancements that power users or institutions are willing to pay for.

### 4.2 Freemium Model

**Free Tier (Permanent)**
| Included | Limit |
|---|---|
| Document uploads | 30 documents |
| AI summarization | 20 queries per day |
| AI Q&A chat | 20 queries per day |
| Highlighting | Unlimited |
| Sticky notes | Unlimited |
| Folders | Unlimited |
| Offline access | All cached documents |
| Supported languages | English |

**Pro Tier ($4.99/month or $39.99/year)**
| Upgrade | Detail |
|---|---|
| Document uploads | Unlimited |
| AI queries | Unlimited per day |
| Priority processing | AI responses 2x faster |
| Multi-language support | 50+ languages via Nemotron |
| Advanced export | PDF, Word, Markdown export |
| Collaboration | Share with up to 10 classmates |
| Priority support | Email + in-app chat support |

**Institutional Tier ($2.99/student/month, 50+ seats)**
| Feature | Detail |
|---|---|
| Bulk deployment | Admin dashboard for school/university |
| Shared libraries | Department-wide document repositories |
| Analytics | Usage analytics for educators |
| SSO Integration | Institution-managed authentication |
| Custom branding | School colors and logo |

### 4.3 Revenue Projections

| Milestone | Timeline | Users | Pro Conversion | Monthly Revenue |
|---|---|---|---|---|
| Launch | Month 1 | 1,000 | 3% | $150 |
| Growth | Month 3 | 10,000 | 5% | $2,500 |
| Scale | Month 6 | 50,000 | 7% | $17,500 |
| Maturity | Month 12 | 200,000 | 10% | $100,000 |

---

## 5. Success Metrics & KPIs

### 5.1 Engagement Metrics

| Metric | Target | Measurement Method |
|---|---|---|
| Documents per active user per week | 10+ | Supabase analytics |
| AI queries per user session | 5+ | Event logging |
| Average session duration | 15+ minutes | App analytics |
| Daily Active Users (DAU) | Growing 10% month-over-month | Supabase |
| Monthly Active Users (MAU) | 10,000 within 6 months | Supabase |

### 5.2 Retention Metrics

| Metric | Target |
|---|---|
| Day 1 retention | 60% |
| Day 7 retention | 45% |
| Day 30 retention | 70% |
| Churn rate (monthly) | < 15% |

### 5.3 Performance Metrics

| Metric | Target |
|---|---|
| App cold start | < 2 seconds |
| PDF page render | < 500ms |
| AI summarization response | < 5 seconds |
| AI Q&A response | < 8 seconds |
| Upload speed (10MB file) | < 10 seconds on WiFi |
| Crash rate | < 1% |

### 5.4 Quality Metrics

| Metric | Target |
|---|---|
| App Store rating | 4.5+ stars |
| Bug report rate | < 2 per 1,000 sessions |
| Accessibility compliance | WCAG 2.1 AA |
| Offline availability | 100% for cached content |

### 5.5 Business Metrics

| Metric | Target (Month 6) |
|---|---|
| Pro conversion rate | 5-10% |
| Monthly recurring revenue | $2,500+ |
| Customer acquisition cost | < $2 per user |
| Lifetime value (Pro user) | $60+ |

---

## 6. Constraints & Assumptions

### 6.1 Technical Constraints

| Constraint | Detail |
|---|---|
| Zero budget | All infrastructure must be free-tier (Supabase, NVIDIA, Vercel) |
| Team size | 1-2 developers |
| Timeline | 8 weeks for MVP |
| AI rate limits | 40 RPM per NVIDIA API endpoint |
| Supabase storage | 1GB total (cloud) — rely on local Hive for bulk |
| Supabase database | 500MB PostgreSQL — minimal cloud data |
| Device support | Android 8.0+ (API 26), iOS 13.0+ |
| RAM floor | Must function on 2GB RAM devices |

### 6.2 Assumptions

- NVIDIA Nemotron free tier remains available during development and early growth
- Supabase free tier is sufficient for the first 10,000 users
- Students primarily use Wi-Fi for uploads; cellular for reading/AI queries
- PDF is the dominant academic document format (covers 90%+ use cases)
- English is the primary language; multi-language is a V2 feature
- Google Sign-In is the dominant social auth method for the target demographic

### 6.3 Risks

| Risk | Impact | Mitigation |
|---|---|---|
| NVIDIA free tier rate limits hit during growth | AI features degrade | Implement client-side throttling, queue system, cache aggressively |
| Supabase storage limit exceeded | Cloud sync fails | Prioritize local Hive; only sync metadata to cloud, not file bytes |
| Google removes free Gemini/Nemotron access | AI pipeline breaks | Abstract AI layer behind a service interface; swap providers easily |
| PDFs with scanned images (no text) | Text extraction fails | Detect OCR-needed documents; prompt user or queue for OCR processing |
| Large PDFs (>100 pages) | Memory crashes on low-end devices | Lazy-load pages; process in chunks; set max 200-page limit |
