insert into dq_rule_set(rule_set_code, rule_set_name, description)
values ('CUSTOMER_LOAD', 'Customer load data quality', 'Validation rules for customer source data');

insert into dq_rule(rule_code, rule_name, target_table, key_expression, failure_condition, severity)
values ('CUSTOMER_ID_NOT_NULL','Customer ID must not be null','DQ_CUSTOMER_SOURCE','to_char(customer_id)','customer_id is null','CRITICAL');

insert into dq_rule(rule_code, rule_name, target_table, key_expression, failure_condition, severity)
values ('CUSTOMER_NAME_NOT_NULL','Customer name must not be null','DQ_CUSTOMER_SOURCE','to_char(customer_id)','customer_name is null','ERROR');

insert into dq_rule(rule_code, rule_name, target_table, key_expression, failure_condition, severity)
values ('CUSTOMER_EMAIL_VALID','E-mail address must contain @','DQ_CUSTOMER_SOURCE','to_char(customer_id)','email_address is not null and instr(email_address,''@'') = 0','WARNING');

insert into dq_rule(rule_code, rule_name, target_table, key_expression, failure_condition, severity)
values ('CUSTOMER_STATUS_VALID','Status must be ACTIVE or INACTIVE','DQ_CUSTOMER_SOURCE','to_char(customer_id)','status_code not in (''ACTIVE'',''INACTIVE'')','ERROR');

insert into dq_rule_set_member(rule_set_id, rule_id, rule_order)
select s.rule_set_id, r.rule_id, row_number() over(order by r.rule_id) * 10
from dq_rule_set s cross join dq_rule r
where s.rule_set_code = 'CUSTOMER_LOAD';

commit;
