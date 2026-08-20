# Image generation cascade

Start Tier 1, escalate only if the user asks.

**Tier 1 - Pollinations/Flux (free)**
`https://image.pollinations.ai/prompt/{encoded}?width=1024&height=1024&nologo=true`
Download via curl. Tell the user: "Gerado gratis. Diz 'upgrade' se nao curtiu."

**Tier 2 - Imagen 4 Fast (~R$0.11/img)**
```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-fast-generate-001:predict?key=$GEMINI_DESIGN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"instances":[{"prompt":"PROMPT"}],"parameters":{"sampleCount":1,"aspectRatio":"1:1"}}'
```
Base64 in `predictions[0].bytesBase64Encoded`.

**Tier 3 - Nano Banana 2 (~R$0.38/img)**
```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image-preview:generateContent?key=$GEMINI_DESIGN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Generate an image: PROMPT"}]}],"generationConfig":{"responseModalities":["TEXT","IMAGE"]}}'
```

**User shortcuts:** "upgrade"/"podre"/"ruim" = next tier, "nb2" = Tier 3, "free" = Tier 1, "imagen" = Tier 2.

**Photos without generation:** Unsplash direct `https://images.unsplash.com/photo-{id}?w={w}&h={h}&fit=crop` or `https://picsum.photos/seed/{descriptive-seed}/{w}/{h}`. Never gray placeholder boxes.

**Logos:** SVG in code first (free). AI only if the user wants something elaborate - ask "Quer SVG (gratis) ou IA (cascata)?". Real brand logos via Simple Icons CDN.
