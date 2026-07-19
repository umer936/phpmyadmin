# phpMyAdmin Timepicker Testing Guide

Complete test environment for testing timepickers with all MySQL/MariaDB date/time column types.

## 🚀 Quick Start

1. **Start the environment:**
   ```powershell
   docker compose -f docker-compose.timepicker.yml up -d
   ```

2. **Access phpMyAdmin:** http://localhost:8080

3. **Login credentials:**
   - Username: `root`
   - Password: `root`
   - Server: Choose MySQL 8.0, MySQL 8.4, or MariaDB 11.4

4. **Test database:** `timepicker_test` (already loaded with test data)

## 🗄️ Database Servers Available

- **MySQL 8.0** - Port 33061
- **MySQL 8.4** - Port 33062
- **MariaDB 11.4** - Port 33063

All servers have the same test data for cross-compatibility testing.

## 📊 Test Tables

### Table 1: `events` (4 rows) - Quick Start
Simple table with common date/time types for quick testing.

| Column            | Type      | Example             |
|-------------------|-----------|---------------------|
| event_date        | DATE      | 2026-07-20          |
| event_time        | TIME      | 09:30:00            |
| event_datetime    | DATETIME  | 2026-07-20 09:30:00 |
| created_timestamp | TIMESTAMP | Auto-set            |
| updated_timestamp | TIMESTAMP | Auto-updated        |

### Table 2: `time_types_full` (3 rows) - Coverage Test
Compares basic precision (0) vs highest precision (6), includes YEAR type.

| Column             | Type         | Example                    |
|--------------------|--------------|----------------------------|
| year_only          | YEAR         | 2026                       |
| date_only          | DATE         | 2026-07-20                 |
| time_basic         | TIME         | 09:30:45                   |
| time_microsec      | TIME(6)      | 09:30:45.123456            |
| datetime_basic     | DATETIME     | 2026-07-20 09:30:45        |
| datetime_microsec  | DATETIME(6)  | 2026-07-20 09:30:45.123456 |
| timestamp_basic    | TIMESTAMP    | 2026-07-20 09:30:45        |
| timestamp_microsec | TIMESTAMP(6) | 2026-07-20 09:30:45.123456 |

### Table 3: `all_time_precisions` (2 rows) ⭐ COMPLETE
**ALL fractional second precision levels (0-6) for TIME, DATETIME, and TIMESTAMP.**

**23 time/date columns total** covering every possible precision:

#### Precision Levels (using input `09:30:45.123456`):
- **(0)** → `09:30:45` - seconds only
- **(1)** → `09:30:45.1` - tenths
- **(2)** → `09:30:45.12` - hundredths
- **(3)** → `09:30:45.123` - milliseconds
- **(4)** → `09:30:45.1235` - ten-thousandths
- **(5)** → `09:30:45.12346` - hundred-thousandths
- **(6)** → `09:30:45.123456` - microseconds (highest!)

#### All Columns:
- `year_col` - YEAR
- `date_col` - DATE
- `time_0` through `time_6` - TIME with precision 0-6
- `datetime_0` through `datetime_6` - DATETIME with precision 0-6
- `timestamp_0` through `timestamp_6` - TIMESTAMP with precision 0-6

### Table 4: `timezone_tests` (6 rows) ⏰ TIMEZONE HANDLING

**Purpose:** Test timezone-aware (TIMESTAMP) vs timezone-naive (DATETIME) behavior.

| Column            | Type         | Behavior                                                          |
|-------------------|--------------|-------------------------------------------------------------------|
| ts_utc            | TIMESTAMP    | **Timezone-aware**: Converts to UTC, displays in session timezone |
| ts_with_precision | TIMESTAMP(6) | Same as above with microseconds                                   |
| dt_local          | DATETIME     | **NOT timezone-aware**: Stores exactly what you input             |
| dt_with_precision | DATETIME(6)  | Same as above with microseconds                                   |
| timezone_info     | VARCHAR(50)  | Reference info (UTC+0, UTC-5, etc.)                               |

#### 🌍 Test Data Includes:
- UTC Midnight (UTC+0)
- New York EST (UTC-5)
- London GMT (UTC+0)
- Tokyo JST (UTC+9)
- Sydney AEDT (UTC+10)
- DST Boundary Test (Pacific Time daylight saving transition)

#### ⚠️ Important Timezone Notes:

**TIMESTAMP behavior:**
- Stores values in UTC internally
- Converts input based on server's timezone setting
- Displays values in current session timezone
- **Your timepicker must handle timezone conversions!**

**DATETIME behavior:**
- Stores exactly what you input (no timezone conversion)
- Always displays the same value regardless of timezone
- **Your timepicker should NOT convert these values**

**Testing timezone conversion:**
```sql
-- Check current timezone
SELECT @@session.time_zone;

-- Change session timezone and see TIMESTAMP values change
SET time_zone = '+00:00';  -- UTC
SELECT ts_utc, dt_local FROM timezone_tests WHERE id = 2;

SET time_zone = '+09:00';  -- Tokyo
SELECT ts_utc, dt_local FROM timezone_tests WHERE id = 2;
-- ts_utc will show different time, dt_local stays the same!
```

