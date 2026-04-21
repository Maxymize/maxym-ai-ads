---
name: ads-budget
description: "Budget allocation and bidding strategy for paid advertising. Two modes — Budget Audit (evaluates existing spend, bidding strategies, scaling readiness, kill/scale lists using 3x Kill Rule + 70/20/10 rule + 20% scaling rule) and Budget Allocation (takes a monthly amount and produces Conservative/Balanced/Aggressive scenarios with CPM/CPC/CPA projections, break-even analysis, and scaling roadmap). Use when user says budget allocation, bidding strategy, ad spend, ROAS target, media budget, or scaling."
user-invokable: false
---

<!-- maxym-ai-ads | ads-budget unified v1.0 -->

# Budget Allocation & Bidding Strategy

This skill operates in two complementary modes selected by the argument passed to `/ads budget`:

- **With an amount** (e.g. `/ads budget 5000` or `/ads budget $3k/mo`) → **Budget Allocation** mode: produces a forward-looking plan with Conservative/Balanced/Aggressive scenarios, ROI projections, and a scaling roadmap.
- **Without an amount** (`/ads budget`) → **Budget Audit** mode: evaluates the user's existing spend distribution, bidding strategies, and flags campaigns to kill or scale.

Both modes output to `ADS-BUDGET.md` (or `BUDGET-STRATEGY-REPORT.md` when running in audit mode) in the current working directory.

---

## Budget Audit

Use this mode when an active account exists and spend/performance data is available.

### Process
1. Collect budget and performance data across all active platforms
2. Read `ads/references/budget-allocation.md` for allocation framework
3. Read `ads/references/bidding-strategies.md` for strategy decision trees
4. Read `ads/references/benchmarks.md` for CPC/CPA benchmarks
5. Read `ads/references/scoring-system.md` for health score algorithm
6. **Validate**: confirm spend data covers ≥14 days before evaluating kill/scale decisions
7. Evaluate budget allocation, bidding strategy, and scaling readiness
8. **Validate**: verify kill list candidates have sufficient data (≥20 clicks or ≥$100 spend) before recommending pause
9. Generate recommendations with kill list and scale list

### 70/20/10 Rule
- **70%** on proven channels (consistent ROAS/CPA targets met)
- **20%** on scaling channels (showing promise, need more data)
- **10%** on testing channels (new platforms, audiences, creatives)

### Budget Sufficiency Rules

| Platform | Minimum Daily | Learning Phase Budget |
|----------|--------------|----------------------|
| Google Search | $20/day | Sufficient for 15+ conv/month |
| Google PMax | $50/day | Sufficient for algorithm optimization |
| Meta | $20/day per ad set | ≥5× target CPA per ad set |
| LinkedIn | $50/day Sponsored Content | 15+ conversions/month |
| TikTok | $50/day campaign, $20/day ad group | ≥50× target CPA per ad group |
| Microsoft | No strict minimum | Sufficient for stable delivery |

### Bidding Strategy Evaluation

**Google Ads Bidding Decision Tree**
```
Start
├─ <30 conversions/month?
│  └─ Use Maximize Clicks (cap CPC at benchmark)
│     └─ When >30 conv/month → Maximize Conversions
├─ 30-50 conversions/month?
│  └─ Use Maximize Conversions
│     └─ When stable CPA → Target CPA
├─ >50 conversions/month?
│  └─ Use Target CPA
│     └─ When revenue tracking → Target ROAS
└─ Revenue tracking active + >50 conv/month?
   └─ Use Target ROAS
```

**Meta Ads Bidding**
- Lowest Cost (default): best for volume, may have CPA variance
- Cost Cap: sets CPA ceiling, may reduce volume
- Bid Cap: maximum bid per auction, most control
- ROAS Goal: target return on ad spend
- CBO vs ABO: CBO for proven campaigns, ABO for testing

