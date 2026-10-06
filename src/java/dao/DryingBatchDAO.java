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
import model.DryingBatch;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class DryingBatchDAO {

    // Existing Operator method
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
                batch.setBatchId(rs.getString("batch_id"));
                batch.setWarehouseId(rs.getString("warehouse_id"));
                batch.setOperatorId(rs.getString("operator_id"));
                batch.setOperatorName(rs.getString("operator_name"));
                batch.setProductName(rs.getString("product_name"));
                batch.setWeightKg(rs.getDouble("weight_kg"));
                batch.setStartTime(rs.getTimestamp("start_time"));
                batch.setEndTime(rs.getTimestamp("end_time"));
                batch.setStatus(rs.getString("status"));
                batch.setNotes(rs.getString("notes"));
                return batch;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // New methods from NB13
    private static final String SELECT =
            "SELECT "
            + "b.batch_id, "
            + "b.warehouse_id, "
            + "w.warehouse_name, "
            + "b.start_time, "
            + "b.end_time, "
            + "b.status, "
            + "b.created_by, "
            + "u.full_name AS created_by_name "
            + "FROM DRYING_BATCH b "
            + "JOIN WAREHOUSE w "
            + "ON b.warehouse_id = w.warehouse_id "
            + "LEFT JOIN USERS u "
            + "ON b.created_by = u.user_id ";

    public List<DryingBatch> getByManager(String managerId, String warehouseId, String search) throws Exception {
        String sql =
                SELECT
                + "JOIN USER_WAREHOUSE uw "
                + "ON b.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? ";

        if (warehouseId != null && !warehouseId.trim().isEmpty()) {
            sql += "AND b.warehouse_id = ? ";
        }

        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (b.batch_id LIKE ? OR w.warehouse_name LIKE ?) ";
        }

        sql += "ORDER BY b.start_time DESC";

        List<DryingBatch> list = new ArrayList<DryingBatch>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int index = 1;
            ps.setString(index++, managerId);

            if (warehouseId != null && !warehouseId.trim().isEmpty()) {
                ps.setString(index++, warehouseId);
            }

            if (search != null && !search.trim().isEmpty()) {
                String s = "%" + search.trim() + "%";
                ps.setString(index++, s);
                ps.setString(index++, s);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int countActiveByManager(String managerId) throws Exception {
        String sql =
                "SELECT COUNT(*) "
                + "FROM DRYING_BATCH b "
                + "JOIN USER_WAREHOUSE uw "
                + "ON b.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND b.status = 'DRYING'";
        return DBContext.scalar(sql, managerId);
    }

    public int countAllActive() throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM DRYING_BATCH WHERE status = 'DRYING'");
    }

    public boolean exists(String batchId) throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM DRYING_BATCH WHERE batch_id = ?", batchId) > 0;
    }

    public boolean hasActiveBatch(String warehouseId) throws Exception {
        return DBContext.scalar(
                "SELECT COUNT(*) FROM DRYING_BATCH WHERE warehouse_id = ? AND status = 'DRYING'",
                warehouseId
        ) > 0;
    }

    public void startBatch(String batchId, String warehouseId, String createdBy) throws Exception {
        DBContext.exec(
                "INSERT INTO DRYING_BATCH "
                + "(batch_id, warehouse_id, start_time, status, created_by) "
                + "VALUES (?, ?, SYSDATETIME(), 'DRYING', ?)",
                batchId, warehouseId, createdBy
        );
    }

    public void completeBatch(String batchId, String managerId) throws Exception {
        String sql =
                "UPDATE DRYING_BATCH "
                + "SET end_time = SYSDATETIME(), "
                + "status = 'COMPLETED' "
                + "WHERE batch_id = ? "
                + "AND status = 'DRYING' "
                + "AND warehouse_id IN ("
                + "SELECT warehouse_id "
                + "FROM USER_WAREHOUSE "
                + "WHERE user_id = ?"
                + ")";
        DBContext.exec(sql, batchId, managerId);
    }

    private DryingBatch map(ResultSet rs) throws SQLException {
        return new DryingBatch(
                rs.getString("batch_id"),
                rs.getString("warehouse_id"),
                rs.getString("warehouse_name"),
                rs.getTimestamp("start_time"),
                rs.getTimestamp("end_time"),
                rs.getString("status"),
                rs.getString("created_by"),
                rs.getString("created_by_name")
        );
    }
}
