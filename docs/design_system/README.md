# PulseTime Design System

PulseTime is a dual-surface design system crafted for mobile-first attendance flows with a responsive admin console. The system adheres to an 8pt grid, Material 3 foundations, and the Inter typeface. This document summarises the primary tokens, components, and mapping back to Flutter theme configuration so that product, design, and engineering can iterate in lock-step.

## Foundations

### Typography
| Token | Font | Weight | Size |
| --- | --- | --- | --- |
| Display / H1 | Inter | 700 | 28 |
| H2 | Inter | 600 | 22 |
| H3 | Inter | 600 | 18 |
| Body | Inter | 400 | 14 |
| Caption | Inter | 400 | 12 |

### Color tokens
| Token | Light | Dark |
| --- | --- | --- |
| Primary | #2B6CB0 | #93C5FD |
| On Primary | #FFFFFF | #0B1120 |
| Secondary | #00A389 | #34D399 |
| Warning | #FFB020 | #FACC15 |
| Success | #2FB344 | #4ADE80 |
| Error | #E04444 | #F87171 |
| Info | #3B82F6 | #60A5FA |
| Surface | #F8FAFC | #0F172A |
| On Surface | #0F172A | #F1F5F9 |
| Divider | #E2E8F0 | #1E293B |

### Spacing
The spacing scale is derived from an 8pt base. `DesignTokens.spacing.step(n)` is surfaced in Flutter for consistent gaps across widgets. Safe margins are set to 16pt on mobile and 32pt on desktop.

### Semantic mapping
The Flutter theme (see `lib/app/themes/app_theme.dart`) registers `DesignTokens` as a `ThemeExtension`. Colors and typography cascade through Material 3 components, ensuring all tokens are available via `DesignTokens.of(context)`.

## Component library

| Category | Variants |
| --- | --- |
| Buttons | Filled, Tonal, Outlined, Destructive, Loading |
| Chips | Status, Filter, Segmented, Badges (Auto / Pending / Approved / Rejected) |
| Cards | KPI, Activity, Person row, Policy summary |
| Inputs | Text fields, Dropdown, Date picker affordances |
| Navigation | Bottom navigation, Navigation rail, Drawer, Tab bar |
| Feedback | Toasts/Snackbars, Smart alerts, Empty/Error views |
| Sheets & Dialogs | Attendance modal, Approvals drawer, Policy editor |

Each component is available in light/dark mode with AA contrast and motion durations aligned to Material 3 (200ms). Component specs mirror Flutter implementations with shared padding tokens, icon sizing (24dp), and border radii (16/20dp).

## Assets

SVG assets live under `assets/icons` and `assets/illustrations`. They are exported from Figma with consistent stroke widths (2dp) and aligned to the primary palette. Flutter loads them via `flutter_svg`.

## Prototyping

Interactive Figma prototypes cover:

- Mobile employee journey (Login → Permissions → Home → Mark attendance → Calendar → Requests → Reports → Profile)
- Desktop admin console (Dashboard → Team → Requests → Policies → Reports → Settings)

Links:
- Employee flow: https://www.figma.com/proto/pulsetime-attendance-employee
- Admin flow: https://www.figma.com/proto/pulsetime-attendance-admin

Specs are annotated with component names, spacing, and token references to accelerate handoff.

## Implementation notes

- Flutter `AppTheme` wires typography and color tokens, exposing semantic colors for chips, charts, and status banners.
- GetX controllers encapsulate view state, DI, and navigation ensuring modules remain testable.
- Policy engine logic is centralised in `lib/core/services/policy_engine.dart` and covered by unit tests.
- Golden tests validate the fidelity of the employee home screen using real theme tokens.

Refer to `docs/prototypes/README.md` for interaction guidelines and admin compact mode behaviour.