**LinkedIn Bidding**
- Cost Per Send (CPS) for Message Ads
- Manual CPC recommended as starting point for cost control
- Cost Cap for efficiency at scale
- Maximum Delivery only for scale with established data
- Target Cost for predictable CPA

**TikTok Bidding**
- Lowest Cost: maximize conversions within budget
- Cost Cap: set maximum CPA (efficiency)
- Bid Cap: maximum bid per impression
- Budget ≥50× CPA per ad group for learning phase exit

**Microsoft Bidding**
- Mirror Google strategy but bid 20-35% lower
- Manual CPC for low-volume campaigns
- Target CPA / Target ROAS for automated (requires 15+ conversions/30 days)

### 2026 Bidding Innovations
- **Google AI Max for Search**: 14% conversion lift, needs strong negative keyword lists; DSA likely consolidated into AI Max by Q2 2026
- **TikTok Smart+ Modular Control**: lock targeting/creative/budget/placement independently; 1.41-1.67× ROAS in early adopter data
- **Apple Ads Maximize Conversions** (GA Feb 26, 2026): AI auto-bidder, target CPA on weekly average, daily budget ≥5× target CPA, 2-week learning phase
- **Meta Advantage+ Bidding**: auto-optimizes across placements inside Advantage+ Sales campaigns; best with broad targeting and high creative volume

### Scaling Assessment

**Ready to Scale (Green Light)**
- CPA consistently below target for 2+ weeks
- ≥50 conversions per week (learning phase exited)
- CTR stable or improving
- ROAS above target
- No creative fatigue signals

**20% Rule** — never increase budget by more than 20% at a time; monitor 3-5 days after each increase.

**Scaling Methods**
1. Vertical — increase budget on winning campaigns (20% rule)
2. Horizontal — duplicate winning campaigns to new audiences
3. Platform expansion — add budget on new platforms
4. Geographic expansion — test new markets/regions
5. Format expansion — test new ad formats on same platform

### Kill List Assessment

**3× Kill Rule**
- Any campaign/ad group with CPA >3× target → **flag for pause**
- Spend in last 14 days with no conversions → **flag for pause**
- Creative with CTR >50% below platform benchmark → **flag for creative kill**

**Kill Decision Framework**
| Scenario | Data Required | Action |
|----------|---------------|--------|
| CPA >3× target | ≥7 days data, ≥20 clicks | Pause immediately |
| No conversions | ≥$100 spend or ≥50 clicks | Pause and diagnose |
| CTR <50% of benchmark | ≥1,000 impressions | Kill creative, test new |
| ROAS <50% of target | ≥14 days data | Reduce budget 50% or pause |

### MER (Marketing Efficiency Ratio)
```
MER = Total Revenue / Total Marketing Spend
```
- Assess blended efficiency across all platforms
- Target MER varies by business: 3×-10× depending on margins
- Use MER to evaluate overall health, not just per-platform ROAS
- Incrementality testing recommended for MER accuracy

### Audit Output
```
Budget Allocation Health

Allocation Strategy:  ████████░░  XX/100
Bidding Strategies:   ██████████  XX/100
Scaling Readiness:    ███████░░░  XX/100
Budget Sufficiency:   █████░░░░░  XX/100
```

**Audit Deliverables** (`BUDGET-STRATEGY-REPORT.md`)
- Current vs recommended budget split
- Bidding strategy recommendations per platform/campaign
- Scale list: campaigns ready for more budget
- Kill list: campaigns/ad groups to pause immediately
- MER analysis and trend
- Quick Wins for immediate budget optimization

---

## Budget Allocation

Use this mode when the user supplies a monthly amount and wants a forward-looking plan.

