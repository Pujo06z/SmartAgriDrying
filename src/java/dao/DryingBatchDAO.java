/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

}
