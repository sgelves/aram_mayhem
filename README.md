# Mayhem Forge — ARAM Companion

Fan-made iOS/iPadOS app for browsing **League of Legends ARAM: Mayhem** augments and Stat Anvils.

> Fan-made app. Not affiliated with or endorsed by Riot Games. Follow Riot's "Legal Jibber Jabber" policy for fan projects. No Riot logos, wordmarks, official champion/item/augment art, or copyrighted characters (no Poros). All visuals are original.

## 1. Summary

- Platform: **SwiftUI, iOS 16+**, iPhone and iPad, portrait and landscape, adaptive grids by size class.
- **Front end only**: only ready-to-use, publicly hosted data (no own backend, no scraping, no API keys).
- Tabs:
  1. **Augments**: browse/search/filter all Mayhem augments (viable).
  2. **Anvils**: Stat Anvils + augments that grant anvils (viable).
  3. ~~Best combinations~~: dropped (no ready-to-use stats source, see section 4). Possible future replacement: client-side "Build planner" or a hand-curated synergies JSON.
- UI designed in Google Stitch (project id `18417273127315870605`, "Mayhem Forge iOS Companion").

## 2. Mode facts (verify each patch)

- Internal codename of the mode: **`kiwi`** (appears in game file names).
- Queue ID in Riot match data: **2400** (classic ARAM is 450).
- Augment tiers: **Silver** (weakest), **Gold**, **Prismatic** (rarest/strongest). Everyone is offered the same tier per selection round; tier is random.
- Augments are picked at the start and at levels 7, 11, 15 (picked after dying, in base). Patch 26.12 changed the first pick to level 3, added "Ability Augments" (enhance a single champion ability, e.g. Multishot, Chain Reaction) and removed Augment Sets. **Re-check current rules.**
- **Stat Anvils**: consumable items added in patch 25.23, Silver/Gold/Prismatic versions. At launch: available from **level 9**, **750 gold** each. Values may have changed.
- Augments that grant anvils: **"Stats!", "Stats on Stats!", "Stats on Stats on Stats!"** (as of patch 26.4 they granted 2 / 3 / 4 anvils). Re-check current values.
- Riot provides **no official Mayhem API**. Sites like Mobalytics combine ARAM data with rating-based augment data.

## 3. Data sources (ready to use, no key)

Legend: ✅ confirmed during research · ⚠️ URL pattern from general knowledge, verify before coding

### 3.1 CommunityDragon — raw game data (main source)

- Domain: `https://raw.communitydragon.org/`
- Patch folder: `latest/` or a specific patch like `16.19/`. Use a fixed patch in production.
- Free, no key, static JSON over HTTPS → fetch from SwiftUI (`URLSession` + `Codable`).

**a) Mayhem augments — `kiwi.bin.json` ✅ (exists; exact path ⚠️)**
- Community project Lanternko/ARAM-Mayhem-Database uses `kiwi.bin.json` to resolve Mayhem augments.
- Resolution flow:
  1. In `kiwi.bin.json`: augment entry → `AugmentPlatformId` (numeric ID) → `DescriptionTra` (translation key, not text)
  2. In `lol.stringtable.json` (per language): key → human-readable text
- Exact path not confirmed; browse `https://raw.communitydragon.org/latest/game/` and search for "kiwi".
- Raw `.bin.json` files are large (that project's cache with stringtable was ~30 MB). Do the join once (script), bundle a small `augments.json` in the app, or host it on GitHub Pages / a gist.
- Fields the app needs after cleaning:
  - `id` (Int) – AugmentPlatformId
  - `name` (String)
  - `description` (String; may contain HTML-like tags and `@Variable@` placeholders to replace with numbers)
  - `tier` (Silver / Gold / Prismatic)
  - `iconPath` (String → convert to a CommunityDragon URL)
  - Optional: tags (AP/AD/Tank…), "grants anvils" count

**b) Stringtable (translations) ⚠️**
- `https://raw.communitydragon.org/latest/game/en_us/data/menu/en_us/lol.stringtable.json`
- Contains `entries: { key: text }`. Swap `en_us` for `es_mx`, `es_es`, etc.

**c) Items (for Stat Anvils) ⚠️**
- `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/items.json`
- Useful fields: `id`, `name` (filter by "Anvil"), `description`, `price`, `priceTotal`, `iconPath`
  (e.g. `/lol-game-data/assets/ASSETS/Items/Icons2D/xxxx.png`).
- Icon URL rule: replace `/lol-game-data/assets/` with `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/` and **lowercase** the rest of the path.
- If anvils are not in this file, they may be defined inside `kiwi.bin.json`.

