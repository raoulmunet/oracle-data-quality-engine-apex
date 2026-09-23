create table dq_customer_source (
    customer_id    number,
    customer_name  varchar2(200),
    email_address  varchar2(320),
    status_code    varchar2(20),
    birth_date     date
);

insert into dq_customer_source values (1, 'Alice Morgan', 'alice@example.com', 'ACTIVE', date '1990-05-10');
insert into dq_customer_source values (2, 'Bob Green', 'invalid-email', 'ACTIVE', date '1984-07-22');
insert into dq_customer_source values (3, null, 'carla@example.com', 'ACTIVE', date '1995-01-05');
insert into dq_customer_source values (4, 'Dan Stone', 'dan@example.com', 'UNKNOWN', date '1989-11-11');
insert into dq_customer_source values (null, 'Missing ID', 'missing@example.com', 'ACTIVE', date '2000-02-02');

commit;
