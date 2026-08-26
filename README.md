# MindSpace

**Free AI Study Assistant** — Your personal LiquidText alternative, completely free.

<p align="center">
  <img src="screenshots/mindspace-ui-preview.html" alt="MindSpace UI Preview" width="100%">
</p>

## Features

### Authentication
- Puter account token-based authentication
- Auth persistence across app restarts (secure token storage)

### Dashboard
- Document grid with search and sort
- Folder organization with CRUD operations
- PDF file picker integration with 50MB / 200-page validation
- Grid/list view toggle

### Document Viewer & Annotations
- PDF rendering with pdfx
- 4-color highlight system (yellow, green, blue, pink)
- Sticky note creation and editing (500-char limit)
- Full undo/redo stack for all annotations (50-action depth)
- Spatial canvas workspace with ink-link connections

### AI Features (Powered by Puter)
- **Summarization**: Page/section/selection scope with 500+ AI models
- **AI Chat**: Ask questions about your documents with citation badges
- **Flashcards**: AI-generated active-recall study cards
- **Quiz**: Interactive multiple-choice quizzes with scoring
- **Formula Extraction**: Key formulas, definitions, and theorems
- Daily AI usage limit (20 queries/day)
- Proper error handling with typed errors and retry UI

### Testing & Quality
- 81 passing tests across 17 test files
- Widget tests for all screens
- Unit tests for entities, providers, and AI service
- Zero lint warnings

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.44.7 |
| **State** | Riverpod 2.x |
| **Routing** | GoRouter with custom transitions |
| **Local Storage** | Hive CE (offline-first) |
| **Cloud AI** | Puter (OpenAI-compatible endpoint, 500+ models) |
| **Auth** | Puter token-based authentication |
| **PDF** | pdfx |
| **Design** | Google Stitch design system |

## Getting Started

### Prerequisites
- Flutter 3.24+
- Dart 3.5+
- A [Puter](https://puter.com) account (free)

### Setup

```bash
# Clone the repository
git clone https://github.com/Sakeeb24/Mind.git
cd Mind

# Install dependencies
flutter pub get

# Run the app with your Puter auth token
flutter run --dart-define=PUTER_AUTH_TOKEN=your_token_here
```

### Environment Variables

All configuration is via `--dart-define` flags. Copy `lib/config/env.dart.example` to `lib/config/env.dart` or pass values at build time:

```bash
# Required: Puter auth token (get from https://puter.com/dashboard → Create token)
--dart-define=PUTER_AUTH_TOKEN=your_token_here

# Optional: AI model selection (default: gpt-4o-mini)
--dart-define=AI_MODEL=gpt-4o-mini
```

**Important**: Puter provides free access to 500+ AI models (GPT, Claude, Gemini, Grok, etc.) with no API key management. Your Puter auth token is the only credential needed.

## Project Structure

```
lib/
├── config/          # Theme, routes, environment
├── core/            # Widgets, utils, services, errors
├── features/
│   ├── auth/        # Puter authentication
│   ├── dashboard/   # Document management
│   ├── document_viewer/  # PDF viewer + annotations
│   ├── ai_chat/     # AI chat interface
│   ├── summarization/    # AI summarization
│   └── folders/     # Folder organization
├── providers/       # AI service provider
└── services/        # AI service (Puter OpenAI-compatible)
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

Built with **Google Stitch** design system:
- Typography hierarchy (display → label)
- Consistent spacing (8/16/24/32/48px)
- Neutral surfaces with intentional accent color
- Subtle animations (fade-in, scale, pulse)
- Custom page transitions

## License

MIT License

## Acknowledgments

- [Puter](https://puter.com) — Free AI and cloud infrastructure
- [Supabase](https://supabase.com) — Previously used for backend (migrated to Puter)
- [NVIDIA](https://build.nvidia.com) — AI models