**d) Arena augments (reference only, NOT Mayhem) ⚠️**
- `https://raw.communitydragon.org/latest/cdragon/arena/en_us.json`
- Clean format CommunityDragon uses for Arena: `augments[]` with `id`, `apiName`, `name`, `desc`, `tooltip`, `iconSmall`, `iconLarge`, `rarity` (0 silver, 1 gold, 2 prismatic), `dataValues`. Check whether a similar `cdragon/kiwi/` file exists for Mayhem; it would save the join work.

### 3.2 League of Legends Wiki — fallback for augment data ✅

- Augment list page: `https://wiki.leagueoflegends.com/en-us/ARAM_Mayhem/Augments`
- Data source module: `Module:MayhemAugmentData/data` (Lua table, community-edited)
- MediaWiki API ⚠️: `https://wiki.leagueoflegends.com/en-us/api.php?action=query&prop=revisions&titles=Module:MayhemAugmentData/data&rvprop=content&rvslots=main&format=json`
- Returns Lua source as text → needs parsing. Easier to read than raw game files, but may lag behind patches.

### 3.3 Data Dragon (official Riot static CDN) ⚠️

- Versions: `https://ddragon.leagueoflegends.com/api/versions.json` (first item = current patch → show in nav bar)
- Champions: `https://ddragon.leagueoflegends.com/cdn/{version}/data/en_US/champion.json`
- Champion icon: `https://ddragon.leagueoflegends.com/cdn/{version}/img/champion/{ChampionId}.png`
- Items: `https://ddragon.leagueoflegends.com/cdn/{version}/data/en_US/item.json`
- Does not include Mayhem augments.

## 4. Sources evaluated and rejected

- **Riot Match-V5 API**: needs API key + backend; a community project reports Mayhem matches (queue 2400) aren't returned at all.
- **LCU API** (local client API): works for collecting Mayhem matches with augments, but needs a desktop collector → not front-end.
- **U.GG, Mobalytics, arammayhem.com, arammeta.com**: have Mayhem augment/combo stats but **no public API**; scraping would break their terms.
- Consequence: Tab 3 (best combinations with win rates) is not feasible with ready-to-use APIs. **The app must not show winrates, tier lists, "meta" labels or synergy scores.**

## 5. Architecture

1. One-time script (or manual step) → produce small `augments.json` and `anvils.json` from CommunityDragon (or the wiki).
2. Bundle them in the app and/or host on GitHub Pages for updates without App Store releases.
3. App fetches patch version from Data Dragon, icons from CommunityDragon.
4. SwiftUI iOS 16: `TabView` (compact) / `NavigationSplitView` (regular), `LazyVGrid(.adaptive(minimum: 150, maximum: 220))`, `.searchable`, `.sheet` + `.presentationDetents`, `ObservableObject`. **Avoid iOS 17+ APIs** (`.inspector`, `ContentUnavailableView`, `@Observable`).
5. Show the disclaimer: "Fan-made app. Not affiliated with or endorsed by Riot Games."

Code lives in the Xcode project: `aram_mayhem/aram_mayhem.xcodeproj` (sources `aram_mayhem/aram_mayhem/`, tests in `aram_mayhemTests/` and `aram_mayhemUITests/`).

## 6. Design (Stitch)

Stitch project: **Mayhem Forge iOS Companion**, id `18417273127315870605`. Theme **"Frostforge"**: frozen abyss at night + glowing forge.

**Base (dark, primary):** Abyss Night `#0B1020` (background) · Deep Ice `#141A2E` (cards, sheets) · Glacier Slate `#1C2440` (selected, chips) · Frozen Steel `#2A3352` (borders) · Snowlight `#F2F4FA` (text) · Mist `#A7B0C8` (secondary) · Fog `#6B7592` (tertiary/disabled)

**Accents:** Frost Cyan `#3FD0E0` (primary; pressed `#2BA9B8`) · Forge Ember `#FF7A3D` (everything anvil-related; glow = 35% opacity)

**Tiers:**
- Silver `#B8C2D3` (dark `#7E8AA0`)
- Gold `#F2B63D` (dark `#C98A1B`)
- Prismatic: gradient `#9B5CFF → #FF5FA2 → #3FD0E0` at 135° (tint `#9B5CFF` 14%, shimmer)
- Tinted backgrounds 12% (Silver/Gold), glow 30%

**Status:** Success `#4ADE80` · Warning `#FBBF24` · Error `#F87171`

**Light mode (secondary):** background `#F4F6FB`, surface `#FFFFFF`, elevated `#E9EDF6`, border `#D5DBE8`, text `#0B1020` / `#4A5470`; same accents, use "dark" tier variants for text.

**Typography:** SF Pro, Dynamic Type. Large Title 34 Bold · Title 2 22 Bold · Headline 17 Semibold · Body 17 · Subheadline 15 · Caption 12 Semibold uppercase (0.5pt tracking). Numbers inside descriptions: Semibold, Frost Cyan.

