create or replace package body pkg_dq_engine as

    function safe_object_name(p_name varchar2) return varchar2 is
    begin
        return dbms_assert.sql_object_name(upper(trim(p_name)));
    end;

    function run_rule_set(
        p_rule_set_code in varchar2
    ) return number
    is
        l_execution_id      number;
        l_rule_set_id       number;
        l_rows_checked      number := 0;
        l_rules_executed    number := 0;
        l_violations        number := 0;
        l_rule_violations   number := 0;
        l_sql               varchar2(32767);
        l_score             number;
        l_denominator       number;
        l_cur               sys_refcursor;
        l_business_key      varchar2(1000);
    begin
        select rule_set_id
          into l_rule_set_id
          from dq_rule_set
         where rule_set_code = p_rule_set_code
           and enabled_flag = 'Y';

        insert into dq_execution(rule_set_id, rule_set_code, status)
        values (l_rule_set_id, p_rule_set_code, 'RUNNING')
        returning execution_id into l_execution_id;

        commit;

        for r in (
            select d.rule_id, d.rule_code, d.rule_name, d.target_table,
                   d.key_expression, d.failure_condition, d.severity
              from dq_rule_set_member m
              join dq_rule d on d.rule_id = m.rule_id
             where m.rule_set_id = l_rule_set_id
               and d.enabled_flag = 'Y'
             order by m.rule_order, d.rule_id
        )
        loop
            l_rules_executed := l_rules_executed + 1;

            if l_rows_checked = 0 then
                l_sql := 'select count(*) from ' || safe_object_name(r.target_table);
                execute immediate l_sql into l_rows_checked;
            end if;

            l_sql := 'select count(*) from ' || safe_object_name(r.target_table) ||
                     ' where ' || r.failure_condition;
            execute immediate l_sql into l_rule_violations;
            l_violations := l_violations + l_rule_violations;

            if l_rule_violations > 0 then
                l_sql := 'select ' || r.key_expression ||
                         ' from ' || safe_object_name(r.target_table) ||
                         ' where ' || r.failure_condition;

                open l_cur for l_sql;
                loop
                    fetch l_cur into l_business_key;
                    exit when l_cur%notfound;

                    insert into dq_violation(
                        execution_id, rule_id, business_key, severity, violation_message
                    )
                    values (
                        l_execution_id, r.rule_id, l_business_key, r.severity, r.rule_name
                    );
                end loop;
                close l_cur;
            end if;
        end loop;

        l_denominator := greatest(l_rows_checked * l_rules_executed, 1);
        l_score := round(greatest(0, 100 - (l_violations / l_denominator * 100)), 2);

        update dq_execution
           set status='COMPLETED',
               finished_at=systimestamp,
               rows_checked=l_rows_checked,
               rules_executed=l_rules_executed,
               violations_found=l_violations,
               dq_score=l_score
         where execution_id=l_execution_id;

        commit;
        return l_execution_id;

    exception
        when others then
            begin
                if l_cur%isopen then close l_cur; end if;
            exception when invalid_cursor then null;
            end;

            update dq_execution
               set status='FAILED',
                   finished_at=systimestamp,
                   error_message=substr(sqlerrm || chr(10) || dbms_utility.format_error_backtrace,1,4000)
             where execution_id=l_execution_id;
            commit;
            raise;
    end;

end pkg_dq_engine;
/
