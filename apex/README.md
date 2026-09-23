# Oracle APEX Dashboard Build Guide

Suggested application name:

```text
Oracle Data Quality Monitor
```

## Page 1 — Dashboard

Create KPI/Card regions from `V_DQ_LATEST_EXECUTION`.

### Latest DQ Score

```sql
select rule_set_code as title,
       to_char(dq_score, 'FM990D00') || '%' as value,
       status as description
from v_dq_latest_execution
```

### Violations by Severity

```sql
select severity label,
       count(*) value
from dq_violation
where execution_id = (select max(execution_id) from dq_execution)
group by severity
order by severity
```

### Violations by Rule

```sql
select rule_name label,
       violation_count value
from v_dq_rule_summary
where execution_id = (select max(execution_id) from dq_execution)
order by violation_count desc
```

### DQ Score Trend

```sql
select started_at label,
       dq_score value,
       rule_set_code series
from dq_execution
where status = 'COMPLETED'
order by started_at
```

## Page 2 — Rule Sets

Interactive Report or Grid on `DQ_RULE_SET`.

## Page 3 — Rules

Interactive Grid on `DQ_RULE`.

Restrict this page to trusted users because rule expressions are executable metadata.

## Page 4 — Execution History

Interactive Report on `DQ_EXECUTION`.

## Page 5 — Violations

Create page item `P5_EXECUTION_ID` and use:

```sql
select v.violation_id,
       r.rule_code,
       r.rule_name,
       v.business_key,
       v.severity,
       v.violation_message,
       v.detected_at
from dq_violation v
join dq_rule r on r.rule_id = v.rule_id
where (:P5_EXECUTION_ID is null or v.execution_id = :P5_EXECUTION_ID)
order by v.violation_id desc
```

## Run button

Create a button named `RUN CUSTOMER CHECKS` and process:

```plsql
declare
    l_execution_id number;
begin
    l_execution_id := pkg_dq_engine.run_rule_set('CUSTOMER_LOAD');

    apex_application.g_print_success_message :=
        'Data quality execution completed. Execution ID = ' || l_execution_id;
end;
```
