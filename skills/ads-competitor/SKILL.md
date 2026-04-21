---
name: ads-competitor
description: "Competitor ad intelligence across Google, Meta, LinkedIn, TikTok, Microsoft, YouTube, and Apple Ads. Combines cross-platform reconnaissance (ad libraries, auction insights, platform signals, estimated spend) with strategic gap analysis and a 'beat the competition' playbook — positioning statement, ad angles, creative differentiation plan, targeting exploitation, offer counter-strategy, plus a swipe file template for ongoing tracking. Use when user says competitor ads, ad spy, competitive analysis, competitor PPC, or ad intelligence."
user-invokable: false
---

<!-- maxym-ai-ads | ads-competitor unified v1.0 -->

# Competitor Ad Intelligence

This skill produces a full competitive intelligence report in two linked sections:

1. **Competitor Ad Intelligence** — platform-by-platform reconnaissance across every major ad library and data source. Who is active, where, with what creative, and what it is costing them.
2. **Gap Analysis & Opportunities** — the strategic output: what competitors are *not* doing, a positioning statement the business can own, 3-5 specific ad angles that exploit those gaps, a creative differentiation plan, targeting exploitation, offer counter-strategy, and a swipe-file template for continuous tracking.

The final deliverable is `ADS-COMPETITORS.md` in the current working directory (plus an optional `COMPETITIVE-GAPS.md` standalone gap extract when `--gaps-only` is passed).

---

## Process

1. Fetch the target business website with `WebFetch` to anchor positioning
2. Identify 3-5 competitors (2-3 direct, 1 aspirational, 1 indirect/emerging)
3. Read `ads/references/benchmarks.md` for industry CPC/CTR/CVR baselines
4. Run the Competitor Ad Intelligence section (reconnaissance)
5. Run the Gap Analysis & Opportunities section (strategy)
6. Assemble the `ADS-COMPETITORS.md` output

---

## Competitor Ad Intelligence

### Competitor Identification

**Search queries to run (via WebSearch):**
```
"[business type] [city/region]"       — local competitors
"[business name] vs"                  — direct comparison
"[business name] alternatives"        — substitute competitors
"[business name] competitors"         — industry analysis
"best [product/service category]"     — category leaders
"[product/service] reviews"           — who appears on review sites
```

**Competitor Categories**
| Category | Definition | Why It Matters |
|---|---|---|
| Direct | Same product, same market, same audience | Same customers and keywords |
| Indirect | Different product, same problem | Same budget and attention |
| Aspirational | Larger companies in the same space | Proven ad strategies to adapt |
| Emerging | Newer companies gaining traction | Innovative approaches worth studying |

Select 3-5: 2-3 direct, 1 aspirational, 1 indirect/emerging.

### Platform Presence Detection

For each competitor, determine which ad platforms they likely run.

| Signal | Platform | How to Check |
|---|---|---|
| Facebook pixel on website | Meta | Page source: `fbq` or `fb-pixel` |
| Google Ads tag on website | Google Ads | Page source: `gtag` / `googleads` |
| LinkedIn Insight Tag | LinkedIn Ads | Page source: `_linkedin_partner_id` |
| TikTok pixel | TikTok Ads | Page source: `ttq` |
| UTM parameters in links | Multiple | Check `utm_source` on their social links |
| Meta Ad Library results | Active Meta advertiser | Search their page name |
| Branded search ads | Google Search | Google their brand — do ads appear? |
| Shopping results | Google Shopping | Search their product names |
| Sponsored content on LinkedIn | LinkedIn Ads | Check their company page |
| Pre-roll / in-stream ads | YouTube | Notice if ads play before their niche's videos |

### Data Sources

| Source | Platform | What You Can Find |
|---|---|---|
| Google Ads Transparency Center | Google | Active ads, formats, geo targeting |
| Meta Ad Library | Meta/Instagram | All active ads, creative, copy, spend range |
| LinkedIn Ad Library | LinkedIn | Active ads from company pages |
| TikTok Creative Center 2.0 | TikTok | Top ads, trending creative, hashtags, Shop activity |
| Microsoft Ads Auction Insights | Microsoft | Impression share, overlap, position data |
| Apple Ads (App Store) | Apple | Search tab, Today tab, CPP variants |

