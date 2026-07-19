-- phpMyAdmin Timepicker Test Database
-- Complete coverage of all MySQL/MariaDB time/date column types
-- Includes all fractional second precisions (0-6)

CREATE DATABASE IF NOT EXISTS timepicker_test;
USE timepicker_test;

-- =====================================================
-- Table 1: events - Quick start with basic types
-- =====================================================
CREATE TABLE IF NOT EXISTS events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  event_name VARCHAR(100),
  event_date DATE,
  event_time TIME,
  event_datetime DATETIME,
  created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO events (event_name, event_date, event_time, event_datetime) VALUES
  ('Morning Meeting', '2026-07-20', '09:30:00', '2026-07-20 09:30:00'),
  ('Lunch Break', '2026-07-20', '12:00:00', '2026-07-20 12:00:00'),
  ('Afternoon Workshop', '2026-07-21', '14:15:30', '2026-07-21 14:15:30'),
  ('Evening Webinar', '2026-07-22', '18:45:00', '2026-07-22 18:45:00');

-- =====================================================
-- Table 2: time_types_full - Basic vs high precision
-- =====================================================
CREATE TABLE IF NOT EXISTS time_types_full (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(100),
  year_only YEAR,
  date_only DATE,
  time_basic TIME,
  time_microsec TIME(6),
  datetime_basic DATETIME,
  datetime_microsec DATETIME(6),
  timestamp_basic TIMESTAMP NULL,
  timestamp_microsec TIMESTAMP(6) NULL
);

INSERT INTO time_types_full (
  description,
  year_only,
  date_only,
  time_basic,
  time_microsec,
  datetime_basic,
  datetime_microsec,
  timestamp_basic,
  timestamp_microsec
) VALUES
  (
    'Full precision test',
    2026,
    '2026-07-20',
    '09:30:45',
    '09:30:45.123456',
    '2026-07-20 09:30:45',
    '2026-07-20 09:30:45.123456',
    '2026-07-20 09:30:45',
    '2026-07-20 09:30:45.123456'
  ),
  (
    'Midnight edge case',
    2026,
    '2026-01-01',
    '00:00:00',
    '00:00:00.000001',
    '2026-01-01 00:00:00',
    '2026-01-01 00:00:00.000001',
    '2026-01-01 00:00:00',
    '2026-01-01 00:00:00.000001'
  ),
  (
    'End of day',
    2026,
    '2026-12-31',
    '23:59:59',
    '23:59:59.999999',
    '2026-12-31 23:59:59',
    '2026-12-31 23:59:59.999999',
    '2026-12-31 23:59:59',
    '2026-12-31 23:59:59.999999'
  );

-- =====================================================
-- Table 3: all_time_precisions - COMPLETE COVERAGE
-- ALL precision levels 0-6 for TIME, DATETIME, TIMESTAMP
-- =====================================================
CREATE TABLE IF NOT EXISTS all_time_precisions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(100),

  -- Lowest resolution
  year_col YEAR,
  date_col DATE,

  -- TIME with all precisions 0-6
  time_0 TIME(0),
  time_1 TIME(1),
  time_2 TIME(2),
  time_3 TIME(3),
  time_4 TIME(4),
  time_5 TIME(5),
  time_6 TIME(6),

  -- DATETIME with all precisions 0-6
  datetime_0 DATETIME(0),
  datetime_1 DATETIME(1),
  datetime_2 DATETIME(2),
  datetime_3 DATETIME(3),
  datetime_4 DATETIME(4),
  datetime_5 DATETIME(5),
  datetime_6 DATETIME(6),

  -- TIMESTAMP with all precisions 0-6
  timestamp_0 TIMESTAMP(0) NULL,
  timestamp_1 TIMESTAMP(1) NULL,
  timestamp_2 TIMESTAMP(2) NULL,
  timestamp_3 TIMESTAMP(3) NULL,
  timestamp_4 TIMESTAMP(4) NULL,
  timestamp_5 TIMESTAMP(5) NULL,
  timestamp_6 TIMESTAMP(6) NULL
);

INSERT INTO all_time_precisions (
  description,
  year_col,
  date_col,
  time_0, time_1, time_2, time_3, time_4, time_5, time_6,
  datetime_0, datetime_1, datetime_2, datetime_3, datetime_4, datetime_5, datetime_6,
  timestamp_0, timestamp_1, timestamp_2, timestamp_3, timestamp_4, timestamp_5, timestamp_6
) VALUES
  (
    'Full precision showcase',
    2026,
    '2026-07-20',
    '09:30:45.123456', '09:30:45.123456', '09:30:45.123456', '09:30:45.123456', '09:30:45.123456', '09:30:45.123456', '09:30:45.123456',
    '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456',
    '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:45.123456'
  ),
  (
    'Edge case: 9s rounding',
    2026,
    '2026-12-31',
    '23:59:59.999999', '23:59:59.999999', '23:59:59.999999', '23:59:59.999999', '23:59:59.999999', '23:59:59.999999', '23:59:59.999999',
    '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999',
    '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999', '2026-12-31 23:59:59.999999'
  );

-- =====================================================
-- Table 4: timezone_tests - TIMEZONE HANDLING
-- Test TIMESTAMP (timezone-aware) vs DATETIME (not timezone-aware)
-- =====================================================
CREATE TABLE IF NOT EXISTS timezone_tests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(200),

  -- TIMESTAMP is timezone-aware: converts to UTC for storage, displays in session timezone
  ts_utc TIMESTAMP NULL,
  ts_with_precision TIMESTAMP(6) NULL,

  -- DATETIME is NOT timezone-aware: stores exactly what you give it
  dt_local DATETIME,
  dt_with_precision DATETIME(6),

  -- Store timezone offset info as text for reference
  timezone_info VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO timezone_tests (description, ts_utc, ts_with_precision, dt_local, dt_with_precision, timezone_info) VALUES
  ('UTC Midnight', '2026-07-20 00:00:00', '2026-07-20 00:00:00.000000', '2026-07-20 00:00:00', '2026-07-20 00:00:00.000000', 'UTC+0'),
  ('New York (EST)', '2026-07-20 09:30:00', '2026-07-20 09:30:45.123456', '2026-07-20 09:30:00', '2026-07-20 09:30:45.123456', 'UTC-5 (EST)'),
  ('London (GMT)', '2026-07-20 14:00:00', '2026-07-20 14:00:30.500000', '2026-07-20 14:00:00', '2026-07-20 14:00:30.500000', 'UTC+0 (GMT)'),
  ('Tokyo (JST)', '2026-07-20 23:00:00', '2026-07-20 23:00:15.999999', '2026-07-20 23:00:00', '2026-07-20 23:00:15.999999', 'UTC+9 (JST)'),
  ('Sydney (AEDT)', '2026-07-21 04:30:00', '2026-07-21 04:30:45.123456', '2026-07-21 04:30:00', '2026-07-21 04:30:45.123456', 'UTC+10 (AEDT)'),
  ('DST Boundary Test', '2026-03-08 07:00:00', '2026-03-08 07:00:00.000001', '2026-03-08 02:00:00', '2026-03-08 02:00:00.000001', 'UTC-8 to UTC-7 (PST→PDT)');