**Shape/depth:** card radius 16pt, sheet 24pt, chips/badges capsule; card shadow black 40%, 12pt blur, 4pt Y; tier glow = 1.5pt border + 30% outer glow. Spacing 4/8/12/16/24/32; side margins 16 (iPhone) / 24 (iPad). 44pt min touch targets.

**Navigation:** iPhone bottom tab bar (Augments: `sparkles`, Frost Cyan; Anvils: `hammer`, Forge Ember; inactive Fog). iPad left sidebar with only Augments and Anvils. Patch caption capsule ("Patch 26.19") in the nav bar.

**Grid columns:** iPhone portrait 2 · iPhone landscape 4 · iPad portrait 4–5 · iPad landscape 5–6 (fewer with detail panel open).

**Screens:**
- *Augments:* large title, search ("Search augments"), tier chips (All/Silver/Gold/Prismatic), type chips (All/Stat/Ability/Utility), sort menu (Name A–Z, Tier), results count, card grid (icon, name ≤2 lines, tier badge, tier border/glow). Detail: bottom sheet (iPhone/iPad portrait) or right panel (iPad landscape): icon, name, tier, description, tag chips (AP, AD, Tank, Healing, Crit), "Grants Stat Anvils ×N" row. Empty state: "No augments match your filters" + "Clear filters". Error: "Couldn't load augments" + Retry. Loading: skeleton cards.
- *Anvils:* collapsible "What are Stat Anvils?" card (Ember accent bar, unlock level + gold cost capsules), three anvil cards (Silver/Gold/Prismatic) with stat list, section "Augments that grant Anvils" with ×N badges, anvil detail sheet/panel with Stat | Value table.
- *App icon:* original silver anvil + prismatic crystal + ember glow, no text; full-bleed 1024 square plus tinted/mono variant. *Launch screen:* static, glyph + "Mayhem Forge" / "ARAM Companion" + disclaimer.

## 7. Stitch audit status (2026-10-03)

Original Stitch output contained **invented data**: winrates ("+4.8%", 54–58%), "S-Tier"/meta labels, fake anvil augments (Ironwork Master, Ember Alchemist, Forgeborne Giant), wrong unlock level (7/11/15), wrong costs (1,250/2,000 G), made-up stat values, roll probabilities, reroll rules, "Pro Forge Tip", "Track" button, profile icon, "keystones" search text, wrong tag chips. It also drifted from the design system (`#0e1323`, Plus Jakarta Sans, Material Symbols, small radii).

Review after corrections:

| Screen | Verdict |
|---|---|
| Augments (Compliant), iPhone | OK to build from. "Sample data" labels, correct filters/sort/tags/empty state. |
| Stat Anvils (Compliant), iPhone | OK to build from. Level 9, 750 G, "value TBD", Stats!/Stats on Stats!/Stats on Stats on Stats! = ×2/×3/×4. |
| Launch screen | OK. |
| App icon (full-bleed) + tinted/mono variant | OK. |
| iPad Landscape (Augments Compliant) | OK to build from (redone 2026-10-03). Sidebar has only Augments and Anvils, SF system font, "Sample data" label, no winrates/pick %/tier distribution. Percentages shown are sample augment-description values only. |
| iPad Landscape (Stat Anvils Compliant) | OK to build from (redone 2026-10-03). Level 9, 750 G, "value TBD", no drop weights or invented tier effects. |

The original iPad versions were rejected for: winrate 58.4%, "Top 4% Pick", tier distribution, "Simulate Damage Output", extra nav (Synergy Builds, Tier Matrix, Reroll Sim, Abyss Engine, Summoner Forge), drop weights 55/35/10%, invented tier effects ("guarantees Prismatic", "+15% rare chance"), Inter/Space Grotesk, no color tokens.

Nits on the OK screens: "Toggle Empty State Preview" is mock-only; hide the "Grants Stat Anvils ×0" row when the count is 0; map Material icon names to SF Symbols; use SF Pro in SwiftUI.

**Still missing:** iPhone landscape, iPad portrait, theme/component sheet, loading and error states. The Stitch design-system tokens themselves are still the drifted ones (screens override them).

A Figma copy of the compliant screens (inspect-only, raw captured frames) lives in "Mayhem Forge — Stitch Export": https://www.figma.com/design/ZNCnbEUQavsNCkMjulY9oN

## 8. Open items

- [ ] Confirm the exact `kiwi.bin.json` path in CommunityDragon.
- [ ] Get per-tier anvil stat values from `items.json` (or `kiwi.bin.json`).
- [ ] Re-verify anvil unlock level / gold cost and anvil counts for the current patch.
- [ ] Re-verify augment pick levels after patch 26.12.
- [ ] Decide on hosting for `augments.json` / `anvils.json`.
- [x] Redo the iPad landscape Stitch screens.
- [ ] Generate iPhone landscape, iPad portrait, theme sheet, loading/error states.
