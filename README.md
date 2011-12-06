# PgDumper

Abstraction layer between PostgreSQL utility pg_dump and Rails app.

## Rake tasks
You can specify few ENV variables:
GZIP - to gzip sql dump with gzip utility
FILE - dump output (else asks interactively)
VERBOSE - verbose output
Z - pg_dump compression level

### db:dump
Dumps database schema **with data**.

### db:dump:schema
Dumps database schema **without data**.

# Credits
PgDumper uses awesome [Escape](https://github.com/akr/escape) library so thanks to [Tanaka Akira](https://github.com/akr).

# Tests

Huge TODO!

But is tested on Travis against 1.8.7, ree, 1.9.2 and 1.9.3.
