# MindSpace — Project Rules & Standards

> **Version**: 1.0 — August 2026
> **Last Updated**: August 24, 2026

---

## Table of Contents

1. [Approved Technologies](#1-approved-technologies)
2. [Prohibited Technologies & Practices](#2-prohibited-technologies--practices)
3. [Libraries & Dependencies](#3-libraries--dependencies)
4. [Code Style & Standards](#4-code-style--standards)
5. [Error Handling Standards](#5-error-handling-standards)
6. [AI Boundaries](#6-ai-boundaries)
7. [Security Rules](#7-security-rules)
8. [Performance Rules](#8-performance-rules)
9. [Testing Standards](#9-testing-standards)
10. [Git & Collaboration](#10-git--collaboration)
11. [Localization Rules](#11-localization-rules)

---

## 1. Approved Technologies

Everything below is **explicitly approved** for use in MindSpace. No other technologies may be introduced without team review.

### 1.1 Core Framework

| Category | Approved Technology | Version Required |
|---|---|---|
| UI Framework | Flutter | 3.24+ |
| Language | Dart | 3.5+ |
| State Management | Riverpod (with code generation) | 2.6+ |
| Immutable Models | Freezed | 3.0+ |
| JSON Serialization | json_serializable | 6.8+ |

### 1.2 Data & Storage

| Category | Approved Technology | Purpose |
|---|---|---|
| Local Database | Hive | Key-value structured storage |
| Secure Storage | flutter_secure_storage | Auth tokens, secrets |
| File Storage | path_provider | App directories |
| Image Cache | cached_network_image | Thumbnails, avatars |

### 1.3 Networking

| Category | Approved Technology | Purpose |
|---|---|---|
| HTTP Client | Dio | API calls with interceptors |
| Connectivity | connectivity_plus | Network status detection |

### 1.4 UI & UX

| Category | Approved Technology | Purpose |
|---|---|---|
| PDF Rendering | pdfx | Display PDFs with zoom/pan |
| File Selection | file_picker | Pick PDFs from device |
| Local Notifications | flutter_local_notifications | Processing alerts |
| Share/Export | share_plus | Share content |
| URL Launching | url_launcher | Open links in browser |
| In-App Review | in_app_review | Prompt App Store reviews |
| App Info | package_info_plus | Version display |

### 1.5 Backend Services

| Service | Purpose | Tier |
|---|---|---|
| Supabase Auth | Authentication | Free |
| Supabase Database | Cloud metadata | Free |
| Supabase Storage | Cloud file backup | Free |
| Supabase Edge Functions | API proxy | Free |
| NVIDIA Nemotron-Parse | Text extraction | Free |
| NVIDIA Nemotron 3 Ultra 550B | Summarization + Q&A | Free |
| NVIDIA Nemotron 3 Nano 30B | Fast alternative | Free |

### 1.6 Development Tools

| Tool | Purpose |
|---|---|
| GitHub | Version control |
| GitHub Actions | CI/CD |
| Flutter Lints | Code analysis |
| Mockito | Unit test mocking |
| Build Runner | Code generation |

---

## 2. Prohibited Technologies & Practices

### 2.1 Never Use These

| Prohibited | Why |
|---|---|
| Firebase | Supabase is the approved BaaS; mixing causes auth conflicts and billing confusion |
| SQLite (sqflite) | Hive is the approved local DB; SQLite adds native code complexity |
| BLoC / Cubit | Riverpod is the approved state manager; mixing patterns causes confusion |
| GetX | Anti-pattern framework; poor testability, magic routing |
| Provider (package:provider) | Riverpod supersedes it; use Riverpod exclusively |
| Redux | Overly complex for this app size; Riverpod is sufficient |
| syncfusion_flutter_pdfviewer | Paid license required; pdfx is the free alternative |
| OpenAI API | NVIDIA Nemotron is the approved AI provider (free tier, privacy) |
| Google Gemini | Privacy concerns with free tier; Nemotron preferred |
| MobX | Not approved; Riverpod is the standard |
| react_native / Kotlin Multiplatform | Flutter is the approved cross-platform framework |

### 2.2 Never Do These

| Prohibited Practice | Why |
|---|---|
| Hardcoded strings in widgets | All user-facing strings must be in ARB localization files |
| Storing API keys on the client | Keys go in Supabase Edge Functions only |
| `setState()` outside of widgets | Use Riverpod providers for all state |
| `print()` statements in production code | Use the AppLogger utility |
| Importing entire packages | Import only what you need (e.g., `package:riverpod/riverpod.dart`) |
| God classes (>300 lines) | Split into smaller, focused files |
| Synchronous file I/O on main thread | Always use `compute()` or isolates for heavy operations |
| Catching generic `Exception` | Catch specific exception types |
| Magic numbers/strings | Define as named constants in `constants.dart` |
| Manual JSON parsing | Use Freezed + json_serializable |
| Direct HTTP calls without Dio interceptor | All API calls go through the configured Dio instance |

---

## 3. Libraries & Dependencies

### 3.1 Production Dependencies

| Package | Version Constraint | Purpose | When to Use |
|---|---|---|---|
| `flutter_riverpod` | ^2.6.0 | State management | All state across the app |
| `riverpod_annotation` | ^2.6.0 | Riverpod code generation | All provider definitions |
| `freezed_annotation` | ^3.0.0 | Immutable data classes | All entities and models |
| `json_annotation` | ^4.9.0 | JSON serialization annotations | All serializable models |
| `hive` | ^2.2.0 | Local NoSQL database | All local data storage |
| `hive_flutter` | ^1.1.0 | Flutter integration for Hive | App initialization |
| `flutter_secure_storage` | ^9.2.0 | Encrypted key-value storage | Auth tokens |
| `dio` | ^5.7.0 | HTTP client | All API communication |
| `pdfx` | ^2.6.0 | PDF rendering | Document viewer |
| `file_picker` | ^8.1.0 | Device file selection | PDF upload |
| `path_provider` | ^2.1.0 | App directory paths | File storage |
| `cached_network_image` | ^3.4.0 | Network image caching | Thumbnails |
| `flutter_local_notifications` | ^18.0.0 | Local push notifications | Processing complete |
| `share_plus` | ^10.1.0 | System share sheet | Export/share |
| `url_launcher` | ^6.3.0 | Open URLs | Links, legal pages |
| `connectivity_plus` | ^6.1.0 | Network status | Online/offline handling |
| `package_info_plus` | ^8.1.0 | App metadata | Version display |
| `in_app_review` | ^2.0.0 | App store review prompt | After positive interactions |
| `supabase_flutter` | ^2.8.0 | Supabase SDK | Auth, DB, Storage |
| `uuid` | ^4.5.0 | UUID generation | Entity IDs |
| `intl` | ^0.19.0 | Date/number formatting | Display formatting |

### 3.2 Development Dependencies

| Package | Version Constraint | Purpose |
|---|---|---|
| `flutter_lints` | ^5.0.0 | Lint rules |
| `build_runner` | ^2.4.0 | Code generation runner |
| `freezed` | ^3.0.0 | Freezed code generation |
| `json_serializable` | ^6.8.0 | JSON serialization generation |
| `riverpod_generator` | ^2.6.0 | Riverpod code generation |
| `hive_generator` | ^2.0.0 | Hive TypeAdapter generation |
| `mockito` | ^5.4.0 | Test mocking |
| `build_verify` | ^3.1.0 | Ensure generated code is fresh |
| `flutter_test` | (SDK) | Widget testing |
| `mocktail` | ^1.0.0 | Mocking alternative |

### 3.3 Adding New Dependencies

Before adding any new dependency, check:

1. Is there already an approved dependency that does the same thing?
2. Is the package well-maintained (last update within 6 months)?
3. Does it have a pub.dev score above 130?
4. Is it compatible with our minimum Dart/Flutter versions?
5. Does it pull in heavy native dependencies that increase build time?

If you need to add a new dependency, **document it in this file** with its purpose before using it.

---

## 4. Code Style & Standards

### 4.1 Dart Code Style

Follow the official Dart style guide with these project-specific additions:

**Naming Conventions**

| Element | Convention | Example |
|---|---|---|
| Classes | PascalCase | `DocumentRepository` |
| Variables/Functions | camelCase | `fetchDocuments` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_FILE_SIZE_BYTES` |
| Files | snake_case | `document_repository.dart` |
| Folders | snake_case | `document_viewer/` |
| Enums | PascalCase values | `HighlightColor.yellow` |
| Providers | camelCase with Provider suffix | `documentListProvider` |

**File Organization (top to bottom)**

1. Part directives
2. Imports (grouped: dart → flutter → packages → relative)
3. Exports
4. Constants
5. Enums
6. Type aliases
7. Classes
8. Top-level functions

**Import Ordering**
```
1. Dart SDK (dart:async, dart:io)
2. Flutter SDK (package:flutter/*)
3. Third-party packages (package:*)
4. Relative imports (../, ./)
```

### 4.2 Riverpod Provider Rules

| Rule | Detail |
|---|---|
| Use `@riverpod` annotation | For code-generated providers |
| Name providers with `Provider` suffix | `authProvider`, `documentListProvider` |
| Keep providers focused | One concern per provider |
| Never mutate provider state directly | Use notifier pattern |
| Use `ref.watch()` in build methods | For reactive rebuilds |
| Use `ref.read()` in event handlers | For one-time reads |
| Use `ref.listen()` for side effects | Navigation, snackbar, etc. |

### 4.3 Widget Rules

| Rule | Detail |
|---|---|
| Prefer `ConsumerWidget` | Over `StatefulWidget` when using Riverpod |
| One widget per file | With rare exceptions for tightly coupled small widgets |
| Maximum widget nesting depth | 5 levels; extract if deeper |
| Extract business logic | Never put business logic in widget build methods |
| Use `const` constructors | Whenever possible for performance |
| Prefer `ListView.builder` | Over `ListView` for dynamic lists |

### 4.4 Architecture Layer Rules

| Layer | Rules |
|---|---|
| **Presentation** | Only UI logic and state observation. No business logic, no data access. |
| **Domain** | Pure business entities and repository interfaces. No framework dependencies. |
| **Data** | Repository implementations, API calls, database access. Can depend on packages. |

**Dependency Rule**: Dependencies flow inward only. Presentation → Domain ← Data. Domain layer must never import from Presentation or Data layers.

---

## 5. Error Handling Standards

### 5.1 Custom Exception Hierarchy

```
AppException (base)
├── AuthException
│   ├── InvalidCredentialsException
│   ├── UserNotFoundException
│   ├── EmailAlreadyInUseException
│   ├── WeakPasswordException
│   ├── NetworkAuthException
│   └── GoogleSignInCancelledException
├── DocumentException
│   ├── FileTooLargeException
│   ├── InvalidFileFormatException
│   ├── DocumentNotFoundException
│   ├── UploadFailedException
│   └── PageLimitExceededException
├── AIException
│   ├── RateLimitExceededException
│   ├── AIServiceUnavailableException
│   ├── EmptyResponseException
│   ├── TextExtractionFailedException
│   └── TokenLimitExceededException
├── AnnotationException
│   ├── HighlightSaveFailedException
│   └── NoteSaveFailedException
├── SyncException
│   ├── CloudSyncFailedException
│   └── OfflineOperationException
└── StorageException
    ├── LocalStorageException
    └── SecureStorageException
```

### 5.2 Error Handling Rules

| Rule | Detail |
|---|---|
| Catch specific exceptions | Never use `catch (e)` without type |
| Log all errors | Use `AppLogger.error()` with context |
| Show user-friendly messages | Never show raw exception text to users |
| Fail gracefully | App should never crash; degrade functionality if needed |
| Retry transient errors | Network errors: 3 retries with exponential backoff |
| Distinguish error types | User errors (wrong input) vs system errors (server down) vs programming errors (null) |

### 5.3 User Error Message Standards

| Error Category | Message Pattern | Example |
|---|---|---|
| Network error | "No internet connection. Check your network and try again." | — |
| Auth error | "Sign in failed. Please check your email and password." | — |
| Upload error | "Could not upload [filename]. Please try again." | — |
| Rate limit | "You've reached the daily limit. Try again tomorrow or upgrade to Pro." | — |
| AI error | "AI service is temporarily unavailable. Please try again in a moment." | — |
| File error | "This file is too large or not a valid PDF." | — |

### 5.4 Error Handling Pattern

Every service call follows this pattern:

```
try {
  result = await service.call();
} on SpecificException catch (e) {
  logger.error('Context message', error: e);
  // Show user-friendly message
  // Cache failure state if needed
  // Retry if appropriate
} on Exception catch (e) {
  logger.error('Unexpected error', error: e);
  // Show generic "something went wrong" message
  // Report to error tracking
}
```

---

## 6. AI Boundaries

### 6.1 What AI CAN Do

| Capability | Detail |
|---|---|
| Summarize documents | Page-level, section-level, selection-level summaries |
| Answer questions | Natural language Q&A about document content |
| Extract structured text | With bounding boxes and semantic labels |
| Detect document structure | Titles, sections, tables, lists, captions, footnotes |
| Provide citations | Reference specific pages in responses |
| Process follow-up questions | Maintain conversation context within a document session |

### 6.2 What AI CANNOT Do

| Limitation | Detail |
|---|---|
| Access files directly | AI never sees the PDF file; only extracted text |
| Remember across sessions | Each Q&A session is independent (no persistent memory) |
| Generate perfect answers | Responses may contain errors; always show "AI-generated" disclaimer |
| Replace human judgment | Summaries are starting points, not substitutes for reading |
| Process non-text content | Images, diagrams, handwriting require OCR (V2) |
| Guarantee accuracy | Always display confidence indicators and source citations |

### 6.3 AI Usage Rules

1. **Always show "AI-generated" label** on summaries and chat responses
2. **Always include page citations** when referencing document content
3. **Never send full documents** to AI — only relevant pages/sections
4. **Cache AI responses** to avoid redundant API calls
5. **Enforce rate limits** client-side before making API calls
6. **Gracefully handle AI failures** — never block the user from reading the document
7. **Store minimal AI data** — only user-facing summaries and messages, not intermediate prompts
8. **Allow user to dismiss/regenerate** any AI response they don't like

### 6.4 AI Response Formatting Rules

| Element | Rule |
|---|---|
| Summaries | Max 500 words. Use bullet points. Include source page. |
| Chat responses | Max 1000 words. Include citations. Show thinking indicator while processing. |
| Confidence | Show confidence level (High/Medium/Low) based on answer specificity |
| Disclaimer | Footer: "AI-generated content may contain errors. Verify important information." |

---

## 7. Security Rules

### 7.1 Authentication Security

| Rule | Detail |
|---|---|
| Password minimum | 8 characters, 1 uppercase, 1 number |
| Token storage | flutter_secure_storage only (never SharedPreferences) |
| Session timeout | 1 hour active, 30 days refresh |
| Google Sign-In | Use Supabase adapter, not raw OAuth |
| Biometric auth | Optional, V2 feature |

### 7.2 Data Security

| Rule | Detail |
|---|---|
| API keys on server only | Never bundle NVIDIA keys in the app |
| HTTPS only | All API communication encrypted in transit |
| Row-level security | All Supabase tables enforce user_id matching |
| No PII in logs | Redact emails, tokens, user IDs in production |
| App sandbox | Document files stored in app-private directory |
| Data deletion | Users can delete all data from Settings |

### 7.3 Input Security

| Rule | Detail |
|---|---|
| Sanitize note content | Strip HTML/script tags before storage |
| Validate file uploads | Check MIME type, file extension, size |
| Limit input lengths | Notes: 500 chars. Chat messages: 2000 chars. Folder names: 50 chars. |
| No eval/exec | Never dynamically execute user input |

---

## 8. Performance Rules

### 8.1 App Performance

| Metric | Target | Enforcement |
|---|---|---|
| Cold start | < 2 seconds | Profile on low-end device before each release |
| PDF page render | < 500ms | Lazy-load pages; don't render all at once |
| AI response | < 8 seconds | Show typing indicator; stream if possible |
| Memory usage | < 200MB | Limit cached pages to 10 at a time |
| App size (APK/IPA) | < 30MB | Compress assets; use deferred loading |

### 8.2 Performance Rules

| Rule | Detail |
|---|---|
| Lazy-load PDF pages | Only render visible page + 1 adjacent page |
| Cache aggressively | Store extracted text, summaries, thumbnails locally |
| Use `compute()` for heavy work | Text processing, image generation, JSON parsing |
| Minimize widget rebuilds | Use `select()` with Riverpod to watch specific values |
| Debounce search input | 300ms delay before filtering |
| Limit Hive box size | Archive old chat history after 100 messages per document |
| Compress images | Generate thumbnails at 200x280 pixels max |

### 8.3 Memory Management

| Rule | Detail |
|---|---|
| Dispose controllers | Always dispose AnimationController, TextEditingController, etc. |
| Limit page cache | Keep max 10 rendered PDF pages in memory |
| Close Hive boxes | Properly close boxes when no longer needed |
| Avoid large lists | Use `ListView.builder` for virtualized rendering |
| Profile regularly | Use Flutter DevTools to check for memory leaks |

---

## 9. Testing Standards

### 9.1 Test Types & Requirements

| Test Type | Tool | Coverage Target | When to Run |
|---|---|---|---|
| Unit Tests | flutter_test | 80%+ for domain/data layers | Every commit |
| Widget Tests | flutter_test | All screens + key widgets | Every commit |
| Integration Tests | integration_test | Critical user flows | Before release |
| Golden Tests | golden_toolkit | All key UI components | UI changes |
| Lint Checks | flutter_lints | Zero warnings | Every commit |

### 9.2 Testing Rules

| Rule | Detail |
|---|---|
| Test file location | Mirror `lib/` structure under `test/` |
| Test file naming | `*_test.dart` suffix |
| Mock external services | Never make real API calls in tests |
| Test edge cases | Empty states, error states, loading states |
| Test accessibility | Screen reader labels, tap targets |
| No flaky tests | If a test is flaky, fix it or mark it as skip with a TODO |

### 9.3 What to Test

| Layer | What to Test |
|---|---|
| Domain Entities | Equality, serialization, business rules |
| Repositories | Success and error paths, caching behavior |
| Services | API response handling, rate limiting, retry logic |
| Providers | State transitions, side effects |
| Widgets | Rendering, user interactions, error states |
| Utils | Validation, formatting, extension functions |

### 9.4 What NOT to Test

- Framework-generated code (Freezed, json_serializable)
- Third-party library internals
- Simple getters/setters
- UI pixel-perfect positioning (test structure, not exact pixels)
- Configuration files

---

## 10. Git & Collaboration

### 10.1 Branch Strategy

```
main          ← Production-ready code
  └── develop ← Integration branch (all features merge here)
       ├── feature/auth-login
       ├── feature/document-upload
       ├── feature/ai-chat
       └── fix/pdf-render-crash
```

| Branch | Purpose | Protection |
|---|---|---|
| `main` | Production releases | PR required, 1 approval, CI must pass |
| `develop` | Feature integration | PR required, CI must pass |
| `feature/*` | New features | No protection; developer controls |
| `fix/*` | Bug fixes | No protection; developer controls |
| `release/*` | Release prep | PR to main required |

### 10.2 Commit Message Format

```
<type>(<scope>): <description>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

**Examples**:
```
feat(auth): add Google Sign-In integration
fix(viewer): resolve crash on 200+ page PDFs
docs(prd): update monetization strategy
test(chat): add unit tests for chat provider
chore(deps): upgrade supabase_flutter to 2.8.0
```

### 10.3 Pull Request Rules

| Rule | Detail |
|---|---|
| Title | Match commit message format |
| Description | What changed, why, how to test |
| Size | Keep PRs under 400 lines of changes |
| Self-review | Review your own PR before requesting review |
| CI must pass | No merging with failing tests or lint errors |
| Squash merge | All feature branches squash into develop |

### 10.4 Code Review Checklist

- [ ] Does the code follow naming conventions?
- [ ] Are there corresponding unit tests?
- [ ] Are error cases handled?
- [ ] Are there any hardcoded strings that should be localized?
- [ ] Is the code properly documented (comments for non-obvious logic)?
- [ ] Does it follow the architecture layer rules?
- [ ] Are there any potential memory leaks?
- [ ] Is the UI accessible (screen reader labels)?

---

## 11. Localization Rules

### 11.1 String Management

| Rule | Detail |
|---|---|
| All UI strings in ARB files | Never hardcode user-facing text |
| Primary locale | English (`app_en.arb`) |
| Structure | Group strings by feature/section |
| Naming | Use descriptive keys: `auth_login_title`, `dashboard_empty_state` |
| Pluralization | Use ICU syntax for count-based strings |
| Parameters | Use `{variable}` syntax for dynamic content |

### 11.2 ARB File Structure

```
{
  "@@locale": "en",
  "app_name": "MindSpace",
  "auth_login_title": "Welcome Back",
  "auth_login_subtitle": "Sign in to continue studying",
  "auth_email_label": "Email Address",
  "dashboard_empty_title": "No Documents Yet",
  "dashboard_empty_subtitle": "Upload your first PDF to get started",
  "ai_summarize_button": "Summarize",
  "ai_disclaimer": "AI-generated content may contain errors.",
  "@ai_disclaimer": {
    "description": "Footer disclaimer shown on all AI responses"
  }
}
```

---

## 12. Documentation Rules

### 12.1 What to Document

| Item | Documentation |
|---|---|
| Public API methods | Dart doc comments (`///`) |
| Complex algorithms | Inline comments explaining the approach |
| Non-obvious business rules | Comments at the point of implementation |
| Architecture decisions | architecture.md or ADR (Architecture Decision Record) |
| Setup instructions | README.md |

### 12.2 What NOT to Document

- Self-explanatory code (good naming is the documentation)
- Obvious getters/setters
- Generated code (Freezed, json_serializable)
- Third-party library usage (link to docs instead)

### 12.3 Documentation Standards

- Keep README.md updated with current setup instructions
- Update architecture.md when adding new services or patterns
- Update memory.md after every significant session
- Keep rules.md current as project standards evolve
- All planning documents in the project root directory
