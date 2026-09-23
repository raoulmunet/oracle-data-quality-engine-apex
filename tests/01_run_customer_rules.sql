set serveroutput on

declare
    l_execution_id number;
begin
    l_execution_id := pkg_dq_engine.run_rule_set('CUSTOMER_LOAD');
    dbms_output.put_line('Execution ID = ' || l_execution_id);
end;
/

select *
from dq_execution
order by execution_id desc
fetch first 1 row only;
