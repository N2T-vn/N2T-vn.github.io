---
title : "CloudWatch and SNS"
date : 2026-06-01
weight : 8
chapter : false
pre : " <b> 5.8. </b> "
---

#### Overview

Observability across every service in the final architecture - EC2, RDS, and
the Application Load Balancer - built entirely from default, free metrics,
plus alarms proven to actually notify someone rather than sit untested in the
OK state. This section itself adds nothing to the bill: EC2 Detailed
Monitoring and CloudWatch Logs Insights beyond the free monthly allowance are
both deliberately left off - the real cost of this architecture comes from
the load balancer, the NAT gateways, and Multi-AZ RDS (see [Cost and
Resource Management](/5-Workshop/5.10-Cost/)), not from monitoring it.
Application-level logging (shipping `pm2`'s own logs into CloudWatch Logs) is
scoped out of this project entirely, rather than half-built - the dashboard
and alarms below are built only from metrics AWS already collects for free on
every EC2 instance, RDS instance, and load balancer, with nothing for the
application itself to ship or configure.

#### Content

- [Build the Dashboard](5.8.1-dashboard/)
- [Alarms and Notifications](5.8.2-alarms/)

