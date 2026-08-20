# Canonical skeletons

The traps are pre-fixed: `start: "top top"` (never "top center" - pin fires halfway down), scroll distance derived from real content travel, cleanup on unmount, reduced-motion collapse built in.

Plain DOM (standalone HTML previews, CDN GSAP): the same ScrollTrigger configs apply; replace the `useReducedMotion()` gate with `gsap.matchMedia("(min-width: 1024px) and (prefers-reduced-motion: no-preference)", ...)` - it gates breakpoint and reduced-motion together and auto-reverts when either changes.

SVG trap: `gsap.set(el, { x, y })` on an element that carries an SVG `transform` attribute REPLACES its translate instead of composing. Position on an outer `<g transform="translate(...)">` and animate a nested inner `<g>`.

## 1. Sticky-stack (cards pin and recede as the next arrives) - GSAP

```tsx
"use client";
import { useRef, useEffect } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useReducedMotion } from "motion/react";

gsap.registerPlugin(ScrollTrigger);

export function StickyStack({ cards }: { cards: React.ReactNode[] }) {
  const ref = useRef<HTMLDivElement>(null);
  const reduce = useReducedMotion();

  useEffect(() => {
    if (reduce || !ref.current) return;
    const ctx = gsap.context(() => {
      const els = gsap.utils.toArray<HTMLElement>(".stack-card");
      els.forEach((card, i) => {
        if (i === els.length - 1) return;
        ScrollTrigger.create({
          trigger: card,
          start: "top top",
          endTrigger: els[els.length - 1],
          end: "top top",
          pin: true,
          pinSpacing: false,
        });
        // previous card shrinks as the NEXT card scrolls in
        gsap.to(card, {
          scale: 0.92,
          opacity: 0.55,
          ease: "none",
          scrollTrigger: { trigger: els[i + 1], start: "top bottom", end: "top top", scrub: true },
        });
      });
    }, ref);
    return () => ctx.revert();
  }, [reduce]);

  return (
    <div ref={ref} className="relative">
      {cards.map((card, i) => (
        <div key={i} className="stack-card sticky top-0 min-h-[100dvh] flex items-center justify-center">
          {card}
        </div>
      ))}
    </div>
  );
}
```

## 2. Horizontal pan (vertical scroll drives a horizontal track) - GSAP

```tsx
"use client";
import { useRef, useEffect } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useReducedMotion } from "motion/react";

gsap.registerPlugin(ScrollTrigger);

export function HorizontalPan({ children }: { children: React.ReactNode }) {
  const wrap = useRef<HTMLDivElement>(null);
  const track = useRef<HTMLDivElement>(null);
  const reduce = useReducedMotion();

  useEffect(() => {
    if (reduce || !wrap.current || !track.current) return;
    const ctx = gsap.context(() => {
      const distance = track.current!.scrollWidth - window.innerWidth;
      gsap.to(track.current, {
        x: -distance,
        ease: "none",
        scrollTrigger: {
          trigger: wrap.current,
          start: "top top",
          end: () => `+=${distance}`, // scroll length = horizontal travel, nothing more
          pin: true,
          scrub: 1,
          invalidateOnRefresh: true,
        },
      });
    }, wrap);
    return () => ctx.revert();
  }, [reduce]);

  return (
    <section ref={wrap} className="relative overflow-hidden">
      <div ref={track} className="flex h-[100dvh] items-center">{children}</div>
    </section>
  );
}
```

Below 768px: skip the effect entirely and render the track as a vertical stack (iron rule 5).

## 3. Reveal stagger (enter once on scroll) - Motion, no GSAP needed

```tsx
"use client";
import { motion, useReducedMotion } from "motion/react";

export function RevealStagger({ items }: { items: string[] }) {
  const reduce = useReducedMotion();
  return (
    <ul className="grid gap-6">
      {items.map((item, i) => (
        <motion.li
          key={item}
          initial={reduce ? false : { opacity: 0, y: 24 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, amount: 0.3 }}
          transition={{ duration: 0.6, delay: i * 0.06, ease: [0.16, 1, 0.3, 1] }}
        >
          {item}
        </motion.li>
      ))}
    </ul>
  );
}
```

Use for feature lists, testimonial grids, logo walls - anything that just enters on scroll. Save GSAP for real pin/scrub work.

## 4. Triggered reveal in plain DOM - IntersectionObserver (once semantics without React)

```js
const io = new IntersectionObserver((entries) => {
  for (const e of entries) {
    if (e.isIntersecting) {
      e.target.classList.add("is-in");
      io.unobserve(e.target); // fires once, never replays
    }
  }
}, { threshold: 0.3 });
document.querySelectorAll(".reveal").forEach((el) => io.observe(el));
```

```css
@media (prefers-reduced-motion: no-preference) {
  .reveal { opacity: 0; transform: translateY(20px); transition: opacity 600ms cubic-bezier(0.16, 1, 0.3, 1), transform 600ms cubic-bezier(0.16, 1, 0.3, 1); }
}
.reveal.is-in { opacity: 1; transform: none; }
```

## 5. CSS scroll-driven scrub (ambient - replays and reverses with the scroll)

```css
@media (prefers-reduced-motion: no-preference) {
  @supports (animation-timeline: view()) {
    .drift {
      animation: drift linear both;
      animation-timeline: view();
      animation-range: entry 0% exit 100%;
    }
    @keyframes drift {
      from { transform: translateY(32px); }
      to { transform: translateY(-32px); }
    }
  }
}
```

Scrubbed by nature - it re-runs on every scroll pass, so it can NEVER implement a once-only reveal (iron rule 3); use it for parallax and progress-linked ambient motion only. Unsupported browsers and reduced-motion users get the static page - by construction, not by fallback code.

## 6. View transition (route/page change)

```js
// same-document: wrap the DOM update
if (document.startViewTransition) {
  document.startViewTransition(() => updateDOM());
} else {
  updateDOM();
}
```

```css
::view-transition-old(root), ::view-transition-new(root) { animation-duration: 250ms; }
@media (prefers-reduced-motion: reduce) {
  ::view-transition-old(root), ::view-transition-new(root) { animation: none; }
}
```

Shared-element morphs: give the element the same `view-transition-name` on both sides.

## Sources

GSAP/Motion patterns adapted from Leonxlnx/taste-skill's canonical motion section; values and restraint rules from emilkowalski/skills (MIT, (c) 2026 Emil Kowalski) and jakubkrehel/make-interfaces-feel-better.
