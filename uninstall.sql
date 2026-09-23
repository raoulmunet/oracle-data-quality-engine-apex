begin execute immediate 'drop package pkg_dq_engine'; exception when others then null; end;
/
begin execute immediate 'drop view v_dq_rule_summary'; exception when others then null; end;
/
begin execute immediate 'drop view v_dq_latest_execution'; exception when others then null; end;
/
begin execute immediate 'drop table dq_customer_source purge'; exception when others then null; end;
/
begin execute immediate 'drop table dq_violation purge'; exception when others then null; end;
/
begin execute immediate 'drop table dq_execution purge'; exception when others then null; end;
/
begin execute immediate 'drop table dq_rule_set_member purge'; exception when others then null; end;
/
begin execute immediate 'drop table dq_rule purge'; exception when others then null; end;
/
begin execute immediate 'drop table dq_rule_set purge'; exception when others then null; end;
/
