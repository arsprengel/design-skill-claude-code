---
name: "design-system"
description: "Use when the user wants to create or redesign any UI - web pages, dashboards, landing pages, components, or mobile native apps (React Native, Expo, Flutter) - and the result must carry its own visual identity instead of a generic AI look. Also use when an existing screen looks AI-generated, feels inconsistent, or needs a full-screen design review."
---

# Design

This skill is an orchestration layer. The craft lives in the installed lane skills; this file decides when each fires and owns the two things they do not cover: committing to one direction and verifying the whole screen.

The lanes (one skill per concern - never load other design skills on top of these):

- **frontend-design** (foundation): aesthetic direction, typography, signature element, self-critique against the generic default. Load it for any generation work.
- **impeccable** (review + refinement): `/impeccable audit`, `polish`, `bolder`, `quieter`, `distill`, `critique` and the deterministic slop detector (`npx impeccable detect`). Use it for review and for vague refinement asks.
- **make-interfaces-feel-better** (micro-interaction craft): exact values for radius, shadows, press states, optical alignment, staggers. Load it when building or polishing components.
- **motion-choreography** (page-level set pieces, conditional): scroll-driven storytelling, pinned/scrubbed sections, parallax, orchestrated hero entrances, page transitions. Load it ONLY when the direction contract's signature calls for cinematic motion - never for dashboards or product UI.

## Iron rules

1. **The brief wins.** What the user explicitly asked for beats every rule below, including slop warnings. If the user wants glassmorphism, they get good glassmorphism.
2. **Refinement preserves; redesign replaces.** Before ANY change to existing work, re-read the direction contract (DESIGN.md) and change the minimum that honors it. Never re-derive the design, never restyle untouched parts, never invent new elements while fixing others. If the user asked to fix the header, the footer is untouchable.
3. **One direction, named.** "Clean", "modern", "bonito" are not directions - they produce the statistical average. Name it precisely (editorial, brutalist, technical-dense, warm-minimal, cold-luxury, terminal-core, playful-color...) and confirm it before code.
4. **Verify the whole screen, never just elements.** Judgment happens on full-page screenshots, walked section by section. An element checklist misses the ugly page.
5. **Bounded polish.** One batched fix round, one confirmation round, stop. Remaining issues go to the user, not a third silent round.
6. Never use em dash or en dash anywhere. Regular hyphen only.

## Workflow

### 1. Scope (one question, max)

"Que tipo de trabalho e esse?" - build novo / redesign visual / rework de UX / copy. Copy alone routes to the humanize skill. Ask platform (web / mobile native) only if not obvious from the repo.

If redesign: capture the current state FIRST - screenshot the live screen and extract its tokens (`node ~/.claude/skills/design-system/scripts/extract-tokens.js <url> <out.json>`). Rule 2 applies from this moment.

### 2. Direction contract (before any code)

