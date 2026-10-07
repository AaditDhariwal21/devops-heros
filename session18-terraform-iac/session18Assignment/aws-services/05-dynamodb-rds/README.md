# DynamoDB and RDS - AWS Databases

Two main database options I looked at. DynamoDB is NoSQL, RDS is normal SQL databases managed by AWS.

# Part 1 - DynamoDB

## NoSQL
DynamoDB is a fully managed NoSQL key-value / document database. Serverless, no servers to manage.
No fixed schema, each item can have different fields. Really fast (single-digit ms) at any scale.
Pricing is on-demand (pay per request) or provisioned capacity.

## Tables
A table is a collection of items, like a table in SQL but without fixed columns.
When creating it you only have to define the primary key, everything else is flexible.

## Items
An item is one record in the table, like a row. Max size is 400 KB per item.

## Attributes
Attributes are the fields inside an item (like columns), e.g. `name`, `email`, `age`.
Types: string, number, binary, boolean, null, list, map, sets.

## Partition key
The main key. DynamoDB hashes it to decide which partition stores the item.
If the table only has a partition key, it must be unique per item.
Pick something with lots of different values (like `userId`) so data spreads out evenly.

## Sort key
Optional second key. Partition key + sort key together = composite primary key.
Lets you store many items under one partition key, sorted. Example: `userId` + `orderDate`.
Then I can query "all orders for user 42 in October".

```json
{ "userId": "42", "orderDate": "2026-10-07", "total": 499, "status": "shipped" }
```

Fun fact: DynamoDB is also used for Terraform state locking (the old way, newer Terraform can lock with S3 directly).

## Use cases (DynamoDB)
- Shopping carts, user sessions, user profiles.
- Gaming leaderboards, IoT data, anything with huge traffic and simple lookups by key.
- Serverless apps with Lambda.

# Part 2 - RDS

## Relational database
RDS = Relational Database Service. It's normal SQL databases (tables, rows, joins) but AWS manages them.
AWS handles patching, backups, hardware. I just connect and run SQL.
The way I think of it: it's MySQL/Postgres where AWS does the boring admin stuff.

## Supported engines
MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, Db2, plus Amazon Aurora (MySQL- and PostgreSQL-compatible).
Aurora is AWS's own version, faster and storage auto-grows, but costs more.

## DB instances
A DB instance is the actual database server. You pick an instance class like `db.t3.micro` or `db.m6g.large`
and storage (gp3 / io2). One instance can hold multiple databases.

## Security
- Put it in a private subnet, don't make it publicly accessible.
- Security group only allows the DB port (3306 MySQL, 5432 Postgres) from the app servers.
- Encryption at rest with KMS (has to be chosen at creation), SSL/TLS in transit.
- Can store the master password in Secrets Manager, and some engines support IAM auth.

## Backups
Automated backups are on by default, retention 1-35 days, lets you do point-in-time restore.
Manual snapshots stay until you delete them yourself.

## Multi-AZ
A standby copy in another Availability Zone, kept in sync (synchronous replication).
If the main one fails, RDS fails over automatically (DNS endpoint stays the same).
This is for high availability, not for spreading read traffic.

## Read replicas
Copies of the DB that you can read from, using async replication.
Used to offload heavy SELECT queries from the main DB. Can even be in another region.
Writes still only go to the primary.

## Use cases (RDS)
- Normal web apps (users, orders, payments) where you need joins and transactions.
- E-commerce, banking, ERP/CRM type stuff.
- Moving an existing MySQL/Postgres app to AWS without rewriting it.

## DynamoDB vs RDS

| | DynamoDB | RDS |
|---|---|---|
| Type | NoSQL (key-value/document) | Relational (SQL) |
| Schema | Flexible | Fixed tables/columns |
| Scaling | Automatic, basically unlimited | Bigger instance or read replicas |
| Servers | Serverless | You pick an instance class |
| Queries | By key, simple | Complex joins, SQL |
| Good for | High traffic, simple access | Structured data, transactions |

What I learned:
DynamoDB is for fast simple lookups at huge scale with no fixed schema, RDS is a normal SQL database AWS
manages for me. Multi-AZ = availability, read replicas = read performance, they're not the same thing.
