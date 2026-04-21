---
name: ads-landing
description: "Landing page quality assessment and rewrite for paid advertising. Operates in two modes — Audit Mode (technical conversion analysis: message match, page speed, mobile, trust, forms, UTM/tracking) and Strategy Mode (full CRO rewrite with before/after copy, or complete landing page outline from scratch). Use when user says landing page, post-click experience, landing page audit, landing rewrite, CRO, or conversion optimization."
user-invokable: false
---

<!-- maxym-ai-ads | ads-landing unified v1.0 -->

# Landing Page Audit & Optimizer

This skill operates in two complementary modes. By default `/ads landing <url>` runs both sequentially, producing a single consolidated `ADS-LANDING.md` document with the technical audit followed by the CRO rewrite. Use flags to isolate a single mode:

- `--audit-only` → run only the technical conversion audit (scores, thresholds, quick wins)
- `--strategy-only` → run only the rewrite / from-scratch blueprint

If **no URL** is provided, the skill automatically switches to the Blueprint flow (see Strategy Mode § Landing Page Blueprint) to build a complete outline from scratch.

---

## Execution Flow

1. Parse `/ads landing [url] [--audit-only | --strategy-only]` arguments
2. If URL provided: `WebFetch` the page and extract full DOM text + structure
3. Run the selected mode(s):
   - Audit Mode → score 5 technical categories, emit Landing Page Health Score (0-100)
   - Strategy Mode → score 8 CRO categories, emit rewrite blocks and priority action plan
4. Write consolidated output to `ADS-LANDING.md` in the current working directory

Always load `ads/references/benchmarks.md` and `ads/references/conversion-tracking.md` before producing numbers.

---

## Audit Mode

Fast, technical diagnostic built for media buyers running active campaigns. Focus: does the landing page deliver on the ad promise and convert the traffic it is paying for?

### Process
1. Collect landing page URLs from active ad campaigns
2. Read `ads/references/benchmarks.md` for conversion rate benchmarks
3. Read `ads/references/conversion-tracking.md` for pixel/tag verification
4. Assess each landing page for ad-specific quality factors
5. Score landing pages and identify improvement opportunities
6. Generate recommendations prioritized by conversion impact

### Message Match Assessment

The #1 landing page issue in ad campaigns: does the page match the ad?

**What to check**
- **Headline match**: landing page H1 reflects ad copy headline/keyword
- **Offer match**: promoted offer (price, discount, trial) is visible above fold
- **CTA match**: landing page CTA matches ad's promised action
- **Visual match**: consistent imagery between ad creative and page
- **Keyword match**: search keyword appears naturally in page content

**Message Match Scoring**
| Level | Description | Score |
|-------|-------------|-------|
| Exact match | Headline, offer, CTA all align perfectly | 100% |
| Partial match | Headline matches but offer/CTA differs | 60% |
| Weak match | Generic page, loosely related to ad | 30% |
| Mismatch | Page content doesn't reflect ad promise | 0% |

### Page Speed Assessment

Slow pages kill conversion rates. For every 1s delay, CVR drops ~7%.

**Thresholds (Ad Landing Pages)**
| Metric | Pass | Warning | Fail |
|--------|------|---------|------|
| LCP | <2.5s | 2.5-4.0s | >4.0s |
| INP | <200ms | 200-500ms | >500ms |
| CLS | <0.1 | 0.1-0.25 | >0.25 |
| Time to Interactive | <3.0s | 3.0-5.0s | >5.0s |
| Page weight | <2MB | 2-5MB | >5MB |

**Common Speed Issues**
- Hero images not compressed (use WebP/AVIF)
- Too many third-party scripts (chat widgets, analytics, heatmaps)
- Render-blocking CSS/JS above fold
- No lazy loading for below-fold content
- Font files not preloaded

### Mobile Experience

75%+ of ad clicks come from mobile. Mobile experience is critical.

**Mobile Checklist**
- Tap targets: ≥48x48px with ≥8px spacing
- Font size: ≥16px body text (no pinch-to-zoom needed)
- Form fields: properly sized, keyboard type matches input (email, phone, number)
- CTA button: full-width on mobile, visible without scrolling
- No horizontal scroll
- Images responsive and properly sized
- Phone number clickable (tel: link)
- No interstitials or popups blocking content on load

