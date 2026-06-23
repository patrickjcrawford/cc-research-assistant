# Domain Profile

## Field

**Primary:** Economic History & Political Economy
**Adjacent subfields:** American Economic History, European Economic History, Comparative / International Economic History, Historical Political Economy
**Time periods:** Medieval, Early Modern, time-period-agnostic (methods and data drive period selection)
**Theory orientation:** Mostly empirical with theory motivation — brief model to motivate empirics, not formally proved

---

## Target Journals (ranked by tier)

<!-- Updated in Session 5 of the systematic rules review -->

| Tier | Journals |
|------|----------|
| Top-5 | AER, QJE, JPE, Econometrica, REStud |
| Top field | JEH (Journal of Economic History), EHR (Economic History Review), Explorations in Economic History, JHPE (Journal of Historical Political Economy) |
| Strong field | AEJ:Applied, AEJ:EP, JEEA, JDE |
| Specialty | European Review of Economic History, Cliometrica |

---

## Common Data Sources

| Dataset | Type | Access | Notes |
|---------|------|--------|-------|
| Historical government archives | admin/text | public (digitized) | Core source; survival bias and measurement error are standard threats |
| Digitized legislative / parliamentary records | admin/text | public | Roll-call votes, committee records, Hansard, national assembly data |
| Geographic / GIS data | spatial | public | Historical boundaries, terrain, distance measures; used for instruments and RD designs |
| IPUMS (Census, CPS, International) | survey/admin | public | When project spans into modern period or requires demographic benchmarks |

---

## Common Identification Strategies

