# MindSpace — Project Memory

> **Version**: 3.0 — August 2026
> **Last Updated**: August 26, 2026

---

## Purpose

This file maintains context across development sessions. It records important decisions, tracks completed work, logs changes, and captures the current state of the project. **Update this file at the end of every development session.**

---

## Project Status

| Component | Status | Notes |
|-----------|--------|-------|
| Flutter Setup | ✅ Complete | Flutter 3.44.7 installed and working |
| Phase 1 - Auth | ✅ Complete | Puter token-based auth, no Google OAuth |
| Phase 2 - Dashboard | ✅ Complete | Document grid, folders, search, sort |
| Phase 3 - PDF Viewer | ✅ Complete | pdfx rendering, annotations, undo/redo |
| Phase 4 - AI Features | ✅ Complete | Puter AI (OpenAI-compatible), chat, summarize, flashcards, quiz, formulas |
| Phase 5 - Testing | ✅ Complete | 111/111 tests passing, 0 analyzer issues |
| Phase 6 - Deployment | ⏳ Not Started | Pending after testing verification |

## Key Decisions

| # | Decision | Rationale | Date |
|---|---|---|---|
| D1 | Use Flutter (not React Native) | Cross-platform from single codebase; Dart is strongly typed; excellent PDF support | Aug 24, 2026 |
| D2 | Use Riverpod (not BLoC or Provider) | Better testability; code generation; concise syntax; official recommendation | Aug 24, 2026 |
| D3 | Use Hive (not SQLite) | No native code needed; simpler API; sufficient for key-value and structured data | Aug 24, 2026 |
| D4 | Use Supabase (not Firebase) | Open-source; PostgreSQL gives more control; generous free tier; no vendor lock-in | Aug 24, 2026 |
| D5 | Use NVIDIA Nemotron (not Gemini/OpenAI) | Free tier; no data retention; better document accuracy (91% vs 58%); bounding box extraction; 40 RPM | Aug 24, 2026 |
| D6 | Client-heavy, offline-first architecture | Students study in areas with poor connectivity; annotations must never be lost | Aug 24, 2026 |
| D7 | Use pdfx (not syncfusion) | Fully free and open-source; sufficient for MVP; no licensing concerns | Aug 24, 2026 |
| D8 | API keys via Edge Functions only | Security: never bundle NVIDIA keys in the mobile app | Aug 24, 2026 |
| D9 | 4 highlight colors | Matches LiquidText; sufficient for most study workflows; keeps UI simple | Aug 24, 2026 |
| D10 | 50-action undo/redo stack | Balances memory usage with sufficient undo depth for annotation work | Aug 24, 2026 |
| D11 | Max 50MB per PDF upload | Prevents memory issues on low-end devices; covers 95%+ of academic PDFs | Aug 24, 2026 |
| D12 | 200-page limit per document | Prevents memory crashes on 2GB RAM devices; covers most textbooks/chapters | Aug 24, 2026 |

---

## Architecture Decisions

| Area | Decision | Notes |
|---|---|---|
| Folder Structure | Feature-first with clean architecture layers | data/domain/presentation per feature |
| State Management | Riverpod with code generation | `@riverpod` annotation for all providers |
| Model Layer | Freezed + json_serializable | Immutable data classes with serialization |
| Error Handling | Custom exception hierarchy | `AppException` base with typed subclasses |
| Navigation | GoRouter (named routes) | Declarative routing; deep link support |
| Testing | flutter_test + mockito + golden_toolkit | Unit + widget + golden tests |
| Linting | flutter_lints (strict) | Zero warnings policy |
| CI/CD | GitHub Actions | Lint → Test → Build on every PR |

---

## Completed Tasks

### Phase 1 — Authentication (Puter)
- Puter token-based auth via REST API (flutter_secure_storage persistence)
- Auth repository abstraction with PuterAuthRepository implementation
- Auth provider (Riverpod) with loading/error states
- Login, signup, forgot-password screens
- Route guards and auth state persistence
- **Google OAuth completely removed** — zero references in codebase

### Phase 2 — Dashboard & Document Management
- Document upload with file picker (50MB limit, 200-page limit enforced)
- Corrupt/unreadable PDF rejection with user-visible errors
- PDF title extraction (only removes final .pdf extension)
- Hive-based local storage with 8 boxes
- Grid/list toggle, search, sort (recent/name/date/size)
- Folder CRUD with document assignment
- Empty state illustrations

### Phase 3 — PDF Viewer & Annotations
- PDF rendering via pdfx with page navigation
- 4-color highlight system (yellow/green/blue/pink)
- Sticky notes with long-press creation
- Undo/redo stack with 50-action limit enforced
- Annotation persistence in Hive
- Split-pane workspace layout

### Phase 4 — AI Features (Puter AI)
- AI chat with OpenAI-compatible endpoint (500+ models)
- Summarization (page/section/selection scope)
- Flashcard generation (5-card active-recall)
- Quiz generation (multiple-choice with scoring)
- Formula & definition extraction
- AI explanations for excerpts
- **Shared daily usage limit** via AiUsageTracker (Hive-persisted)
- **Typed errors** — AiException, RateLimitException (no fake/hardcoded content)
- **Retry UI** on all AI failure states

### Phase 5 — Cloud Infrastructure (Puter)
- PuterCloudStorage: PDF file persistence via Puter FS REST API
- PuterKVService: metadata persistence (docs, folders, highlights, notes, chat, summaries, canvas, settings)
- CloudSyncService: bidirectional sync (pull cloud → merge → push local)
- Conflict resolution via updatedAt timestamps
- Cloud providers (Riverpod): cloudStorageProvider, kvServiceProvider, cloudSyncServiceProvider
- Auto-sync on login

