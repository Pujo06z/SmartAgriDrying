USE SmartAgriDrying;
GO

-- 1. Check data in every current table
SELECT * FROM USERS;
SELECT * FROM WAREHOUSE;
SELECT * FROM USER_WAREHOUSE;
SELECT * FROM DEVICE;
SELECT * FROM DRYING_BATCH;
SELECT * FROM SENSOR_DATA;
SELECT * FROM EVENT_LOG;
GO

-- 2. Quick row-count check
SELECT 'USERS' AS table_name, COUNT(*) AS total_rows FROM USERS
UNION ALL
SELECT 'WAREHOUSE', COUNT(*) FROM WAREHOUSE
UNION ALL
SELECT 'USER_WAREHOUSE', COUNT(*) FROM USER_WAREHOUSE
UNION ALL
SELECT 'DEVICE', COUNT(*) FROM DEVICE
UNION ALL
SELECT 'DRYING_BATCH', COUNT(*) FROM DRYING_BATCH
UNION ALL
SELECT 'SENSOR_DATA', COUNT(*) FROM SENSOR_DATA
UNION ALL
SELECT 'EVENT_LOG', COUNT(*) FROM EVENT_LOG;
GO

-- 3. Check sample accounts by role
SELECT user_id, username, full_name, role, status
FROM USERS
ORDER BY role, user_id;
GO

-- 4. Check user-to-warehouse assignments
SELECT
    u.user_id,
    u.username,
    u.role,
    w.warehouse_id,
    w.warehouse_name,
    uw.status AS assignment_status
FROM USER_WAREHOUSE uw
JOIN USERS u ON u.user_id = uw.user_id
JOIN WAREHOUSE w ON w.warehouse_id = uw.warehouse_id
ORDER BY u.user_id, w.warehouse_id;
GO

-- 5. Check devices and their warehouses
SELECT
    d.device_id,
    d.device_code,
    d.device_name,
    d.warehouse_id,
    w.warehouse_name,
    d.mode,
    d.roof_status,
    d.last_seen,
    d.status
FROM DEVICE d
JOIN WAREHOUSE w ON w.warehouse_id = d.warehouse_id
ORDER BY d.device_id;
GO

-- 6. Check active drying batches
SELECT *
FROM DRYING_BATCH
WHERE status = 'DRYING'
ORDER BY start_time DESC;
GO

-- 7. Check latest sensor readings
SELECT TOP 20 *
FROM SENSOR_DATA
ORDER BY recorded_at DESC;
GO

-- 8. Check latest events
SELECT TOP 20 *
FROM EVENT_LOG
ORDER BY created_at DESC;
GO
SELECT *
FROM USER_WAREHOUSE
WHERE user_id = 'U002';

go
SELECT*FROM USERS

UPDATE DEVICE
SET last_seen = SYSDATETIME()
WHERE device_id = 'D001';