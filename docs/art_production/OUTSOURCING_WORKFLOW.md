---
id: ART-OUTSOURCING-WORKFLOW
title: Outsourcing Workflow
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - outsourcing
  - style-test
  - review
  - revisions
  - delivery
related:
  - ART-TECHNICAL-STANDARDS
  - ART-MILESTONE-01
---

# Outsourcing Workflow

## Source model

Markdown files in this repository are the internal source of truth. Word and PDF briefs are contractor-facing exports. Exported documents may add commercial terms and signatures, but they must not silently redefine approved gameplay, lore, asset scope, or technical requirements.

## Paid Style Test gate

Milestone 1 does not begin until a separate paid Style Test is delivered and approved under its own short agreement.

The Style Test confirms:

- sprite scale,
- palette,
- detail density,
- top-down perspective fit,
- outline treatment,
- shadow treatment,
- Godot import quality,
- tonal match to Hushiro Gate Village.

After approval, the Style Test outputs are binding visual targets for the milestone. A later direction change is a change order rather than an ordinary revision.

A new artist joining after Milestone 1 should complete a paid style-matching test against approved production assets.

## Dependency order

1. Approve Style Test: scale, palette, perspective, pivots, shadow, and detail density.
2. Approve character or environment concept and silhouette.
3. Approve mechanic-defining key poses and state differences.
4. Produce full animation sheets or modular environment/UI elements.
5. Produce specialized VFX against approved poses and timing.
6. Build final arena and room composition around confirmed combat footprints.
7. Import into Godot and perform gameplay-scale review.

## Review stages

### Concept and key-pose gate

Required for minibosses, bosses, major NPCs, transformations, and designs with high downstream dependency. Mechanic-defining poses should be accepted before full animation production.

### Sheet-level review

Target review window: approximately 3–5 business days from delivery.

Review:

- sheets and frames,
- source files,
- timing notes,
- palette files,
- naming and folder structure,
- state separation,
- modular inventory,
- UI and environment mockups.

Approval at this stage is provisional until the in-engine review passes.

### In-engine review

Target review window: approximately 5–7 business days after sheet approval.

Test:

- normal gameplay camera scale,
- mixed encounters,
- attack windups and recovery,
- parry, posture, and deathblow states,
- hazards and VFX overlap,
- room transitions,
- UI contrast,
- boss phases,
- Godot import and pivot behavior.

An asset that looks correct on a sheet but fails at gameplay scale requires a readability correction before final approval.

## Revision baseline

Current contractor briefs assume:

- up to two sheet-level revision rounds per asset,
- one in-engine readability revision round,
- additional concept/key-pose rounds only when explicitly stated,
- new animations, variants, assets, and post-Style-Test direction changes handled through written change orders.

Revisions cannot silently expand the brief.

## Batch and commercial structure

- Quote, start, review, approve, and pay work per internal batch.
- Current template uses 30% at formal batch kickoff and 70% after final post-engine approval.
- Either party may pause or cancel between batches.
- A top-level milestone is a production goal, not an all-or-nothing delivery.
- If a batch is canceled after kickoff, payment and transfer of substantially completed work must follow the signed contractor agreement rather than assumptions in the internal repository.

Commercial numbers, payment method, currency, legal ownership language, portfolio embargoes, and signatures belong in the executed contractor brief or agreement, not in authoritative design files.

## Batch delivery checklist

Each batch should include, where applicable:

- final PNG sheets or element sheets,
- source files,
- frame timing notes,
- palette files,
- previews,
- correct folder and asset naming,
- confirmation that stated approval criteria were checked in engine.

## Approval rule

Final approval occurs only after:

- required files are delivered,
- sheet-level notes are resolved,
- in-engine readability passes,
- naming and import standards pass,
- the final batch payment condition in the executed agreement is satisfied.
