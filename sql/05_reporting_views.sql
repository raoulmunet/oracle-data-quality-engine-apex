create or replace view v_dq_latest_execution as
select *
from (
    select e.*,
           row_number() over(partition by e.rule_set_id order by e.execution_id desc) rn
    from dq_execution e
)
where rn = 1;

create or replace view v_dq_rule_summary as
select e.execution_id,
       r.rule_code,
       r.rule_name,
       r.severity,
       count(v.violation_id) violation_count
from dq_execution e
join dq_violation v on v.execution_id = e.execution_id
join dq_rule r on r.rule_id = v.rule_id
group by e.execution_id, r.rule_code, r.rule_name, r.severity;
