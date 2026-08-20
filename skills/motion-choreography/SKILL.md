---
name: "motion-choreography"
description: "Use when a landing, brand, portfolio, or experience page calls for page-level motion - scroll-driven storytelling, pinned or scrubbed sections, parallax, orchestrated hero entrances, page/view transitions - or when existing scroll choreography janks, fires at the wrong scroll position, or breaks on mobile. Not for component feedback (hover, press, toasts, drawers): that is make-interfaces-feel-better's lane."
---

# Motion choreography

Page-level cinematic motion for persuade/experience surfaces: landings, brand pages, portfolios, launches. Product UI and dashboards get NO choreography - data being read or acted on must not move. Component feedback (hover, press, popover, toast, drawer) belongs to make-interfaces-feel-better; when both apply in one project, this skill owns sections and pages, that one owns components.

## Iron rules

1. **Motivated, in writing.** Before building any moment, write one sentence naming what it communicates: hierarchy (attention lands on the right thing), storytelling (reveal sequence matches a narrative), or continuity (two states read as one journey). "It looks cool" kills the moment. GSAP everywhere because GSAP is available is amateur.
2. **Budget: one set piece.** ONE orchestrated moment per page (hero entrance OR one scrolltelling section), plus at most 2-3 quiet reveals. The direction contract's signature decides where the set piece lives; everything else stays still.
3. **Scrub or trigger - decide per section.** Scrubbed = progress tied to scroll position (pins, pans, progress). Triggered = fires ONCE entering the viewport, `once: true` always - re-animating on every scroll-by is a page fighting its reader.
4. **Reduced motion is a first-class variant.** Under `prefers-reduced-motion`, pins, parallax, hijacks, marquees, and loops collapse to normal static flow and the page stays complete and readable. Build the variant, do not bolt it on.
5. **Mobile collapses first-class too.** Below 768px, horizontal pans and heavy pins become plain vertical sections unless the mobile choreography is explicitly designed and verified. 768 is a floor, not the collapse point - raise it whenever the pinned composition loses legibility at tablet widths.
6. **Never trap the reader.** A pinned section's scroll distance equals the travel its content actually needs; the wheel must never feel hijacked past the point.
7. **Static-first markup.** Author the DOM in its final, complete state; JS opts IN to choreography (initial states set by GSAP, layout switched by a class). Reduced-motion, no-JS, and the mobile collapse then all fall out for free instead of needing fallback code.

## Tech ladder (cheapest that works)

1. **CSS scroll-driven animations** (`animation-timeline: view()`) - zero JS, but SCRUBBED by nature: they replay and reverse with the scroll, so they serve ambient scrub effects (parallax, progress-linked motion) and can never satisfy a once-only reveal. Progressive enhancement: where unsupported, the page reads fine static.
2. **IntersectionObserver + CSS transition** - triggered reveals in plain DOM: add a class once, unobserve after firing.
3. **Motion `whileInView`** - triggered reveals and staggers in React (`viewport={{ once: true, amount: 0.3 }}`).
4. **Motion `useScroll` + `useTransform`** - scrubbed effects without pinning (progress indicators, hero fade, parallax layers). Never `useState` for continuous scroll values - it re-renders the tree every frame.
5. **GSAP ScrollTrigger** - ONLY for pin/scrub set pieces (sticky-stack, horizontal pan, scrolltelling). Isolate with cleanup: `gsap.context` + revert in React, `gsap.matchMedia()` in plain DOM (it also gates reduced-motion/breakpoints and auto-reverts). Never mix GSAP and Motion in the same component tree - they fight over frames.
6. **View Transitions API** - page and route transitions; fallback is a plain fast fade.

Canonical skeletons with the known traps pre-fixed live in `references/skeletons.md` - start from them. The classic pin failure (section fires halfway down the viewport) comes from `start: "top center"`; it is always `start: "top top"`.

## Values

- Triggered reveals: opacity 0 + translateY 16-24px to rest, 500-700ms, ease `cubic-bezier(0.16, 1, 0.3, 1)`, stagger 50-100ms (30-80ms for small items). Stagger semantic chunks, never every node.
- Hero orchestration: the content is readable within 1.2s; nothing blocks interaction while entering.
- Scrubbed motion has no duration: `ease: "none"` / linear - easing on a scrub feels broken, the scroll IS the easing.
- Marketing beats may exceed the 300ms interaction cap - that cap belongs to component feedback, not set pieces.

## Banned

- `window.addEventListener("scroll")`, `scrollY` in React state, rAF loops touching state. Use `useScroll`, ScrollTrigger, IntersectionObserver, or `animation-timeline`.
- Animating layout properties (width, height, top, left, margin, padding). Transform and opacity only; clip-path sanctioned for reveals.
- Reveals without `once: true`. Pins with `start: "top center"`.
- Parallax, loops, or scroll-hijack surviving reduced-motion.
- More than one marquee per page; any autoplay longer than 5s without a pause control; `scale(0)` entrances.
- Choreography on dashboards, tables, forms, or any surface where data is being read or acted on.

## Verification (mandatory before delivering)

1. **Scroll walk**: Playwright at 1440 and 375 - screenshot at 0/25/50/75/100% scroll depth. Check: pins engage exactly at section top (measure the section's top offset, do not eyeball), nothing appears half-fired, no horizontal overflow, every section and nav destination reachable. Check the nav against the set piece: a fixed header collides with pinned captions and crosses theme boundaries on dark-to-light pages - its treatment is part of the set-piece design.
2. **Reduced motion**: emulate `prefers-reduced-motion: reduce`, take a full-page screenshot, confirm the page is complete and readable with pins/parallax/loops inactive.
3. **The slow replay**: play the set piece at 10% speed (DevTools Animations panel); headless, capture 6 stepped frames across the set piece's scroll progress instead. What feels off slow is what is subtly wrong at full speed.
4. Full-page captures of pinned pages mislead: the pin spacer renders as a tall empty band and below-fold triggered reveals may not have fired yet - walk at human speed first, then capture the settled state; neither is a bug. Programmatic jump-scrolling can outrun IntersectionObserver in headless browsers.
5. A Banned-list item found during the confirmation round is a shipping blocker: fix it and re-confirm once - the bounded-polish rule never ships a ban.
6. The design-system skill's full-screen verification still applies on top; this section only adds the motion checks.
