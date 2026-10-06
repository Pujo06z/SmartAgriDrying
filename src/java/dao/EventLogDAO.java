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

    public void add(String warehouseId, String deviceId, String eventType, String description) throws Exception {
        DBContext.exec(
                "INSERT INTO EVENT_LOG "
                + "(warehouse_id, device_id, event_type, description, created_at) "
                + "VALUES (?, ?, ?, ?, SYSDATETIME())",
                warehouseId, deviceId, eventType, description
        );
    }

    public List<EventLog> getByManager(String managerId) throws Exception {
        String sql =
                "SELECT TOP 200 "
                + "e.event_id, "
                + "w.warehouse_name, "
                + "d.device_code, "
                + "e.event_type, "
                + "e.description, "
                + "e.created_at "
                + "FROM EVENT_LOG e "
                + "JOIN WAREHOUSE w "
                + "ON e.warehouse_id = w.warehouse_id "
                + "LEFT JOIN DEVICE d "
                + "ON e.device_id = d.device_id "
                + "JOIN USER_WAREHOUSE uw "
                + "ON e.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "ORDER BY e.created_at DESC";

        List<EventLog> list = new ArrayList<EventLog>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new EventLog(
                            rs.getLong("event_id"),
                            rs.getString("warehouse_name"),
                            rs.getString("device_code"),
                            rs.getString("event_type"),
                            rs.getString("description"),
                            rs.getTimestamp("created_at")
                    ));
                }
            }
        }
        return list;
    }
}
