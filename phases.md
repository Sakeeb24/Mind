# MindSpace — Project Phases

> **Version**: 1.0 — August 2026
> **Last Updated**: August 24, 2026

---

## Table of Contents

1. [Phase Overview](#1-phase-overview)
2. [Phase 1: Login & Authentication](#2-phase-1-login--authentication)
3. [Phase 2: Dashboard](#3-phase-2-dashboard)
4. [Phase 3: Document Viewer & Annotations](#4-phase-3-document-viewer--annotations)
5. [Phase 4: AI Features](#5-phase-4-ai-features)
6. [Phase 5: Testing & QA](#6-phase-5-testing--qa)
7. [Phase 6: Deployment](#7-phase-6-deployment)
8. [Phase Dependencies](#8-phase-dependencies)
9. [Definition of Done](#9-definition-of-done)

---

## 1. Phase Overview

| Phase | Name | Duration | Weeks | Deliverable |
|---|---|---|---|---|
| 1 | Login & Authentication | 1 week | Week 1 | Working sign-up/sign-in/sign-out |
| 2 | Dashboard | 1 week | Week 2 | Document grid, folders, upload |
| 3 | Document Viewer & Annotations | 2 weeks | Weeks 3–4 | PDF reader, highlights, sticky notes, undo/redo |
| 4 | AI Features | 2 weeks | Weeks 5–6 | Summarization, Q&A chat, text extraction |
| 5 | Testing & QA | 1 week | Week 7 | Full test suite, bug fixes, polish |
| 6 | Deployment | 1 week | Week 8 | App Store + Play Store release |

**Total Duration**: 8 weeks

---

## 2. Phase 1: Login & Authentication

> **Week 1** | Goal: Users can create accounts and sign in

### 2.1 Objectives

- Set up Flutter project with all approved dependencies
- Implement Supabase integration
- Build authentication screens
- Complete auth flow (sign-up, sign-in, sign-out, password reset)

### 2.2 Tasks

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 1.1 | Initialize Flutter project with `flutter create` | 30 min | P0 |
| 1.2 | Configure `pubspec.yaml` with all approved dependencies | 1 hour | P0 |
| 1.3 | Set up project folder structure per architecture.md | 1 hour | P0 |
| 1.4 | Create Supabase project and configure auth settings | 1 hour | P0 |
| 1.5 | Set up environment configuration (`env.dart`) | 30 min | P0 |
| 1.6 | Create theme configuration (light/dark) | 2 hours | P1 |
| 1.7 | Build reusable UI components (buttons, text fields, loading) | 3 hours | P0 |
| 1.8 | Implement `AuthRepository` interface and Supabase implementation | 2 hours | P0 |
| 1.9 | Create `AuthProvider` (Riverpod) with state management | 2 hours | P0 |
| 1.10 | Build Login screen UI | 3 hours | P0 |
| 1.11 | Build Sign-Up screen UI | 2 hours | P0 |
| 1.12 | Build Forgot Password screen UI | 1 hour | P1 |
| 1.13 | Implement Google Sign-In flow | 2 hours | P0 |
| 1.14 | Implement auth state persistence (stay logged in) | 1 hour | P0 |
| 1.15 | Set up secure token storage | 1 hour | P0 |
| 1.16 | Implement route guards (redirect unauthenticated users) | 1 hour | P0 |
| 1.17 | Write unit tests for auth provider and repository | 3 hours | P1 |
| 1.18 | Write widget tests for auth screens | 2 hours | P1 |

**Estimated Total**: ~28 hours

### 2.3 Deliverables

- [x] Flutter project scaffolded with full folder structure
- [x] Theme system (light + dark mode)
- [x] Reusable UI component library (buttons, fields, dialogs)
- [x] Login screen with email + Google Sign-In
- [x] Sign-Up screen with email + password validation
- [x] Forgot Password screen with email reset
- [x] Auth state management with Riverpod
- [x] Secure token storage
- [x] Route guards for protected screens
- [x] Unit tests for auth logic
- [x] Widget tests for auth screens

### 2.4 Acceptance Criteria

| Criterion | How to Verify |
|---|---|
| New user can create account | Sign-up with email → receive verification → sign in |
| Existing user can sign in | Enter credentials → redirected to dashboard |
| Google Sign-In works | Tap Google button → complete OAuth → redirected to dashboard |
| Forgot password works | Enter email → receive reset link → create new password → sign in |
| Unauthenticated users can't access dashboard | Navigate to dashboard without login → redirected to login |
| Tokens persist across app restart | Sign in, close app, reopen → still signed in |
| Sign out clears session | Sign out → navigate back → cannot access dashboard |

---

## 3. Phase 2: Dashboard

> **Week 2** | Goal: Users can see, organize, and upload their documents

### 3.1 Objectives

- Build the main dashboard screen
- Implement folder management
- Implement document upload flow
- Build document card/grid display

### 3.2 Tasks

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 2.1 | Create `DocumentRepository` interface and Hive implementation | 3 hours | P0 |
| 2.2 | Create `FolderRepository` interface and Hive implementation | 2 hours | P0 |
| 2.3 | Define `DocumentModel` and `FolderModel` with Freezed | 2 hours | P0 |
| 2.4 | Create `DashboardProvider` (document list, folder filter) | 2 hours | P0 |
| 2.5 | Create `FolderProvider` (folder CRUD) | 1.5 hours | P0 |
| 2.6 | Build Dashboard screen with grid/list toggle | 3 hours | P0 |
| 2.7 | Build `DocumentCard` widget (thumbnail, title, metadata) | 2 hours | P0 |
| 2.8 | Build `DocumentListTile` widget (list view variant) | 1 hour | P1 |
| 2.9 | Build `FolderCard` widget | 1.5 hours | P0 |
| 2.10 | Implement PDF thumbnail generation | 2 hours | P0 |
| 2.11 | Implement document upload flow (file picker → validate → store) | 3 hours | P0 |
| 2.12 | Build upload progress indicator | 1 hour | P1 |
| 2.13 | Implement folder CRUD (create, rename, delete) | 2 hours | P0 |
| 2.14 | Implement document move-to-folder | 1.5 hours | P1 |
| 2.15 | Build empty state widget for dashboard | 1 hour | P1 |
| 2.16 | Implement sort and search on document list | 2 hours | P1 |
| 2.17 | Set up Supabase database tables (per architecture.md) | 1.5 hours | P0 |
| 2.18 | Implement basic cloud sync for document metadata | 2 hours | P1 |
| 2.19 | Write unit tests for dashboard and folder providers | 3 hours | P1 |
| 2.20 | Write widget tests for dashboard widgets | 2 hours | P1 |

**Estimated Total**: ~37 hours

### 3.3 Deliverables

- [x] Dashboard screen with document grid and list views
- [x] Document cards with thumbnails, titles, and metadata
- [x] Folder creation, renaming, deletion
- [x] Document upload from device (PDF validation)
- [x] Upload progress indicator
- [x] Document move-to-folder functionality
- [x] Empty state illustrations
- [x] Sort (recent, name, date) and search
- [x] Supabase database setup with all tables
- [x] Basic cloud sync for metadata
- [x] Unit and widget tests

### 3.4 Acceptance Criteria

| Criterion | How to Verify |
|---|---|
| Dashboard loads user's documents | Sign in → see document cards in grid |
| New documents appear after upload | Tap FAB → upload PDF → card appears in grid |
| Thumbnails display correctly | Document card shows first page preview |
| Folders can be created/renamed/deleted | Create folder → rename → move docs → delete (docs become unassigned) |
| Grid/list view toggle works | Toggle button switches between views |
| Search filters documents | Type in search bar → only matching documents shown |
| Documents persist locally | Upload docs → restart app → all docs still visible |
| Cloud metadata syncs | Upload doc → check Supabase → metadata row exists |

---

## 4. Phase 3: Document Viewer & Annotations

> **Weeks 3–4** | Goal: Users can read PDFs, highlight text, and add sticky notes

### Week 3: Document Viewer + Highlighting

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 3.1 | Implement PDF rendering with pdfx (page-by-page) | 4 hours | P0 |
| 3.2 | Implement pinch-to-zoom and pan gestures | 3 hours | P0 |
| 3.3 | Build page navigation (swipe, page indicator) | 2 hours | P0 |
| 3.4 | Build jump-to-page input | 1 hour | P1 |
| 3.5 | Create `ViewerProvider` (current page, zoom level) | 2 hours | P0 |
| 3.6 | Implement text selection on PDF pages | 3 hours | P0 |
| 3.7 | Build highlight color picker toolbar | 2 hours | P0 |
| 3.8 | Implement highlight persistence (Hive) | 2 hours | P0 |
| 3.9 | Build highlight rendering overlay on PDF | 3 hours | P0 |
| 3.10 | Implement highlight tap-to-edit/delete | 2 hours | P1 |
| 3.11 | Build annotation toolbar (highlight, note, undo/redo) | 2 hours | P0 |
| 3.12 | Create `HighlightProvider` with undo/redo stack | 3 hours | P0 |

**Week 3 Estimated Total**: ~29 hours

### Week 4: Sticky Notes + Polish

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 4.1 | Implement sticky note creation (long-press) | 2 hours | P0 |
| 4.2 | Build note editor (expandable, max 500 chars) | 2 hours | P0 |
| 4.3 | Implement note persistence (Hive) | 1.5 hours | P0 |
| 4.4 | Build note pin rendering on PDF pages | 2 hours | P0 |
| 4.5 | Implement note tap-to-edit/delete | 1.5 hours | P0 |
| 4.6 | Build annotation list screen (highlights + notes per document) | 3 hours | P1 |
| 4.7 | Implement cloud sync for annotations | 2 hours | P1 |
| 4.8 | Optimize PDF page rendering (lazy-load, caching) | 3 hours | P0 |
| 4.9 | Memory optimization for large PDFs (100+ pages) | 2 hours | P0 |
| 4.10 | Build document info panel (title, page count, date) | 1 hour | P1 |
| 4.11 | Polish annotation UI (colors, animations, transitions) | 2 hours | P1 |
| 4.12 | Write unit tests for viewer and annotation logic | 3 hours | P1 |
| 4.13 | Write widget tests for viewer and annotation widgets | 3 hours | P1 |

**Week 4 Estimated Total**: ~26 hours

### 4.1 Deliverables

- [x] PDF viewer with smooth rendering and zoom/pan
- [x] Page navigation (swipe + page indicator + jump-to-page)
- [x] Text selection with highlight toolbar
- [x] 4-color highlight system
- [x] Sticky note creation with pin placement
- [x] Note editor with character limit
- [x] Undo/redo for all annotation actions (50-action depth)
- [x] Annotation list view per document
- [x] Annotation cloud sync
- [x] Performance optimization for large PDFs
- [x] Unit and widget tests

### 4.2 Acceptance Criteria

| Criterion | How to Verify |
|---|---|
| PDF renders correctly | Open any PDF → pages display without distortion |
| Zoom works smoothly | Pinch to zoom in/out → smooth 0.5x–5x range |
| Page navigation works | Swipe between pages → indicator updates correctly |
| Highlighting works | Select text → tap color → highlight appears with correct color |
| Sticky notes work | Long-press → add note → pin appears → tap to expand |
| Undo/redo works | Highlight text → undo → highlight removed → redo → highlight restored |
| Annotations persist | Add highlights/notes → close document → reopen → all annotations present |
| Large PDFs don't crash | Open a 200-page PDF → navigate freely without memory issues |
| Annotations sync to cloud | Add annotation → check Supabase → record exists |

---

## 5. Phase 4: AI Features

> **Weeks 5–6** | Goal: Users can summarize documents and chat with AI about content

### Week 5: Text Extraction + Summarization

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 5.1 | Set up NVIDIA Nemotron API integration | 2 hours | P0 |
| 5.2 | Build `AIService` interface + Nemotron implementations | 3 hours | P0 |
| 5.3 | Create Supabase Edge Functions for API proxy | 3 hours | P0 |
| 5.4 | Implement PDF-to-image conversion for text extraction | 2 hours | P0 |
| 5.5 | Build text extraction pipeline (Nemotron-Parse) | 3 hours | P0 |
| 5.6 | Store extracted text + bounding boxes in Hive | 2 hours | P0 |
| 5.7 | Build `SummaryProvider` with caching | 2 hours | P0 |
| 5.8 | Build summary UI (bottom sheet, scope selector) | 3 hours | P0 |
| 5.9 | Implement rate limiting (client-side) | 1.5 hours | P0 |
| 5.10 | Implement summary caching (avoid re-processing) | 1.5 hours | P0 |
| 5.11 | Build summary display card (copy, share) | 2 hours | P1 |
| 5.12 | Handle AI errors gracefully | 2 hours | P0 |

**Week 5 Estimated Total**: ~27 hours

### Week 6: AI Q&A Chat

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 6.1 | Build `ChatProvider` with message history | 2 hours | P0 |
| 6.2 | Build AI Chat screen (full-screen chat interface) | 4 hours | P0 |
| 6.3 | Build `ChatBubble` widget (user + assistant variants) | 2 hours | P0 |
| 6.4 | Build `ChatInputBar` widget (text input + send button) | 2 hours | P0 |
| 6.5 | Build `TypingIndicator` widget | 1 hour | P1 |
| 6.6 | Build `CitationBadge` widget (page references) | 1.5 hours | P0 |
| 6.7 | Implement chat history persistence (Hive) | 1.5 hours | P0 |
| 6.8 | Implement chat context loading (active document) | 2 hours | P0 |
| 6.9 | Implement follow-up question support | 2 hours | P1 |
| 6.10 | Build chat history list per document | 1.5 hours | P1 |
| 6.11 | Add "AI-generated" disclaimer to all AI responses | 30 min | P0 |
| 6.12 | Implement AI query daily limit display | 1 hour | P1 |
| 6.13 | End-to-end integration testing of AI pipeline | 3 hours | P0 |
| 6.14 | Performance testing (response time, memory) | 2 hours | P0 |
| 6.15 | Write unit tests for AI providers and services | 3 hours | P1 |

**Week 6 Estimated Total**: ~29.5 hours

### 5.1 Deliverables

- [x] NVIDIA Nemotron integration (Parse + Ultra 550B)
- [x] Supabase Edge Functions for secure API proxy
- [x] Text extraction pipeline with bounding boxes
- [x] AI Summarization (page, section, selection scope)
- [x] AI Q&A chat interface
- [x] Chat history persistence
- [x] Citation/page references in AI responses
- [x] Rate limiting (client + server)
- [x] Response caching
- [x] Error handling for AI failures
- [x] "AI-generated" disclaimers
- [x] Unit and integration tests

### 5.2 Acceptance Criteria

| Criterion | How to Verify |
|---|---|
| Text extraction works | Upload PDF → extracted text stored locally → searchable |
| Summarization works | Open document → tap "Summarize" → summary appears within 5 seconds |
| Q&A works | Open document → ask question → answer appears with page citations |
| Rate limiting works | Send 41 requests rapidly → 41st shows "daily limit reached" message |
| Caching works | Ask same question twice → second response is instant (from cache) |
| AI failures are handled gracefully | Disconnect network → try AI → error message shown, app doesn't crash |
| Citations are accurate | AI references "Page 3" → that page actually contains the referenced info |
| Chat history persists | Send messages → close document → reopen → chat history still visible |

---

## 6. Phase 5: Testing & QA

> **Week 7** | Goal: App is stable, performant, and accessible

### 6.1 Tasks

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 7.1 | Run full unit test suite — fix all failures | 4 hours | P0 |
| 7.2 | Run full widget test suite — fix all failures | 4 hours | P0 |
| 7.3 | Write integration tests for critical flows | 6 hours | P0 |
| 7.4 | Performance profiling on low-end device (2GB RAM) | 3 hours | P0 |
| 7.5 | Memory leak detection and fixes | 3 hours | P0 |
| 7.6 | Accessibility audit (screen readers, contrast) | 3 hours | P0 |
| 7.7 | Localization audit — ensure all strings are in ARB files | 2 hours | P1 |
| 7.8 | Security audit — API keys, token storage, RLS | 2 hours | P0 |
| 7.9 | UI polish pass — animations, transitions, spacing | 4 hours | P1 |
| 7.10 | Bug bash — test every feature end-to-end | 4 hours | P0 |
| 7.11 | Fix all P0 bugs discovered | 4 hours | P0 |
| 7.12 | Fix all P1 bugs discovered | 3 hours | P1 |
| 7.13 | Update README.md with final setup instructions | 1 hour | P1 |
| 7.14 | Record screen captures for app store | 2 hours | P1 |

**Estimated Total**: ~45 hours

### 6.2 Deliverables

- [x] Full test suite passing (unit + widget + integration)
- [x] Performance benchmarks met on target devices
- [x] Zero memory leaks
- [x] Accessibility compliance (WCAG 2.1 AA)
- [x] All strings localized
- [x] Security audit complete
- [x] All P0 bugs fixed
- [x] UI polished and consistent
- [x] App store assets ready

### 6.3 Quality Gates

| Gate | Requirement to Pass |
|---|---|
| Unit test coverage | ≥ 80% for domain and data layers |
| Widget test coverage | All screens and key widgets |
| Lint warnings | 0 warnings in `flutter analyze` |
| Performance | Cold start < 2s, PDF render < 500ms, AI < 8s |
| Memory | Peak usage < 200MB during normal use |
| Crash rate | 0 crashes in 100-session manual test |
| Accessibility | All interactive elements have semantic labels |

---

## 7. Phase 6: Deployment

> **Week 8** | Goal: App is live on Google Play and App Store

### 7.1 Tasks

| # | Task | Estimated Time | Priority |
|---|---|---|---|
| 8.1 | Set up GitHub Actions CI/CD pipeline | 3 hours | P0 |
| 8.2 | Configure Android release build (signing, ProGuard) | 2 hours | P0 |
| 8.3 | Configure iOS release build (signing, provisioning) | 3 hours | P0 |
| 8.4 | Create Google Play Store listing | 2 hours | P0 |
| 8.5 | Create App Store listing | 2 hours | P0 |
| 8.6 | Generate app store screenshots (all required sizes) | 2 hours | P0 |
| 8.7 | Write app store descriptions (short + full) | 1 hour | P0 |
| 8.8 | Set up Supabase production environment | 1 hour | P0 |
| 8.9 | Configure NVIDIA API keys in Supabase Edge Functions (prod) | 1 hour | P0 |
| 8.10 | Deploy Vercel admin panel (if ready) | 1 hour | P2 |
| 8.11 | Submit to Google Play (internal testing track) | 1 hour | P0 |
| 8.12 | Submit to App Store (TestFlight) | 1 hour | P0 |
| 8.13 | Test on physical devices via TestFlight / Play Internal | 2 hours | P0 |
| 8.14 | Fix any store review issues | 2 hours | P0 |
| 8.15 | Submit for production review | 1 hour | P0 |
| 8.16 | Monitor initial user feedback | Ongoing | P0 |

**Estimated Total**: ~25 hours

### 7.2 Deliverables

- [x] CI/CD pipeline running on GitHub Actions
- [x] Signed release builds for Android and iOS
- [x] Google Play Store listing live
- [x] App Store listing live
- [x] Production Supabase environment configured
- [x] NVIDIA API keys secured in Edge Functions
- [x] Initial user feedback monitoring

### 7.3 Release Checklist

**Pre-Release**
- [ ] All P0 bugs fixed
- [ ] All tests passing
- [ ] No lint warnings
- [ ] Release build signed and tested
- [ ] API keys configured in production
- [ ] Supabase RLS policies verified
- [ ] Rate limits configured and tested
- [ ] Error logging working in production

**Store Submission**
- [ ] App icon (1024x1024)
- [ ] Screenshots (phone + tablet for both stores)
- [ ] App description (short + full)
- [ ] Privacy policy URL
- [ ] Terms of service URL
- [ ] Category: Education
- [ ] Age rating: Everyone
- [ ] Content rating questionnaire completed

**Post-Release**
- [ ] Monitor crash reports (first 48 hours)
- [ ] Monitor user reviews (respond within 24 hours)
- [ ] Verify analytics tracking
- [ ] Check API usage against free tier limits
- [ ] Plan hotfix process for critical bugs

---

## 8. Phase Dependencies

```
Phase 1 (Auth) ──────────────────────┐
                                      │
Phase 2 (Dashboard) ─────────────────┤
                                      │
Phase 3 (Viewer + Annotations) ──────┤
                                      │
Phase 4 (AI Features) ───────────────┤
                                      │
Phase 5 (Testing & QA) ──────────────┤
                                      │
Phase 6 (Deployment) ────────────────┘
```

| Dependency | Description |
|---|---|
| Phase 2 → Phase 1 | Dashboard needs authentication to know which user's documents to show |
| Phase 3 → Phase 2 | Viewer needs documents to exist before they can be opened |
| Phase 4 → Phase 3 | AI features need document text to summarize and answer questions about |
| Phase 5 → Phases 1-4 | Testing requires all features to be implemented |
| Phase 6 → Phase 5 | Deployment requires testing to be complete |

**Parallel Work Opportunities**
- Phase 1 (theme, UI components) can overlap with Phase 2 setup
- Supabase database setup (Phase 2) can start alongside Phase 1
- CI/CD pipeline setup can begin in Phase 1
- App store account creation should happen in Week 1 (approval takes time)

---

## 9. Definition of Done

A feature is "done" when ALL of the following are true:

| Criterion | Detail |
|---|---|
| Code complete | Feature works as specified |
| Tests written | Unit tests for logic, widget tests for UI |
| Tests passing | All tests green, no flaky tests |
| Lint clean | `flutter analyze` shows zero warnings |
| Error handled | All error paths show user-friendly messages |
| Localized | All user-facing strings in ARB files |
| Accessible | Screen reader labels, minimum tap targets (48dp) |
| Documented | Complex logic has inline comments |
| Reviewed | Code reviewed by at least one other person |
| Works offline | Graceful degradation when network is unavailable |
| Performs well | No jank, no memory leaks, meets timing targets |
