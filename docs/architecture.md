# Architecture notes

The engine stores rule failure conditions as metadata and executes them dynamically.

This provides flexibility, but also means rule maintenance is a privileged operation.

For production use, free-form predicates can be replaced or constrained by:

- a restricted rule DSL;
- JSON-based rule definitions;
- generated predicates;
- whitelisted columns and operators.

A future version can integrate directly with the ETL Batch Framework so each ETL job runs one or more rule sets before data is promoted from staging to warehouse tables.