### Execution Flow
1. Parse the budget amount (e.g., `$3000`, `3k`, `$5,000/mo`)
2. Determine business context (from session or ask: business type, primary offer, AOV/deal size, current monthly revenue)
3. Detect business type to apply correct benchmark data
4. Select recommended platforms based on business type
5. Run 3 budget scenarios (Conservative, Balanced, Aggressive)
6. Project impressions, clicks, and conversions at each budget tier
7. Calculate break-even point and payback period
8. Build a scaling roadmap from current budget to 3×-5×
9. Output complete plan to `ADS-BUDGET.md`

### Required Inputs
| Input | How to Get It | Default If Missing |
|---|---|---|
| Monthly budget | User provides via command | REQUIRED — ask if missing |
| Business type | Detect from URL or ask | Ask user |
| Average order value (AOV) | Ask or estimate from industry | Use industry average |
| Customer lifetime value (LTV) | Ask or calculate as AOV × avg purchases | AOV × 2.5 |
| Current monthly revenue | Ask if available | Skip break-even if missing |
| Target CPA goal | Calculate from margins | LTV / 3 |

### Platform Selection Matrix

| Business Type | Primary | Secondary | Testing |
|---------------|---------|-----------|---------|
| SaaS B2B | Google Search, LinkedIn | Meta, YouTube | TikTok, Microsoft |
| E-commerce | Google Shopping, Meta | TikTok, YouTube | Microsoft, LinkedIn |
| Local Service | Google Search, Google LSA | Meta | Microsoft, YouTube |
| B2B Enterprise | LinkedIn, Google Search | Meta | Microsoft, TikTok |
| Info Products | Meta, YouTube | Google Search | TikTok |
| Mobile App | Meta, Google UAC | TikTok | Apple Ads |
| Real Estate | Google Search, Meta | YouTube | Microsoft |
| Healthcare | Google Search | Meta | Microsoft, YouTube |
| Finance | Google Search, Meta | LinkedIn | Microsoft |
| Agency (clients) | Varies by client | N/A | N/A |

### Industry Benchmark Database

**CPC Benchmarks by Platform and Industry**

| Industry | Meta CPC | Google Search CPC | Google Display CPC | LinkedIn CPC | TikTok CPC |
|---|---|---|---|---|---|
| E-commerce (general) | $0.70-$1.20 | $1.00-$2.50 | $0.30-$0.80 | $5.00-$8.00 | $0.50-$1.00 |
| SaaS / Software | $1.50-$3.00 | $3.00-$8.00 | $0.50-$1.20 | $5.50-$11.00 | $0.80-$1.50 |
| Local Services | $0.80-$1.50 | $2.00-$6.00 | $0.40-$1.00 | $4.00-$7.00 | $0.60-$1.20 |
| Agency / B2B Services | $1.20-$2.50 | $3.00-$7.00 | $0.50-$1.00 | $5.00-$9.00 | $0.70-$1.30 |
| Creator / Course | $0.60-$1.00 | $1.50-$4.00 | $0.30-$0.70 | $6.00-$10.00 | $0.40-$0.80 |
| Healthcare / Dental | $1.00-$2.00 | $3.00-$8.00 | $0.50-$1.20 | $5.00-$8.00 | $0.70-$1.20 |
| Real Estate | $0.80-$1.50 | $2.00-$5.00 | $0.40-$0.90 | $4.50-$8.00 | $0.60-$1.00 |
| Legal Services | $1.50-$3.00 | $5.00-$15.00 | $0.60-$1.50 | $5.50-$10.00 | $0.80-$1.50 |
| Fitness / Wellness | $0.50-$1.00 | $1.50-$4.00 | $0.30-$0.80 | $5.00-$8.00 | $0.40-$0.90 |
| Restaurant / Food | $0.40-$0.80 | $1.00-$3.00 | $0.25-$0.60 | $4.00-$7.00 | $0.30-$0.70 |

**CPM Benchmarks (per 1,000 impressions)**

