---
title: "Event 2"
date: 2026-06-01
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Summary Report: FCAJ Agentic AI Build Week — Community Day

### Event Objectives

- Give the four hackathon teams a stage to walk through what they actually
  shipped during Agentic AI Build Week, architecture diagrams included
- Show, with real slide decks rather than a summary, how an agentic system is
  assembled from ordinary AWS building blocks
- Be honest about a 24-hour build cycle: the sleep deprivation and the
  pushed-a-secret-file-to-GitHub moments alongside the working demo
- Give someone who has never sat a hackathon a concrete sense of what the
  format actually demands

### Presenting Teams

- **Plan V** — *Solution Architect Professional Native App*
  (Pham Tien Thuan Phat, Huynh Hoang Long, Le Minh Nghia, Tran Dai Vi, Nguyen An)
- **Signal Scout** — *Corporate restructuring-signal detection platform*
  (Le Tan Luc, Do Hoang Hieu, Trieu Quoc Hao, Nguyen Van Duy Khiem, Nguyen Cong Minh, Nguyen Tran Minh Quan)
- **One Team** — *KFC Bot Agent*, winner of the AABW Hackathon
  (Anh Duy, Tran Dong, Doan Trung, Minh Viet, Anshul Roy)
- **3KA** — *S.H.E.P.H.E.R.D* and the hackathon journey
  (Huynh An Khuong, Nguyen Quoc Huy, Ngo Quang Khoi, Hoang Le Thanh Duc, Dang Nguyen Phuoc Loc, Dang Truong Hung)

---

### Key Highlights

#### Plan V — Solution Architect Professional Native App

The team opened with a scene every consultant recognises: a customer asks for
an AI system design for their SOP documents, wants it by Thursday, then wants
it *immediately*. Behind that one-liner sits the actual workload a solution
architect has to carry — pulling requirements out of a conversation, sketching
a first architecture, drawing the diagram, and pricing the cloud spend, all
before the ink on the request is dry.

Their app takes each of those four jobs off the human's plate. It reads
natural-language input and structured project documents, drafts hybrid-cloud
architecture options that already respect the company's own standards, and
generates an editable diagram in Draw.io using the official AWS icon set. A
directional cost estimate for `ap-southeast-1` comes out alongside the
architecture rather than as an afterthought, and the tool is upfront about its
own assumptions and where the requirements still have gaps. None of this is a
one-shot generation — a chat sidebar with per-project custom instructions lets
the architect keep steering it.

Under the hood, an app server sits between the user and four backing services:
a knowledge base built from ingested internal documents and architecture
references, an Amazon Bedrock model for the reasoning itself, a Draw.io MCP
server for diagram generation, and an AWS Pricing MCP server for the cost
numbers — each one invoked as a tool rather than baked into a single prompt.

Their before/after framing was the slide I noted most carefully:

| Before | After |
|---|---|
| Read the BRD/PRD line by line, manually | Upload and chat naturally — a requirements catalogue in minutes |
| Start from a blank page every time | A grounded first draft to react to, not build from scratch |
| Write infrastructure as code by hand | Infrastructure as code generated automatically |
| Cost estimation by experience-dependent guesswork | A directional estimate produced alongside the architecture |

The choice of words mattered here: the output is a *draft to react to*, not a
finished deliverable. The tool is positioned as removing the blank page, not
the architect who still has to sign off on the design.

#### Signal Scout — catching corporate restructuring before it's announced

Signal Scout's target user is not a developer but a corporate strategy, risk,
competitive-intelligence, or B2B account team that needs early warning of a
counterparty's restructuring — before it becomes a press release.

The system is a genuine multi-agent pipeline rather than one model with a big
prompt. A **Crawler Subagent**, built on AgentCore Runtime with a Strands
Agent, gathers evidence from external sources through TinyFish and Apify. Its
output is handed via an agent-to-agent (A2A) call to an **Analysis Subagent** —
the same AgentCore Runtime and Strands Agent pattern, but with Bedrock
Guardrails applied on top — which turns raw evidence into scored signals and
scenarios. Short-term memory lives in AgentCore Memory, session state in
DynamoDB, and evidence artefacts in S3. The user-facing edge runs through
Route 53, Amplify, and API Gateway behind WAF and Cognito, with CloudWatch and
CloudTrail for observability and Secrets Manager plus IAM for everything that
needs a credential.

