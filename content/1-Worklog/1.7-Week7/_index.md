---
title: "Week 7 Worklog"
date: 2026-06-01
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
reportType: "worklog"
---

### Week 7 Objectives: Caerus - Testing, Report, and Submission

* Prove the no-double-booking guarantee against the deployed system, not just assert it.
* Verify the documented edge cases against the real environment.
* Assemble and submit the final report.

### Tasks to be carried out this week:

| Time | Task | Reference Material |
| --- | --- | --- |
| 27/7 | - The concurrency test: two browser sessions, logged in as two different users, selecting the same seat on the same screening and submitting as close together as possible <br> - Confirmed one request received `201 Created` and the other a `409 SEAT_ALREADY_BOOKED` naming the contested seat, and that the seat map afterward showed the seat booked exactly once |  |
| 28/7 | - Edge-case testing against the deployed system: cancelling after showtime, cancelling an already-cancelled booking, booking more than six seats, an expired or malformed token, a non-admin calling an admin route, and downloading a ticket for a cancelled booking <br> - Recorded the actual observed status code and error code for each row against the specification, rather than leaving the table as a checklist |  |
| 29/7 | - Assembled the report structure and began writing, working from the frozen specification, the worklog, and the actual architecture as built <br> - Went back through every AWS console used across the project and captured the screenshots the report references |  |
| 30/7 | - **Published Blog 1** (AWS Budgets and Cost Anomaly Detection, from Week 2's self-study) and **Blog 3** (AWS Config and Conformance Packs, from Week 3's self-study) to the AWS Study Group community <br> - Finished writing the report content, including the cost section reflecting the architecture's real monthly run-rate rather than a Free Tier estimate that no longer applied | <https://www.facebook.com/groups/awsstudygroupfcj/permalink/2229088634522763/> |
| 31/7 | - Final review of the report and the deployed system together, correcting the few places where the two had drifted apart during the week's changes <br> - Recorded a demonstration video as a backup in case of a live failure during presentation <br> - **Milestone reached:** report submitted |  |

### Week 7 Achievements:

* Proved the project's central claim - a seat can never be sold twice - against the real deployed system, with both the successful and the rejected request captured as evidence.
* Verified every documented edge case against the deployed environment rather than trusting the specification alone.
* Published the remaining two blog posts of the internship, closing out the reading that began as self-study in Weeks 2 and 3.
* Submitted a report whose architecture, cost, and testing sections all describe the system exactly as it was actually built and run, not as it was originally planned seven weeks earlier.
