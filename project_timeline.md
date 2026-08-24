# MindSpace — Project Timeline

> **Version**: 1.0 — August 2026
> **Last Updated**: August 24, 2026
> **Total Duration**: 8 Weeks (MVP)
> **Start Date**: TBD
> **Target Launch**: Start Date + 8 Weeks

---

## Table of Contents

1. [Timeline Overview](#1-timeline-overview)
2. [Week-by-Week Breakdown](#2-week-by-week-breakdown)
3. [Milestones & Deliverables](#3-milestones--deliverables)
4. [Risk Assessment](#4-risk-assessment)
5. [Resource Requirements](#5-resource-requirements)
6. [Critical Path](#6-critical-path)
7. [Buffer & Contingency](#7-buffer--contingency)

---

## 1. Timeline Overview

```
Week 1    Week 2    Week 3    Week 4    Week 5    Week 6    Week 7    Week 8
│─────────│─────────│─────────│─────────│─────────│─────────│─────────│─────────│
│ PHASE 1 │ PHASE 2 │         PHASE 3        │         PHASE 4        │ PHASE 5 │ PHASE 6 │
│ Auth    │Dashboard│     Viewer + Annot.    │    AI Features         │Testing  │ Deploy  │
│         │         │                        │                        │         │         │
│ ●───────│●────────│●───────────────────────│●───────────────────────│●────────│●────────│
│ Setup   │Upload   │PDF Rendering           │Text Extraction         │Bug Fix  │App Store│
│ Login   │Folders  │Highlighting            │Summarization           │Perf     │Play Stor│
│ Signup  │Dashboard│Sticky Notes            │AI Chat                 │Access.  │CI/CD    │
│         │         │Undo/Redo               │Edge Functions          │         │         │
│         │         │                        │                        │         │         │
│ M1: Auth│M2: Docs │M3: Reader     M4: Full │M5: AI Summ   M6: Chat │M7: QA   │M8: Live │
│ Working │Uploading│Rendering     Annotate  │Working      Working   │Passing  │Shipped  │
```

| Week | Phase | Focus Area | Working Hours (est.) |
|---|---|---|---|
| Week 1 | Phase 1 | Authentication | 28 hours |
| Week 2 | Phase 2 | Dashboard | 37 hours |
| Week 3 | Phase 3 (Part A) | Document Viewer + Highlighting | 29 hours |
| Week 4 | Phase 3 (Part B) | Sticky Notes + Polish | 26 hours |
| Week 5 | Phase 4 (Part A) | Text Extraction + Summarization | 27 hours |
| Week 6 | Phase 4 (Part B) | AI Q&A Chat | 29.5 hours |
| Week 7 | Phase 5 | Testing & QA | 45 hours |
| Week 8 | Phase 6 | Deployment | 25 hours |
| **Total** | | | **~246.5 hours** |

---

## 2. Week-by-Week Breakdown

### Week 1: Authentication

**Goal**: Users can sign up, sign in, sign out, and reset passwords.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Initialize Flutter project; configure pubspec.yaml; set up folder structure | 3 | Project scaffold |
| Mon | Create Supabase project; configure auth settings; set up env.dart | 2 | Backend connected |
| Tue | Create theme system (light/dark); define color tokens; set up typography | 2 | Theme system |
| Tue | Build reusable UI components (buttons, text fields, dialogs, loading) | 3 | Component library |
| Wed | Implement AuthRepository + Supabase implementation; create AuthProvider | 4 | Auth logic working |
| Thu | Build Login screen; build Sign-Up screen; build Forgot Password screen | 5 | Auth screens |
| Fri | Implement Google Sign-In; auth state persistence; route guards | 3 | Full auth flow |
| Sat | Write unit tests for auth; write widget tests for auth screens | 5 | Tests passing |
| Sun | Buffer / fix issues / code review | 3 | Phase 1 complete |

**End of Week 1 Milestone** (M1):
- ✅ User can create account with email
- ✅ User can sign in with email or Google
- ✅ User can sign out
- ✅ User can reset password
- ✅ Unauthenticated users are redirected to login
- ✅ Session persists across app restart

---

### Week 2: Dashboard

**Goal**: Users can upload, view, and organize documents in folders.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Create DocumentRepository + FolderRepository (Hive); define models with Freezed | 5 | Data layer |
| Tue | Create DashboardProvider + FolderProvider; set up Supabase database tables | 4 | State + cloud |
| Wed | Build Dashboard screen (grid/list toggle); build DocumentCard widget | 5 | Dashboard UI |
| Thu | Implement document upload flow (file picker → validate → store → thumbnail) | 5 | Upload working |
| Fri | Build folder CRUD; build folder cards; implement document move-to-folder | 4 | Folder system |
| Sat | Build empty state; implement sort + search; basic cloud sync | 5 | Polish |
| Sun | Write unit + widget tests for dashboard and folders | 4 | Tests passing |

**End of Week 2 Milestone** (M2):
- ✅ Dashboard shows all user documents in grid/list view
- ✅ User can upload PDFs from device
- ✅ Thumbnails are generated for each document
- ✅ User can create, rename, and delete folders
- ✅ User can move documents between folders
- ✅ User can search and sort documents
- ✅ Document metadata syncs to Supabase

---

### Week 3: Document Viewer + Highlighting

**Goal**: Users can read PDFs and highlight text with 4 colors.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Implement PDF rendering with pdfx (page-by-page lazy loading) | 4 | PDF renders |
| Tue | Implement pinch-to-zoom and pan gestures; page navigation | 5 | Zoom + navigate |
| Wed | Implement text selection on PDF; build highlight color picker toolbar | 5 | Text selection |
| Thu | Implement highlight persistence (Hive); build highlight rendering overlay | 5 | Highlights working |
| Fri | Create ViewerProvider + HighlightProvider with undo/redo stack | 5 | State management |
| Sat | Build annotation toolbar; implement highlight tap-to-edit/delete | 3 | Annotation toolbar |
| Sun | Write unit + widget tests; optimize page rendering | 2 | Tests + perf |

**End of Week 3 Milestone** (M3):
- ✅ PDF renders with smooth zoom and pan
- ✅ User can swipe between pages
- ✅ User can select text on PDF
- ✅ User can apply 4-color highlights
- ✅ Highlights persist locally

---

### Week 4: Sticky Notes + Polish

**Goal**: Users can add sticky notes, use undo/redo, and all annotations sync to cloud.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Implement sticky note creation; build note editor; note persistence | 5.5 | Sticky notes |
| Tue | Build note pin rendering; implement note tap-to-edit/delete | 3.5 | Notes working |
| Wed | Build annotation list screen; implement cloud sync for annotations | 5 | Annotation sync |
| Thu | Optimize PDF page rendering; memory optimization for large PDFs | 5 | Performance |
| Fri | Polish annotation UI (colors, animations, transitions) | 2 | UI polish |
| Sat | Build document info panel; write unit + widget tests | 4 | Tests |
| Sun | Buffer / integration testing / code review | 1 | Phase 3 complete |

**End of Week 4 Milestone** (M4):
- ✅ Users can add sticky notes anchored to document positions
- ✅ Full undo/redo for all annotations (50-action depth)
- ✅ All annotations sync to Supabase
- ✅ Large PDFs (200 pages) render without crashes
- ✅ Memory usage stays under 200MB

---

### Week 5: Text Extraction + Summarization

**Goal**: AI can extract text from PDFs and generate summaries.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Set up NVIDIA Nemotron API integration; build AIService interface | 5 | AI service layer |
| Tue | Create Supabase Edge Functions (summarize, chat, extract-text) | 6 | Edge functions |
| Wed | Implement PDF-to-image conversion; build text extraction pipeline | 5 | Text extraction |
| Thu | Store extracted text + bounding boxes in Hive; build SummaryProvider | 4.5 | Extraction working |
| Fri | Build summary UI (bottom sheet, scope selector, summary card) | 5 | Summarization UI |
| Sat | Implement rate limiting (client-side); implement summary caching | 2 | Rate limits |
| Sun | Handle AI errors gracefully; write tests | 2.5 | Error handling |

**End of Week 5 Milestone** (M5):
- ✅ Text extraction pipeline extracts structured text from PDFs
- ✅ Users can summarize pages, sections, or selections
- ✅ Summaries display with source references
- ✅ Rate limiting prevents API abuse
- ✅ Summary caching avoids redundant API calls

---

### Week 6: AI Q&A Chat

**Goal**: Users can have natural language conversations about their documents.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Build ChatProvider with message history; create AI Chat screen | 6 | Chat screen |
| Tue | Build ChatBubble, ChatInputBar, TypingIndicator widgets | 5 | Chat widgets |
| Wed | Build CitationBadge widget; implement chat context loading | 3.5 | Citations working |
| Thu | Implement chat history persistence (Hive); follow-up question support | 3.5 | Chat persistence |
| Fri | Build chat history list; add AI-generated disclaimers; daily limit display | 2.5 | Chat polish |
| Sat | End-to-end integration testing of full AI pipeline | 5 | Integration tested |
| Sun | Performance testing; write unit tests | 4 | Tests passing |

**End of Week 6 Milestone** (M6):
- ✅ Users can ask questions about their documents
- ✅ AI responses include page citations
- ✅ Chat history persists per document
- ✅ Follow-up questions work within context
- ✅ All AI responses include "AI-generated" disclaimer
- ✅ Full AI pipeline tested end-to-end

---

### Week 7: Testing & QA

**Goal**: App is stable, performant, and accessible.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Run full unit test suite; fix all failures; aim for 80%+ coverage | 8 | Tests green |
| Tue | Run full widget test suite; fix all failures | 8 | Widget tests green |
| Wed | Write integration tests for critical user flows | 6 | Integration tests |
| Thu | Performance profiling on low-end device; memory leak detection | 6 | Performance verified |
| Fri | Accessibility audit (screen readers, contrast, tap targets) | 3 | Accessibility pass |
| Sat | Localization audit; security audit; bug bash | 7 | Audits complete |
| Sun | Fix all P0 bugs; fix P1 bugs; UI polish pass | 7 | All bugs fixed |

**End of Week 7 Milestone** (M7):
- ✅ All tests passing (unit, widget, integration)
- ✅ 80%+ test coverage for domain and data layers
- ✅ Zero lint warnings
- ✅ Cold start < 2 seconds on target device
- ✅ Memory usage < 200MB during normal use
- ✅ Zero crashes in 100-session manual test
- ✅ All interactive elements have semantic labels
- ✅ All strings in localization files

---

### Week 8: Deployment

**Goal**: App is live on Google Play and App Store.

| Day | Tasks | Hours | Deliverable |
|---|---|---|---|
| Mon | Set up GitHub Actions CI/CD; configure Android release build | 5 | CI/CD + Android build |
| Tue | Configure iOS release build; generate app store screenshots | 5 | iOS build + assets |
| Wed | Create Google Play Store listing; create App Store listing | 5 | Store listings |
| Thu | Set up Supabase production; configure NVIDIA keys in prod Edge Functions | 2 | Production backend |
| Fri | Submit to Google Play (internal testing) + App Store (TestFlight) | 2 | Submitted |
| Sat | Test on physical devices via TestFlight / Play Internal; fix issues | 4 | Verified |
| Sun | Submit for production review; monitor | 2 | Live! |

**End of Week 8 Milestone** (M8):
- ✅ CI/CD pipeline running
- ✅ Signed release builds for Android and iOS
- ✅ Google Play Store listing live
- ✅ App Store listing live
- ✅ Production backend configured and secured
- ✅ App available for download

---

## 3. Milestones & Deliverables

| Milestone | Week | Key Deliverable | Acceptance Gate |
|---|---|---|---|
| **M1**: Auth Working | End of Week 1 | Full auth flow (signup, login, Google, reset) | User can complete all auth flows without errors |
| **M2**: Documents Uploading | End of Week 2 | Dashboard with upload, folders, grid/list | User can upload PDF and see it in dashboard |
| **M3**: PDF Rendering | End of Week 3 | PDF viewer with zoom/pan + highlighting | User can read PDF and apply 4-color highlights |
| **M4**: Full Annotations | End of Week 4 | Sticky notes + undo/redo + cloud sync | All annotation types work and persist |
| **M5**: AI Summarization | End of Week 5 | Text extraction + summary generation | User can get AI summaries of document sections |
| **M6**: AI Chat Working | End of Week 6 | Full AI Q&A chat with citations | User can ask questions and get cited answers |
| **M7**: QA Passing | End of Week 7 | All tests green, performance targets met | Zero P0 bugs, all quality gates pass |
| **M8**: Live on Stores | End of Week 8 | App published on Google Play + App Store | App available for public download |

---

## 4. Risk Assessment

### 4.1 High-Risk Items

| Risk | Probability | Impact | Mitigation | Owner |
|---|---|---|---|---|
| **Nemotron free tier changes** | Medium | Critical | Abstract AI layer behind interface; prepare Gemini fallback | Dev Lead |
| **PDF text selection not working** | Medium | High | pdfx may need custom overlay; prototype in Week 3 Day 1; fallback: image-based OCR | Dev Lead |
| **Supabase free tier limit hit** | Low | High | Store minimal data in cloud; maximize local Hive usage; monitor storage | Dev Lead |
| **Low-end device memory crashes** | Medium | High | Aggressive lazy-loading; limit cached pages to 10; test on 2GB RAM device weekly | Dev |
| **App Store rejection** | Low | High | Follow guidelines strictly; prepare privacy policy early; test thoroughly | Dev Lead |
| **AI response latency > 8s** | Medium | Medium | Cache aggressively; use Nano model for simple queries; show typing indicator | Dev |
| **Scope creep (V2 features in MVP)** | High | Medium | Strict adherence to MVP feature list; V2 features deferred to backlog | PM |

### 4.2 Medium-Risk Items

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Code generation conflicts (Freezed + Hive) | Medium | Medium | Use `--delete-conflicting-outputs`; keep models simple |
| Google OAuth setup complexity | Low | Medium | Follow Supabase docs exactly; test early in Week 1 |
| CI/CD pipeline failures | Low | Medium | Set up CI in Week 1; fix issues incrementally |
| Localization completeness | Medium | Low | Audit all strings in Week 7; use ARB file consistently |
| Performance on old iPhones | Low | Medium | Test on iPhone 8 (A11 Bionic) as minimum target |

### 4.3 Risk Matrix

```
              │ Low Impact    │ Medium Impact │ High Impact   │ Critical Impact
──────────────┼───────────────┼───────────────┼───────────────┼────────────────
High Prob.    │               │ Scope Creep   │               │
Medium Prob.  │               │ Gen Conflicts │ PDF Selection │ Nemotron Change
              │               │ AI Latency    │ Memory Crash  │
              │               │ Localization  │               │
Low Prob.     │ Old iPhones   │ OAuth Setup   │ Supabase Limit│ App Store Reject
              │               │ CI Failures   │               │
```

---

## 5. Resource Requirements

### 5.1 Human Resources

| Role | Count | Commitment | Responsibilities |
|---|---|---|---|
| **Full-Stack Flutter Developer** | 1 | Full-time (8 weeks) | All development, testing, deployment |
| **Product Manager / Lead** | 1 | Part-time (5 hrs/week) | Requirements, design review, acceptance testing |

### 5.2 Hardware Requirements

| Device | Purpose | Cost |
|---|---|---|
| Development machine (macOS or Linux) | Primary development | Existing |
| Android phone (budget, 2GB RAM) | Performance testing | ~$100-150 |
| iPhone (iPhone 8 or newer) | iOS testing | Existing or ~$150 |
| Android emulator (API 26+) | Daily development | Free (comes with Android Studio) |
| iOS simulator (iOS 13+) | Daily development | Free (comes with Xcode, macOS only) |

### 5.3 Service Costs

| Service | Cost | Notes |
|---|---|---|
| Supabase | $0/month | Free tier covers MVP |
| NVIDIA Nemotron | $0/month | Free tier covers MVP |
| GitHub | $0/month | Free for public repos |
| GitHub Actions | $0/month | 2,000 minutes/month free |
| Vercel | $0/month | Free tier for admin panel |
| Google Play Developer | $25 (one-time) | Required for Play Store |
| Apple Developer | $99/year | Required for App Store |
| Domain (optional) | ~$12/year | For privacy policy / landing page |
| **Total** | **~$136-236** | First year cost |

### 5.4 Software Requirements

| Software | Version | Purpose |
|---|---|---|
| Flutter SDK | 3.24+ | Development framework |
| Dart SDK | 3.5+ | Programming language |
| Android Studio | Latest | Android development |
| Xcode | Latest (macOS) | iOS development |
| VS Code | Latest | Primary IDE |
| Git | 2.30+ | Version control |
| Supabase CLI | Latest | Backend management |
| Chrome | Latest | Web testing |
| Figma (optional) | Free tier | Design mockups |

---

## 6. Critical Path

The critical path determines the minimum time to complete the project. Any delay on the critical path delays the entire project.

```
Flutter Setup → Auth → Dashboard → PDF Viewer → Text Extraction → AI Chat → Testing → Deployment
     1d           5d      5d          5d            5d             5d        5d         5d
```

**Critical Path Duration**: 36 working days (approximately 7-8 weeks)

**Float (non-critical activities)**:
- Theme system: Can be done in parallel with auth screens (1 day float)
- CI/CD setup: Can start in Week 1 (5 days float)
- App store account creation: Should start immediately (14+ days for approval)
- Localization: Can be done incrementally throughout (7 days float)

### Key Dependencies on Critical Path

| Dependency | Blocks |
|---|---|
| Auth complete | Dashboard can show user-specific content |
| Dashboard complete | Documents exist to view |
| PDF viewer complete | Text can be selected for AI extraction |
| Text extraction complete | AI can summarize and answer questions |
| AI chat complete | Final QA can test full user flow |
| QA complete | Safe to deploy |

---

## 7. Buffer & Contingency

### 7.1 Built-in Buffer

| Buffer Type | Amount | When Used |
|---|---|---|
| Sunday buffer (weekly) | 2-4 hours/week | Catch up on missed tasks; fix issues |
| Week 7 heavy testing | 45 hours (highest week) | Absorb delays from earlier weeks |
| Scope deferral | V2 features → backlog | If MVP timeline is at risk |

### 7.2 Contingency Plans

**If 1 week behind schedule:**
1. Defer all P1 features to post-MVP patch
2. Reduce widget tests to critical-path screens only
3. Simplify UI animations (use simple fades instead of complex transitions)
4. Skip golden tests

**If 2 weeks behind schedule:**
1. All of the above, plus:
2. Defer cloud sync to post-MVP (annotations stay local-only initially)
3. Reduce summary UI to single scope (page-level only)
4. Simplify onboarding to single screen

**If AI integration is blocked:**
1. Ship MVP without AI features
2. AI features become V1.1 release (1 week after MVP)
3. All other features work without AI

**If App Store rejection:**
1. Address rejection reasons immediately
2. Submit to TestFlight for continued testing
3. Resubmit within 48 hours of fixing issues

### 7.3 Weekly Check-in Points

| Day | Activity | Decision |
|---|---|---|
| Monday | Review week plan | Are we on track? Adjust if needed |
| Wednesday | Mid-week check | Any blockers? Re-prioritize if needed |
| Friday | End-of-week review | Milestone progress? Update timeline |
| Sunday | Buffer day | Catch up or prepare for next week |

---

## Appendix: Post-MVP Roadmap

| Timeframe | Feature | Priority |
|---|---|---|
| Month 3 | AI Flashcards | High |
| Month 3 | Quiz Generator | High |
| Month 3 | Smart Search across all documents | Medium |
| Month 4 | Collaboration (share with classmates) | Medium |
| Month 4 | Export notes (PDF, Word, Markdown) | Medium |
| Month 5 | Web Clipper browser extension | Low |
| Month 5 | Multi-device sync | High |
| Month 6 | Pro tier monetization launch | High |
| Month 6 | Institutional tier development | Medium |
| Month 9 | Web app (Flutter Web) | Low |
| Month 12 | Tablet-optimized layout | Medium |
