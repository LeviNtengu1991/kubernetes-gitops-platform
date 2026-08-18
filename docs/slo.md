# Service-level objective

This lab uses an illustrative availability SLO of 99.5% over a rolling 30-day window.

- SLI: successful blackbox probes divided by all probes.
- Good event: `probe_success == 1`.
- Objective: `availability >= 0.995`.
- Error budget: approximately 3 hours 36 minutes per 30 days.

This is a learning target. It must not be presented as measured production performance unless real historical metrics are collected and retained.
