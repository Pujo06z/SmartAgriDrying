/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.EventLog;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class EventLogDAO {

    private String generateEventId(
            Connection conn)
            throws Exception {

        String sql
                = "SELECT ISNULL("
                + "MAX(CAST(SUBSTRING(event_id, 2, 9) AS INT)), 0) + 1 "
                + "FROM EVENT_LOG";

        try (
                 PreparedStatement ps
                = conn.prepareStatement(sql);  ResultSet rs
                = ps.executeQuery()) {

            if (rs.next()) {

                int nextNumber
                        = rs.getInt(1);

                return String.format(
                        "E%03d",
                        nextNumber
                );
            }
        }

        return "E001";
    }

    // =========================================================
    // MAP RESULTSET
    // =========================================================
    private EventLog mapEvent(
            ResultSet rs)
            throws Exception {

        EventLog event
                = new EventLog();

        event.setEventId(
                rs.getString("event_id")
        );

        event.setWarehouseId(
                rs.getString("warehouse_id")
        );

        event.setDeviceId(
                rs.getString("device_id")
        );

        event.setBatchId(
                rs.getString("batch_id")
        );

        event.setActorUserId(
                rs.getString("actor_user_id")
        );

        event.setEventType(
                rs.getString("event_type")
        );

        event.setSource(
                rs.getString("source")
        );

        event.setDescription(
                rs.getString("description")
        );

        event.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        return event;
    }

// =========================================================
    // SEARCH + FILTER + SORT + PAGINATION
    // =========================================================
    public List<EventLog> searchEvents(
            String warehouseId,
            String keyword,
            String eventType,
            String source,
            String sortBy,
            String sortOrder,
            int page,
            int pageSize)
            throws Exception {

        List<EventLog> list
                = new ArrayList<EventLog>();

        // =====================================================
        // VALIDATE PAGE
        // =====================================================
        if (page < 1) {

            page = 1;
        }

        if (pageSize < 1) {

            pageSize = 10;
        }

        int offset
                = (page - 1) * pageSize;

        // =====================================================
        // SAFE SORT COLUMN
        // Do not take column names directly from the request
        // =====================================================
        String sortColumn;

        if ("eventType".equals(sortBy)) {

            sortColumn
                    = "event_type";

        } else if ("source".equals(sortBy)) {

            sortColumn
                    = "source";

        } else {

            sortColumn
                    = "created_at";
        }

        // =====================================================
        // SAFE SORT ORDER
        // =====================================================
        String direction;

        if ("ASC".equalsIgnoreCase(sortOrder)) {

            direction
                    = "ASC";

        } else {

            direction
                    = "DESC";
        }

        // =====================================================
        // BUILD SQL
        // =====================================================
        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT "
                + "event_id, "
                + "warehouse_id, "
                + "device_id, "
                + "batch_id, "
                + "actor_user_id, "
                + "event_type, "
                + "source, "
                + "description, "
                + "created_at "
                + "FROM EVENT_LOG "
                + "WHERE 1 = 1 "
        );

        List<Object> params
                = new ArrayList<Object>();

        // =====================================================
        // FILTER WAREHOUSE
        // =====================================================
        if (warehouseId != null
                && !warehouseId.trim().isEmpty()) {

            sql.append(
                    "AND warehouse_id = ? "
            );

            params.add(
                    warehouseId.trim()
            );
        }

        // =====================================================
        // SEARCH KEYWORD
        //
        // Search:
        // event ID
        // event type
        // device ID
        // batch ID
        // actor ID
        // description
        // =====================================================
        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "event_id LIKE ? "
                    + "OR event_type LIKE ? "
                    + "OR ISNULL(device_id, '') LIKE ? "
                    + "OR ISNULL(batch_id, '') LIKE ? "
                    + "OR ISNULL(actor_user_id, '') LIKE ? "
                    + "OR ISNULL(description, '') LIKE ? "
                    + ") "
            );

            String searchValue
                    = "%"
                    + keyword.trim()
                    + "%";

            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
        }

        // =====================================================
        // FILTER EVENT TYPE
        // =====================================================
        if (eventType != null
                && !eventType.trim().isEmpty()) {

            sql.append(
                    "AND event_type = ? "
            );

            params.add(
                    eventType.trim()
            );
        }

        // =====================================================
        // FILTER SOURCE
        // =====================================================
        if (source != null
                && !source.trim().isEmpty()) {

            sql.append(
                    "AND source = ? "
            );

            params.add(
                    source.trim()
            );
        }

        // =====================================================
        // SORT
        // =====================================================
        sql.append(
                "ORDER BY "
                + sortColumn
                + " "
                + direction
                + ", event_id ASC "
        );

        // =====================================================
        // PAGINATION
        // =====================================================
        sql.append(
                "OFFSET ? ROWS "
                + "FETCH NEXT ? ROWS ONLY"
        );

        params.add(offset);
        params.add(pageSize);

        // =====================================================
        // RUN QUERY
        // =====================================================
        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(
                        sql.toString()
                )) {

            for (int i = 0;
                    i < params.size();
                    i++) {

                ps.setObject(
                        i + 1,
                        params.get(i)
                );
            }

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapEvent(rs)
                    );
                }
            }
        }

        return list;
    }

    // =========================================================
    // COUNT EVENTS
    //
    // Used to calculate:
    // totalRecords
    // totalPages
    // =========================================================
    public int countEvents(
            String warehouseId,
            String keyword,
            String eventType,
            String source)
            throws Exception {

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT COUNT(*) "
                + "FROM EVENT_LOG "
                + "WHERE 1 = 1 "
        );

        List<Object> params
                = new ArrayList<Object>();

        // =====================================================
        // WAREHOUSE
        // =====================================================
        if (warehouseId != null
                && !warehouseId.trim().isEmpty()) {

            sql.append(
                    "AND warehouse_id = ? "
            );

            params.add(
                    warehouseId.trim()
            );
        }

        // =====================================================
        // KEYWORD
        // =====================================================
        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "event_id LIKE ? "
                    + "OR event_type LIKE ? "
                    + "OR ISNULL(device_id, '') LIKE ? "
                    + "OR ISNULL(batch_id, '') LIKE ? "
                    + "OR ISNULL(actor_user_id, '') LIKE ? "
                    + "OR ISNULL(description, '') LIKE ? "
                    + ") "
            );

            String searchValue
                    = "%"
                    + keyword.trim()
                    + "%";

            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
        }

        // =====================================================
        // EVENT TYPE
        // =====================================================
        if (eventType != null
                && !eventType.trim().isEmpty()) {

            sql.append(
                    "AND event_type = ? "
            );

            params.add(
                    eventType.trim()
            );
        }

        // =====================================================
        // SOURCE
        // =====================================================
        if (source != null
                && !source.trim().isEmpty()) {

            sql.append(
                    "AND source = ? "
            );

            params.add(
                    source.trim()
            );
        }

        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(
                        sql.toString()
                )) {

            for (int i = 0;
                    i < params.size();
                    i++) {

                ps.setObject(
                        i + 1,
                        params.get(i)
                );
            }

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    // =========================================================
    // GET ALL EVENTS
    // ADMIN
    // =========================================================
    public List<EventLog> getAllEvents()
            throws Exception {

        List<EventLog> list
                = new ArrayList<EventLog>();

        String sql
                = "SELECT event_id, warehouse_id, device_id, "
                + "batch_id, actor_user_id, event_type, "
                + "source, description, created_at "
                + "FROM EVENT_LOG "
                + "ORDER BY created_at DESC";

        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(sql);  ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                list.add(
                        mapEvent(rs)
                );
            }
        }

        return list;
    }

    // =========================================================
    // GET EVENTS BY WAREHOUSE
    // MANAGER / OPERATOR
    // =========================================================
    public List<EventLog> getEventsByWarehouse(
            String warehouseId)
            throws Exception {

        List<EventLog> list
                = new ArrayList<EventLog>();

        String sql
                = "SELECT event_id, warehouse_id, device_id, "
                + "batch_id, actor_user_id, event_type, "
                + "source, description, created_at "
                + "FROM EVENT_LOG "
                + "WHERE warehouse_id = ? "
                + "ORDER BY created_at DESC";

        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapEvent(rs)
                    );
                }
            }
        }

        return list;
    }

    // =========================================================
    // GET LATEST EVENTS
    // Used for Dashboard if needed
    // =========================================================
    public List<EventLog> getLatestEvents(
            int limit)
            throws Exception {

        List<EventLog> list
                = new ArrayList<EventLog>();

        String sql
                = "SELECT TOP (?) "
                + "event_id, warehouse_id, device_id, "
                + "batch_id, actor_user_id, event_type, "
                + "source, description, created_at "
                + "FROM EVENT_LOG "
                + "ORDER BY created_at DESC";

        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    limit
            );

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapEvent(rs)
                    );
                }
            }
        }

        return list;
    }

    // =========================================================
    // ADD EVENT
    // Automatically called by the system on user actions
    // =========================================================
    public boolean addEvent(
            String warehouseId,
            String deviceId,
            String batchId,
            String actorUserId,
            String eventType,
            String source,
            String description)
            throws Exception {

        String sql
                = "INSERT INTO EVENT_LOG "
                + "(event_id, warehouse_id, device_id, "
                + "batch_id, actor_user_id, event_type, "
                + "source, description, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        try (
                 Connection conn
                = DBContext.getConnection()) {

            String eventId
                    = generateEventId(conn);

            try (
                     PreparedStatement ps
                    = conn.prepareStatement(sql)) {

                ps.setString(
                        1,
                        eventId
                );

                ps.setString(
                        2,
                        warehouseId
                );

                ps.setString(
                        3,
                        deviceId
                );

                ps.setString(
                        4,
                        batchId
                );

                ps.setString(
                        5,
                        actorUserId
                );

                ps.setString(
                        6,
                        eventType
                );

                ps.setString(
                        7,
                        source
                );

                ps.setString(
                        8,
                        description
                );

                return ps.executeUpdate() > 0;
            }
        }
    }
}