# MindSpace

**Free AI Study Assistant** — Your personal LiquidText alternative, completely free.

<p align="center">
  <img src="screenshots/mindspace-ui-preview.html" alt="MindSpace UI Preview" width="100%">
</p>

## Features

### Phase 1 — Authentication
- Email/password sign-up and sign-in
- Google OAuth integration
- Forgot password flow
- Auth persistence across app restarts

### Phase 2 — Dashboard
- Document grid with search and sort
- Folder organization with CRUD operations
- PDF file picker integration
- Grid/list view toggle

### Phase 3 — Document Viewer & Annotations
- PDF rendering with pdfx
- 4-color highlight system (yellow, green, blue, pink)
- Sticky note creation and editing
- Full undo/redo stack for all annotations

### Phase 4 — AI Features
- **Summarization**: Page/section/selection scope with Nemotron Ultra 550B
- **AI Chat**: Ask questions about your documents with citation badges
- Rate limiting (20 queries/day on free tier)
- Offline mock service for development

### Phase 5 — Testing & Quality
- 81 passing tests across 17 test files
- Widget tests for all screens
- Unit tests for entities, providers, and AI service
- Web Design Guidelines compliance audit

## Screenshots

Open `screenshots/mindspace-ui-preview.html` in your browser to see all 6 screens:

| Screen | Description |
|--------|-------------|
| **Login** | Email/password + Google OAuth with staggered animations |
| **Sign Up** | Account creation with validation |
| **Dashboard** | Document grid with folders and search |
| **Document Viewer** | PDF viewer with annotation toolbar |
| **AI Chat** | Chat interface with citation badges |
| **AI Summary** | Scope selector with generate/copy/share |

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.24 |
| **State** | Riverpod 2.x |
| **Routing** | GoRouter with custom transitions |
| **Local Storage** | Hive CE |
| **Cloud** | Supabase (Auth + Database) |
| **AI** | NVIDIA Nemotron Ultra 550B |
| **PDF** | pdfx |
| **Design** | Taste Skill + Ponytail |

## Getting Started

### Prerequisites
- Flutter 3.24+
- Dart 3.5+
- Supabase account (free tier)
- NVIDIA API key (free tier)

### Setup

```bash
# Clone the repository
git clone https://github.com/Sakeeb24/Mind.git
cd Mind

# Install dependencies
flutter pub get

# Configure environment
# Edit lib/config/env.dart with your Supabase keys

# Run the app
flutter run
```

### Environment Variables

```dart
// lib/config/env.dart
class Env {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabasePublishableKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

## Project Structure

```
lib/
├── config/          # Theme, routes, environment
├── core/            # Widgets, utils, services
├── features/
│   ├── auth/        # Authentication (domain/data/presentation)
│   ├── dashboard/   # Document management
│   ├── document_viewer/  # PDF viewer + annotations
│   ├── ai_chat/     # AI chat interface
│   ├── summarization/    # AI summarization
│   └── folders/     # Folder organization
└── services/        # AI service interfaces
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/features/auth/
```

## CI/CD

GitHub Actions workflow runs on every push/PR:
- **Test**: Flutter analyze + tests
- **Build Android**: APK artifact
- **Build iOS**: IPA artifact
- **Build Web**: Web build artifact

## Design System

Built with **Taste Skill** principles:
- Typography hierarchy (display → label)
- Consistent spacing (8/16/24/32/48px)
- Neutral surfaces with intentional accent color
- Subtle animations (fade-in, scale, pulse)
- Cupertino page transitions

## License

MIT License

## Acknowledgments

- [Taste Skill](https://github.com/leonxlnx/taste-skill) — Design guidelines
- [Ponytail](https://github.com/vercel-labs/agent-skills) — Code quality
- [Supabase](https://supabase.com) — Backend services
- [NVIDIA](https://build.nvidia.com) — AI models
