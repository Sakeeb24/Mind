# MindSpace — UI/UX Design Guidelines

> **Version**: 1.0 — August 2026
> **Last Updated**: August 24, 2026

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Layout](#4-spacing--layout)
5. [Components](#5-components)
6. [Memory & User Preferences](#6-memory--user-preferences)
7. [Screen Specifications](#7-screen-specifications)
8. [Accessibility](#8-accessibility)
9. [Responsive Design](#9-responsive-design)
10. [Animations & Transitions](#10-animations--transitions)

---

## 1. Design Principles

### 1.1 Core Principles

| Principle | Description |
|---|---|
| **Student-First** | Every decision should ask: "Does this help a student study more effectively?" |
| **Minimal Cognitive Load** | Show only what's needed. Hide complexity behind progressive disclosure. |
| **Mobile-First** | Design for one-handed phone use first. Tablet/desktop enhancements come later. |
| **Instant Feedback** | Every user action gets immediate visual response within 100ms. |
| **Consistency** | Similar actions produce similar results. Patterns repeat predictably. |
| **Delightful Simplicity** | The app should feel calm and unhurried. No visual noise. |

### 1.2 Design Philosophy

MindSpace should feel like a **quiet library, not a busy marketplace**. The UI recedes into the background so the user's documents take center stage. Colors are used sparingly — mostly for interactive elements and status indicators. The reading experience is paramount.

**Visual Hierarchy**
1. Content (document text, AI responses) — highest priority
2. Navigation (bottom bar, back button) — always accessible
3. Actions (annotate, summarize, chat) — contextual
4. Metadata (timestamps, file sizes) — subtle, secondary

---

## 2. Color System

### 2.1 Light Theme (Default)

| Token | Hex | Usage |
|---|---|---|
| **Primary** | #6C63FF | Primary buttons, links, active states, FAB |
| **Primary Light** | #8B83FF | Hover states, secondary badges, subtle highlights |
| **Primary Dark** | #5A52E0 | Pressed states, dark accents |
| **Secondary** | #FF6584 | Accent CTAs, notifications, important badges |
| **Secondary Light** | #FF8FA3 | Hover states for secondary elements |
| **Background** | #F8F9FE | App background (behind all surfaces) |
| **Surface** | #FFFFFF | Cards, sheets, dialogs, elevated containers |
| **Surface Variant** | #F1F3F8 | Disabled surfaces, input backgrounds |
| **Text Primary** | #1A1A2E | Headlines, body text, primary labels |
| **Text Secondary** | #6B7280 | Subtitles, descriptions, timestamps |
| **Text Tertiary** | #9CA3AF | Hints, placeholders, disabled text |
| **Divider** | #E5E7EB | Separators between items |
| **Success** | #10B981 | Success states, positive indicators |
| **Success Background** | #ECFDF5 | Success toast/notification background |
| **Warning** | #F59E0B | Warning states, caution indicators |
| **Warning Background** | #FFFBEB | Warning toast/notification background |
| **Error** | #EF4444 | Error states, destructive actions |
| **Error Background** | #FEF2F2 | Error toast/notification background |

### 2.2 Dark Theme

| Token | Hex | Usage |
|---|---|---|
| **Background** | #0F0F1A | App background |
| **Surface** | #1A1A2E | Cards, sheets, elevated containers |
| **Surface Variant** | #252540 | Disabled surfaces, input backgrounds |
| **Text Primary** | #F8F9FE | Headlines, body text |
| **Text Secondary** | #9CA3AF | Subtitles, timestamps |
| **Text Tertiary** | #6B7280 | Hints, placeholders |
| **Divider** | #2D2D44 | Separators |
| **Primary** | #8B83FF | Slightly lighter primary for dark backgrounds |
| **Secondary** | #FF8FA3 | Slightly lighter secondary |
| **Success** | #34D399 | Brighter green for dark backgrounds |
| **Warning** | #FBBF24 | Brighter amber |
| **Error** | #F87171 | Brighter red |

### 2.3 Highlight Colors

| Color Name | Hex | Usage |
|---|---|---|
| Yellow | #FFEB3B | Default highlight, important concepts |
| Green | #66BB6A | Definitions, key terms |
| Blue | #42A5F5 | Quotes, references |
| Pink | #EC407A | Questions, action items |

### 2.4 Color Application Rules

| Rule | Detail |
|---|---|
| Primary color for actions | All primary buttons, FABs, active navigation items |
| Secondary color sparingly | Only for notifications, badges, secondary CTAs |
| Background color never on content | Background is behind everything; never used on cards |
| Success/Warning/Error for status only | Never use as decorative colors |
| Maximum 3 colors per screen | Avoid rainbow overload; keep it calm |
| High contrast on text | Always verify WCAG AA contrast ratio (4.5:1 minimum) |

---

## 3. Typography

### 3.1 Font Family

**Primary Font**: Inter
- Clean, modern, highly readable at all sizes
- Excellent legibility on mobile screens
- Free and open-source (Google Fonts)
- Available weights: Regular (400), Medium (500), SemiBold (600), Bold (700)

### 3.2 Type Scale

| Token | Font | Weight | Size | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|---|
| Display Large | Inter | Bold | 28sp | 34sp | -0.5 | Onboarding headlines |
| Display Medium | Inter | Bold | 24sp | 30sp | -0.3 | Section titles |
| Headline Large | Inter | Bold | 20sp | 26sp | 0 | Screen titles |
| Headline Medium | Inter | SemiBold | 18sp | 24sp | 0 | Card titles, section headers |
| Title Large | Inter | SemiBold | 16sp | 22sp | 0.1 | List item titles |
| Title Medium | Inter | Medium | 14sp | 20sp | 0.1 | Card subtitles, tab labels |
| Body Large | Inter | Regular | 16sp | 24sp | 0.2 | Primary body text |
| Body Medium | Inter | Regular | 14sp | 20sp | 0.25 | Secondary body text |
| Body Small | Inter | Regular | 12sp | 16sp | 0.4 | Captions, timestamps |
| Label Large | Inter | SemiBold | 14sp | 20sp | 0.1 | Button text |
| Label Medium | Inter | Medium | 12sp | 16sp | 0.5 | Badge text, chip labels |
| Label Small | Inter | Medium | 10sp | 14sp | 0.5 | Tag labels |

### 3.3 Typography Rules

| Rule | Detail |
|---|---|
| Maximum 2 sizes per screen section | Avoid too many different sizes competing for attention |
| Minimum body text size | 14sp (accessibility requirement) |
| Never use bold for emphasis in body | Use color (Primary) for emphasis instead |
| Heading hierarchy | Maximum 3 levels deep per screen |
| Right-aligned text | Only for numbers, timestamps, and right-to-left languages |
| Center-aligned text | Only for headlines, empty states, and onboarding |

---

## 4. Spacing & Layout

### 4.1 Spacing Scale

Based on an 8px grid system:

| Token | Value | Usage |
|---|---|---|
| Space XS | 4px | Tight spacing within compact elements |
| Space SM | 8px | Between related items (icon + text gap) |
| Space MD | 12px | Default spacing within cards |
| Space LG | 16px | Card padding, section spacing |
| Space XL | 24px | Between major sections |
| Space 2XL | 32px | Screen-level padding |
| Space 3XL | 48px | Hero spacing, large gaps |

### 4.2 Layout Grid

| Device | Columns | Gutter | Margin |
|---|---|---|---|
| Phone (< 600px) | 4 | 16px | 16px |
| Small Tablet (600-840px) | 8 | 16px | 24px |
| Large Tablet (> 840px) | 12 | 24px | 32px |

### 4.3 Border Radius

| Token | Value | Usage |
|---|---|---|
| Radius SM | 8px | Buttons, chips, small cards |
| Radius MD | 12px | Cards, dialogs, bottom sheets |
| Radius LG | 16px | Large cards, full-width containers |
| Radius XL | 24px | FAB, avatar |
| Radius Full | 999px | Circular elements (profile pic, icons) |

### 4.4 Elevation & Shadows

| Level | Shadow | Usage |
|---|---|---|
| 0 | None | Flat surfaces (background) |
| 1 | 0 1px 3px rgba(0,0,0,0.08) | Cards at rest |
| 2 | 0 4px 8px rgba(0,0,0,0.12) | Cards in pressed state, bottom sheets |
| 3 | 0 8px 16px rgba(0,0,0,0.16) | Dialogs, FAB |
| 4 | 0 12px 24px rgba(0,0,0,0.20) | Modals, floating elements |

---

## 5. Components

### 5.1 Buttons

**Primary Button**
- Background: Primary (#6C63FF)
- Text: White, SemiBold, 14sp
- Height: 48px
- Border Radius: 8px
- Padding: 0 24px
- State: Default → Pressed (Primary Dark #5A52E0) → Disabled (Primary at 40% opacity)

**Secondary Button (Outline)**
- Border: 1.5px Primary (#6C63FF)
- Text: Primary, SemiBold, 14sp
- Background: Transparent
- State: Default → Pressed (Primary at 8% opacity background)

**Text Button**
- Text: Primary, SemiBold, 14sp
- Background: Transparent
- Padding: 0 12px
- State: Default → Pressed (Primary at 8% opacity background)

**FAB (Floating Action Button)**
- Background: Primary (#6C63FF)
- Icon: White, 24px
- Size: 56x56px
- Shadow: Level 3
- Position: Bottom-right, 16px from edges

### 5.2 Cards

**Document Card (Grid View)**
- Background: Surface (#FFFFFF)
- Border Radius: 12px
- Shadow: Level 1
- Padding: 0
- Content: Thumbnail (full width, 160px height) → Title + Metadata (12px padding)
- State: Default → Pressed (Scale 0.98, Shadow Level 2)

**Document Card (List View)**
- Background: Surface (#FFFFFF)
- Border Radius: 12px
- Shadow: Level 1
- Padding: 12px
- Content: Thumbnail (48x64px) → Title + Subtitle + Date → Overflow menu
- Height: 72px

**Folder Card**
- Background: Surface (#FFFFFF)
- Border Radius: 12px
- Shadow: Level 1
- Content: Folder icon (Primary color) → Name → Document count
- Padding: 16px

### 5.3 Input Fields

**Text Field**
- Background: Surface Variant (#F1F3F8)
- Border: None (filled style)
- Border Radius: 8px
- Height: 48px
- Padding: 0 16px
- Text: Body Medium (14sp)
- Hint: Text Tertiary
- Focus: 2px Primary border, slight scale animation

### 5.4 Bottom Navigation

- Background: Surface (#FFFFFF)
- Height: 64px
- Items: Dashboard | Documents | AI Chat | Settings
- Active icon: Primary (#6C63FF), filled
- Active label: Primary, Medium, 12sp
- Inactive icon: Text Tertiary (#9CA3AF), outlined
- Inactive label: Text Tertiary, Regular, 12sp
- Shadow: Level 1 (top shadow)
- Safe area: Respects device notch/cutout

### 5.5 App Bar

- Background: Surface (#FFFFFF) — or transparent on viewer screens
- Height: 56px
- Title: Headline Medium (18sp), Text Primary
- Back button: 24px icon, Text Primary
- Actions: 24px icons, 8px spacing between
- Shadow: None (flat) or Level 1 (scrolling)

### 5.6 Dialogs

- Background: Surface (#FFFFFF)
- Border Radius: 16px
- Padding: 24px
- Shadow: Level 4
- Overlay: Black at 40% opacity
- Max width: 320px (phone)
- Title: Headline Medium, centered
- Body: Body Medium, Text Secondary
- Actions: Right-aligned, Text Button pattern

### 5.7 Bottom Sheets

- Background: Surface (#FFFFFF)
- Border Radius: 16px (top only)
- Handle bar: 32x4px, Text Tertiary, centered
- Padding: 16px horizontal
- Drag to dismiss: enabled
- Overlay: Black at 40% opacity

### 5.8 Toast / Snackbar

- Background: Text Primary (#1A1A2E) in light mode, Surface in dark mode
- Text: White / Text Primary, Body Medium
- Border Radius: 8px
- Margin: 16px from edges, 16px from bottom
- Duration: 3 seconds auto-dismiss
- Action: Text Button (Primary Light in dark mode)

---

## 6. Memory & User Preferences

### 6.1 What MindSpace Remembers

MindSpace stores user preferences locally in Hive so the app feels personalized every time it opens.

| Preference | Storage Key | Default | What It Controls |
|---|---|---|---|
| Theme Mode | `theme_mode` | "system" | Light, dark, or follow system setting |
| Sort Order | `sort_order` | "recent" | How documents are sorted on dashboard |
| View Mode | `view_mode` | "grid" | Grid or list view on dashboard |
| Last Opened Document | `last_document_id` | null | Quick resume on app launch |
| Last Opened Page | `last_page_{doc_id}` | 1 | Resume reading where user left off |
| Highlight Color | `last_highlight_color` | "yellow" | Remembers last-used highlight color |
| Note Pin Size | `note_pin_size` | "medium" | Sticky note pin size preference |
| AI Model Preference | `ai_model_pref` | "auto" | Ultra for complex, Nano for simple |
| Font Size Override | `font_size_override` | null | Custom text size for AI responses |
| Onboarding Complete | `onboarding_done` | false | Skip onboarding after first time |
| Notification Preferences | `notifications_enabled` | true | Processing complete notifications |
| Cloud Sync Enabled | `cloud_sync` | true | Sync annotations to Supabase |

### 6.2 Preferences UI

All user preferences are accessible from **Settings → Preferences**:

| Section | Options |
|---|---|
| **Appearance** | Theme (Light / Dark / System), Font size (Small / Medium / Large) |
| **Reading** | Default sort, Default view mode, Resume last document on launch |
| **AI** | Default model (Auto / Ultra / Nano), Response font size |
| **Notifications** | Processing complete alerts, Weekly study summary |
| **Storage** | Clear cache, Manage offline documents, Storage usage |

### 6.3 Adaptive Memory Patterns

| Pattern | Behavior |
|---|---|
| Smart resume | On app open, offer to resume last document at last page |
| Color memory | Highlight toolbar remembers last-used color |
| Query suggestions | AI chat shows recent/suggested questions based on document |
| Frequently accessed | Dashboard surfaces most-opened documents at top |
| Time-based | Evening use switches to dark mode if "system" is selected |

---

## 7. Screen Specifications

### 7.1 Onboarding (3 Screens)

**Purpose**: Introduce app value proposition to first-time users.

**Screen 1: "Organize Your Study Life"**
- Illustration: Books and folders in a clean arrangement
- Headline: "Organize Your Study Life" (Display Large, Bold)
- Subtitle: "Keep all your PDFs, notes, and research in one place" (Body Large, Text Secondary)
- Background: Primary at 5% opacity gradient
- Navigation: "Skip" (top-right, Text Button) + "Next" (bottom, Primary Button)
- Dots indicator: 3 dots, active is Primary, others are Text Tertiary

**Screen 2: "Highlight What Matters"**
- Illustration: Document with colorful highlights
- Headline: "Highlight What Matters"
- Subtitle: "Color-code key concepts and add sticky notes as you read"
- Same navigation pattern

**Screen 3: "Ask Your Documents"**
- Illustration: Chat bubbles coming from a document
- Headline: "Ask Your Documents Anything"
- Subtitle: "Get instant answers and summaries powered by AI"
- Navigation: "Skip" + "Get Started" (Primary Button)

### 7.2 Login / Signup

**Login Screen**
- Logo: MindSpace logo centered, 80px height
- Headline: "Welcome Back" (Headline Large, centered)
- Subtitle: "Sign in to continue studying" (Body Large, Text Secondary, centered)
- Email field: Label "Email", keyboard type email
- Password field: Label "Password", toggle visibility
- "Sign In" button: Primary, full width
- Divider: "OR" centered with horizontal lines
- Puter button: Outlined, cloud icon + "Sign in with Puter"
- Footer: "Don't have an account? Sign Up" (Text Button, centered)
- Forgot password: "Forgot password?" link below password field

**Signup Screen**
- Logo: MindSpace logo centered
- Headline: "Create Account"
- Subtitle: "Start your free study assistant"
- Name field: Label "Full Name"
- Email field: Label "Email"
- Password field: Label "Password" + requirements hint
- Confirm Password field: Label "Confirm Password"
- "Create Account" button: Primary, full width
- Divider + Puter token input (same as login)
- Footer: "Already have an account? Sign In"

### 7.3 Dashboard

**Header**
- Greeting: "Good [morning/afternoon/evening], [Name]" (Headline Large)
- Subtitle: "[X] documents in your library" (Body Medium, Text Secondary)
- Profile avatar: Top-right, 40px circle, taps to Settings

**Search Bar**
- Below header, full width
- Placeholder: "Search documents..."
- Icon: Search (leading), X to clear (trailing, when text present)
- Background: Surface Variant, 40px height

**Folder Section**
- Horizontal scrollable list of folder cards
- Each card: Folder icon + name + document count
- "+ New Folder" card at the end (dashed border, Primary text)
- Section title: "Folders" (Title Medium)

**Document Grid**
- Section title: "All Documents" or "[Folder Name]" (Title Medium)
- Grid: 2 columns on phone, 3 on tablet
- Card size: Equal width, aspect ratio 3:4
- Empty state: Illustration + "No documents yet" + "Upload your first PDF" button

**FAB**
- Bottom-right, above bottom navigation
- "+" icon
- Taps to show upload options (bottom sheet)

### 7.4 Document Viewer

**Full-screen layout** (no app bar by default)

**Top Bar** (appears on tap, auto-hides after 3s)
- Back button (←)
- Document title (truncated with ellipsis)
- Actions: Info (ℹ️), Share, Overflow menu (⋯)

**Bottom Toolbar** (annotation toolbar)
- Appears when in annotation mode
- Icons: Highlight (with color dots), Sticky Note, Undo, Redo
- Background: Surface with Level 2 shadow
- Height: 56px

**Page Navigation**
- Bottom-left: Page indicator "Page X of Y"
- Tap page indicator: Jump-to-page input

**Highlighting Flow**
1. User long-presses and selects text
2. Selection handles appear (blue dots)
3. Toolbar appears above selection: 4 color circles + Note icon
4. Tap color → highlight applied, toolbar dismisses
5. Tap highlighted text → mini toolbar: Change color | Edit | Delete

**Sticky Note Flow**
1. User long-presses on empty area
2. Context menu: "Add Note"
3. Note editor opens (bottom sheet, 50% height)
4. User types note content
5. Taps "Save"
6. Pin icon appears at press location
7. Tap pin → note expands in bottom sheet

### 7.5 AI Chat

**Header**
- Back button
- Document title: "Chat about [Document Name]"
- Subtitle: "[X] pages analyzed" (Body Small, Text Tertiary)

**Chat Area**
- Scrollable message list
- User messages: Right-aligned, Primary background, White text, 12px radius (top-left corner square)
- AI messages: Left-aligned, Surface background, Text Primary, 12px radius (top-right corner square)
- AI messages include citation badges: "[Page X]" as tappable chips
- "AI-generated" disclaimer at bottom of AI messages

**Input Bar**
- Fixed at bottom (above keyboard)
- Text field: Multi-line, max 4 lines visible
- Send button: Primary circle with arrow icon (right of field)
- Disabled state: Send button grayed out when empty

**Empty Chat State**
- Illustration: Chat bubble with document
- Headline: "Ask Anything"
- Subtitle: "Questions about [Document Name]"
- Suggested questions (3 chips): Based on document content

### 7.6 Profile / Settings

**Header**
- Profile picture (circular, 80px)
- Display name (Headline Medium)
- Email (Body Medium, Text Secondary)
- Subscription badge: "Free" (chip, Primary Light background)

**Settings Sections**

| Section | Items |
|---|---|
| **Account** | Edit Profile, Change Password, Sign Out |
| **Preferences** | Theme, Font Size, Default Sort, Default View |
| **AI** | Default Model, Daily Usage (X/20 queries), Clear AI Cache |
| **Storage** | Storage Usage (bar graph), Clear Cache, Offline Documents |
| **Support** | Help Center, Send Feedback, Rate MindSpace |
| **About** | Version, Privacy Policy, Terms of Service, Licenses |
| **Danger Zone** | Delete All Data (Error color, with confirmation) |

---

## 8. Accessibility

### 8.1 Requirements

| Requirement | Standard |
|---|---|
| Minimum tap target | 48x48 dp (all interactive elements) |
| Color contrast | WCAG AA (4.5:1 for normal text, 3:1 for large text) |
| Screen reader support | All interactive elements have semantic labels |
| Font scaling | Support up to 200% system font scaling |
| No color-only information | Never use color as the only indicator (add icons or text) |
| Focus order | Logical top-to-bottom, left-to-right flow |
| Animations | Respect `reduceMotion` system setting |

### 8.2 Semantic Labels

Every interactive widget must have a `semanticsLabel`:

| Widget | Label Example |
|---|---|
| Highlight button | "Highlight text" |
| Color option | "Yellow highlight" |
| Sticky note pin | "Sticky note: [first 20 chars]" |
| Document card | "Document: [title], [page count] pages" |
| AI send button | "Send message" |
| Undo button | "Undo last action" |
| Delete button | "Delete [item name]" |
| Sort toggle | "Sort by [current sort]" |

### 8.3 High Contrast Mode

When system high contrast is enabled:
- All borders increase to 2px
- Text colors shift to pure black/white
- Interactive elements get visible focus rings (2px Primary)
- Background contrast increases

---

## 9. Responsive Design

### 9.1 Breakpoints

| Breakpoint | Width | Layout |
|---|---|---|
| Phone | < 600px | Single column, bottom navigation |
| Tablet Portrait | 600-840px | Single column with larger cards, optional side nav |
| Tablet Landscape | > 840px | Two-column layout (list + detail) |

### 9.2 Phone Layout (Default)

- Bottom navigation: 4 items
- Dashboard: 2-column grid
- Document viewer: Full screen
- AI Chat: Full screen

### 9.3 Tablet Layout (Future Enhancement)

- Navigation: Rail navigation on left side (56px width)
- Dashboard: 3-column grid
- Document viewer: Left panel (document) + Right panel (annotations/AI)
- AI Chat: Split view with document reference

---

## 10. Animations & Transitions

### 10.1 Standard Durations

| Duration | Value | Usage |
|---|---|---|
| Instant | 100ms | Button press, toggle switch |
| Fast | 200ms | Navigation transitions, show/hide elements |
| Normal | 300ms | Page transitions, bottom sheets |
| Slow | 500ms | Complex animations, onboarding transitions |

### 10.2 Standard Curves

| Curve | Usage |
|---|---|
| easeInOut | Default for most transitions |
| easeOut | Elements entering the screen |
| easeIn | Elements leaving the screen |
| bounceOut | Success confirmations, celebrations |

### 10.3 Key Animations

| Animation | Detail |
|---|---|
| Page transition | Fade + slight slide up (300ms, easeInOut) |
| Bottom sheet | Slide up from bottom (300ms, easeOut) |
| Card press | Scale to 0.98 (100ms, easeOut) |
| FAB press | Scale to 0.9 (100ms, easeOut) |
| Highlight appear | Fade in with slight scale (200ms) |
| Chat message | Slide up + fade in (200ms, easeOut) |
| Loading spinner | Continuous rotation (1000ms loop) |
| Skeleton shimmer | Horizontal gradient sweep (1500ms loop) |
| Undo toast | Slide up from bottom (200ms), auto-dismiss (3s) |
| Onboarding swipe | Horizontal page turn with parallax (300ms) |

### 10.4 Motion Preferences

When the user has enabled "Reduce Motion" in system settings:
- All animations are replaced with simple fade transitions (100ms)
- No scale animations
- No bouncing curves
- Skeleton shimmer becomes static
- Page transitions become instant cross-fade
