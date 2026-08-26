# Contributing to MindSpace

Thank you for your interest in contributing to MindSpace! This document provides guidelines and instructions for contributing to this project.

---

## Table of Contents

1. [Getting Started](#1-getting-started)
2. [Development Workflow](#2-development-workflow)
3. [Code Standards](#3-code-standards)
4. [Commit Guidelines](#4-commit-guidelines)
5. [Pull Request Process](#5-pull-request-process)
6. [Reporting Issues](#6-reporting-issues)
7. [Code of Conduct](#7-code-of-conduct)

---

## 1. Getting Started

### Prerequisites

Before you begin, ensure you have:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.24+
- [Dart SDK](https://dart.dev/get-dart) 3.5+ (included with Flutter)
- [Git](https://git-scm.com/) 2.30+
- [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter/Dart plugins
- A [Puter](https://puter.com) account (free tier)
- An [NVIDIA](https://build.nvidia.com) account for AI API keys

### Fork & Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/mindspace.git
   cd mindspace
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/Sakeeb24/Mindspace.git
   ```

### Environment Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Configure environment variables:
   - Copy `lib/config/env.dart.example` to `lib/config/env.dart`
   - Add your Puter credentials
   - **Never commit API keys**

4. Set up Puter:
   - Create a project at [puter.com](https://puter.com)
   - Run the database schema from `architecture.md` (Section 6.1)
   - Configure Puter auth token in env.dart

5. Run the app:
   ```bash
   flutter run
   ```

---

## 2. Development Workflow

### Branch Strategy

```
main          ← Production-ready code (protected)
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

### Creating a Branch

Always start from `develop` (or the appropriate base branch):

```bash
git checkout develop
git pull upstream develop
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/short-description` — New features
- `fix/short-description` — Bug fixes
- `docs/short-description` — Documentation updates
- `test/short-description` — Test additions/improvements
- `chore/short-description` — Maintenance tasks

### Keeping Your Branch Updated

Regularly sync with upstream:

```bash
git fetch upstream
git rebase upstream/develop
```

Resolve any conflicts during rebase, then force-push to your fork:

```bash
git push origin your-branch-name --force-with-lease
```

---

## 3. Code Standards

### General Rules

1. **Follow the Dart style guide**: [dart.dev/effective-dart/style](https://dart.dev/effective-dart/style)
2. **Use `flutter analyze`**: Zero warnings required before submitting
3. **No hardcoded strings**: All user-facing text goes in ARB localization files
4. **No `print()` statements**: Use the `AppLogger` utility instead
5. **One widget per file**: Keep files focused and manageable
6. **Use `const` constructors**: Whenever possible for performance

### Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Classes | PascalCase | `DocumentRepository` |
| Variables/Functions | camelCase | `fetchDocuments` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_FILE_SIZE_BYTES` |
| Files | snake_case | `document_repository.dart` |
| Folders | snake_case | `document_viewer/` |
| Enums | PascalCase values | `HighlightColor.yellow` |

### Architecture Layers

Follow the clean architecture pattern:

```
features/
├── auth/
│   ├── data/          # Repository implementations, API calls
│   ├── domain/        # Business entities, repository interfaces
│   └── presentation/  # Screens, widgets, providers
```

**Dependency Rule**: Dependencies flow inward only. Presentation → Domain ← Data. Domain layer must never import from Presentation or Data layers.

### Testing Requirements

- **Unit tests**: For all business logic (domain + data layers)
- **Widget tests**: For all screens and key widgets
- **Coverage target**: ≥ 80% for domain and data layers

Run tests before submitting:

```bash
flutter test
flutter test --coverage
```

---

## 4. Commit Guidelines

### Format

```
<type>(<scope>): <description>

<body>

<footer>
```

### Types

| Type | Description |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Code style changes (formatting, no logic change) |
| `refactor` | Code refactoring (no feature change) |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks |
| `perf` | Performance improvements |

### Examples

```
feat(auth): add Puter token sign-in integration
fix(viewer): resolve crash on 200+ page PDFs
docs(prd): update monetization strategy
test(chat): add unit tests for chat provider
chore(deps): upgrade puter_flutter to 2.8.0
```

### Rules

- Use imperative mood ("add feature" not "added feature")
- Keep subject line under 72 characters
- Reference issue numbers when applicable: `fix(auth): resolve login timeout (#42)`
- Separate subject from body with blank line
- Use body to explain what and why, not how

---

## 5. Pull Request Process

### Before Submitting

1. **Update your branch** with latest upstream changes
2. **Run all checks**:
   ```bash
   flutter analyze
   flutter test
   ```
3. **Ensure code generation is fresh**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Review your changes** for:
   - Follows coding standards
   - Includes tests for new functionality
   - No hardcoded strings (localization)
   - No debug/print statements
   - Proper error handling
   - Accessibility considerations

### Creating the PR

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a PR from your fork to `develop` (not `main`)

3. Fill in the PR template:
   - **What**: Brief description of changes
   - **Why**: Motivation and context
   - **How to test**: Steps to verify the changes
   - **Screenshots**: If UI changes are involved

### PR Title Format

Match commit message format:
```
feat(auth): add Puter token sign-in integration
```

### PR Size Guidelines

- Keep PRs under **400 lines** of changes
- Split large features into smaller, reviewable PRs
- Each PR should be a complete, working unit

### Review Process

1. **Automated checks** must pass (CI, linting, tests)
2. **Code review** by at least one maintainer
3. **Address feedback** promptly
4. **Squash merge** when approved

### After Merge

1. Delete your feature branch
2. Pull latest from upstream:
   ```bash
   git checkout develop
   git pull upstream develop
   ```

---

## 6. Reporting Issues

### Bug Reports

When reporting bugs, include:

1. **Environment**: Flutter version, device/emulator, OS version
2. **Steps to reproduce**: Clear, numbered steps
3. **Expected behavior**: What should happen
4. **Actual behavior**: What actually happens
5. **Screenshots/videos**: If applicable
6. **Logs**: Any error messages or console output

### Feature Requests

When requesting features, include:

1. **Problem**: What problem does this solve?
2. **Proposed solution**: How would you implement it?
3. **Alternatives considered**: Other approaches
4. **Additional context**: Use cases, examples

### Issue Labels

| Label | Description |
|---|---|
| `bug` | Something isn't working |
| `enhancement` | New feature or improvement |
| `documentation` | Documentation improvements |
| `good first issue` | Good for newcomers |
| `help wanted` | Extra attention needed |
| `question` | Further information requested |

---

## 7. Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone. We pledge to act and interact in ways that contribute to an open, friendly, diverse, and healthy community.

### Expected Behavior

- Be respectful and inclusive
- Give and receive constructive feedback
- Focus on what is best for the community
- Show empathy towards other contributors

### Unacceptable Behavior

- Harassment, trolling, or personal attacks
- Publishing private information without permission
- Any conduct that would be considered inappropriate in a professional setting

### Enforcement

Project maintainers have the right to remove, edit, or reject comments, commits, code, issues, and other contributions that do not align with this Code of Conduct.

---

## Questions?

If you have questions about contributing:

1. Check existing documentation in `docs/`
2. Search existing issues and PRs
3. Open a new issue with the `question` label
4. Reach out to the project maintainers

---

**Thank you for contributing to MindSpace! 🎓**
