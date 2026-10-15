# Stitch → Figma export process

Only read this file if the Stitch → Figma export itself has to change or be redone (new/updated Stitch screens, broken import, new assets). It is not needed for normal app work.

## Current state (2026-10-03; Anvils frames modified 2026-10-14, see Change log)

- Figma file: "Mayhem Forge — Stitch Export", key `ZNCnbEUQavsNCkMjulY9oN`, https://www.figma.com/design/ZNCnbEUQavsNCkMjulY9oN (team plan `team::1688248093334360990`).
- Source: Stitch project `18417273127315870605`.
- Page 1, one row, y=0, 120px gap: Launch — iPhone (390 wide), Augments — iPhone (390), Stat Anvils — iPhone (390), Augments — iPad Landscape (1280), Stat Anvils — iPad Landscape (1280).
- Below at y=1900: App Icon — Full-Bleed, App Icon — Tinted / Mono, Anvil & Crystal Glyph (vectors from the Stitch SVGs).
- Purpose: inspect spacing, colors and sizes only. Frames are raw captured frames, not components.

## Change log

### 2026-10-14 — Anvil cards: stats first, price/level once (edited directly in Figma)

Stitch edits did not persist (`edit_screens` returned DOM operations but the stored HTML of both Anvils screens stayed unchanged), so these changes exist **only in Figma**. Stitch still has the old cards. Do not re-export the two Anvils screens from Stitch without redoing these edits.

Frames edited (in place): `Stat Anvils — iPhone` (`14:2`) and `Stat Anvils — iPad Landscape` (`16:2`).

- Removed the per-card "Unlock Level 9" / "Unlock Lv 9" text and the 750 G / "Cost 750 Gold" pill or row on all three tier cards. Price and level now appear once, in the "What are Stat Anvils?" box (Unlock Level 9, Cost 750 Gold).
- Added a "Stats granted · Random" header plus "Stats are rolled randomly" note (new auto-layout frames `73:2`…`73:17`) above the stat rows on every card.
- iPhone: stat row labels renamed "Stat" → "Random stat" (values stay "value TBD"). Icon slot enlarged 32 → 56 px. Frame grew 1589 → 1811 px; bottom nav moved to y=1754.
- iPad: removed the one-line card subtitles (e.g. "Standard core stat shards") and the Prismatic card's equivalent paragraph. Icon slots enlarged 40 → 56 px (Silver, Gold). Primary/Secondary/Special stat rows are unchanged.
- Not changed: the Augments frames, the right sidebar inspector on iPad (still shows Prismatic details), the "Augments that grant Anvils" section.
- Planned but not done: real anvil icon from CommunityDragon (item `220000`, `220000_StatAnvil.png`; vouchers share `3865_WorldAtlas.png`). Figma cannot create image fills via `use_figma`, so the icon slots stay as Material glyphs. Needs a CLAUDE.md exception for "no Riot official art" (item icons only).
- Open: the Stitch project also has a stray screen "Augments (Prioritized Descriptions)" (`1b7fe4d0a00f4b2fab2fa43a14cd5da9`) created by a rejected edit.

## Known limits

- Icons are outlined Material Symbols SVGs (from `@material-symbols/svg-400`), not SF Symbols. `auto_mode` → `autorenew`, `monetization_on` → `paid` (the originals do not exist in that package). Map to SF Symbols in SwiftUI.
- Fonts stay as in Stitch HTML, not SF Pro.
- The search icon in the Augments iPhone search field did not import.
- The full-bleed icon lost its crystal blur glow (`createNodeFromSvg` ignores the SVG filter).
- `use_figma` cannot create image fills (`createImageAsync` is unsupported); images only arrive through the HTML capture.

## Why a plain capture failed

Capturing Stitch HTML as-is gave: icons as text (`local_fire_department`, no Material font in Figma), missing images (no `<img>` fills), and 1920px-wide frames (browser window width). The steps below fix each.

## Procedure

Work in the session scratchpad dir (e.g. `.../scratchpad/stitch`), never in the repo.

1. **List screens**: `mcp__stitch__list_screens` with the project id. Screens with `htmlCode.downloadUrl` (HTML) or SVG mime type. Skip any screen the README section 7 marks as not OK.
2. **Download** each HTML/SVG with `curl -sL "<downloadUrl>" -o name.html`.
3. **Audit before importing**: strip `<script>/<style>`, grep visible text for banned content (winrate, `Top 4`, Tier Matrix, Synergy, Reroll, Simulate, Keystone, drop weights, "guarantee"). Percentages inside sample augment descriptions are fine. See CLAUDE.md "Never invent data".
4. **Icons**: collect every icon name (`class="material-symbols-outlined"` text, plus names in the page JS data) and download `https://cdn.jsdelivr.net/npm/@material-symbols/svg-400/outlined/<name>.svg` into `icons/`.
5. **Images**: download each `https://lh3.googleusercontent.com/...` `src` to `img/<md5(url)[:8]>.png` (the `.png` extension is required or the local server serves it without a type and the image is not captured).
6. **Rewrite pages** to `fix_<name>.html`:
   - replace lh3 `src` with `/img/<hash>.png`;
   - inject the Figma capture script before `</head>`: `<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>`;
   - before `</body>` inject CSS `body{width:Wpx!important;max-width:Wpx!important;margin:0!important;transform:translateZ(0);overflow-x:hidden}` (W = 390 iPhone, 1280 iPad; `transform` makes `fixed` elements relative to the body) and `.material-symbols-outlined{display:inline-flex!important;width:1em;height:1em;font-size:inherit;line-height:1;overflow:hidden}` `.material-symbols-outlined svg{width:1em;height:1em;fill:currentColor;display:block}`;
   - inject a script that on `load` and every 500 ms replaces the text of each `.material-symbols-outlined:not([data-svg])` with the fetched `/icons/<name>.svg` (width/height attributes stripped, `data-svg` set).
7. **Serve**: `python3 -m http.server 8765` in the scratchpad dir (check `lsof -i :8765` first).
8. **Capture**: for each page call `generate_figma_design` with the fileKey (no captureId) to get a single-use capture ID; open `http://localhost:8765/fix_<name>.html#figmacapture=<id>&figmaendpoint=<urlencoded https://mcp.figma.com/mcp/capture/<id>/submit?bindVariables=true>&figmadelay=4000` with `open`; wait ~10 s; poll `generate_figma_design` with fileKey + captureId until completed. Safari is the only installed browser.
9. **Clean up in Figma** (`use_figma`, load the `figma:figma-use` skill first, node IDs from the capture results `node-id=N-2`): remove superseded frames, `clipsContent=true`, `resize(W, h)`, rename, position in the row.
10. **Standalone SVG assets** (app icons, glyph): `figma.createNodeFromSvg(svg)` inside `use_figma`, one node per SVG, placed at y=1900. Strip SVG comments and `<filter>` blocks if the import fails.
11. **Verify**: `node.screenshot()` on each frame; confirm no text nodes matching `^[a-z]+(_[a-z]+)+$` (leftover icon names) and that image fills exist on the launch and augments frames.
12. **Stop the server** when done (`lsof -i :8765` → kill) and update this file's "Current state".

## Not to be reused

Capture IDs are single-use. The old direct captures (1920px, text icons) were deleted; do not recreate them.
