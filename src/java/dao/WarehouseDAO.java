/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Warehouse;
import util.DBContext;
/**
 *
 * @author ADMIN
 */
public class WarehouseDAO {
    public Warehouse getWarehouseByUser(String userId){
        String sql
                = "SELECT w.warehouse_id, "
                + "w.warehouse_code, "
                + "w.warehouse_name, "
                + "w.location, "
                + "w.status, "
                + "w.created_at "
                + "FROM WAREHOUSE w "
                + "JOIN USER_WAREHOUSE uw "
                + "ON w.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE'";
        
        try {
            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                
                Warehouse warehouse = new Warehouse();
                
                warehouse.setWarehouseId(
                        rs.getString("warehouse_id")
                );
                
                warehouse.setWarehouseCode(
                        rs.getString("warehouse_code")
                );
                
                warehouse.setWarehouseName(
                        rs.getString("warehouse_name")
                );
                
                warehouse.setLocation(
                        rs.getString("location")
                );
                
                warehouse.setStatus(
                        rs.getString("status")
                );
                
                warehouse.setCreatedAt(
                        rs.getTimestamp("created_at")
                );
                
                return warehouse;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
        }
    
}
