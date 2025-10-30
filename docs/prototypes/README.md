# Prototype Interaction Notes

The Figma prototypes linked in the design system document map 1:1 to the Flutter navigation hierarchy. Use these cues when validating builds or planning iterations.

## Employee mobile flow
1. **Login** — supports email/phone, OTP, and SSO stub. Selecting Admin/Employee toggles the route on submission.
2. **Permissions onboarding** — sequential cards for Location, Camera/Face ID, and Notifications. Each card surfaces rationale and status chip for compliance.
3. **Home** — displays Today card, quick stats, smart alerts, and recent activity. Floating action button opens the Mark Attendance sheet.
4. **Mark Attendance sheet** — contextual buttons (Check-in, Break start/end, Check-out) with inline policy hints and auto-checkout banner.
5. **Calendar** — month grid with punch timeline bottom sheet and export CTA.
6. **Requests** — Tabbed view for Pending/Approved/Rejected with creation modal capturing issue type, time range, reason, and attachments.
7. **Reports** — KPI grid, insight cards, permission status, and export CTAs.
8. **Profile** — employee info, devices, notifications toggles, and policy quick links.

## Admin desktop flow
1. **Dashboard** — KPI cards, charts, department heatmap, and live punches table. Compact toggle snaps cards into a denser layout.
2. **Team** — data table with search, export, and shift creation CTA.
3. **Requests** — approval list with action buttons and filter drawer.
4. **Policies** — shift cards and company-wide toggles for late rules, grace, geo, QR, and biometrics.
5. **Reports** — export shortcuts plus configurable report builder and scheduling.
6. **Settings** — company profile, timezone, locations, and integration toggles (Mail, Slack/Teams, Cloud storage).

## Engineering spec summary
- **Navigation**: Employee uses bottom nav with nested `IndexedStack`; Admin uses responsive navigation rail/bottom nav.
- **State management**: All screens consume data from GetX controllers, with repositories stubbing offline-first behaviour.
- **Policy cues**: Chips and banners reflect policy engine output (`PolicyEngineResult`) for transparency.
- **Break logic**: Paid/unpaid states surfaced via chips and timers; Mark Attendance sheet disables conflicting actions.
- **Exports**: Provide placeholders for Excel/PDF flows and scheduling.

Use these prototypes to verify transitions, component states (hover/pressed/disabled), and theming (light/dark) before promoting builds to production.
