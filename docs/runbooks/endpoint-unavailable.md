# Runbook: platform demo unavailable

## Impact

The demo endpoint is failing synthetic HTTP probes.

## Investigate

1. Confirm the alert and note its start time.
2. Check `kubectl -n platform-lab get pods,deploy,svc,endpoints`.
3. Review recent Argo CD sync history and Git commits.
4. Inspect events with `kubectl -n platform-lab get events --sort-by=.lastTimestamp`.
5. Review logs with `kubectl -n platform-lab logs deployment/platform-demo --tail=100`.

## Mitigate

- Revert the responsible Git commit; allow Argo CD to reconcile.
- If necessary, use Argo CD rollback to the last healthy revision.
- Confirm ready replicas, endpoints, and successful probes.

## Close

Record detection, mitigation, and recovery timestamps. Write a blameless postmortem with the technical cause and a preventive action.
