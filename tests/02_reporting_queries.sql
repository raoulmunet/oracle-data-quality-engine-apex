select *
from v_dq_latest_execution;

select *
from v_dq_rule_summary
order by execution_id desc, violation_count desc;

select v.violation_id,
       e.rule_set_code,
       r.rule_code,
       r.rule_name,
       v.business_key,
       v.severity,
       v.detected_at
from dq_violation v
join dq_execution e on e.execution_id = v.execution_id
join dq_rule r on r.rule_id = v.rule_id
order by v.violation_id desc;