| Strategy | Typical Application | Key Assumption to Defend |
|----------|-------------------|------------------------|
| Difference-in-Differences | Policy/institutional change across units; staggered adoption common | Parallel trends; rule out contemporaneous confounders |
| Staggered DiD | Units adopt treatment at different times across long historical panels | Heterogeneity-robust estimator (Callaway-Sant'Anna or Sun-Abraham); pre-trend event study |
| Instrumental Variables | Geography, historical accidents, or colonial/institutional origins as instruments | Exclusion restriction — instrument affects outcome only through treatment |
| Regression Discontinuity | Geographic RD, electoral thresholds, administrative cutoffs | Continuity of potential outcomes at the threshold; no sorting |
| Synthetic Control | Single or small-N treatment units (cities, countries); comparative case studies | No interference; donor pool validity |
| Novel / project-appropriate | Use the strictly appropriate strategy for the data, including methods not listed here | Whatever the design demands |

**Clustering:** Varies by paper — match the level of treatment variation. Always justify the clustering choice explicitly.

---

## Field Conventions

- Persistence papers must discuss the transmission mechanism — showing long-run effects is not sufficient; the channel must be identified or bounded
- Papers using archival / digitized data must address survival bias and measurement error explicitly (either in the text or a robustness section)
- Geographic instruments require a dedicated exclusion restriction discussion — reviewers expect it
- SUTVA / spillover violations are common at geographic borders — always check for and report spatial autocorrelation
- External validity: comparative and cross-country designs must explicitly scope their claims; single-country studies need a "why here, why now" paragraph
- Pre-trend event studies are expected for any DiD design, even when not strictly required by the estimator
- Robustness section should include: alternative control groups, placebo outcomes, measurement error bounds (Oster 2019 or Manski bounds where appropriate)
- No causal language in purely descriptive papers

---

## Notation Conventions

| Symbol | Meaning | Anti-pattern |
|--------|---------|-------------|
| $Y_{it}$ | Outcome for unit $i$ at time $t$ (subscript named to unit type: $c$ for country, $s$ for state, $d$ for district, etc.) | Don't use $y$ without subscripts |
| $D_{it}$ | Treatment indicator (binary) or treatment intensity | Don't use $T$ (conflicts with time) |
| $Z_{it}$ | Instrument | Don't reuse $Z$ for controls |
| $X_{it}$ | Covariate vector / controls | Standard |
| $\alpha_i$ | Unit fixed effect | Don't use $\mu_i$ (conflicts with mean notation) |
| $\lambda_t$ | Time fixed effect | Standard |
| $\varepsilon_{it}$ | Error term | Use $\varepsilon$, not $e$ or $u$ |
| $\beta$ | Main treatment coefficient of interest | Always the estimand of interest — bold or starred if significant |

**Framework:** Mix of potential outcomes ($Y_i(1), Y_i(0)$, ATT, ATE) for causal claims and regression notation for estimation sections. Switch is context-driven; be consistent within a section.

---

## Seminal References

| Paper | Why It Matters |
|-------|---------------|
| North (1990) | *Institutions, Institutional Change and Economic Performance* — baseline definition of institutions; nearly all papers in this field position relative to it |
| North & Weingast (1989) | "Constitutions and Commitment," *JPE* — credible commitment mechanism; canonical model for political institutions → economic outcomes |
| Acemoglu, Johnson & Robinson (2001) | "The Colonial Origins of Comparative Development," *AER* — gold standard historical IV; defines the institutions → growth research agenda |
| Engerman & Sokoloff (2002) | "Factor Endowments, Inequality, and Paths of Development" — path dependence and comparative economic history across long time horizons |
| Dell (2010) | "The Persistent Effects of Peru's Mining Mita," *Econometrica* — canonical geographic RD with historical data |
| Voigtländer & Voth (2012) | "Persecution Perpetuated," *QJE* — benchmark for persistence studies using digitized archival data across very long time horizons |
| Callaway & Sant'Anna (2021) | "Difference-in-Differences with Multiple Time Periods," *JoE* — required citation for staggered DiD |
| Sun & Abraham (2021) | "Estimating Dynamic Treatment Effects in Event Studies," *JoE* — paired with Callaway-Sant'Anna; event-study heterogeneity |
| Abadie, Diamond & Hainmueller (2010) | "Synthetic Control Methods," *JASA* — primary reference for synthetic control |
| Nunn (2009) | "The Importance of History for Economic Development," *Annual Review* — methodological overview of historical instruments and persistence designs; the methods handbook for the field |

---

## Theoretical Foundational References

<!-- Only populated when a paper has a formal theory section. Leave blank to fall back to theorist agent defaults. -->

| Topic | Anchor references |
|-------|------------------|
| DiD with staggered adoption | Callaway & Sant'Anna (2021); Sun & Abraham (2021) |
| Synthetic control | Abadie, Diamond & Hainmueller (2010); Abadie (2021) |
| Persistence and path dependence | Nunn (2009); Dell (2010) |

---

## Paper Author Team

<!-- Fill in per-project when authors are foundational on a topic covered in the paper. -->

| Author | Foundational on |
|--------|----------------|
| (fill in per project) | — |

---

## Field-Specific Referee Concerns

**Identification**
- Parallel trends not credible given historical context — always show pre-trend event study and discuss why trends would have been parallel absent treatment
- Exclusion restriction for historical/geographic instruments — referees expect an explicit, substantive defense, not just an assertion
- Contemporaneous confounders — "something else happened at the same time"; rule out alternative explanations in a robustness section

**Data & Measurement**
- Selection into historical records (survival bias) — non-random survival of entities, documents, or observations; address explicitly
- Measurement error in archival/digitized data — attenuation bias concerns; use test-retest, cross-source validation, or bounds where possible
- Geographic spillovers / SUTVA violations — treatment in one unit contaminating controls; especially acute at geographic borders

**Scope & Validity**
- External validity / generalizability — "this is one country/period; why should we believe it generalizes?"; scope claims explicitly
- Persistence mechanisms not pinned down — showing long-run effects is insufficient; channels must be identified, bounded, or ruled out

---

## Quality Tolerance Thresholds

<!-- Default template thresholds — kept as-is -->

| Gate | Score | Applies To |
|------|-------|------------|
| Commit | ≥ 80 | Weighted aggregate |
| PR | ≥ 90 | Weighted aggregate |
| Submission | ≥ 95 | Aggregate + all components ≥ 80 |

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Point estimates | 1e-6 | Numerical precision |
| Standard errors | 1e-4 | MC variability |
| Coverage rates | ± 0.01 | Simulation with B reps |
