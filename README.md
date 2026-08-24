# MindSpace

> **A free, AI-powered document intelligence and study assistant for students.**

MindSpace helps college and high school students organize, read, annotate, and interact with their PDF study materials. Upload documents, highlight key concepts, add sticky notes, and use AI to summarize chapters or ask questions about your materials — all completely free.

---

## Features

### MVP (Version 1)

- **Document Management** — Upload, organize, and browse PDFs in folders
- **PDF Viewer** — Smooth rendering with pinch-to-zoom and page navigation
- **Highlighting** — 4-color text highlighting with persistent storage
- **Sticky Notes** — Add notes anchored to specific document sections
- **AI Summarization** — One-click summaries of chapters, sections, or selections
- **AI Q&A Chat** — Ask natural language questions about your documents
- **Undo/Redo** — Full undo/redo for all annotation actions
- **Offline Access** — Read and annotate without internet connection
- **Dark Mode** — Full light and dark theme support

### Coming in Version 2

- AI-generated flashcards and quizzes
- Collaboration with classmates
- Web clipper browser extension
- Export notes as PDF, Word, or Markdown

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.24+ (Dart 3.5+) |
| **State Management** | Riverpod 2.6+ |
| **Local Database** | Hive 2.2+ |
| **PDF Rendering** | pdfx 2.6+ |
| **Authentication** | Supabase Auth (Email + Google) |
| **Cloud Database** | Supabase PostgreSQL (free tier: 500MB) |
| **Cloud Storage** | Supabase Storage (free tier: 1GB) |
| **AI — Text Extraction** | NVIDIA Nemotron-Parse API (free tier: 40 RPM) |
| **AI — Summarization & Q&A** | NVIDIA Nemotron 3 Ultra 550B (free tier: 40 RPM) |
| **CI/CD** | GitHub Actions |

---

## Getting Started

### Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Flutter SDK | 3.24+ | [Install Flutter](https://docs.flutter.dev/get-started/install) |
| Dart SDK | 3.5+ | Included with Flutter |
| Android Studio | Latest | For Android emulator and SDK |
| Xcode | Latest | For iOS simulator (macOS only) |
| Git | 2.30+ | Version control |
| Supabase Account | Free | [Create project](https://supabase.com) |
| NVIDIA API Key | Free | [Get API key](https://build.nvidia.com) |

### Step 1: Clone the Repository

```bash
git clone https://github.com/[your-org]/mindspace.git
cd mindspace
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates Freezed models, Hive TypeAdapters, and Riverpod providers.

To watch for changes during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Step 4: Configure Environment Variables

Create the file `lib/config/env.dart` with your API keys:

```dart
class Env {
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Note: NVIDIA API keys are stored in Supabase Edge Functions
  // and are NEVER included in the mobile app.
}
```

> **Important**: Never commit API keys. The `env.dart` file should be in `.gitignore`.

### Step 5: Set Up Supabase

1. Create a free account at [supabase.com](https://supabase.com)
2. Create a new project
3. Go to **Settings → API** and copy:
   - Project URL
   - Anon (public) key
4. Go to **Authentication → Providers** and enable:
   - Email (enable email confirmations for production)
   - Google (requires Google Cloud Console OAuth setup)
5. Go to **SQL Editor** and run the database schema from `architecture.md` (Section 6.1)
6. Go to **Storage** and create a bucket named `documents`

### Step 6: Set Up NVIDIA Nemotron API

1. Create a free account at [build.nvidia.com](https://build.nvidia.com)
2. Navigate to NVIDIA Nemotron-Parse and generate an API key
3. Navigate to NVIDIA Nemotron 3 Ultra 550B and generate an API key
4. Store these keys as Supabase Edge Function secrets (not in the app):

```bash
# Using Supabase CLI
supabase secrets set NEMOTRON_PARSE_API_KEY=your_key_here
supabase secrets set NEMOTRON_ULTRA_API_KEY=your_key_here
```

5. Deploy the Edge Functions:

```bash
supabase functions deploy summarize
supabase functions deploy chat
supabase functions deploy extract-text
```

### Step 7: Run the App

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Chrome (for quick testing):**
```bash
flutter run -d chrome
```

---

## API Key Configuration Guide

### Where Keys Are Stored

| Key | Location | Who Has Access |
|---|---|---|
| Supabase URL | `lib/config/env.dart` | Mobile app |
| Supabase Anon Key | `lib/config/env.dart` | Mobile app (public, row-level security enforced) |
| Supabase Service Key | Supabase Dashboard only | Admin only |
| NVIDIA Nemotron-Parse Key | Supabase Edge Function secrets | Server-side only |
| NVIDIA Nemotron Ultra Key | Supabase Edge Function secrets | Server-side only |
| Google OAuth Client ID | `android/app/build.gradle` + `ios/Runner/Info.plist` | Mobile app (public, secured by Google) |

### Security Rules

1. **Never** put NVIDIA API keys in the mobile app
2. **Never** commit `.env` files or `env.dart` to version control
3. The Supabase anon key is safe to include — row-level security protects user data
4. Rotate keys immediately if accidentally exposed
5. Use different API keys for development and production

---

## Project Structure

```
mindspace/
├── lib/
│   ├── app.dart                    # App root widget
│   ├── main.dart                   # Entry point
│   ├── config/                     # Theme, constants, routes, env
│   ├── core/                       # Shared utilities, widgets, errors
│   ├── features/                   # Feature modules (clean architecture)
│   │   ├── auth/                   # Authentication
│   │   ├── dashboard/              # Document dashboard
│   │   ├── document_viewer/        # PDF viewer
│   │   ├── annotations/            # Highlights + Notes
│   │   ├── ai_chat/                # AI Q&A chat
│   │   ├── summarization/          # AI summaries
│   │   ├── folders/                # Folder management
│   │   └── settings/               # User settings
│   ├── services/                   # External service integrations
│   └── l10n/                       # Localization (ARB files)
├── assets/                         # Images, fonts
├── test/                           # Unit + widget tests
├── integration_test/               # Integration tests
├── PRD.md                          # Product Requirements
├── architecture.md                 # System Architecture
├── rules.md                        # Project Standards
├── phases.md                       # Development Phases
├── design.md                       # UI/UX Guidelines
├── memory.md                       # Project Memory
└── project_timeline.md             # Timeline & Milestones
```

See `architecture.md` for the complete folder structure with every file.

---

## Development Commands

| Command | Purpose |
|---|---|
| `flutter pub get` | Install dependencies |
| `dart run build_runner build` | Generate code (Freezed, Hive, Riverpod) |
| `dart run build_runner watch` | Watch mode for code generation |
| `flutter analyze` | Run static analysis (must have 0 warnings) |
| `flutter test` | Run unit and widget tests |
| `flutter test --coverage` | Run tests with coverage report |
| `flutter run -d <device>` | Run app on device |
| `flutter build apk` | Build Android release APK |
| `flutter build ipa` | Build iOS release |
| `supabase start` | Start local Supabase (for development) |
| `supabase functions deploy` | Deploy Edge Functions |

---

## Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/features/auth/auth_provider_test.dart

# Run integration tests (requires device/emulator)
flutter test integration_test/
```

### Coverage Requirements

- Domain and Data layers: ≥ 80% coverage
- All screens: Widget tests for rendering and interactions
- All providers: Unit tests for state transitions

---

## Contributing

### Branch Workflow

1. `main` — Production-ready code (protected)
2. `develop` — Integration branch (all features merge here)
3. `feature/*` — New feature branches
4. `fix/*` — Bug fix branches

### Contribution Steps

1. Create a feature/fix branch from `develop`
2. Make your changes following the coding standards in `rules.md`
3. Write tests for new functionality
4. Ensure `flutter analyze` shows zero warnings
5. Ensure all tests pass (`flutter test`)
6. Create a pull request to `develop`
7. Fill in the PR template (what, why, how to test)
8. Wait for CI to pass and code review approval

### Commit Messages

Follow the format: `<type>(<scope>): <description>`

Examples:
- `feat(auth): add Google Sign-In integration`
- `fix(viewer): resolve crash on 200+ page PDFs`
- `test(chat): add unit tests for chat provider`
- `docs(prd): update monetization strategy`

### Code Style

See `rules.md` for the full coding standards. Key rules:

- Follow Dart style guide
- Use `snake_case` for files and folders
- Use `PascalCase` for classes
- Use `camelCase` for variables and functions
- One widget per file
- No hardcoded strings (use localization)
- No `print()` in production code

---

## Troubleshooting

### Common Issues

**Code generation fails**
```bash
dart run build_runner build --delete-conflicting-outputs
```
The `--delete-conflicting-outputs` flag resolves most conflicts.

**Supabase connection fails**
- Check that `supabaseUrl` and `supabaseAnonKey` are correct in `env.dart`
- Verify the Supabase project is not paused (free tier pauses after 7 days of inactivity)
- Check that RLS policies are configured on all tables

**PDF won't render**
- Ensure the PDF file is valid and not corrupted
- Check file size (max 50MB)
- Try a different PDF to rule out file-specific issues

**AI features return errors**
- Verify NVIDIA API keys are set in Supabase Edge Functions
- Check you haven't exceeded the 40 RPM free tier limit
- Verify Edge Functions are deployed (`supabase functions list`)

**Build fails on iOS**
```bash
cd ios && pod install && cd ..
flutter clean
flutter pub get
```

**Hive box errors**
- Ensure `Hive.initFlutter()` is called in `main()` before any box operations
- Ensure all Hive TypeAdapters are registered before box operations
- Run `build_runner build` to regenerate TypeAdapters

---

## Documentation

| Document | Purpose |
|---|---|
| [PRD.md](PRD.md) | Product requirements, features, success metrics |
| [architecture.md](architecture.md) | System design, tech stack, data flows, database schema |
| [rules.md](rules.md) | Coding standards, approved tech, error handling, security |
| [phases.md](phases.md) | 6-phase development plan across 8 weeks |
| [design.md](design.md) | UI/UX guidelines, color system, typography, components |
| [memory.md](memory.md) | Project decisions, current status, learnings |
| [project_timeline.md](project_timeline.md) | Week-by-week breakdown, milestones, risks |

---

## License

This project is private and proprietary. All rights reserved.

---

## Support

For questions or issues:
- Check this README and the planning documents first
- Search existing GitHub issues
- Create a new issue with steps to reproduce
- For urgent issues, contact the project lead directly

---

**Built with 💜 for students everywhere.**