**Google Ads Auction Insights** (from the user's own account): impression share vs competitors, overlap rate, outranking share, top-of-page rate, absolute top of page rate. Available on Search and Shopping.

### 2025-2026 Platform Intelligence Updates

**Meta** — Andromeda creative clustering (Oct 2025): ads with >60% similarity are suppressed, so measure *genuine* conceptual diversity. Advantage+ Sales replaced ASC as the unified shopping campaign type — check competitor adoption.

**Google** — Demand Gen fully replaced Video Action Campaigns (April 2026). AI Max for Search delivers a ~14% conversion lift — check competitor adoption via Transparency Center. Expanded Transparency Center gives richer history, formats, and region targeting data.

**TikTok** — Creative Center 2.0 with enhanced industry benchmarking and objective/format filtering. Symphony AI (2025) generates creative at scale — assess whether competitors rely on Symphony vs original. Review TikTok Shop tabs, catalogs, reviews, and live shopping.

**LinkedIn** — Thought Leader Ads expansion (March 2025) now supports non-employee creators. CRM integration (June 2025) enables more precise audience matching — competitors with CRM integration show tighter targeting patterns.

**Microsoft** — Copilot ads in conversations (new placement in MS Copilot chat). CTV inventory via Netflix, Max, Hulu, Roku — assess competitor presence on connected TV.

**Apple Ads** — Rebranded from "Apple Search Ads" (April 2025). Custom Product Pages let competitors run different page variants per ad group — analyze the CPP strategy. Maximize Conversions (GA Feb 2026) is the new AI auto-bidder — check adoption.

> For live programmatic access to competitor data, see `ads/references/mcp-integration.md`.

### Ad Copy Analysis Framework

For each competitor, document:
- **Headlines** — primary messages and value propositions
- **CTAs** — action driven (free trial, demo, buy now, learn more)
- **Offers** — pricing, discounts, free shipping, trials
- **Tone** — professional, casual, urgent, educational, emotional
- **USPs** — unique selling propositions
- **Pain points** — customer problems they address

### Creative Strategy Analysis
- **Formats** — image, video, carousel, collection, document
- **Visual style** — photography, illustration, UGC, stock, branded
- **Video approach** — studio vs UGC vs animated
- **Creative volume** — number of active ads (testing velocity signal)
- **Refresh frequency** — how often new creatives appear

### Creative Style Taxonomy

| Style | Description | When It Works |
|---|---|---|
| UGC | Selfie-style, testimonial videos, unpolished | E-commerce, DTC, courses |
| Polished/Professional | Studio-shot, branded, high production | B2B, SaaS, luxury, services |
| Educational/Tutorial | How-to, tips, demos | SaaS, tools — builds authority |
| Meme/Trend-Based | Current trends, humor | Consumer brands, younger audiences |
| Data/Stat-Driven | Infographics, charts | B2B, SaaS, finance — credibility |
| Comparison/vs | Side-by-side with alternatives | Challenger brands |
| Testimonial-Led | Customer stories front and center | High-trust industries |
| Problem-Agitation | Dramatize pain before revealing solution | Emotional/urgent services |

### Messaging Theme Matrix

| Theme | Competitor A | Competitor B | Your Brand |
|---|---|---|---|
| Price/Value | ✅ Primary | ⚠️ Secondary | ? |
| Quality/Premium | ❌ | ✅ Primary | ? |
| Speed/Convenience | ⚠️ Secondary | ❌ | ? |
| Trust/Authority | ✅ Primary | ✅ Primary | ? |
| Innovation | ❌ | ⚠️ Secondary | ? |

### Keyword Intelligence (Google/Microsoft/Apple)
- Brand keyword bidding — are competitors bidding on your brand?
- Keyword overlap — non-brand terms both target
- Keyword gaps — terms they rank for that you do not target
- Match type strategy — inferred from ad triggers

### Targeting Reverse-Engineering

| Signal on Their Page/Ads | Inferred Targeting |
|---|---|
| Industry-specific language | Industry / vertical targeting |
| City/region mentioned | Geo-targeting |
| Job titles called out | LinkedIn job title targeting |
| Company size references | Firmographic targeting |
| Income/lifestyle references | Demographic + income targeting |
| Problem-specific language | Interest / in-market targeting |
| "As seen in [publication]" | Publication-reader retargeting |
| Multiple language versions | International / multilingual |
| Mobile-specific CTAs ("Call now") | Mobile device targeting |
| Time-sensitive offers | Day-parting / scheduling |

### Spend Estimation

- Meta Ad Library shows spend ranges for political/social ads
- Google Auction Insights + impression share → directional estimate
- Third-party tools (SpyFu, SEMrush, AdBeat, Pathmatics) for precision
- Manual formula:
  ```
  Estimated Monthly Spend = Impressions × CPM / 1000
                          = Clicks × Estimated CPC
  ```

---

## Gap Analysis & Opportunities

This is the strategic payoff of the skill. Everything above is input for this section.

### Gap Categories

| Gap Type | How to Identify | Opportunity |
|---|---|---|
| Messaging | All competitors say the same thing | Own a unique angle no one claims |
| Audience | Competitors target the same broad audience | Target a niche they ignore |
| Platform | Competitors cluster on Meta/Google | First-mover on LinkedIn/TikTok/YouTube/CTV |
| Creative | All static images | Stand out with video/UGC/Reels |
| Offer | Same free trial / 10% off | Guarantee, bundle, free assessment |
| Content | No educational content | Build authority with content-first ads |
| Trust | No social proof / reviews in ads | Lead with overwhelming proof |
| Speed | Slow LPs or complex funnels | Win on simplicity and load time |
| Objection | No one addresses the top objection | Lead with the elephant in the room |
| Format | No long-form content / webinars / series | Build a content moat |

### Gap Analysis Template
```
| Gap Type | What Competitors Do | What's Missing | Your Opportunity |
|---|---|---|---|
| Messaging | [pattern] | [what no one says] | [claim to own] |
| Audience | [who they all target] | [who they ignore] | [niche to own] |
| Platform | [where they advertise] | [unused platform] | [first-mover] |
| Creative | [their approach] | [unused format] | [how to stand out] |
| Offer | [standard offers] | [missing offer type] | [differentiated offer] |
| Trust | [proof strategy] | [proof they lack] | [credibility edge] |
```

### "Beat the Competition" Strategy

**1. Positioning Statement**
```
"While [competitors] focus on [what they all say], [Your Business] is the only
[business type] that [unique differentiator], which means [customer benefit]."
```

**2. Ad Angle Recommendations (3-5)**
```
ANGLE 1: [Gap-based angle]
- Hook: "[Specific hook text]"
- Body: "[Key message]"
- CTA: "[Specific CTA]"
- Why this beats competitors: [Explanation]
```

**3. Creative Differentiation Plan**
```
IF competitors use [format]  → YOU use [different format]  because [reason]
IF competitors' tone is [X]  → YOUR tone is [Y]            because [reason]
IF competitors' ads feel [F] → YOUR ads feel [G]           because [reason]
```

**4. Targeting Exploitation**
```
AUDIENCE GAPS TO TARGET:
- [Underserved segment]: [Why competitors miss them] — [How to reach them]

KEYWORD OPPORTUNITIES:
- [Competitor] + "alternative" — bid on competitor brand terms (know the rules)
- [Problem keyword competitors don't bid on] — uncontested intent
- [Long-tail competitors ignore] — low CPC, high intent
```

**5. Offer Differentiation**
```
COMPETITOR OFFERS            →  YOUR COUNTER-OFFER
[Competitor 1]: [their offer] →  [differentiated offer]
[Competitor 2]: [their offer] →  [how yours is better]
[Competitor 3]: [their offer] →  [what you offer that they don't]
```

### Competitive Response Playbook

**When competitors bid on your brand**
- Always run brand campaigns to defend (low CPC, high CTR)
- Dynamic keyword insertion
- Sitelinks to key pages (pricing, features, reviews)
- Copy that emphasizes unique differentiators
- Consider bidding on their brand terms (respect platform rules)

**When you are outspent**
- Focus on efficiency over volume (targeting, creative, LP)
- Target long-tail keywords competitors ignore
- Use Exact match for precision (less waste)
- Double down on retargeting (lower CPA than prospecting)
- Compete on creative quality, not budget

---

## Competitor Ad Swipe File Template

```markdown
## Competitor Ad Swipe File

### [Competitor Name]
**Last Updated:** [Date]
**Platforms Active:** [List]
**Estimated Monthly Ad Spend:** [Low/Medium/High based on ad volume]

#### Ad Examples
**Ad 1**
- Platform: [Meta / Google / LinkedIn / TikTok]
- Format: [Static / Video / Carousel / Story]
- Hook: "[First line of ad copy]"
- Body: "[Key message summary]"
- CTA: "[CTA text]"
- Landing Page: [URL]
- Offer: [What they're offering]
- Creative Style: [UGC / Polished / Educational / etc.]
- Estimated Run Time: [How long active]
- Notes: [What works, what doesn't, what to learn]

#### Tracking Notes
- Frequency of new ads: [Weekly / Bi-weekly / Monthly / Rarely]
- Creative refresh pattern
- Seasonal patterns
- Offer change cadence
```

---

## Competitive Monitoring

**Free Tools**

| Tool | What It Does | Cadence |
|---|---|---|
| Meta Ad Library | All active Meta/IG ads per page | Monthly |
| Google Ads Transparency Center | Verified advertisers, ad history | Quarterly |
| LinkedIn Ad Library | Sponsored content per company | Monthly |
| SimilarWeb (free tier) | Traffic estimates and sources | Monthly |
| BuiltWith | Tech stack + pixel detection | One-off / ad-hoc |
| Social Blade | Social growth tracking | Monthly |
| Google Alerts | Brand mention monitoring | Continuous |

**Paid Tools (recommended at $5K+/mo ad spend)**

| Tool | What It Does | Price Range |
|---|---|---|
| SpyFu | Competitor keyword + PPC intelligence | $39-$79/mo |
| SEMrush | Comprehensive competitor ad analysis | $130-$500/mo |
| Ahrefs | Organic + paid search intelligence | $99-$999/mo |
| AdBeat | Display ad intelligence | $249+/mo |
| Pathmatics | Cross-platform ad spend estimates | Enterprise |

---

## Output Template (`ADS-COMPETITORS.md`)

```markdown
# Competitive Ad Intelligence: [Business Name]

**Generated:** [Date]
**Target Business:** [Name + URL]
**Industry:** [Industry/Niche]
**Competitors Analyzed:** [Number]

## Executive Summary
[3-5 sentences: key findings, biggest opportunity, recommended strategy]

## Competitor Overview
| Competitor | URL | Type | Platforms | Ad Activity | Threat Level |
|---|---|---|---|---|---|

## Detailed Competitor Analysis
### Competitor 1: [Name]
  - Platform Presence
  - Messaging & Positioning
  - Landing Page Analysis
  - Creative Approach
  - Targeting Strategy (inferred)
  - Strengths & Weaknesses
### Competitor 2 / 3 / …

## Positioning Gap Analysis
[Gap table with industry pattern and your opportunity]

## Beat the Competition Strategy
- Your Competitive Positioning (statement)
- Recommended Ad Angles (3-5)
- Creative Differentiation Plan
- Targeting Opportunities
- Offer Strategy

## Competitor Ad Swipe File
[Swipe file populated with discovered ads]

## Monitoring Plan
[Tools and frequency for ongoing tracking]
```

---

## Rules

1. ALWAYS fetch the target business website first — know THEIR positioning before analyzing competitors
2. ALWAYS identify at least 3 competitors — fewer than 3 is insufficient competitive context
3. ALWAYS include the positioning gap analysis — this is the most valuable strategic output
4. ALWAYS provide specific ad angle recommendations — not "be different" but exactly HOW
5. ALWAYS include the swipe file template — users need a system for ongoing tracking
6. ALWAYS search for competitor ads via Meta Ad Library and Google Ads Transparency Center
7. NEVER make up competitor ad examples — only include what can be verified or reasonably inferred
8. NEVER skip the "beat the competition" strategy — analysis without strategy is just data
9. NEVER ignore indirect competitors — they reveal positioning opportunities direct rivals miss
10. ALWAYS include monitoring recommendations — competitive intelligence is ongoing
11. ALWAYS assess threat level per competitor — helps prioritize attention
12. Output the complete intelligence report to `ADS-COMPETITORS.md` in the current working directory
