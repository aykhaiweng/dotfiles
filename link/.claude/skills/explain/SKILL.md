---
name: explain
description: "Explain a topic in depth (a technology, design choice, library, pattern, change, policy or decision), covering what it is, the major changes it brings, its pros, cons, consequences and other effects, what a Product Owner, Solutions Architect and Senior Engineer each need from it, a recommendation and a glossary. Several items are explained one section each, with one shared glossary, and each option of an item gets its own pros, cons, consequences and other effects. Use when the user invokes /explain, or asks to explain X, for the tradeoffs of X, what changes if we adopt X, or the consequences of X. Do not use it for a quick factual lookup or a one-line definition; answer those directly."
argument-hint: "<topic>"
---

# Explain

Explain `$ARGUMENTS` well enough that the reader could make a decision about
it.

## Before writing

- No topic, or more than one reasonable reading: ask one question and stop.
- Ground it rather than explaining from memory. If it's in the workspace (a
  file, diff, PR or ADR), read it. For a library or service, fetch current docs.
  For recent or version-specific facts, search the web. Mark anything
  unverified.

## Structure

One topic gets the sections below once. Several separate items (a list of
decisions, options or changes) get them once per item. Give each item a `##`
heading numbered from 1 and named after it, with the title wrapped in `__` so
it is underlined, and a row of 78 `═` on the line above it, after a blank line:

```
══════════════════════════════════════════════════════════════════════════════
## 1. __Accepting ADR 0141__
```

Sections 1 to 9 go under it as `###` headings, so each item stands on its own.
Never merge items into shared Pros, Cons, By role or Recommendation sections.

The **Glossary** is its own `## Glossary` section at the very top of the
answer, before the first item (or before the TL;DR of a single topic). It comes
once and covers everything below it. Write it last, so it lists the terms the
answer really uses, and print it first.

Use these nine sections, in this order. If one genuinely doesn't apply, keep the
heading and say why in one line. Don't pad.

When an item has more than one way to go, leaving things as they are included,
name each option with a letter. Replace sections 4 to 7 with one `### Options`
section holding a `#### Option A: <name>` block per option, each with its own
Pros, Cons, Consequences and Other effects, and add "(recommended)" to the
heading of the option you would pick. Give each option its own column in the
Major changes table. Sections 8 and 9 refer to options by letter.

1. **TL;DR**: two or three sentences, covering what it is and the main tradeoff.
2. **What it is**: plain words first, then the technical detail and how it
   works, with at least one diagram (see "Diagrams").
3. **Major changes**: what's different compared with the status quo (when
   adopting something) or the previous version (for a release). Use a
   before/after table, and flag breaking changes.
4. **Pros**: who benefits, and under what conditions.
5. **Cons**: held to the same standard. Include easy-to-miss costs such as
   learning curve, lock-in and migration effort.
6. **Consequences**: what follows, in the short and long term, and how hard it
   is to reverse.
7. **Other effects**: only the axes that matter, such as security, performance,
   cost, operations or team process.
8. **By role**: what each of these three readers needs in order to act. Give
   each its own short list, specific to this topic, and add what the sections
   above don't already say instead of repeating them. End each list with the
   decision or action that falls to that role.
   - **Product Owner**: what users see and lose, the value against the cost and
     time, the risk to users or the business, and what it does to scope.
   - **Solutions Architect**: system boundaries and integrations, how data
     moves, constraints and non-functional requirements (security, scale,
     availability, compliance), lock-in, and how it fits the wider design.
   - **Senior Engineer**: the code and files involved, failure modes and edge
     cases, how to test and verify it, migration and rollback, and what it
     costs to run and maintain.
9. **Recommendation**: what you would do and why, in a sentence or two. If the
   evidence doesn't favour one choice, say so and name what would settle it.

The Glossary holds every term in the answer that one of those three readers
might not know, including acronyms and project-specific names. Each entry is
one line in plain words, says what the term means here when that differs from
the general meaning, and comes in alphabetical order. Merge synonyms into one
entry.

## Diagrams

Always draw at least one per item, whatever the topic. Pick the shape that shows the
mechanism: boxes and arrows for what talks to what and what flows between
them, a sequence for a request or a process step by step, a before/after pair
for a change, a tree for a hierarchy. When the reader must choose between
options, draw each option so they can compare them.

- Plain text in a fenced `text` block (box-drawing characters or ASCII), since
  the answer is read in a terminal, where Mermaid shows as raw code.
- Label boxes with real names: file paths, components, routes, tables.
- Keep each one under about 80 columns and 25 lines; split rather than cram.
- One sentence under it says what to notice.

Add **Alternatives** or **Open questions** only when they would change the
reader's decision, inside the item they belong to. List the sources you
consulted once, at the very end.

Answer in the terminal. If the user names a focus, go deeper there.
