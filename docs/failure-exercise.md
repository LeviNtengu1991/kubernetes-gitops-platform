# Controlled failure exercise

Run only in the disposable local lab.

1. Record the starting Git SHA and verify both pods are ready.
2. Change the readiness probe path in `workload.yaml` from `/` to `/not-found`.
3. Confirm `make observability` has completed, commit the change on an exercise branch, and let Argo CD reconcile it.
4. Observe pod readiness, service endpoints, events, and probe alerts.
5. Investigate using the endpoint-unavailable runbook.
6. Revert the change and confirm recovery.
7. Record actual timestamps and findings in a dated document under `docs/exercises/`.

Do not add invented timestamps, screenshots, or recovery metrics. Evidence should come from an exercise you personally ran.

## Evidence status

**Not yet executed by Levi.** Replace this line only after personally running the exercise and recording real evidence under `docs/exercises/`.
