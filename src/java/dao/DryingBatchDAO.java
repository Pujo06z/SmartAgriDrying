/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DryingBatch;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class DryingBatchDAO {

    public DryingBatch getActiveBatchByOperator(String operatorId) {
        String sql
                = "SELECT TOP 1 "
                + "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.operator_id = ? "
                + "AND b.status = 'DRYING' "
                + "ORDER BY b.start_time DESC";
        try {

            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, operatorId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                DryingBatch batch = new DryingBatch();

                batch.setBatchId(
                        rs.getString("batch_id")
                );

                batch.setWarehouseId(
                        rs.getString("warehouse_id")
                );

                batch.setOperatorId(
                        rs.getString("operator_id")
                );

                batch.setOperatorName(
                        rs.getString("operator_name")
                );

                batch.setProductName(
                        rs.getString("product_name")
                );

                batch.setWeightKg(
                        rs.getDouble("weight_kg")
                );

                batch.setStartTime(
                        rs.getTimestamp("start_time")
                );

                batch.setEndTime(
                        rs.getTimestamp("end_time")
                );

                batch.setStatus(
                        rs.getString("status")
                );

                batch.setNotes(
                        rs.getString("notes")
                );

                return batch;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return null;

    }

    public List<DryingBatch> getBatchesByWarehouse(String warehouseId) {

        List<DryingBatch> list = new ArrayList<>();
        String sql = "SELECT b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
                + "ORDER BY b.start_time DESC";
        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                DryingBatch batch = new DryingBatch();

                batch.setBatchId(
                        rs.getString("batch_id")
                );

                batch.setWarehouseId(
                        rs.getString("warehouse_id")
                );

                batch.setOperatorId(
                        rs.getString("operator_id")
                );

                batch.setOperatorName(
                        rs.getString("operator_name")
                );

                batch.setProductName(
                        rs.getString("product_name")
                );

                batch.setWeightKg(
                        rs.getDouble("weight_kg")
                );

                batch.setStartTime(
                        rs.getTimestamp("start_time")
                );

                batch.setEndTime(
                        rs.getTimestamp("end_time")
                );

                batch.setStatus(
                        rs.getString("status")
                );

                batch.setNotes(
                        rs.getString("notes")
                );

                list.add(batch);
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();

        }
        return list;
    }

    public List<DryingBatch> searchBatchesByWarehouse(
            String warehouseId,
            String keyword,
            String status,
            String sortBy,
            String sortOrder,
            int page,
            int pageSize) {

        List<DryingBatch> list
                = new ArrayList<>();

        // =========================================
        // SORT COLUMN
        // =========================================
        String sortColumn;

        switch (sortBy) {

            case "endTime":
                sortColumn = "b.end_time";
                break;

            case "productName":
                sortColumn = "b.product_name";
                break;

            case "weight":
                sortColumn = "b.weight_kg";
                break;

            case "status":
                sortColumn = "b.status";
                break;

            case "startTime":
            default:
                sortColumn = "b.start_time";
                break;
        }

        if (!"ASC".equalsIgnoreCase(sortOrder)) {
            sortOrder = "DESC";
        }

        // =========================================
        // SQL
        // =========================================
        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT "
                + "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
        );

        // SEARCH
        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "b.batch_id LIKE ? "
                    + "OR b.product_name LIKE ? "
                    + "OR u.full_name LIKE ?"
                    + ") "
            );
        }

        // FILTER STATUS
        if (status != null
                && !status.trim().isEmpty()) {

            sql.append(
                    "AND b.status = ? "
            );
        }

        // SORT + PAGINATION
        sql.append(
                "ORDER BY "
                + sortColumn
                + " "
                + sortOrder
                + " "
                + "OFFSET ? ROWS "
                + "FETCH NEXT ? ROWS ONLY"
        );

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    warehouseId
            );

            // SEARCH PARAMS
            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                String search
                        = "%"
                        + keyword.trim()
                        + "%";

                ps.setString(index++, search);
                ps.setString(index++, search);
                ps.setString(index++, search);
            }

            // STATUS PARAM
            if (status != null
                    && !status.trim().isEmpty()) {

                ps.setString(
                        index++,
                        status
                );
            }

            int offset
                    = (page - 1)
                    * pageSize;

            ps.setInt(
                    index++,
                    offset
            );

            ps.setInt(
                    index,
                    pageSize
            );

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapBatch(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    public int countBatchesByWarehouse(
            String warehouseId,
            String keyword,
            String status) {

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT COUNT(*) AS total "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
        );

        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "b.batch_id LIKE ? "
                    + "OR b.product_name LIKE ? "
                    + "OR u.full_name LIKE ?"
                    + ") "
            );
        }

        if (status != null
                && !status.trim().isEmpty()) {

            sql.append(
                    "AND b.status = ? "
            );
        }

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    warehouseId
            );

            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                String search
                        = "%"
                        + keyword.trim()
                        + "%";

                ps.setString(index++, search);
                ps.setString(index++, search);
                ps.setString(index++, search);
            }

            if (status != null
                    && !status.trim().isEmpty()) {

                ps.setString(
                        index,
                        status
                );
            }

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

    private String generateBatchId(Connection con)
            throws SQLException {

        String sql
                = "SELECT TOP 1 batch_id "
                + "FROM DRYING_BATCH "
                + "ORDER BY "
                + "TRY_CAST(SUBSTRING(batch_id, 2, 20) AS INT) DESC";

        try ( PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                String lastId
                        = rs.getString("batch_id");

                int number
                        = Integer.parseInt(
                                lastId.substring(1)
                        );

                return String.format(
                        "B%03d",
                        number + 1
                );
            }
        }

        return "B001";
    }

    public String createBatch(
            String warehouseId,
            String operatorId,
            String productName,
            double weightKg,
            String notes)
            throws Exception {

        String sql
                = "INSERT INTO DRYING_BATCH "
                + "(batch_id, warehouse_id, operator_id, "
                + "product_name, weight_kg, start_time, "
                + "end_time, status, notes) "
                + "VALUES (?, ?, ?, ?, ?, SYSDATETIME(), "
                + "NULL, 'DRYING', ?)";

        try (
                 Connection conn
                = DBContext.getConnection()) {

            String batchId
                    = generateBatchId(conn);

            try (
                     PreparedStatement ps
                    = conn.prepareStatement(sql)) {

                ps.setString(
                        1,
                        batchId
                );

                ps.setString(
                        2,
                        warehouseId
                );

                ps.setString(
                        3,
                        operatorId
                );

                ps.setString(
                        4,
                        productName
                );

                ps.setDouble(
                        5,
                        weightKg
                );

                ps.setString(
                        6,
                        notes
                );

                int rows
                        = ps.executeUpdate();

                if (rows > 0) {

                    return batchId;
                }
            }
        }

        return null;
    }

    public boolean completeBatch(
            String batchId,
            String operatorId) {

        String sql
                = "UPDATE DRYING_BATCH "
                + "SET status = 'COMPLETED', "
                + "end_time = SYSDATETIME() "
                + "WHERE batch_id = ? "
                + "AND operator_id = ? "
                + "AND status = 'DRYING'";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, batchId);

            ps.setString(2, operatorId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<DryingBatch> getCompletedBatchesByWarehouse(
            String warehouseId) {

        List<DryingBatch> list = new ArrayList<>();

        String sql
                = "SELECT b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
                + "AND b.status = 'COMPLETED' "
                + "ORDER BY b.end_time DESC";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, warehouseId);

            try ( ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    DryingBatch batch = new DryingBatch();

                    batch.setBatchId(
                            rs.getString("batch_id")
                    );

                    batch.setWarehouseId(
                            rs.getString("warehouse_id")
                    );

                    batch.setOperatorId(
                            rs.getString("operator_id")
                    );

                    batch.setOperatorName(
                            rs.getString("operator_name")
                    );

                    batch.setProductName(
                            rs.getString("product_name")
                    );

                    batch.setWeightKg(
                            rs.getDouble("weight_kg")
                    );

                    batch.setStartTime(
                            rs.getTimestamp("start_time")
                    );

                    batch.setEndTime(
                            rs.getTimestamp("end_time")
                    );

                    batch.setStatus(
                            rs.getString("status")
                    );

                    batch.setNotes(
                            rs.getString("notes")
                    );

                    list.add(batch);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // MAP RESULTSET -> DRYING BATCH
    // =====================================================
    private DryingBatch mapBatch(ResultSet rs)
            throws SQLException {

        DryingBatch batch = new DryingBatch();

        batch.setBatchId(
                rs.getString("batch_id")
        );

        batch.setWarehouseId(
                rs.getString("warehouse_id")
        );

        batch.setOperatorId(
                rs.getString("operator_id")
        );

        batch.setOperatorName(
                rs.getString("operator_name")
        );

        batch.setProductName(
                rs.getString("product_name")
        );

        batch.setWeightKg(
                rs.getDouble("weight_kg")
        );

        batch.setStartTime(
                rs.getTimestamp("start_time")
        );

        batch.setEndTime(
                rs.getTimestamp("end_time")
        );

        batch.setStatus(
                rs.getString("status")
        );

        batch.setNotes(
                rs.getString("notes")
        );

        return batch;
    }

    // =====================================================
    // OPERATOR + MANAGER DASHBOARD
    // ONLY GET BATCHES THAT ARE DRYING
    // =====================================================
    public List<DryingBatch> getActiveBatchesByWarehouse(
            String warehouseId) {

        List<DryingBatch> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
                + "AND b.status = 'DRYING' "
                + "ORDER BY b.start_time DESC";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            try ( ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapBatch(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // MANAGER
    // GET BATCHES IN ASSIGNED WAREHOUSES
    // OPTIONAL WAREHOUSE FILTER + SEARCH
    // =====================================================
    public List<DryingBatch> getByManager(
            String managerId,
            String warehouseId,
            String search) {

        List<DryingBatch> list
                = new ArrayList<>();

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT DISTINCT "
        );

        sql.append(
                "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
        );

        sql.append(
                "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "JOIN WAREHOUSE w "
                + "ON b.warehouse_id = w.warehouse_id "
                + "JOIN USER_WAREHOUSE uw "
                + "ON b.warehouse_id = uw.warehouse_id "
        );

        sql.append(
                "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE' "
        );

        if (warehouseId != null
                && !warehouseId.trim().isEmpty()) {

            sql.append(
                    "AND b.warehouse_id = ? "
            );
        }

        if (search != null
                && !search.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "b.batch_id LIKE ? "
                    + "OR b.product_name LIKE ? "
                    + "OR u.full_name LIKE ?"
                    + ") "
            );
        }

        sql.append(
                "ORDER BY b.start_time DESC"
        );

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    managerId
            );

            if (warehouseId != null
                    && !warehouseId.trim().isEmpty()) {

                ps.setString(
                        index++,
                        warehouseId
                );
            }

            if (search != null
                    && !search.trim().isEmpty()) {

                String keyword
                        = "%"
                        + search.trim()
                        + "%";

                ps.setString(
                        index++,
                        keyword
                );

                ps.setString(
                        index++,
                        keyword
                );

                ps.setString(
                        index++,
                        keyword
                );
            }

            try ( ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapBatch(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // MANAGER DASHBOARD
    // COUNT ACTIVE BATCHES IN MANAGER'S WAREHOUSES
    // =====================================================
    public int countActiveByManager(
            String managerId) {

        String sql
                = "SELECT COUNT(DISTINCT b.batch_id) AS total "
                + "FROM DRYING_BATCH b "
                + "JOIN USER_WAREHOUSE uw "
                + "ON b.warehouse_id = uw.warehouse_id "
                + "JOIN WAREHOUSE w "
                + "ON b.warehouse_id = w.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE' "
                + "AND b.status = 'DRYING'";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    managerId
            );

            try ( ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

    // =====================================================
    // ADMIN DASHBOARD
    // COUNT ALL ACTIVE BATCHES
    // =====================================================
    public int countAllActive() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DRYING_BATCH "
                + "WHERE status = 'DRYING'";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(
                        "total"
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

    // =====================================================
    // CHECK IF BATCH ID EXISTS
    // =====================================================
    public boolean exists(
            String batchId) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DRYING_BATCH "
                + "WHERE batch_id = ?";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    batchId
            );

            try ( ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    ) > 0;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // MANAGER
    // COMPLETE BATCH IN ASSIGNED WAREHOUSE
    // =====================================================
    public boolean completeBatchByManager(
            String batchId,
            String managerId) {

        String sql
                = "UPDATE b "
                + "SET b.status = 'COMPLETED', "
                + "b.end_time = SYSDATETIME() "
                + "FROM DRYING_BATCH b "
                + "WHERE b.batch_id = ? "
                + "AND b.status = 'DRYING' "
                + "AND EXISTS ( "
                + "    SELECT 1 "
                + "    FROM USER_WAREHOUSE uw "
                + "    JOIN WAREHOUSE w "
                + "      ON uw.warehouse_id = w.warehouse_id "
                + "    WHERE uw.user_id = ? "
                + "    AND uw.warehouse_id = b.warehouse_id "
                + "    AND uw.status = 'ACTIVE' "
                + "    AND w.status = 'ACTIVE' "
                + ")";

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    batchId
            );

            ps.setString(
                    2,
                    managerId
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    public List<DryingBatch> searchCompletedBatchHistory(
            String warehouseId,
            String keyword,
            String fromDate,
            String toDate,
            int page,
            int pageSize) {

        List<DryingBatch> list
                = new ArrayList<>();

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT "
                + "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
                + "AND b.status = 'COMPLETED' "
        );

        // SEARCH
        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "b.batch_id LIKE ? "
                    + "OR b.product_name LIKE ? "
                    + "OR u.full_name LIKE ?"
                    + ") "
            );
        }

        // FROM DATE
        if (fromDate != null
                && !fromDate.trim().isEmpty()) {

            sql.append(
                    "AND CAST(b.end_time AS DATE) >= ? "
            );
        }

        // TO DATE
        if (toDate != null
                && !toDate.trim().isEmpty()) {

            sql.append(
                    "AND CAST(b.end_time AS DATE) <= ? "
            );
        }

        sql.append(
                "ORDER BY b.end_time DESC "
                + "OFFSET ? ROWS "
                + "FETCH NEXT ? ROWS ONLY"
        );

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    warehouseId
            );

            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                String search
                        = "%" + keyword.trim() + "%";

                ps.setString(index++, search);
                ps.setString(index++, search);
                ps.setString(index++, search);
            }

            if (fromDate != null
                    && !fromDate.trim().isEmpty()) {

                ps.setDate(
                        index++,
                        java.sql.Date.valueOf(
                                fromDate
                        )
                );
            }

            if (toDate != null
                    && !toDate.trim().isEmpty()) {

                ps.setDate(
                        index++,
                        java.sql.Date.valueOf(
                                toDate
                        )
                );
            }

            int offset
                    = (page - 1) * pageSize;

            ps.setInt(
                    index++,
                    offset
            );

            ps.setInt(
                    index,
                    pageSize
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapBatch(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    public int countCompletedBatchHistory(
            String warehouseId,
            String keyword,
            String fromDate,
            String toDate) {

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT COUNT(*) AS total "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.warehouse_id = ? "
                + "AND b.status = 'COMPLETED' "
        );

        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND ("
                    + "b.batch_id LIKE ? "
                    + "OR b.product_name LIKE ? "
                    + "OR u.full_name LIKE ?"
                    + ") "
            );
        }

        if (fromDate != null
                && !fromDate.trim().isEmpty()) {

            sql.append(
                    "AND CAST(b.end_time AS DATE) >= ? "
            );
        }

        if (toDate != null
                && !toDate.trim().isEmpty()) {

            sql.append(
                    "AND CAST(b.end_time AS DATE) <= ? "
            );
        }

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    warehouseId
            );

            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                String search
                        = "%" + keyword.trim() + "%";

                ps.setString(index++, search);
                ps.setString(index++, search);
                ps.setString(index++, search);
            }

            if (fromDate != null
                    && !fromDate.trim().isEmpty()) {

                ps.setDate(
                        index++,
                        java.sql.Date.valueOf(
                                fromDate
                        )
                );
            }

            if (toDate != null
                    && !toDate.trim().isEmpty()) {

                ps.setDate(
                        index++,
                        java.sql.Date.valueOf(
                                toDate
                        )
                );
            }

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }
    // =====================================================
// GET BATCH BY ID
// =====================================================

    public DryingBatch getBatchById(String batchId) {

        String sql
                = "SELECT "
                + "b.batch_id, "
                + "b.warehouse_id, "
                + "b.operator_id, "
                + "u.full_name AS operator_name, "
                + "b.product_name, "
                + "b.weight_kg, "
                + "b.start_time, "
                + "b.end_time, "
                + "b.status, "
                + "b.notes "
                + "FROM DRYING_BATCH b "
                + "JOIN USERS u "
                + "ON b.operator_id = u.user_id "
                + "WHERE b.batch_id = ?";

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    batchId
            );

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return mapBatch(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
}
