create or replace package pkg_dq_engine as
    function run_rule_set(
        p_rule_set_code in varchar2
    ) return number;
end pkg_dq_engine;
/
