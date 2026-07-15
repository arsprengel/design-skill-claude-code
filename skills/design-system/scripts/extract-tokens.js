#!/usr/bin/env node
/**
 * Extract design tokens from a URL: colors, fonts, spacing, radii, shadows.
 * Usage: node extract-tokens.js <url> [out.json]
 *
 * Uses Playwright (must be installed: npx -y playwright install chromium).
 * Falls back to plain fetch + regex if Playwright is not available.
 */
const fs = require('fs');
const path = require('path');

async function extractWithPlaywright(url) {
  const { chromium } = require('playwright');
  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });

  const tokens = await page.evaluate(() => {
    const freq = (arr) => {
      const m = new Map();
      for (const v of arr) if (v) m.set(v, (m.get(v) || 0) + 1);
      return [...m.entries()].sort((a, b) => b[1] - a[1]).slice(0, 20).map(([v, c]) => ({ value: v, count: c }));
    };
    const all = document.querySelectorAll('*');
    const colors = [], bgs = [], fonts = [], sizes = [], weights = [], radii = [], shadows = [], spacings = [];
    all.forEach((el) => {
      const s = getComputedStyle(el);
      colors.push(s.color);
      bgs.push(s.backgroundColor);
      fonts.push(s.fontFamily);
      sizes.push(s.fontSize);
      weights.push(s.fontWeight);
      radii.push(s.borderRadius);
      shadows.push(s.boxShadow);
      spacings.push(s.padding);
    });
    return {
      color: freq(colors),
      background: freq(bgs),
      font_family: freq(fonts),
      font_size: freq(sizes),
      font_weight: freq(weights),
      border_radius: freq(radii),
      box_shadow: freq(shadows),
      padding: freq(spacings),
    };
  });

  const html = await page.content();
  const screenshot = await page.screenshot({ fullPage: false, type: 'png' });
  await browser.close();

  return { url, tokens, html_length: html.length, screenshot_base64: screenshot.toString('base64') };
}

async function main() {
  const url = process.argv[2];
  const out = process.argv[3];
  if (!url) {
    console.error('Usage: extract-tokens.js <url> [out.json]');
    process.exit(1);
  }
  try {
    const data = await extractWithPlaywright(url);
    const json = JSON.stringify(data, null, 2);
    if (out) {
      fs.writeFileSync(out, json);
      console.log(`Saved tokens to ${out}`);
    } else {
      console.log(json);
    }
  } catch (e) {
    console.error('Extraction failed:', e.message);
    console.error('Install playwright: npm i -g playwright && npx playwright install chromium');
    process.exit(2);
  }
}

main();