Write `DESIGN.md` at the project root (impeccable's detector and future sessions read it). If one already exists, update it - never fork a second contract. Writing this file counts as impeccable's project setup - never also run `/impeccable init`; its interview duplicates this contract. One screen, five parts:

- **Scene**: one concrete sentence - who uses this, where, under what ambient light, in what mood. If the sentence does not force the light/dark choice, it is not concrete yet. Never pick dark because "tools are cool dark".
- **Direction**: the one named aesthetic (rule 3) and the type pairing that carries it.
- **Color strategy**: restrained (neutrals + one accent <=10%) / committed (one saturated color on 30-60% of the surface) / full palette (3-4 colors with named roles) / drenched (the surface IS the color). Explicit choice - do not collapse to restrained by reflex.
- **References**: 2-3 real products studied - user URLs first, then `~/.claude/design-systems/` (60 real design systems, INDEX.json), Awwwards/Godly (web) or Mobbin (mobile). From each, write the DECISION stolen (type scale, spacing rhythm, color strategy, signature move) - never the pixels.
- **Signature**: the ONE element this screen will be remembered by. Spend all boldness there; everything around it stays quiet.
- **Standing rules** (optional): execution-level constants the whole screen obeys (radius system, tabular-nums, locale/currency specifics).

**Category-reflex check** before showing it: if theme + palette are guessable from the product category alone (observability -> dark+blue, fintech -> navy+gold, health -> white+teal, AI -> purple gradient), redo the scene and strategy until it escapes the reflex.

Show the contract in ~5 lines and get the user's approval of the DIRECTION. One message. No moodboard ceremony.

### 3. Generate

Follow the frontend-design skill's process (token plan -> critique against the generic default -> build), executing the contract exactly. Consult `~/.claude/design-systems/pro-max-data/*.csv` (palettes, font pairings, landing patterns) only when a specific lookup is needed - never as a substitute for the contract.

Build every UI state from the start: hover, focus, active, loading, empty, error. Component-level craft comes from make-interfaces-feel-better. Real images per `references/images.md`; never gray placeholders.

Save previews in `.design/preview-{name}.html` (standalone, Tailwind CDN, Google Fonts).

### 4. Full-screen verification (mandatory - this pass catches what element checks miss)

**Round 1, batched:**

a. **Screenshots**: Playwright at 1440, 768, 375 wide - FULL page. Scroll through and capture everything below the fold, not just the hero. Save in `.design/validation/`. If the Playwright MCP browser is unavailable, use `npx playwright screenshot --browser=chromium --full-page`.
b. **Specific diff, not vibe check**: look at each screenshot and walk the page section by section, top to bottom. For each section list every place spacing, alignment, hierarchy, type size, contrast (4.5:1 body text, 3:1 large text and UI graphics), or color differs from DESIGN.md or reads as template. Name every section - a section with no findings is written down as "ok", which proves it was actually looked at. At 375, every nav destination must remain reachable.
c. **Deterministic detection**: `npx impeccable detect .design/preview-*.html` - always pass explicit file paths; hidden directories are silently skipped and exit 0 with no output. The detector flags generic anti-patterns; contract conformance comes from your section walk in (b). A finding that contradicts a documented contract decision may be waived - cite the DESIGN.md line when waiving.
d. **States**: confirm hover, focus, loading, empty, error exist and are styled on every element that has those states; on static/marketing pages that means forms, nav, and any demo widget. Confirm `prefers-reduced-motion` is respected.

Fix everything found - one batch.

**Round 2**: re-screenshot, confirm the fixes, stop (rule 5). Deliver: preview path + screenshots + what was found and fixed.

### 5. Refine on feedback

Re-read DESIGN.md before every change (rule 2). Vague asks map to impeccable commands instead of improvising: "sem graca / mais ousado" -> `/impeccable bolder` · "poluido / muita coisa" -> `/impeccable quieter` · "sem alma" -> `/impeccable delight` · "tira gordura" -> `/impeccable distill` · final pass -> `/impeccable polish`. If the `/impeccable` commands are not available (e.g. inside a subagent), run `npx impeccable detect` and make the equivalent adjustment manually against DESIGN.md. After any refinement, re-run detection plus one screenshot.

### 6. Adopt

Convert the approved preview into the project's framework, reusing its existing primitives and tokens. Keep DESIGN.md at the root as the standing contract. Re-run the round-1 verification against the real dev server before calling it done.

## Mobile native (RN / Expo / Flutter)

Same workflow, swapped sources: references from Mobbin (real iOS/Android flows); component craft from Gluestack, Tamagui, NativeWind, or React Native Reusables - never web HTML pasted into RN. Preview as fixed-viewport HTML mockup (375x812 and 412x915, status bar simulated, labeled "MOCKUP - final in RN") so the verification pass still runs in Playwright. Extra checks: safe area >= 44px top iOS / 24px Android, touch targets 44/48px, bottom nav >= 56px. Adopt with the project's styling lib (one of NativeWind/Tamagui, never two).

## Never

- Code before DESIGN.md exists and the direction is approved.
- Deliver without both verification rounds.
- Restyle anything the user did not ask to change.
- Add other design skills or marketplace components (uiverse/21st) on top of this stack - layout and identity come from the contract, craft from the three lanes.
- Claim a component came from a reference when it was invented.
- Em dash or en dash in any file.