| Platform | TOFU CPM | MOFU CPM | BOFU CPM | Retargeting CPM |
|---|---|---|---|---|
| Meta (FB/IG) | $5-$12 | $10-$20 | $15-$30 | $8-$18 |
| Google Display | $2-$6 | $4-$10 | $8-$15 | $5-$12 |
| Google Search | N/A | $20-$50 | $30-$80 | RLSA: $25-$60 |
| YouTube | $4-$10 | $8-$18 | $12-$25 | $6-$15 |
| LinkedIn | $30-$60 | $40-$80 | $50-$100 | $25-$50 |
| TikTok | $3-$8 | $6-$15 | $10-$25 | $5-$12 |

### Minimum Viable Budget by Platform

| Platform | Minimum Monthly | Recommended Monthly | Why |
|---|---|---|---|
| Meta | $500 | $1,500+ | $15-20/day/ad set required for algorithm |
| Google Search | $500 | $1,000+ | Keyword-dependent; need 10-20 clicks/day |
| Google Display | $300 | $800+ | Low CPM but needs volume |
| Google Shopping | $500 | $1,500+ | Product-dependent |
| LinkedIn | $1,000 | $3,000+ | High CPCs ($5-12); significance requires volume |
| TikTok | $300 | $1,000+ | Algorithm needs 50+ conversions/week |
| YouTube | $500 | $1,500+ | Brand recall lift requires impressions |

### Three Budget Scenarios

**Scenario 1: Conservative**
- 1-2 platforms (highest-intent)
- 60% BOFU, 25% MOFU, 15% TOFU
- No retargeting until month 2
- Manual bidding / lowest cost
- 2-3 ad variations per ad set
- Recommend when: new advertiser, unproven offer, no pixel data, tight margins

**Scenario 2: Balanced (Recommended default)**
- 2-3 platforms
- 30% TOFU, 35% MOFU, 25% BOFU, 10% retargeting
- Automated bidding after 2 weeks of data
- 3-5 ad variations per ad set
- Creative refresh every 2-3 weeks
- Recommend when: moderate budget ($2K-$5K/mo), proven offer, has pixel data

**Scenario 3: Aggressive**
- 3+ platforms
- 35% TOFU, 30% MOFU, 20% BOFU, 15% retargeting
- Advantage+ / Performance Max
- 5-10 ad variations per ad set
- Weekly creative refresh; scale winners +20-30% every 3 days
- Recommend when: proven funnel, strong margins, $5K+/mo, 50+ conv/mo pixel data

### ROI Projection Formula

```
Monthly Budget ÷ Avg CPC = Estimated Clicks
Estimated Clicks × Landing Page Conversion Rate = Estimated Conversions
Estimated Conversions × AOV = Estimated Revenue
Estimated Revenue ÷ Monthly Budget = ROAS
Estimated Revenue − Monthly Budget = Net Return
```

### Projection Table Template

| Metric | Conservative | Balanced | Aggressive |
|---|---|---|---|
| Monthly Budget | $[X] | $[X] | $[X] |
| Platform Split | [platforms] | [platforms] | [platforms] |
| Avg Blended CPC | $[X] | $[X] | $[X] |
| Est. Monthly Clicks | [X] | [X] | [X] |
| Avg Conversion Rate | [X]% | [X]% | [X]% |
| Est. Monthly Conversions | [X] | [X] | [X] |
| CPA | $[X] | $[X] | $[X] |
| AOV / Deal Size | $[X] | $[X] | $[X] |
| Est. Monthly Revenue | $[X] | $[X] | $[X] |
| ROAS | [X]× | [X]× | [X]× |
| Net Return | $[X] | $[X] | $[X] |
| Break-Even CPA | $[X] | $[X] | $[X] |

### Break-Even Analysis
```
Break-Even CPA = AOV × Profit Margin %            (single purchase)
Break-Even CPA = LTV × Profit Margin %            (recurring revenue)

Example: AOV = $100, Profit Margin = 40%
  → Break-Even CPA = $40
Example: LTV = $400, Profit Margin = 40%
  → Break-Even CPA = $160
```