## 🎯 How to Test the Timepicker

1. Open http://localhost:8080 in your browser
2. Login with `root` / `root`
3. Select a database server from the dropdown
4. Click `timepicker_test` database in left sidebar
5. Choose a table:
   - **`events`** - Quick 5-minute test (basic types)
   - **`time_types_full`** - 15-minute coverage test (basic vs high precision)
   - **`all_time_precisions`** - Complete 30+ minute test (all precisions 0-6) ⭐
   - **`timezone_tests`** - 20-minute timezone test (TIMESTAMP vs DATETIME) ⏰
6. Click **"Insert"** tab to test adding new rows
7. Click **"Browse"** then **"Edit"** to test editing existing rows

## 🛠️ Docker Commands

### Start containers
```powershell
docker compose -f docker-compose.timepicker.yml up -d
```

### Stop containers
```powershell
docker compose -f docker-compose.timepicker.yml down
```

### Restart phpMyAdmin (after code changes)
```powershell
docker compose -f docker-compose.timepicker.yml restart phpmyadmin-dev
```

### Rebuild JavaScript assets (after editing resources/js/)
```powershell
docker compose -f docker-compose.timepicker.yml exec phpmyadmin-dev yarn run build
```

### View phpMyAdmin logs
```powershell
docker compose -f docker-compose.timepicker.yml logs phpmyadmin-dev -f
```

### Reset everything (delete all data)
```powershell
docker compose -f docker-compose.timepicker.yml down -v
```

## 📁 Load Test Data from SQL File

If you need to reload the test database:

```powershell
# MySQL 8.0
docker exec -i pma-mysql80 mysql -uroot -proot < timepicker_test.sql

# MySQL 8.4
docker exec -i pma-mysql84 mysql -uroot -proot < timepicker_test.sql

# MariaDB 11.4
docker exec -i pma-mariadb114 mariadb -uroot -proot < timepicker_test.sql
```

## 🔧 Setup Details

### Modified Files
- `docker/phpmyadmin/Dockerfile` - Updated to Node.js 22 (required by locutus package)
- `docker/phpmyadmin/entrypoint-dev.sh` - Added HTTP configuration for local development

### Ports
- phpMyAdmin: http://localhost:8080
- MySQL 8.0: localhost:33061
- MySQL 8.4: localhost:33062
- MariaDB 11.4: localhost:33063

### Volume Mounts
- Your code: `./` → `/var/www/html` (live updates)
- Dependencies cached: `pma_vendor`, `pma_node_modules`
- Database data: `mysql80_data`, `mysql84_data`, `mariadb114_data`

## 🧪 What to Test

### Input Handling
- Can the timepicker accept input for each precision level?
- Does it display the correct number of decimal places?

### Display Formatting
- TIME(0): `HH:MM:SS`
- TIME(3): `HH:MM:SS.ddd`
- TIME(6): `HH:MM:SS.dddddd`

### Validation
- Does it prevent invalid values?
- Does it handle precision truncation correctly?

### Edge Cases
- Midnight: `00:00:00.000001`
- End of day: `23:59:59.999999` (watch for rounding!)

### Timezone Handling ⏰
**If your timepicker supports timezones:**
- Does it correctly handle TIMESTAMP (timezone-aware) fields?
- Does it NOT convert DATETIME (timezone-naive) fields?
- Can users select/display different timezones?
- Does it handle timezone abbreviations (EST, JST, AEDT)?
- Does it handle UTC offsets (UTC-5, UTC+9)?
- Does it handle DST (Daylight Saving Time) boundaries?

**Test strategy:**
1. Insert a TIMESTAMP value with timezone info
2. Query it from different timezone settings
3. Verify DATETIME values remain unchanged
4. Test DST boundary dates (March/November in US)

## ✅ Complete Column Type Coverage

**All MySQL/MariaDB time/date types are covered:**
- ✅ YEAR
- ✅ DATE
- ✅ TIME with precision 0, 1, 2, 3, 4, 5, 6
- ✅ DATETIME with precision 0, 1, 2, 3, 4, 5, 6
- ✅ TIMESTAMP with precision 0, 1, 2, 3, 4, 5, 6
- ✅ **TIMEZONE HANDLING** (TIMESTAMP vs DATETIME behavior) ⏰

**Total: 23 different time/date column configurations + timezone testing** across 4 test tables! 🎉

## 📊 Summary

| Table                 | Rows | Focus                                        |
|-----------------------|------|----------------------------------------------|
| `events`              | 4    | Quick start - basic types                    |
| `time_types_full`     | 3    | Coverage - basic vs high precision           |
| `all_time_precisions` | 2    | Complete - all precisions 0-6 ⭐             |
| `timezone_tests`      | 6    | Timezone handling - TIMESTAMP vs DATETIME ⏰ |

## 📝 Files

- `timepicker_test.sql` - SQL file to create all test tables and data
- `docker-compose.timepicker.yml` - Docker Compose configuration
- `docker/TIMEPICKER-DEV.md` - Original Docker documentation
- This `README.md` - Complete testing guide

## 🎉 Ready to Test!

You're all set to test your custom timepicker against every possible MySQL/MariaDB date/time column type and precision level!
