---
title: "Event 1"
date: 2026-06-01
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

# Summary Report: Cloud Architect Quiz Night

### Event Objectives

- Turn certification-style knowledge — Cloud Practitioner, Solutions Architect
  Associate, and Solutions Architect Professional — into a live, competitive
  format instead of a solo mock exam
- Test both breadth (service purpose, pricing basics) and depth (multi-account
  design trade-offs) within the same match
- Give interns outside the immediate cohort a reason to team up and revise
  together under mild time pressure
- Keep the tone closer to a game show than a written test, without lowering the
  bar on the underlying content

### Format

- **Teams:** 8 teams of exactly 5 interns each, formed freely across cohorts —
  a team did not have to come from the same internship group, and no one could
  be registered on more than one team. Seasoned working professionals were
  explicitly excluded from recruitment, to keep the contest between learners.
- **Structure:** two teams face off per match, answering question sets that
  escalate in difficulty. The higher-scoring team advances; a tie at the end of
  the set is broken by a single sudden-death question — question 11 — answered
  under a strict buzzer, where speed decides the match.
- **Subject matter:** all questions are drawn from the same territory as AWS
  certification exams, ordered roughly Practitioner → Solutions Architect
  Associate → Solutions Architect Professional, so a match gets harder as it
  goes rather than staying flat.
- **Two one-time skills per team:**
  - **Safety Net** (*Rủi ro tối thiểu*) — played on a question the team is
    unsure of. A wrong answer costs nothing; a correct answer is only worth
    half points.
  - **Hope Star** (*Ngôi sao hi vọng*) — played on the question the team is
    most confident about. A correct answer scores double; a wrong answer is
    penalised double.
- **Selection:** because slots were limited, teams were admitted by random
  draw from the sign-ups rather than first-come-first-served, with results
  announced on 19 June 2026. Admission came with a firm commitment to show up
  — no partial attendance once a team was drawn in.

---

### Key Highlights

#### Round 1 — Practitioner warm-up

The opening set stayed close to Cloud Practitioner territory: what a service is
for, how AWS bills for it, and which piece of the shared responsibility model
belongs to whom. Typical questions in this band:

- *Which AWS service lets an organisation centrally manage billing and apply
  policies across many accounts without giving up account-level autonomy?*
- *Which purchasing option gives the largest discount on compute capacity that
  the workload can afford to lose on short notice?*
- *Under the shared responsibility model, who patches the guest operating
  system on an EC2 instance?*

This round was fast and mostly about recall rather than reasoning, and the gap
between teams was small — everyone had clearly done the reading. Our team
opened cautiously, using **Safety Net** on a question about the exact free-tier
limits for a service none of us used day to day, which turned out to be the
right call: the answer was wrong, and the skill meant it cost us nothing.

#### Round 2 — Solutions Architect Associate

The difficulty stepped up from "what does this do" to "which combination of
services satisfies this constraint." This is where the match actually started
to separate the teams:

- *A workload must keep serving traffic through the loss of an entire
  Availability Zone, with the least operational effort. Which combination of
  services satisfies this most directly?*
- *An application reads the same handful of records far more often than it
  writes them, and read latency is the primary complaint. Where does a cache
  belong in this design, and which failure mode does it introduce?*
- *A company needs object storage that automatically moves infrequently
  accessed data to a cheaper tier without anyone having to decide when.*

This was the round where the format's design showed its purpose: it rewards
understanding a trade-off, not memorising a service name. We played **Hope
Star** on the Multi-AZ question, confident because it maps almost exactly onto
a decision I had already made and wrote up for my own project — and it paid
off, doubling our score for that question.

#### Round 3 — Solutions Architect Professional, and the tie-break

The final set moved into genuinely professional-level territory: multi-account
governance, migration sequencing, and hybrid connectivity, where there is
rarely one clean answer and the question is which trade-off the organisation
can live with.

- *An organisation runs 20 AWS accounts under AWS Organizations and wants
  centrally enforced, non-negotiable guardrails while still letting account
  owners manage their own non-critical resources. What is the most appropriate
  mechanism?*
- *A company is migrating a large on-premises database to AWS with a
  cutover window measured in minutes, not hours. Which service pattern
  minimises that window?*
- *Two VPCs in different accounts need private connectivity without
  overlapping CIDR ranges becoming a long-term constraint on growth.*

Neither team had a clean lead going into the last question of the set, which
meant the match came down to question 11 — sudden death, first correct buzzer
wins. The question concerned Service Control Policies versus Identity and
Access Management policies, and the trade-off between blast radius and
flexibility. We buzzed first and got it right, which settled the match; the
margin the whole night came down to seconds rather than points.

---

### Key Takeaways

**Certification knowledge and design judgement are not the same skill, and the
format made that visible.** Round 1 rewarded recall; round 3 rewarded weighing
trade-offs with no perfect option. Teams that were fast in round 1 were not
automatically the ones ahead by round 3.

**A wager mechanic surfaces what a team actually believes, not just what it
knows.** Deciding when to play Safety Net versus Hope Star forced an honest
conversation, out loud and under a clock, about which answers we were guessing
at and which ones we would defend. That conversation was more useful than
either individual answer.

**Under time pressure, the team that agrees on an answer fastest wins, not
necessarily the team that is most correct in isolation.** The sudden-death
round rewarded consensus speed as much as knowledge, which is a different skill
from either.

---

### Applying to Work

The Multi-AZ question in round 2 mapped directly onto a decision already made
for Caerus: accepting a single EC2 instance in a single Availability Zone as a
documented trade-off, rather than pretending high availability was out of
scope. Hearing the same design question asked cold, without my own project's
context attached, was a useful check that the reasoning behind that decision
holds up on its own.

The SCP-versus-IAM-policy question in the tie-break is directly relevant to
how Caerus separates the booking application's permissions from anything an
operator could touch manually — a guardrail enforced at the account level
should not depend on the application behaving correctly, the same principle
the question was testing.

The habit of stating a confidence level before answering — which the Safety
Net and Hope Star mechanics forced onto the surface — is one I now apply when
reviewing my own architecture decisions: naming the two or three points I am
least sure about, rather than presenting the whole design with uniform
confidence.

<!-- Add photos to static/images/4-EventParticipated/4.1-Event1/ and reference them here, e.g.

-->
#### Event photo

![](/images/4-EventParticipated/event1.jpg)
