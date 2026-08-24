# MindSpace — Architecture & High-Level Design

> **Version**: 1.0 — August 2026
> **Last Updated**: August 24, 2026

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Component Architecture](#2-component-architecture)
3. [Tech Stack](#3-tech-stack)
4. [Folder & File Structure](#4-folder--file-structure)
5. [Data Flow Diagrams](#5-data-flow-diagrams)
6. [Database Schema](#6-database-schema)
7. [API Design](#7-api-design)
8. [Security Architecture](#8-security-architecture)

---

## 1. System Overview

### 1.1 High-Level System Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        MINDSPACE CLIENT                         │
│                     (Flutter Mobile App)                        │
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │ Auth     │  │ Document │  │ AI       │  │ Annotation    │  │
│  │ Module   │  │ Module   │  │ Module   │  │ Module        │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬────────┘  │
│       │              │              │               │           │
│  ┌────┴──────────────┴──────────────┴───────────────┴────────┐  │
│  │                   STATE MANAGEMENT (Riverpod)             │  │
│  └────────┬──────────────┬──────────────┬───────────────┬────┘  │
│           │              │              │               │       │
│  ┌────────┴────┐  ┌──────┴──────┐  ┌───┴────┐  ┌──────┴─────┐ │
│  │ Local DB    │  │ PDF Engine  │  │ HTTP   │  │ File       │ │
│  │ (Hive)      │  │ (pdfx)      │  │ Client │  │ Storage    │ │
│  └─────────────┘  └─────────────┘  └───┬────┘  └──────┬─────┘ │
└────────────────────────────────────────┼───────────────┼───────┘
                                         │               │
                    ┌────────────────────┼───────────────┼───────┐
                    │          CLOUD SERVICES                        │
                    │                                                │
                    │  ┌──────────────┐  ┌───────────────────────┐  │
                    │  │  Supabase    │  │  NVIDIA Nemotron API  │  │
                    │  │  ┌────────┐  │  │  ┌─────────────────┐  │  │
                    │  │  │Auth    │  │  │  │ Nemotron-Parse  │  │  │
                    │  │  ├────────┤  │  │  ├─────────────────┤  │  │
                    │  │  │Database│  │  │  │ Nemotron 3 Ultra│  │  │
                    │  │  ├────────┤  │  │  │ (550B)          │  │  │
                    │  │  │Storage │  │  │  ├─────────────────┤  │  │
                    │  │  ├────────┤  │  │  │ Nemotron 3 Nano │  │  │
                    │  │  │Edge    │  │  │  │ (30B)           │  │  │
                    │  │  │Functions│ │  │  └─────────────────┘  │  │
                    │  │  └────────┘  │  └───────────────────────┘  │
                    │  └──────────────┘                              │
                    └────────────────────────────────────────────────┘
```

### 1.2 Architecture Philosophy

MindSpace follows an **offline-first, client-heavy** architecture. The Flutter app is the brain — it handles most logic locally using Hive for storage and Riverpod for state. Cloud services (Supabase, NVIDIA) are used sparingly for authentication, cloud backup, and AI processing.

**Key Design Decisions**

| Decision | Rationale |
|---|---|
| Client-heavy architecture | Offline-first requirement; students study in areas with poor connectivity |
| Hive over SQLite | No native code needed; simpler API; sufficient for key-value and structured data |
| Riverpod over BLoC | More concise; better testability; built-in code generation |
| Supabase over Firebase | Open-source; PostgreSQL gives more control; generous free tier |
| NVIDIA Nemotron over OpenAI/Gemini | Free tier; no data retention; better document accuracy; bounding box extraction |
| pdfx over syncfusion_pdfviewer | Fully free; open-source; sufficient for MVP |

---

## 2. Component Architecture

### 2.1 Client Modules

**Authentication Module**
- Handles sign-up, sign-in, sign-out, password reset
- Manages session tokens via flutter_secure_storage
- Google OAuth flow via Supabase Auth
- Token refresh logic (auto-refresh before expiry)
- Auth state exposed via Riverpod auth provider

**Document Module**
- PDF upload and file management
- PDF rendering via pdfx (page-by-page lazy loading)
- Document metadata management (title, page count, size, date)
- Local file caching in app documents directory
- Thumbnail generation for dashboard cards
- Document search and filtering

**AI Module**
- Text extraction pipeline (Nemotron-Parse)
- Summarization engine (Nemotron 3 Ultra 550B)
- Q&A chat engine (Nemotron 3 Ultra 550B)
- Response caching (avoid re-querying for same question)
- Rate limit management (40 RPM per endpoint)
- Request queue for concurrent requests

**Annotation Module**
- Highlight creation, editing, deletion
- Sticky note creation, editing, deletion
- Undo/redo stack (50-action depth)
- Annotation persistence (Hive + Supabase sync)
- Annotation rendering overlay on PDF viewer

**State Management Layer (Riverpod)**
- `AuthStateProvider` — authentication status, current user
- `DocumentListProvider` — all documents with pagination
- `CurrentDocumentProvider` — active document and its state
- `AnnotationsProvider` — highlights and notes for active document
- `AIChatProvider` — chat messages for active document
- `FolderProvider` — folder hierarchy
- `SettingsProvider` — user preferences, theme, language

### 2.2 Cloud Services

**Supabase**
| Service | Usage | Free Tier Limit |
|---|---|---|
| Auth | Email + Google OAuth | 50,000 MAU |
| Database | Document metadata, annotations, chat history | 500MB |
| Storage | Document file backup (optional sync) | 1GB |
| Edge Functions | Server-side AI request proxying (hide API keys) | 500K invocations |
| Real-time | Future: collaboration features (V2) | 200 concurrent |

**NVIDIA Nemotron**
| Model | Usage | Free Tier |
|---|---|---|
| Nemotron-Parse | PDF text extraction with bounding boxes | 40 RPM |
| Nemotron 3 Ultra 550B | Summarization + Q&A | 40 RPM |
| Nemotron 3 Nano 30B | Fast responses for simple queries | 40 RPM |

### 2.3 Service Interfaces

All external services are accessed through **abstract service interfaces** in the codebase. This ensures:

1. **Testability** — mock any service in unit tests
2. **Swappability** — replace Supabase with Firebase without touching business logic
3. **Consistency** — uniform error handling across all service calls

```
AuthService (interface)
  ├── SupabaseAuthService (implementation)
  └── MockAuthService (testing)

DocumentService (interface)
  ├── LocalDocumentService (Hive implementation)
  └── CloudDocumentService (Supabase implementation)

AIService (interface)
  ├── NemotronParseService (text extraction)
  ├── NemotronUltraService (summarization + Q&A)
  └── MockAIService (testing)

AnnotationService (interface)
  ├── LocalAnnotationService (Hive)
  └── CloudAnnotationService (Supabase sync)
```

---

## 3. Tech Stack

### 3.1 Complete Technology Matrix

| Layer | Technology | Version | Purpose | License |
|---|---|---|---|---|
| **Framework** | Flutter | 3.24+ | Cross-platform mobile app | BSD-3 |
| **Language** | Dart | 3.5+ | Programming language | BSD-3 |
| **State Management** | Riverpod | 2.6+ | Reactive state management | MIT |
| **Code Generation** | Freezed | 3.0+ | Immutable data classes | MIT |
| **Local Database** | Hive | 2.2+ | NoSQL key-value local storage | Apache-2.0 |
| **Secure Storage** | flutter_secure_storage | 9.2+ | Encrypted token/key storage | BSD-3 |
| **PDF Rendering** | pdfx | 2.6+ | PDF display with zoom/pan | Apache-2.0 |
| **HTTP Client** | Dio | 5.7+ | API communication with interceptors | MIT |
| **File Picker** | file_picker | 8.1+ | Select PDFs from device | MIT |
| **Path Provider** | path_provider | 2.1+ | App directory access | BSD-3 |
| **Image Caching** | cached_network_image | 3.4+ | PDF thumbnail caching | BSD-3 |
| **Local Notifications** | flutter_local_notifications | 18.0+ | Processing complete notifications | BSD-3 |
| **Share** | share_plus | 10.1+ | Export/share functionality | MIT |
| **Connectivity** | connectivity_plus | 6.1+ | Network status detection | BSD-3 |
| **Package Info** | package_info_plus | 8.1+ | App version info | BSD-3 |
| **Linting** | flutter_lints | 5.0+ | Code quality rules | BSD-3 |
| **Testing** | mockito | 5.4+ | Mocking in unit tests | MIT |
| **Testing** | golden_toolkit | 0.15+ | Golden tests for UI | MIT |

### 3.2 Backend Services

| Service | Purpose | Free Tier Limit |
|---|---|---|
| Supabase Auth | User authentication (email + Google) | 50,000 MAU |
| Supabase PostgreSQL | Cloud database for metadata | 500MB |
| Supabase Storage | Cloud file storage (optional sync) | 1GB |
| Supabase Edge Functions | API proxy to hide NVIDIA keys | 500K invocations/month |
| NVIDIA Nemotron-Parse | PDF text extraction | 40 RPM |
| NVIDIA Nemotron 3 Ultra 550B | Summarization + Q&A | 40 RPM |
| NVIDIA Nemotron 3 Nano 30B | Fast alternative model | 40 RPM |
| Vercel | Admin panel hosting (future) | 100GB bandwidth |

### 3.3 Development Tools

| Tool | Purpose |
|---|---|
| GitHub | Version control + issue tracking |
| GitHub Actions | CI/CD pipeline (build, test, lint) |
| VS Code + Flutter extension | Primary IDE |
| Android Studio | Android emulator + debugging |
| Xcode | iOS simulator + debugging |
| Flutter DevTools | Performance profiling |

---

## 4. Folder & File Structure

### 4.1 Project Root

```
mindspace/
├── .github/                          # GitHub configuration
│   └── workflows/
│       ├── ci.yml                    # CI pipeline (lint, test)
│       └── release.yml               # Build + release pipeline
├── android/                          # Android platform files
├── ios/                              # iOS platform files
├── lib/                              # Main application code
│   ├── app.dart                      # App root widget + MaterialApp config
│   ├── main.dart                     # Entry point
│   ├── config/                       # App configuration
│   │   ├── theme.dart                # Light + dark theme definitions
│   │   ├── constants.dart            # App-wide constants
│   │   ├── routes.dart               # Named route definitions
│   │   └── env.dart                  # Environment variables (API keys)
│   ├── core/                         # Core utilities shared across features
│   │   ├── errors/                   # Custom error classes
│   │   │   ├── app_exception.dart    # Unified exception types
│   │   │   └── error_handler.dart    # Global error handling
│   │   ├── extensions/               # Dart/Flutter extensions
│   │   │   ├── string_extensions.dart
│   │   │   ├── datetime_extensions.dart
│   │   │   └── context_extensions.dart
│   │   ├── utils/                    # Utility functions
│   │   │   ├── logger.dart           # App logging utility
│   │   │   ├──validators.dart        # Input validation functions
│   │   │   ├── debouncer.dart        # Debounce utility for search
│   │   │   └── file_utils.dart       # File handling utilities
│   │   └── widgets/                  # Shared/reusable widgets
│   │       ├── app_button.dart       # Primary, secondary, text buttons
│   │       ├── app_text_field.dart   # Styled text input
│   │       ├── loading_overlay.dart  # Full-screen loading indicator
│   │       ├── empty_state.dart      # Empty state illustrations
│   │       ├── error_widget.dart     # Error display widget
│   │       └── confirm_dialog.dart   # Reusable confirmation dialog
│   ├── features/                     # Feature-based organization
│   │   ├── auth/                     # Authentication feature
│   │   │   ├── data/                 # Data layer
│   │   │   │   ├── repositories/     # Repository implementations
│   │   │   │   └── models/           # Data models (DTOs)
│   │   │   ├── domain/               # Domain layer
│   │   │   │   ├── entities/         # Business entities
│   │   │   │   └── repositories/     # Repository interfaces
│   │   │   └── presentation/         # UI layer
│   │   │       ├── screens/          # Full screens/pages
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── signup_screen.dart
│   │   │       │   └── forgot_password_screen.dart
│   │   │       ├── widgets/          # Screen-specific widgets
│   │   │       │   ├── auth_form.dart
│   │   │       │   └── social_login_buttons.dart
│   │   │       └── providers/        # Riverpod providers
│   │   │           └── auth_provider.dart
│   │   ├── dashboard/                # Document dashboard feature
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── dashboard_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── document_card.dart
│   │   │       │   ├── document_grid.dart
│   │   │       │   ├── document_list_tile.dart
│   │   │       │   ├── folder_card.dart
│   │   │       │   ├── upload_button.dart
│   │   │       │   └── empty_dashboard.dart
│   │   │       └── providers/
│   │   │           └── dashboard_provider.dart
│   │   ├── document_viewer/          # PDF viewer feature
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── document_viewer_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── pdf_page_view.dart
│   │   │       │   ├── annotation_toolbar.dart
│   │   │       │   ├── highlight_overlay.dart
│   │   │       │   ├── sticky_note_pin.dart
│   │   │       │   └── page_indicator.dart
│   │   │       └── providers/
│   │   │           └── viewer_provider.dart
│   │   ├── annotations/              # Highlights + Notes feature
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── annotation_list_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── color_picker.dart
│   │   │       │   ├── note_editor.dart
│   │   │       │   └── annotation_card.dart
│   │   │       └── providers/
│   │   │           ├── highlight_provider.dart
│   │   │           └── note_provider.dart
│   │   ├── ai_chat/                 # AI Q&A feature
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── ai_chat_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── chat_bubble.dart
│   │   │       │   ├── chat_input_bar.dart
│   │   │       │   ├── citation_badge.dart
│   │   │       │   └── typing_indicator.dart
│   │   │       └── providers/
│   │   │           └── chat_provider.dart
│   │   ├── summarization/            # AI summary feature
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── summary_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── summary_card.dart
│   │   │       │   └── scope_selector.dart
│   │   │       └── providers/
│   │   │           └── summary_provider.dart
│   │   ├── folders/                 # Folder management feature
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── folder_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── folder_list_tile.dart
│   │   │       │   └── create_folder_dialog.dart
│   │   │       └── providers/
│   │   │           └── folder_provider.dart
│   │   └── settings/                # Settings & profile feature
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │           ├── screens/
│   │           │   └── settings_screen.dart
│   │           ├── widgets/
│   │           │   ├── theme_toggle.dart
│   │           │   └── account_section.dart
│   │           └── providers/
│   │               └── settings_provider.dart
│   ├── services/                     # External service integrations
│   │   ├── auth/
│   │   │   ├── auth_service.dart         # Abstract interface
│   │   │   ├── supabase_auth_service.dart
│   │   │   └── mock_auth_service.dart
│   │   ├── ai/
│   │   │   ├── ai_service.dart           # Abstract interface
│   │   │   ├── nemotron_parse_service.dart
│   │   │   ├── nemotron_ultra_service.dart
│   │   │   ├── nemotron_nano_service.dart
│   │   │   └── mock_ai_service.dart
│   │   ├── storage/
│   │   │   ├── cloud_storage_service.dart
│   │   │   └── local_storage_service.dart
│   │   └── notification/
│   │       └── notification_service.dart
│   └── l10n/                         # Localization files
│       ├── app_en.arb                # English strings
│       └── app_es.arb                # Spanish strings (V2)
├── assets/                           # Static assets
│   ├── images/
│   │   ├── logo.png
│   │   ├── onboarding_1.png
│   │   ├── onboarding_2.png
│   │   ├── onboarding_3.png
│   │   ├── empty_state.png
│   │   └── google_icon.png
│   └── fonts/
│       ├── Inter-Regular.ttf
│       ├── Inter-Medium.ttf
│       ├── Inter-SemiBold.ttf
│       └── Inter-Bold.ttf
├── test/                             # Unit and widget tests
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── document_viewer/
│   │   ├── annotations/
│   │   ├── ai_chat/
│   │   ├── summarization/
│   │   └── folders/
│   ├── core/
│   ├── services/
│   └── widgets/
├── integration_test/                 # Integration tests
├── pubspec.yaml                      # Package manifest
├── analysis_options.yaml             # Lint rules
├── .gitignore
├── README.md
├── PRD.md
├── architecture.md
├── rules.md
├── phases.md
├── design.md
├── memory.md
└── project_timeline.md
```

### 4.2 Architecture Patterns

The project follows **Clean Architecture** with three layers per feature:

**Presentation Layer** (UI)
- Screens — full-page widgets
- Widgets — reusable UI components
- Providers — Riverpod state providers

**Domain Layer** (Business Logic)
- Entities — pure Dart business objects
- Repositories — abstract interfaces for data access

**Data Layer** (Implementation)
- Repositories — concrete implementations of domain interfaces
- Models — data transfer objects (DTOs) for serialization
- Services — external API integrations

### 4.3 File Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Feature folder | snake_case | `ai_chat/` |
| Screen file | `*_screen.dart` | `login_screen.dart` |
| Widget file | `*_widget.dart` or descriptive | `chat_bubble.dart` |
| Provider file | `*_provider.dart` | `auth_provider.dart` |
| Repository interface | `*_repository.dart` | `document_repository.dart` |
| Repository implementation | `*_repository_impl.dart` or `supabase_*` | `supabase_document_repository.dart` |
| Model/Entity | `*_model.dart` / `*_entity.dart` | `document_model.dart` |
| Service interface | `*_service.dart` | `ai_service.dart` |
| Service implementation | `*_service_impl.dart` | `nemotron_ultra_service.dart` |

---

## 5. Data Flow Diagrams

### 5.1 Authentication Flow

```
User taps "Sign In with Google"
         │
         ▼
┌─────────────────────┐
│ Auth Screen          │
│ Calls AuthService    │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Supabase Auth        │
│ signInWithOAuth()    │
│ Opens Google Sign-In │
│ system dialog        │
└────────┬────────────┘
         │
    ┌────┴────┐
    │ Success  │──── Failure ──── Show error snackbar
    └────┬────┘
         │
         ▼
┌─────────────────────┐
│ Receive Auth Token   │
│ Store in flutter_    │
│ secure_storage       │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Update Riverpod      │
│ AuthStateProvider    │
│ State → Authenticated│
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Navigate to          │
│ Dashboard Screen     │
└─────────────────────┘
```

### 5.2 Document Upload Flow

```
User taps FAB "+" → Selects "Upload PDF"
         │
         ▼
┌─────────────────────┐
│ file_picker opens    │
│ User selects PDF     │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Validate file        │
│ ✓ Is PDF?            │
│ ✓ Under 50MB?        │
│ ✓ At least 1 page?   │
└────────┬────────────┘
    ┌────┴────┐
    │ Invalid  │──── Show validation error
    └────┬────┘
    ┌────┴────┐
    │ Valid    │
    └────┬────┘
         │
         ▼
┌─────────────────────┐
│ Copy file to app     │
│ documents directory  │
│ (local persistence)  │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Generate thumbnail   │
│ Render first page    │
│ at reduced resolution│
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Create Document      │
│ metadata record      │
│ Store in Hive        │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Upload to Supabase   │
│ Storage (background) │
│ + Save metadata to   │
│ Supabase Database    │
└────────┬────────────┘
         │
    ┌────┴──────────┐
    │ Online         │──── Queue for retry if offline
    └────┬──────────┘
         │
         ▼
┌─────────────────────┐
│ Trigger background   │
│ text extraction      │
│ (Nemotron-Parse)     │
│ Page → Image → API   │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Store extracted text │
│ + bounding boxes     │
│ in Hive              │
│ (enable search + AI) │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Update Dashboard     │
│ New document card    │
│ appears with thumb   │
└─────────────────────┘
```

### 5.3 AI Query Flow (Summarization + Q&A)

```
User taps "Summarize" / Sends chat message
         │
         ▼
┌─────────────────────┐
│ Check rate limiter   │
│ (max 40 RPM)        │
└────────┬────────────┘
    ┌────┴──────────┐
    │ Over limit     │──── Show "Please wait" + queue request
    └────┬──────────┘
    ┌────┴──────────┐
    │ Within limit   │
    └────┬──────────┘
         │
         ▼
┌─────────────────────┐
│ Check local cache   │
│ (same doc + query?) │
└────────┬────────────┘
    ┌────┴──────────┐
    │ Cache hit       │──── Return cached response immediately
    └────┬──────────┘
    ┌────┴──────────┐
    │ Cache miss      │
    └────┬──────────┘
         │
         ▼
┌─────────────────────┐
│ Load document text   │
│ + bounding boxes     │
│ from Hive cache      │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Prepare API request  │
│ - Document context   │
│   (relevant pages)   │
│ - User question      │
│ - System prompt      │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Send to Supabase     │
│ Edge Function        │
│ (hides NVIDIA API    │
│  key from client)    │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Edge Function calls  │
│ NVIDIA Nemotron API  │
│ (Ultra 550B or       │
│  Nano 30B based on   │
│  complexity)         │
└────────┬────────────┘
         │
    ┌────┴──────────┐
    │ Error           │──── Retry once, then show error
    └────┬──────────┘
    ┌────┴──────────┐
    │ Success         │
    └────┬──────────┘
         │
         ▼
┌─────────────────────┐
│ Parse response       │
│ - Answer text        │
│ - Page citations     │
│ - Confidence score   │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Cache response       │
│ in Hive              │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Store in Supabase    │
│ (chat history /      │
│  summary log)        │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Display to user      │
│ - Summary card with  │
│   copy/share buttons │
│ - OR chat bubble     │
│   with citations     │
└─────────────────────┘
```

### 5.4 Annotation Flow

```
User selects text on PDF page
         │
         ▼
┌─────────────────────┐
│ Text selection ends  │
│ Show highlight       │
│ toolbar popup        │
└────────┬────────────┘
         │
    ┌────┴──────────────┐
    │ User taps color    │──→ Create highlight entity
    └────┬──────────────┘         │
         │                        ▼
         │               ┌─────────────────────┐
         │               │ Store in Hive        │
         │               │ (documentId, page,   │
         │               │  color, startOffset,  │
         │               │  endOffset, text)     │
         │               └────────┬────────────┘
         │                        │
         │                        ▼
         │               ┌─────────────────────┐
         │               │ Push to undo stack   │
         │               └────────┬────────────┘
         │                        │
         │                        ▼
         │               ┌─────────────────────┐
         │               │ Queue cloud sync     │
         │               │ (Supabase)           │
         │               └─────────────────────┘
         │
    ┌────┴──────────────┐
    │ User taps "Add     │──→ Open note editor
    │ Note"               │         │
    └────┬──────────────┘          ▼
         │               ┌─────────────────────┐
         │               │ User types note      │
         │               │ (max 500 chars)      │
         │               │ Taps "Save"          │
         │               └────────┬────────────┘
         │                        │
         │                        ▼
         │               ┌─────────────────────┐
         │               │ Store note in Hive   │
         │               │ (page, x, y, text,   │
         │               │  createdAt)           │
         │               └────────┬────────────┘
         │                        │
         │                        ▼
         │               ┌─────────────────────┐
         │               │ Render pin icon at   │
         │               │ (x, y) on page       │
         │               └────────────────────┘
         │
    ┌────┴──────────────┐
    │ User taps undo     │──→ Pop last action from
    │                     │    undo stack, reverse it
    └───────────────────┘
```

### 5.5 Offline/Online Sync Flow

```
┌─────────────────────────────────────────────┐
│ APP STARTS                                  │
│ Check network connectivity                   │
└────────────────┬────────────────────────────┘
                 │
        ┌────────┴────────┐
        │ OFFLINE          │ ONLINE
        │                  │
        ▼                  ▼
┌──────────────┐  ┌──────────────────┐
│ Load from    │  │ Load from Hive   │
│ Hive only    │  │ (fast, cached)   │
│ (full works) │  └────────┬─────────┘
└──────────────┘           │
                           ▼
                  ┌──────────────────┐
                  │ Check sync queue │
                  │ (pending uploads, │
                  │  annotation sync) │
                  └────────┬─────────┘
                           │
                  ┌────────┴────────┐
                  │ Queue empty      │ Queue has items
                  └────────┬────────┘  │
                           │           ▼
                           │  ┌──────────────────┐
                           │  │ Process queue:    │
                           │  │ 1. Upload docs    │
                           │  │ 2. Sync annot.    │
                           │  │ 3. Sync chat      │
                           │  │    history         │
                           │  └──────────────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │ App fully loaded │
                  │ Ready for use    │
                  └──────────────────┘
```

---

## 6. Database Schema

### 6.1 Supabase PostgreSQL (Cloud)

```sql
-- Users table (auto-managed by Supabase Auth, extended here)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  display_name TEXT,
  avatar_url TEXT,
  subscription_tier TEXT DEFAULT 'free',
  daily_ai_queries INT DEFAULT 0,
  last_query_reset DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Folders
CREATE TABLE folders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  color TEXT,
  parent_id UUID REFERENCES folders(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Documents (metadata only — files stored locally or in Supabase Storage)
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  folder_id UUID REFERENCES folders(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size_bytes BIGINT,
  page_count INT,
  storage_path TEXT,
  thumbnail_path TEXT,
  has_extracted_text BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_opened_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Highlights
CREATE TABLE highlights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  page_number INT NOT NULL,
  start_offset INT NOT NULL,
  end_offset INT NOT NULL,
  selected_text TEXT,
  color TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sticky Notes
CREATE TABLE sticky_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  page_number INT NOT NULL,
  x_position DOUBLE PRECISION NOT NULL,
  y_position DOUBLE PRECISION NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI Summaries
CREATE TABLE summaries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  scope TEXT NOT NULL, -- 'page', 'section', 'selection'
  scope_reference TEXT,
  content TEXT NOT NULL,
  model_used TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI Chat History
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL, -- 'user' or 'assistant'
  content TEXT NOT NULL,
  citations JSONB,
  model_used TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 6.2 Hive Local Storage (On-Device)

| Box Name | Key Type | Value Type | Purpose |
|---|---|---|---|
| `user_box` | `String` ("current_user") | `UserModel` | Cached user profile |
| `settings_box` | `String` ("theme") | `String` ("light"/"dark") | User preferences |
| `documents_box` | `String` (UUID) | `DocumentModel` | Document metadata cache |
| `highlights_box` | `String` (UUID) | `List<HighlightModel>` | Highlights per document |
| `notes_box` | `String` (UUID) | `List<NoteModel>` | Notes per document |
| `extracted_text_box` | `String` (doc UUID) | `ExtractedTextModel` | Parsed text + bounding boxes |
| `chat_history_box` | `String` (doc UUID) | `List<ChatMessageModel>` | Chat messages per document |
| `summary_cache_box` | `String` (hash) | `SummaryModel` | Cached AI summaries |
| `sync_queue_box` | `String` (UUID) | `SyncActionModel` | Pending cloud sync actions |

---

## 7. API Design

### 7.1 Supabase Edge Functions (API Proxy)

Edge functions serve as a **secure proxy** between the client and NVIDIA API, hiding the API key from the mobile app.

**POST /functions/v1/summarize**
- Input: `documentId`, `scope` ("page"|"section"|"selection"), `pageNumber`, `selectedText?`
- Process: Load extracted text → Send to Nemotron Ultra 550B → Return summary
- Rate limit: Enforced per user per day

**POST /functions/v1/chat**
- Input: `documentId`, `message`, `chatHistory?`
- Process: Load document context + chat history → Send to Nemotron Ultra 550B → Return response with citations
- Rate limit: Enforced per user per day

**POST /functions/v1/extract-text**
- Input: `documentId`, `pageImages` (base64 encoded)
- Process: Send to Nemotron-Parse → Return structured text with bounding boxes
- Rate limit: Per document (one-time extraction)

**GET /functions/v1/rate-limit**
- Input: (none — reads from auth header)
- Process: Check current usage against tier limits
- Returns: `{ queriesUsed, queriesRemaining, resetsAt }`

### 7.2 Client-Server Communication Pattern

All client-server communication follows this pattern:

1. Client calls a **Repository method** (domain layer)
2. Repository delegates to **Service implementation** (data layer)
3. Service builds request and sends via **Dio HTTP client**
4. Dio interceptor attaches **Supabase auth token** to every request
5. Dio interceptor handles **retry on network failure** (3 attempts, exponential backoff)
6. Response is **deserialized** into a domain entity
7. Entity is **cached locally** in Hive
8. Entity is **returned** to the provider/presentation layer

---

## 8. Security Architecture

### 8.1 Data Protection

| Data Type | Storage | Encryption |
|---|---|---|
| User passwords | Supabase Auth (bcrypt hashed) | Platform-managed |
| Auth tokens | flutter_secure_storage | iOS Keychain / Android Keystore |
| Document files | App documents directory (local) | Platform sandbox (app isolation) |
| Annotations | Hive (local) + Supabase (cloud) | Supabase at-rest encryption |
| AI API keys | Supabase Edge Functions only | Never on client device |
| Chat history | Hive (local) + Supabase (cloud) | Supabase at-rest encryption |

### 8.2 Security Rules

1. **API keys never leave the server.** NVIDIA API keys are stored in Supabase Edge Function secrets only. The mobile app never has direct access.
2. **All API calls use HTTPS.** No plaintext communication.
3. **Authentication tokens are refreshed automatically.** Tokens expire after 1 hour; refresh tokens last 30 days.
4. **Row-level security (RLS) on all Supabase tables.** Users can only read/write their own data.
5. **Input sanitization** on all user-generated content (notes, chat messages) to prevent injection attacks.
6. **No sensitive data in logs.** Logger redacts auth tokens, user IDs in production builds.
7. **Document files are app-sandboxed.** Other apps cannot access MindSpace document storage.

### 8.3 Privacy Guarantees

- User documents are **never sent to NVIDIA** as raw files. Only extracted text (not images) is sent for AI processing.
- NVIDIA Nemotron free tier has **no data retention policy** — queries are not stored for training.
- Supabase stores **metadata only** (titles, page counts, annotations). Actual document files can remain device-only.
- Users can **delete all their data** at any time from Settings → Account → Delete All Data.
- No analytics or tracking SDKs in the app. Only basic error logging via Supabase.