Their value proposition was stated with unusual discipline: transparent,
citable analysis, every conclusion backed by evidence, and — said explicitly,
twice — **human-controlled decision support**. The product surfaces a Maintain,
Adapt, or Accelerate read on a situation; it does not make that call itself.

The slide I went back to twice was the cost breakdown, because it didn't stop
at the AWS bill:

| | Min | Mid | Max |
|---|---|---|---|
| AWS services (Bedrock, AgentCore, WAF, Amplify, CloudWatch, etc.) | ≈ $17 | ≈ $35 | ≈ $130 |
| Apify / TinyFish (external crawling) | ~$35 | ~$30 | ~$200 |
| Langfuse (observability) | $0–29 | $29 | $29 |
| **Total** | **≈ $81** | **≈ $94** | **≈ $359** |

External crawling providers, not AWS, were the largest line item at every
usage level — which is exactly what pushed the team to design a second,
leaner architecture. In that revision, TinyFish and Apify are replaced by an
AgentCore Gateway invoking a WebSearch tool and a Browser tool directly, and
CloudFront/DynamoDB/Route 53 stay in place underneath. The cost slide didn't
just report a number; it changed the architecture on the next slide.

#### One Team — KFC Bot Agent (hackathon winner)

The winning team didn't open with their own idea — they opened with someone
else's failure. McDonald's shut down an AI drive-thru pilot after testing
automated ordering across more than a hundred US locations. Their read on why
was sharp: the takeaway wasn't "AI ordering doesn't work," it was that
**ordering is a systems problem** — an ordering agent has to track items,
quantities, variants, voucher rules, and cart state while natural language
stays messy, business rules stay strict, orders still need verification, and
a mistake turns into a real refund.

The moment they chose to attack was more specific than "ordering is hard": a
customer is mid-conversation, hunger creates intent right then, and the
existing flow forces them out of the chat entirely — switch app, create an
account, navigate a menu — by which point the momentum that started the order
is gone. Human agents alone don't scale evenly across channels, shifts, and
sudden traffic spikes.

KFC Bot Agent answers that by staying inside the conversation the customer is
already having, on Zalo today with Messenger and future channels by design: no
app switch, no new account, no re-explaining yourself, and less load pushed
onto human staff.

Their central claim is the one I keep returning to:

> **A chatbot replies. An agent acts.**

They broke the loop into five steps — Goal (understand the ordering intent),
Plan (work out what steps are required), Tools (query trusted business data),
Act (update the cart, apply the right promotion), Verify (check the result
against the real cart state) — and summed it up as *the model understands, the
tools decide what is real*. The language model is never trusted to hold the
order state itself; only the tool layer is.

The architecture behind the demo runs messages through WAF, API Gateway, and a
Lambda webhook handler into SQS, then into AgentCore Runtime for the reasoning
and tool-use loop, with session state in DynamoDB, a vector store in
OpenSearch, and product/order data split across S3, DynamoDB, ElastiCache, and
KMS-encrypted storage — with payment, loyalty, delivery, and SMS/email systems
sitting behind it as external integrations.

Four numbers from their closing slide are worth keeping:

| Metric | Value |
|---|---|
| Cost per order | $0.006 (500 orders/day) |
| Infra cost per month | $88 — Bedrock is ~75% of that |
| End-to-end latency | 3–5s, message sent to reply received |
| Infra code reduction | −60%, from letting AgentCore own the infra layer |

#### 3KA — S.H.E.P.H.E.R.D and the hackathon journey

Where the other three teams presented a product, 3KA presented an experience,
structured around four honest stages: signing up and picking a track, building
under pressure, demo day and judging, and what they'd tell their past selves.

