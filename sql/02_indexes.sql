create index ix_dq_execution_set on dq_execution(rule_set_id, started_at);
create index ix_dq_violation_exec on dq_violation(execution_id, rule_id);
create index ix_dq_violation_sev on dq_violation(severity, detected_at);
