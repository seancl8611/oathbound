---
id: META-DOCUMENT-TEMPLATES
title: Document Templates
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Document Templates

## Standard front matter

```yaml
---
id: CATEGORY-STABLE-ID
title: Human-Readable Title
category: lore | gameplay | character | content | art-production | ui-ux | overview
status: locked | approved | draft | under-review | deferred | deprecated | cut
authority: primary | summary
last_reviewed: YYYY-MM-DD
topics:
  - concise-searchable-topic
related:
  - OTHER-DOCUMENT-ID
---
```

Use stable uppercase IDs. Do not change an ID merely because a file is renamed.

`topics` and `related` are optional. Add them only when they improve discovery for recurring concepts or meaningful cross-system relationships. They are search hints, not a complete dependency declaration.

Keep topic labels short, lowercase, and reusable, such as:

- `returning-blood`
- `corruption`
- `shrine`
- `area-1`
- `keeper-of-the-gate`

Do not add large metadata blocks that merely restate the document body.

## Enemy entry

```md
## Enemy Name

**Role:**
**Region:**
**Status:**

### Fantasy

### Combat purpose

### Core actions and response rules

### Readability requirements

### Art/VFX dependencies

### Open questions
```

## Boss entry

```md
# Boss Name

## Narrative identity
## Encounter purpose
## Phase structure
## Core actions and response rules
## Arena requirements
## UI/VFX dependencies
## Completion conditions
## Open questions
```

## Gameplay system

```md
# System Name

## Purpose
## Player inputs and outputs
## Rules
## States
## Dependencies
## UI requirements
## Persistence/reset behavior
## Balance variables
## Open questions
```

## Art milestone

```md
# Milestone N — Name

## Goal
## Dependencies inherited
## Included scope
## Explicitly deferred
## Internal batches
## Review gates
## Completion test
## Contractor-export status
```