### Scaling Roadmap

**Tier 1: $1,000/month — Proving Ground**
- 1 platform only, 2-3 campaigns, 3-4 ad variations
- Daily $33, success = profitable CPA for 2 weeks
- Milestone to scale: CPA below break-even for 2 consecutive weeks

**Tier 2: $3,000/month — Growth**
- 2 platforms, 5-7 campaigns, activate retargeting
- Daily $100, maintain CPA while 2×-3× volume
- Milestone: CPA within 20% of Tier 1 while 2× conversions

**Tier 3: $5,000/month — Acceleration**
- 2-3 platforms, 8-12 campaigns, 10-15% creative testing budget
- Daily $167, retargeting = 15% of budget
- Creative refresh every 2 weeks; each platform independently profitable

**Tier 4: $10,000/month — Scale**
- 3-4 platforms (including TikTok, Pinterest, Snapchat)
- 15-25 campaigns, 25-40 ad variations, weekly creative refresh
- Advantage+ / PMax automation, team (media buyer + designer)
- Success: blended ROAS >3×, systematized creative pipeline

### Budget Optimization Rules

**Increase when:** ROAS > target for 7+ consecutive days, CPA 30%+ below break-even, frequency <2.0, weekly conversion growth. How much: 20-30% every 3-5 days.

**Decrease when:** CPA above break-even 5+ days, ROAS <1×, frequency >4.0, CTR drop of 30%+. How much: cut 30-50%, pause worst ad sets.

**Pause when:** CPA ≥2× break-even for 3+ days, zero conversions in 5+ days, CTR <0.5% (Meta) or <1% (Google Search), LP CVR <1%.

**Reallocate when:** one platform beats another by 2×+ ROAS → shift 20% of loser budget to winner. Re-evaluate monthly.

### Allocation Output Template

```markdown
# Ad Budget Allocation Plan

**Generated:** [Date]
**Monthly Budget:** $[Amount]
**Business Type:** [Type]
**AOV / LTV / Break-Even CPA:** $[X] / $[X] / $[X]

## Executive Summary
[2-3 sentences: approach, expected ROI range, primary platform focus]

## Recommended Platform Mix
| Platform | Allocation | Monthly | Daily | Why |

## Scenario 1: Conservative / 2: Balanced (Recommended) / 3: Aggressive
[Allocation, ROI projection table, risk assessment, requirements]

## Break-Even Analysis
[Break-even CPA + payback period + LTV analysis]

## Scaling Roadmap
[Current → Next milestone → Growth target]

## Budget Optimization Calendar
[Week 1-2 Launch, Week 3-4 Optimize, Month 2 Scale, Month 3 Expand]

## Key Assumptions & Disclaimers
```

---

## Rules

1. ALWAYS ask for or estimate AOV/LTV — without this, ROI projections are meaningless
2. ALWAYS present all 3 scenarios in allocation mode — let the user choose risk tolerance
3. ALWAYS calculate break-even CPA — this is the single most important number
4. ALWAYS use industry-specific benchmarks, not generic averages
5. ALWAYS include a scaling roadmap — users need to know where to go next
6. ALWAYS include daily budget numbers, not just monthly — media buyers work in daily budgets
7. NEVER recommend LinkedIn if monthly budget <$1,000 — CPCs make it unviable
8. NEVER recommend >2 platforms if budget <$2,000 — spread too thin
9. NEVER project ROAS without stating assumptions — note that projections are estimates
10. NEVER ignore minimum viable budget thresholds — some platforms need minimum spend to optimize
11. ALWAYS flag when a budget is too low for a platform ("$300/mo on LinkedIn will not generate meaningful data")
12. In audit mode, validate data completeness (≥14 days, ≥20 clicks or ≥$100 spend) before kill recommendations
13. In audit mode, apply the 3× Kill Rule and the 20% Scaling Rule strictly
