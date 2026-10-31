---
name: explain
description: "Explain a topic in depth (a technology, design choice, library, pattern, change, policy or decision), covering what it is, the major changes it brings, its pros, cons, consequences and other effects. Use when the user invokes /explain, or asks to explain X, for the tradeoffs of X, what changes if we adopt X, or the consequences of X. Do not use it for a quick factual lookup or a one-line definition; answer those directly."
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

Use these sections, in this order. If one genuinely doesn't apply, keep the
heading and say why in one line. Don't pad.

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

## Diagrams

Always draw at least one, whatever the topic. Pick the shape that shows the
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
reader's decision. List the sources you consulted at the end.

Answer in the terminal. If the user names a focus, go deeper there.