### Cleanup & Documentation
- Removed supabase_flutter, supabase/ Edge Functions, all Supabase config
- Removed Google OAuth (signInWithGoogle, social_login_buttons.dart)
- Removed NemotronAIService → replaced with PuterAIService
- Removed 10 unused pubspec dependencies
- Updated architecture.md, CONTRIBUTING.md, design.md for Puter architecture
- Updated README.md with Puter setup instructions
- 111/111 tests passing, 0 analyzer issues

## Major Updates & Changes

| Date | Change | Impact |
|---|---|---|
| Aug 24, 2026 | Initial project planning complete | All 8 planning documents created; ready for development |
| Aug 24, 2026 | Repository initialized on GitHub | Remote origin configured; ready for collaboration |
| Aug 24, 2026 | Added CI/CD, Edge Functions, localization | 10 files, +1,339 lines of infrastructure |
| Aug 24–25, 2026 | Full Flutter app scaffolded + Phase 1 (Auth) complete | 48 source files; working auth with Supabase, Google OAuth, route guards |
| Aug 25, 2026 | Phase 2 (Dashboard) complete | Document/folder management, upload, grid/list views, search, sort |
| Aug 25, 2026 | Phase 3 (Viewer + Annotations) complete | PDF rendering, highlights, sticky notes, undo/redo, spatial canvas workspace |
| Aug 25–26, 2026 | Phase 4 (AI) complete + bonus features | Summarization, chat, formulas, flashcards, quiz — all wired to Nemotron |
| Aug 26, 2026 | Phase 5 testing: 81 tests passing | Full unit/widget test coverage across all features, 0 lint warnings |
| Aug 26, 2026 | Memory.md updated to v2.0 | Project status now accurately reflects actual implementation state |
## Open Questions

| # | Question | Status | Resolution |
|---|---|---|---|
| Q1 | GoRouter vs auto_route? | ✅ Resolved | GoRouter chosen; implemented with named routes and auth guards |
| Q2 | Onboarding shown once or repeatable? | ✅ Resolved | Onboarding key exists in constants but onboarding screen not yet built; defer to Settings |
| Q3 | Supabase free tier 1GB exceeded? | Open | Prioritize local Hive; only sync metadata to cloud (not files) |
| Q4 | Multi-document AI chat? | Deferred to V2 | MVP: one document per chat session |
| Q5 | Biometric auth? | Deferred to V2 | Not in MVP scope |
| Q6 | PDF text selection for highlighting? | 🔴 Open (Critical) | pdfx renders images — need custom overlay for text selection; affects highlight feature quality |
| Q7 | Cloud sync for annotations? | 🔴 Open | All data is local Hive only; need Supabase tables + sync logic |
| Q8 | Chat history persistence? | 🟡 Open | Chat messages are in-memory only; need Hive persistence |
## Learnings & Notes

| Topic | Note |
|---|---|
| Nemotron-Parse | Returns text with bounding boxes AND semantic classes (title, section, table, list, etc.) — this is more structured than generic OCR |
| Supabase Edge Functions | Written in TypeScript; deployed via `supabase functions deploy`; perfect for hiding API keys |
| pdfx | Renders pages as images; text selection is not native — may need custom overlay for highlighting |
| Hive | No SQL queries; use filters for complex queries; boxes should be kept small for performance |
| Flutter memory | PDF page images consume significant memory; must lazy-load and dispose aggressively |

---

## Important Links

| Resource | URL | Purpose |
|---|---|---|
| GitHub Repository | https://github.com/Sakeeb24/Mindspace | Project source code |
| Flutter Docs | https://docs.flutter.dev | Framework documentation |
| Riverpod Docs | https://riverpod.dev | State management docs |
| Supabase Docs | https://supabase.com/docs | Backend service docs |
| NVIDIA Nemotron | https://build.nvidia.com/nvidia/nemotron-3-ultra | AI model docs |
| Hive Docs | https://docs.hivedb.dev | Local database docs |
| pdfx Package | https://pub.dev/packages/pdfx | PDF rendering docs |
| Inter Font | https://fonts.google.com/specimen/Inter | Typography |

---

## Known Gaps

| ID | Gap | Priority | Status |
|----|-----|----------|--------|
| G1 | PDF text selection overlay (highlights stored but not rendered on PDF) | High | Not Started |
| G2 | Cloud sync not verified end-to-end (service exists, not tested on real Puter) | High | Partial |
| G3 | E2E/integration tests (none exist) | High | Not Started |
| G4 | Chat history not persisted to Hive (currently in-memory) | Medium | Not Started |
| G5 | Document thumbnail generation (placeholder only) | Medium | Not Started |
| G6 | Localization wired to UI (ARB files exist but unused) | Low | Not Started |
| G7 | Notification service integrated | Low | Not Started |

## Changelog

| Version | Date | Changes |
|---|---|---|
| 1.0 | Aug 24, 2026 | Initial project memory created with all planning decisions documented |
| 1.1 | Aug 24, 2026 | Updated with repository setup status and new files (.gitignore, CONTRIBUTING.md) |
| 1.2 | Aug 24, 2026 | Added infrastructure: CI/CD, Edge Functions, localization, GitHub templates |
| 2.0 | Aug 26, 2026 | Complete status overhaul: all Phases 1-4 done, Phase 5 partial (81 tests), documented known gaps |
| 3.0 | Aug 26, 2026 | Migrated from Supabase to Puter: removed Supabase auth/Edge Functions/DB, added Puter auth + OpenAI-compatible AI, fixed all identified issues |
