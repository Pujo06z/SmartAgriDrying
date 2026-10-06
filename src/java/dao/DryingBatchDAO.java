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

    public boolean createBatch(
            String warehouseId,
            String operatorId,
            String productName,
            double weightKg,
            String notes) {

        String sql = "INSERT INTO DRYING_BATCH "
                + "(batch_id, warehouse_id, operator_id, "
                + "product_name, weight_kg, start_time, "
                + "end_time, status, notes) "
                + "VALUES (?, ?, ?, ?, ?, "
                + "SYSDATETIME(), NULL, 'DRYING', ?)";
        try {
            Connection con = DBContext.getConnection();

            String batchId = generateBatchId(con);

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, batchId);

            ps.setString(2, warehouseId);

            ps.setString(3, operatorId);

            ps.setString(4, productName);

            ps.setDouble(5, weightKg);

            ps.setString(6, notes);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
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

    try (Connection con = DBContext.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, warehouseId);

        try (ResultSet rs = ps.executeQuery()) {

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
}
