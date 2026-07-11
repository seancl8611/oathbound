---
id: CONTENT-AREA3-HOLLOW-VESSEL
title: Hollow Vessel
category: content
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - area-3
  - hollow-vessel
  - spawner
  - spillborn
  - source-priority
related:
  - CONTENT-AREA3-ENEMIES
  - GAMEPLAY-COMBAT
  - ART-MILESTONE-06
---

# Hollow Vessel

## Gameplay role

Area 3 stationary spawner and source-priority objective enemy. It continuously produces weak expendable Spillborn from leaking Beast Blood, forcing the player to decide when to push through surrounding pressure and destroy the source.

## One-sentence fantasy

A cracked ceremonial urn of the inner court, still performing a sacred function in ruined form by birthing malformed blood-servants from the corruption it can no longer contain.

## Lore context

Hollow Vessels were once part of the court’s Binding rites — ceremonial containers used to hold, sanctify, or regulate Beast Blood within tightly controlled ritual practice. In Kagutsuchi Court, where nothing has been allowed to age, end, or fall properly into ruin, these vessels did not simply break and become inert relics. Their containment failed, but their ritual purpose persisted in corrupted form. Now they leak Beast Blood continuously into the immaculate court floor, and from that pooling corruption malformed Hollows crawl into existence: mindless, disposable fragments of ritual failure still being produced by a court system that no longer understands what it is making.

## Visual identity

A large cracked ceremonial urn with refined court patterns, lacquered or stone-like ritual craftsmanship, gold trim, and a dim internal blood glow. It should feel like a beautiful sacred object first, but visibly breached by corruption: dark red seepage trailing down its body, blood pooling at its base, and small weak humanoid forms dragging themselves out of the spill. The vessel itself remains upright and ceremonially composed, which makes the corruption more disturbing. The contrast should be strong: elegant ritual container above, messy birthed blood-life below.

## Silhouette

Broad, upright, and highly readable. The main silhouette is a large central urn or ritual jar with a stable ceremonial shape, slightly flared lip, and decorative profile. Secondary silhouette reads come from the pooling corruption and the crawling Spillborn emerging around the base. The Vessel itself should remain visually simple and iconic so the player immediately understands it as a stationary source object rather than a roaming enemy.

## Weapon / attack language

Its main attack is spawning. The Hollow Vessel creates pressure indirectly by birthing expendable Spillborn over time, turning the encounter into a source-management problem. It may also leak spreading pools of corruption around itself or periodically surge blood at close range, but its core function is continuous enemy generation. The threat pattern should feel cumulative: the longer the Vessel remains active, the more cluttered and dangerous the encounter becomes.

## Corruption details

The Hollow Vessel represents ritual containment turned reproductive corruption. Beast Blood is no longer held in sacred restraint; it has become a leaking generative force. Corruption should show in the blood seepage cracking through the vessel body, the inner red glow, and the malformed half-born Spillborn crawling from the pooled mass below. The Vessel itself should not become too organic. It must remain a ceremonial object corrupted from within rather than reading as a generic flesh nest.

## Personality in motion

The Vessel should feel mostly still and imposing, more like a ritual object continuing a process than a creature trying to fight. Its life comes through subtle internal pulse, faint tremor, seepage movement, and the emergence of Spillborn from the pool beneath it. Motion should feel slow, inevitable, and process-like rather than reactive.

## Combat read

The player should quickly understand that the Hollow Vessel is not dangerous because it moves or duels directly, but because leaving it alive keeps adding pressure to the room. Spawned Spillborn should be visibly weak while the Vessel reads as the real problem: stationary spawner, ignore at your own risk, kill the source before the room fills.

## Required animations

Idle, spawn_pulse, hurt, death

## Technical notes

The Hollow Vessel is a hybrid between an environmental hazard and a combat unit. Spawn ownership must be obvious: blood pulsing, pooling animation, and visible crawl-out beats should connect each Spillborn to its source. Production needs may include idle pulse, leak or seep loop, spawn windup, spawn release, hurt, progressive crack-damage states, and destruction collapse or burst. The blood pool and spawned units require strong contrast against the elegant court floor.