The system itself, S.H.E.P.H.E.R.D — *Smart Human-flow Evaluation, Prediction,
Hazard Detection, Response, and Dispatch* — was originally scoped as their
Capstone project; they chose to prototype it during the 24-hour build week
instead, specifically to validate the idea against something closer to reality
before committing a full Capstone to it. It watches live camera footage to
detect and track people, measure crowd density, read queue conditions, catch
early signs of congestion, forecast overcrowding, and hand an operator a
proactive alert with a recommended action, built on YOLO and ByteTrack for
detection, an Amazon SageMaker endpoint for inference, Amazon Bedrock
AgentCore with a Strands Agent for the reasoning layer, and a React dashboard
for the humans watching it.

Two agent roles split the work: an **Autonomous Monitor** that watches metrics
continuously and raises alerts unprompted, and an **Operator Copilot** that
lets staff ask a plain-language question and get an answer grounded in live
metrics and prediction tools rather than a canned response.

What made this talk stand out was how little they polished the hard parts.
Their fears going in, read out loud, were exactly the ones anyone would
recognise: not skilled enough, too little time, fear of failing, clueless
where to even start. Their actual biggest obstacles by the end: no AI
background going in, first contact with AWS at all, a hard 24-hour ceiling,
code that flatly refused to run, and a level of sleep deprivation that became
its own running joke. The emotional shape of the day, in their own words, went
Doubt → Flow → Pride — overwhelmed, then the idea clicking into place, then
the surprise of having actually built the thing.

Their advice to a first-timer, stripped to four lines:

- **Just sign up** — don't wait to feel ready
- **Find a team early** — different skills beat matching ones
- **Scope it tiny** — one feature, done well, beats five done badly
- **Talk to everyone** — the mentors and other teams are half the reason to be there

---

### Key Takeaways

**An agent is defined by what its tools are allowed to touch, not by which
model sits behind it.** All four teams arrived at the same boundary from
different directions: the model interprets, the tools act and verify. One
Team's version — *the model understands, the tools decide what is real* — is
the cleanest statement of it, and it's a correctness argument dressed up as an
AI one.

**Cost estimation is a design input, not a report you write afterward.**
Signal Scout didn't just cost their architecture — the number sent them back
to redesign it, replacing the most expensive dependency before the hackathon
even ended.

**A draft you can push back on beats a blank page, every time.** Plan V's
whole pitch rests on that distinction, and it's a more honest description of
what these tools are for than most product marketing manages.

**Tight constraints produce better scope decisions than open-ended ambition
does.** "One feature, done well" is 3KA's line from a 24-hour build, but it
reads exactly the same at week three of a seven-week project.

---

### Applying to Work

The idea that transferred most directly was the tool-verification boundary.
In Caerus, the equivalent split is that the application layer *proposes* a
booking, but the database transaction — row locks, re-checked availability,
then commit — decides whether it actually happened. No amount of confidence in
the application code overrides what the transaction confirms. Watching four
unrelated teams land on the same separation independently made that choice
feel less like an idiosyncrasy of my own design and more like a pattern worth
trusting.

Signal Scout's cost table changed how I wrote the cost section of my own
report. Instead of a single claim that the project fits inside the Free Tier,
I broke it into line items and named which components would actually move the
bill if usage grew — which is also what makes an estimate useful to whoever
reads it next, rather than reassuring on its face and useless in practice.

Seeing `ap-southeast-1` in Plan V's cost estimate was a small, oddly
reassuring confirmation: the same region I picked for latency reasons turned
up independently in a team optimising for cost, for their own separate
reasons.

And 3KA's list of fears — not skilled enough, clueless, too little time — was
close enough to what I felt at the start of this internship that hearing a
team say it on stage, after having shipped something that worked, was
probably the single most useful thing to take from the whole day.

<!-- Add photos to static/images/4-EventParticipated/4.2-Event2/ and reference them here, e.g.

-->
#### Event photo
![](/images/4-EventParticipated/event2.jpg)
