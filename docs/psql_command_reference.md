# PostgreSQL Command Reference

## Terminal commands & psql shell meta-commands

This document does not include SQL queries — only commands you type in the terminal or inside the psql prompt.

---

# 1. Terminal Commands (run outside psql)

Run these in your regular terminal / shell — NOT inside the psql prompt.

| Command | Description |
|----------|-------------|
| `psql -U postgres` | Connect as user postgres |
| `psql -U username -d dbname` | Connect to a specific database |
| `psql -U postgres -h localhost -p 5432 -d dbname` | Connect with full host + port + database |
| `psql -U postgres -W` | Force password prompt |
| `psql -U postgres -c "SELECT version();"` | Run a single query and exit |
| `psql -U postgres -f file.sql` | Run all SQL commands from a .sql file |
| `pg_dump -U postgres dbname > backup.sql` | Export a database to a .sql file |
| `pg_dump -U postgres -Fc dbname > backup.dump` | Export in compressed custom format |
| `pg_dumpall -U postgres > all.sql` | Export all databases at once |
| `psql -U postgres dbname < backup.sql` | Restore a database from a .sql file |
| `pg_restore -U postgres -d dbname backup.dump` | Restore from custom format dump |
| `createdb -U postgres dbname` | Create a new database from terminal |
| `dropdb -U postgres dbname` | Drop a database from terminal |
| `createuser -U postgres --interactive` | Create a new user interactively |

---

# 2. Connection & Session (inside psql)

Run these after you are already inside the psql prompt.

| Meta-command | Description |
|-------------|-------------|
| `\q` | Quit / exit psql |
| `\c dbname` | Switch to another database |
| `\c dbname username` | Switch database and user |
| `\conninfo` | Show current connection info (host, user, db, port) |
| `\password username` | Change password for a user |

---

# 3. List & Inspect Objects (inside psql)

Use these to explore databases, tables, indexes, users, and more.

| Meta-command | Description |
|-------------|-------------|
| `\l` | List all databases |
| `\l+` | List all databases with extra info (size, description) |
| `\dt` | List all tables in the current database |
| `\dt schema.*` | List tables in a specific schema |
| `\d tablename` | Describe a table (columns, types, constraints) |
| `\d+ tablename` | Describe a table with extra detail (storage, stats) |
| `\di` | List all indexes |
| `\dv` | List all views |
| `\df` | List all functions |
| `\dn` | List all schemas |
| `\du` | List all users and roles |
| `\dp tablename` | Show access privileges for a table |
| `\ds` | List all sequences |

---

# 4. Query Execution & Output (inside psql)

| Meta-command | Description |
|-------------|-------------|
| `\i /path/to/file.sql` | Execute SQL commands from a file |
| `\e` | Open external editor to write a long query |
| `\o /path/output.txt` | Save all query output to a file |
| `\o` | Stop saving output to file (back to screen) |
| `\timing` | Toggle query execution time display on/off |
| `\x` | Toggle expanded (vertical) output mode |
| `\x auto` | Auto switch to expanded mode when output is wide |

---

# 5. Command History (inside psql)

| Meta-command | Description |
|-------------|-------------|
| `\s` | Show command history |
| `\s /path/history.txt` | Save command history to a file |

---

# 6. Help (inside psql)

| Meta-command | Description |
|-------------|-------------|
| `\?` | Show all psql meta-commands (backslash commands) |
| `\h` | List all available SQL commands |
| `\h COMMAND` | Show syntax help for a specific SQL command (e.g. `\h SELECT`) |

---

## Quick Reminder

Inside psql the prompt looks like:

```bash
dbname=#    # superuser
dbname=>    # regular user
```

Type:

```bash
\?
```

to see all meta-commands anytime.