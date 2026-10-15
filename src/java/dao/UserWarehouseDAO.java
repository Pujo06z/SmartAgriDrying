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
import model.Warehouse;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class UserWarehouseDAO {

    public List<Warehouse> getWarehousesByUser(
            String userId)
            throws Exception {

        List<Warehouse> list
                = new ArrayList<>();

        String sql
                = "SELECT w.warehouse_id, "
                + "w.warehouse_code, "
                + "w.warehouse_name, "
                + "w.status "
                + "FROM USER_WAREHOUSE uw "
                + "JOIN WAREHOUSE w "
                + "ON uw.warehouse_id = w.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "ORDER BY w.warehouse_id";

        try (
                 Connection conn
                = DBContext.getConnection();  PreparedStatement ps
                = conn.prepareStatement(sql)) {

            ps.setString(
                    1,
                    userId
            );

            try (
                     ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    Warehouse warehouse
                            = new Warehouse();

                    warehouse.setWarehouseId(
                            rs.getString(
                                    "warehouse_id"
                            )
                    );

                    warehouse.setWarehouseCode(
                            rs.getString(
                                    "warehouse_code"
                            )
                    );

                    warehouse.setWarehouseName(
                            rs.getString(
                                    "warehouse_name"
                            )
                    );

                    warehouse.setStatus(
                            rs.getString(
                                    "status"
                            )
                    );

                    list.add(warehouse);
                }
            }
        }

        return list;
    }

    // =========================================
    // SET USER WAREHOUSES
    // =========================================
    public void setUserWarehouses(
            String userId,
            String[] warehouseIds)
            throws Exception {

        Connection conn = null;

        try {

            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            // ==============================
            // 1. DELETE OLD ASSIGNMENTS
            // ==============================
            String deleteSql
                    = "DELETE FROM USER_WAREHOUSE "
                    + "WHERE user_id = ?";

            try (
                     PreparedStatement delete
                    = conn.prepareStatement(deleteSql)) {

                delete.setString(1, userId);

                delete.executeUpdate();
            }

            // ==============================
            // 2. ADD NEW WAREHOUSES
            // ==============================
            if (warehouseIds != null
                    && warehouseIds.length > 0) {

                String insertSql
                        = "INSERT INTO USER_WAREHOUSE "
                        + "(user_id, warehouse_id, assigned_at, status) "
                        + "VALUES (?, ?, GETDATE(), 'ACTIVE')";

                try (
                         PreparedStatement insert
                        = conn.prepareStatement(insertSql)) {

                    for (String warehouseId : warehouseIds) {

                        if (warehouseId == null
                                || warehouseId.trim().isEmpty()) {

                            continue;
                        }

                        insert.setString(
                                1,
                                userId
                        );

                        insert.setString(
                                2,
                                warehouseId.trim()
                        );

                        insert.addBatch();
                    }

                    insert.executeBatch();
                }
            }

            conn.commit();

        } catch (Exception e) {

            if (conn != null) {

                conn.rollback();
            }

            throw e;

        } finally {

            if (conn != null) {

                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}