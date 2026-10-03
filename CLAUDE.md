# Mayhem Forge — ARAM Companion

Fan-made SwiftUI app (iOS 16+, iPhone + iPad) for League of Legends ARAM: Mayhem augments and Stat Anvils.

Full project context (mode facts, data sources, architecture, design tokens, Stitch audit, open items) is in @README.md. Read it before changing data or UI.

## Layout

- Xcode project: `aram_mayhem/aram_mayhem.xcodeproj`; sources `aram_mayhem/aram_mayhem/`; tests `aram_mayhemTests/`, `aram_mayhemUITests/`.

## Rules

- **Front end only**: no own backend, no scraping, no API keys. Use only the sources listed in README section 3.
- **Never invent data**: no winrates, tier lists, "meta"/S-Tier labels, synergy scores, drop weights or roll probabilities. Where data is missing show "value TBD" or mark it as sample data.
- Stat Anvils (as of launch): unlock level 9, 750 gold. Anvil-granting augments: Stats! (×2), Stats on Stats! (×3), Stats on Stats on Stats! (×4). Re-verify per patch before hardcoding.
- Only two tabs: **Augments** and **Anvils** (no "best combinations").
- SwiftUI iOS 16 only: no `.inspector`, `ContentUnavailableView`, `@Observable`.
- No Riot logos, wordmarks, official art or characters. Keep the disclaimer: "Fan-made app. Not affiliated with or endorsed by Riot Games."
- Use SF Pro and SF Symbols (`sparkles`, `hammer`, `arrow.up.arrow.down`, …), not Material icons or web fonts.
- Hide the "Grants Stat Anvils" row when the count is 0.

## Design source (Stitch)

- Project `18417273127315870605` ("Mayhem Forge iOS Companion"). Tokens are in README section 6; use them, not the drifted Stitch design-system values (`#0e1323`, Plus Jakarta Sans).
- Authoritative screens: "Mayhem Forge — Augments (Compliant)", "Mayhem Forge — Stat Anvils (Compliant)", "Mayhem Forge — iPad Landscape (Augments Compliant)", "Mayhem Forge — iPad Landscape (Stat Anvils Compliant)", launch screen, app icon (full-bleed + tinted/mono).
- Figma copy of the Stitch screens (inspect-only): file key `ZNCnbEUQavsNCkMjulY9oN`. The export process is documented in `FIGMA_EXPORT.md` (repo root; deliberately not `@`-imported). **Go to that file only, and only when the Stitch → Figma export process itself must change or be redone** (updated Stitch screens, broken import, new assets). Do not read it for any other task.
- Still missing in Stitch: iPhone landscape, iPad portrait, theme sheet, loading/error states. See README section 7.