### Trust Signals

**Above-the-Fold**
- Company logo visible
- Social proof (customer count, reviews, ratings)
- Security badges (SSL, payment security, guarantees)
- Recognizable client logos (B2B)
- Star ratings or testimonial snippet

**Below-the-Fold**
- Full testimonials with names, photos, companies
- Case study highlights with specific metrics
- Certifications, awards, accreditations
- Privacy policy link
- Physical address/phone number (local service businesses)

### Form Optimization

**Form Length Impact on CVR**
| Fields | Expected CVR Impact | Use Case |
|--------|-------------------|----------|
| 1-3 fields | Highest CVR | Top-of-funnel, free offer |
| 4-5 fields | Moderate CVR | Mid-funnel, qualified leads |
| 6-8 fields | Lower CVR | Bottom-funnel, sales-ready |
| 9+ fields | Lowest CVR | Only for high-value offers |

**Form Best Practices**
- Pre-fill fields where possible (UTM data, known info)
- Use multi-step forms for 5+ fields (progressive disclosure)
- Show progress indicator on multi-step forms
- Inline validation (don't wait until submit to show errors)
- Error messages are clear and helpful
- Submit button text is specific ("Get My Free Quote" not "Submit")
- Thank you page has clear next steps

### Landing Page Health Score Algorithm

```
Landing Page Health = (Message Match x 0.25) + (Page Speed x 0.25)
                    + (Mobile x 0.20) + (Trust x 0.15) + (Form x 0.15)
```

Each component is scored 0-100, then weighted. Final score maps to grade: A (90-100), B (75-89), C (60-74), D (40-59), F (<40).

### Consent Banner Impact

Flag if any of the following are true:
- Consent banner covers the primary CTA on load
- Consent banner delays form interaction by >1 second
- Consent banner pushes critical content (headline, offer, CTA) below the fold
- Banner cannot be dismissed on mobile without scrolling

> **Consent Mode V2**: Verify Consent Mode V2 implementation for EU/EEA traffic to ensure tracking data quality. Without Consent Mode V2, conversion modeling is degraded and remarketing audiences shrink significantly.

### Ad-Specific Landing Page Elements

**UTM Parameter Handling**
- UTM parameters captured and stored (for attribution)
- Click IDs preserved: gclid (Google), fbclid (Meta), ttclid (TikTok), msclkid (Microsoft)
- Parameters passed to form submissions or CRM

**Dynamic Content**
- Dynamic keyword insertion in headline (Google Ads feature)
- Location-specific content for geo-targeted campaigns
- Audience-specific messaging (different pages for different segments)
- A/B testing active on key elements (headline, CTA, hero image)

**Conversion Tracking**
- Thank you page/event fires correctly for all platforms
- Form submission triggers conversion event
- Phone call tracking configured (if applicable)
- Chat/live agent triggers tracked as micro-conversions

### Landing Page Quality by Platform

| Platform | Key Requirement | Notes |
|----------|----------------|-------|
| Google | QS component: landing page experience | Directly affects ad rank and CPC |
| Meta | Page load speed critical | Slow pages = Meta penalizes delivery |
| LinkedIn | Professional, B2B appropriate | Match LinkedIn's professional context |
| TikTok | Mobile-first mandatory | 95%+ TikTok traffic is mobile |
| Microsoft | Desktop-optimized matters more | Higher desktop % than other platforms |

### Quick Wins (Audit Mode)

| Priority | Fix | Expected Impact |
|----------|-----|-----------------|
| 1 | Move primary CTA above the fold on all devices | +15-25% CVR |
| 2 | Reduce form fields to essential only (name, email, one qualifier) | +10-20% CVR |
| 3 | Add trust badges near CTA (security, guarantee, reviews) | +5-15% CVR |
| 4 | Optimize hero image (WebP/AVIF, <200KB, proper dimensions) | -1-2s load time |
| 5 | Fix mobile tap targets (≥48×48px with ≥8px spacing) | +5-10% mobile CVR |

---

## Strategy Mode

CRO-focused rewrite and blueprint mode. Use this to turn a weak page into a high-converting one, or build a new landing page from scratch.

### Execution Flow (Strategy Mode)

**If URL is provided:**
1. `WebFetch` the landing page
2. Extract all visible text — headlines, subheadlines, body copy, CTAs, form fields, navigation
3. Identify trust signals — testimonials, logos, guarantees, security badges, certifications
4. Assess above-the-fold content — what does the visitor see without scrolling?
5. Evaluate CTA clarity — is there one clear action? Is it visible? Is the copy specific?
6. Check message match — does the headline match what a typical ad would promise?
7. Analyze form friction — how many fields? Are any unnecessary? Is there a progress indicator?
8. Evaluate mobile experience — responsive design, button sizes, form usability
9. Check page speed indicators — large images, heavy scripts, render-blocking resources
10. Score across 8 categories (0-100)
11. Generate specific rewrite suggestions with before/after copy
12. Append to `ADS-LANDING.md`

**If NO URL is provided:**
1. Ask the user for: business type, primary offer, target audience, desired conversion action
2. Build a complete landing page outline using the Landing Page Blueprint below
3. Write all copy sections — headline, subheadline, body, CTAs, testimonial placeholders, FAQ
4. Output the complete outline to `ADS-LANDING.md`

### Scoring Rubric (Strategy Mode, 0-100)

| Category | Weight | What It Measures |
|---|---|---|
| Message Match | 20% | Does the headline match the ad promise? Would a visitor feel they landed in the right place? |
| CTA Clarity & Placement | 20% | Is there ONE clear action? Is the CTA visible, specific, and compelling? |
| Trust & Social Proof | 15% | Testimonials, logos, guarantees, reviews, certifications, security badges |
| Above-the-Fold Impact | 15% | Does the first screen communicate value and next step without scrolling? |
| Copy Quality | 10% | Benefit-driven language, clarity, specificity, emotional triggers |
| Form & Friction | 10% | Number of fields, perceived effort, autofill support, error handling |
| Mobile Optimization | 5% | Responsive design, tap targets, form usability, load time |
| Page Speed | 5% | Estimated load time, image optimization, script weight |

### CTA Copy Hierarchy (Best → Worst)
```
BEST:  Specific + Benefit    ("Get My Free Audit Report")
GOOD:  Specific + Action     ("Download the 2026 Guide")
OK:    Action + Context      ("Start Your Free Trial")
WEAK:  Generic Action        ("Sign Up" / "Get Started")
WORST: No Context            ("Submit" / "Click Here" / "Learn More")
```

**CTA Design Checklist**
- [ ] Button color contrasts with page background (not same color family)
- [ ] Button is large enough to tap on mobile (minimum 44×44px)
- [ ] Button copy uses first person ("Get MY quote" > "Get YOUR quote")
- [ ] Sub-text under button reduces anxiety ("No credit card required")
- [ ] CTA appears above the fold, mid-page, and at the bottom
- [ ] Only ONE primary CTA per page (secondary CTAs are visually subordinate)

### Trust Signal Placement Rules
```
HERO SECTION:  Client logo bar (3-6 recognizable logos)
ABOVE FORM:    Star rating + review count ("4.8/5 from 2,847 reviews")
BESIDE FORM:   Security badges, SSL icon, privacy statement
BELOW HERO:    2-3 short testimonials with names and headshots
MID-PAGE:      Full case study or detailed testimonial
NEAR CTA:      Guarantee badge ("30-day money-back guarantee")
FOOTER:        Certifications, association memberships, contact info
```

### Form Friction Reduction
```
FIELD COUNT GUIDELINES:
- Lead gen (B2C):        Name + Email                          = 2 fields max
- Lead gen (B2B):        Name + Email + Company                = 3 fields max
- Consultation booking:  Name + Email + Phone + Preferred Time = 4 fields
- Quote request:         Name + Email + Phone + Brief Desc.    = 4 fields
- E-commerce:            Shipping + Payment (use autofill)

EVERY ADDITIONAL FIELD REDUCES COMPLETION BY ~7-10%

FRICTION REDUCERS:
- "Takes 30 seconds" or "2-minute form" — set time expectation
- Pre-fill fields from browser autofill where possible
- Use dropdown/select instead of free text where appropriate
- Show progress bar for multi-step forms
- Inline validation (green check as they complete fields)
- "We'll never share your email" near the form
- Phone field marked as optional if not essential
```

### Landing Page Blueprint (For Building From Scratch)

When no URL is provided, use this section-by-section blueprint:

**Section 1: Hero (Above the Fold)**
```
HEADLINE: [10 words max. Specific benefit + target audience]
  Formula: "[Desired Outcome] for [Target Audience] — Without [Pain Point]"
  Example: "Get 3x More Qualified Leads — Without Cold Calling"

SUBHEADLINE: [15-25 words. HOW they deliver the benefit]
  Formula: "We help [audience] [achieve outcome] by [method] so you can [ultimate benefit]"

HERO IMAGE/VIDEO: [Product in use, result screenshot, or customer photo]

PRIMARY CTA: [Specific, benefit-driven button text]
  Example: "Get My Free Lead Audit" / "Start My Free Trial" / "Book My Strategy Call"

CTA SUB-TEXT: [Anxiety reducer — 5-10 words under the button]

TRUST BAR: [3-6 client logos, star rating, or "Trusted by X+ companies"]
```

**Section 2: Problem Agitation** — "Does this sound familiar?" + 3 pain points with emotional language.

**Section 3: Solution Introduction** — "How [Product/Service] Works" in 3 steps.

**Section 4: Benefits (Not Features)** — 4 outcome-driven benefits with specific numbers and proof points.

**Section 5: Social Proof Block** — 3 testimonials with names, titles, photos + stats bar.

**Section 6: Offer Details & Pricing** — value stack formatting or lead-gen CTA with what they'll receive.

**Section 7: FAQ Section** — 5 questions aimed at the top objections (pricing, trust, complexity, timeline).

**Section 8: Final CTA Block** — urgency-driven restatement + same primary CTA + guarantee badge.

### Before/After Rewrite Format

```
### [Section Name] — Score: [X]/100

**BEFORE (Current):**
> [Exact current copy from the page]

**ISSUES:**
- [Specific problem 1]
- [Specific problem 2]

**AFTER (Recommended):**
> [Rewritten copy with improvements]

**WHY THIS IS BETTER:**
- [Specific improvement — e.g., "Uses benefit language instead of feature language"]
- [Specific improvement — e.g., "Includes a specific number for credibility"]
```

---

## Output

### Consolidated Document Structure (`ADS-LANDING.md`)

```markdown
# Landing Page Audit: [Business Name / URL]

**Generated:** [Date]
**Page URL:** [URL or "Built from scratch"]
**Business Type:** [Type]
**Primary Conversion Action:** [Purchase / Lead / Sign-up / Call / Book]

---

## Landing Page Health (Audit Mode)

Message Match:    ████████░░  XX/100
Page Speed:       ██████████  XX/100
Mobile:           ███████░░░  XX/100
Trust Signals:    █████░░░░░  XX/100
Form Quality:     ████████░░  XX/100
OVERALL:          ██████████  XX/100  Grade: [A-F]

## CRO Rewrite (Strategy Mode) — Overall XX/100

| Category | Score | Weight | Weighted |
|---|---|---|---|
| Message Match | X/100 | 20% | X |
| CTA Clarity & Placement | X/100 | 20% | X |
| ... | ... | ... | ... |

## Executive Summary
- Top 3 Strengths
- Top 3 Critical Issues
- Estimated CVR improvement if all recommendations implemented

## Detailed Audit
[Per-category analysis with before/after rewrites]

## Complete Rewrite Suggestions
[Hero, Body, CTA rewrites]

## Priority Action Plan
| Priority | Action | Expected Impact | Effort |
```

---

## Rules

1. ALWAYS fetch the URL with `WebFetch` before auditing — never audit based on assumptions
2. ALWAYS provide specific before/after copy rewrites — not just general advice
3. ALWAYS score every category — the overall score gives the user a clear benchmark
4. ALWAYS include the priority action plan — users need to know what to fix first
5. ALWAYS check message match — this is the #1 conversion killer for paid traffic
6. ALWAYS evaluate mobile experience — 60%+ of ad traffic is mobile
7. NEVER give vague recommendations like "improve your CTA" — specify exactly what to change
8. NEVER skip the above-the-fold analysis — this determines whether visitors stay or bounce
9. NEVER ignore form friction — every unnecessary field costs 7-10% of completions
10. If no URL is provided, build the full landing page outline using the Blueprint section
11. ALWAYS include trust signal recommendations with specific placement instructions
12. Output the complete audit to `ADS-LANDING.md` in the current working directory
