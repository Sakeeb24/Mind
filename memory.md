# MindSpace — Project Memory

> **Version**: 1.2 — August 2026
> **Last Updated**: August 24, 2026

---

## Purpose

This file maintains context across development sessions. It records important decisions, tracks completed work, logs changes, and captures the current state of the project. **Update this file at the end of every development session.**

---

## Project Status

| Item | Status | Date |
|---|---|---|
| PRD | ✅ Complete | Aug 24, 2026 |
| Architecture | ✅ Complete | Aug 24, 2026 |
| Rules & Standards | ✅ Complete | Aug 24, 2026 |
| Phases | ✅ Complete | Aug 24, 2026 |
| Design Guidelines | ✅ Complete | Aug 24, 2026 |
| Project Timeline | ✅ Complete | Aug 24, 2026 |
| README | ✅ Complete | Aug 24, 2026 |
| Project Memory | ✅ Complete | Aug 24, 2026 |
| .gitignore | ✅ Complete | Aug 24, 2026 |
| CONTRIBUTING.md | ✅ Complete | Aug 24, 2026 |
| GitHub Actions CI/CD | ✅ Complete | Aug 24, 2026 |
| Supabase Edge Functions | ✅ Complete | Aug 24, 2026 |
| Localization (ARB) | ✅ Complete | Aug 24, 2026 |
| GitHub Templates | ✅ Complete | Aug 24, 2026 |
| Flutter Project Setup | ⏳ Waiting for Flutter install | — |
| Phase 1: Authentication | ⏳ Not Started | — |
| Phase 2: Dashboard | ⏳ Not Started | — |
| Phase 3: Viewer + Annotations | ⏳ Not Started | — |
| Phase 4: AI Features | ⏳ Not Started | — |
| Phase 5: Testing & QA | ⏳ Not Started | — |
| Phase 6: Deployment | ⏳ Not Started | — |

---

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

### August 24, 2026 — Planning Documents
- [x] Created PRD.md with full product requirements
- [x] Created architecture.md with system design, tech stack, folder structure, data flows
- [x] Created rules.md with approved tech, prohibited items, coding standards
- [x] Created phases.md with 6 phases across 8 weeks
- [x] Created design.md with color system, typography, components, screen specs
- [x] Created memory.md (this file)
- [x] Created README.md with setup instructions
- [x] Created project_timeline.md with week-by-week breakdown

### August 24, 2026 — Repository Setup
- [x] Initialized git repository
- [x] Added remote origin (https://github.com/Sakeeb24/Mindspace.git)
- [x] Pushed initial planning documents to main branch
- [x] Created .gitignore for Flutter project
- [x] Created CONTRIBUTING.md with contribution guidelines
- [x] Created feature branch (autopilot/mindspace-fixes)
- [x] PR #1 merged to main (3 files, +501 lines)
- [x] Main branch updated with all planning documents

### August 24, 2026 — Infrastructure & Backend
- [x] Created GitHub Actions CI/CD workflow (lint, test, build)
- [x] Created Supabase Edge Functions (summarize, chat, extract-text, rate-limit)
- [x] Created English localization ARB file (200+ strings)
- [x] Created env.dart.example with app configuration template
- [x] Created GitHub issue templates (bug report, feature request)
- [x] Created PR template with checklist
- [x] Pushed to feature/phase1-flutter-setup branch

---

## Currently Working On

**Current Phase**: Pre-development (infrastructure complete)
**Current Branch**: feature/phase1-flutter-setup (awaiting Flutter install)
**Next Step**: Install Flutter → Initialize project → Set up folder structure
**Blockers**: Flutter SDK not yet installed on development machine
**Notes**: All planning docs and infrastructure ready. PR pending for Edge Functions, CI/CD, localization. Waiting for Flutter install to proceed with Phase 1.

---

## Major Updates & Changes

| Date | Change | Impact |
|---|---|---|
| Aug 24, 2026 | Initial project planning complete | All 8 planning documents created; ready for development |
| Aug 24, 2026 | Repository initialized on GitHub | Remote origin configured; ready for collaboration |
| Aug 24, 2026 | Added .gitignore and CONTRIBUTING.md | Repository now properly configured for Flutter development |
| Aug 24, 2026 | PR #1 merged to main | .gitignore, CONTRIBUTING.md, and memory.md updates merged |
| Aug 24, 2026 | Added CI/CD, Edge Functions, localization | 10 files, +1,339 lines on feature/phase1-flutter-setup |

---

## Open Questions

| # | Question | Status | Resolution |
|---|---|---|---|
| Q1 | Should we use GoRouter or auto_route for navigation? | Open | Evaluate during Phase 1 setup |
| Q2 | Should the onboarding be shown once or repeatable from settings? | Open | Show once by default; add "Replay Onboarding" in Settings |
| Q3 | What happens when Supabase free tier 1GB storage is exceeded? | Open | Prioritize local Hive; only sync metadata to cloud (not files) |
| Q4 | Should AI chat support multiple documents in one conversation? | Deferred to V2 | MVP: one document per chat session |
| Q5 | Should we implement biometric auth (fingerprint/face)? | Deferred to V2 | Not in MVP scope |

---

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

## Changelog

| Version | Date | Changes |
|---|---|---|
| 1.0 | Aug 24, 2026 | Initial project memory created with all planning decisions documented |
| 1.1 | Aug 24, 2026 | Updated with repository setup status and new files (.gitignore, CONTRIBUTING.md) |
| 1.2 | Aug 24, 2026 | Added infrastructure: CI/CD, Edge Functions, localization, GitHub templates |
