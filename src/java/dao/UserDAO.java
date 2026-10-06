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
import model.User;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class UserDAO {

    private static final String BASE_SELECT =
            "SELECT user_id, username, full_name, role, status, created_at "
            + "FROM USERS ";

    public User checkLogin(String username, String password) {
        try {
            String sql = "SELECT user_id, username, password, full_name, "
                    + "role, status, created_at "
                    + "FROM USERS "
                    + "WHERE username = ? "
                    + "AND password = ? "
                    + "AND status = 'ACTIVE'";
            Connection conn = DBContext.getConnection();
            PreparedStatement ptm = conn.prepareStatement(sql);
            ResultSet rs = null;

            ptm.setString(1, username);
            ptm.setString(2, password);

            rs = ptm.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getString("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                return user;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getString("user_id"),
                rs.getString("username"),
                null,
                rs.getString("full_name"),
                rs.getString("role"),
                rs.getString("status"),
                rs.getTimestamp("created_at")
        );
    }

    public List<User> getAllUsers() throws Exception {
        List<User> list = new ArrayList<User>();
        String sql = BASE_SELECT + "ORDER BY role, user_id";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = mapUser(rs);
                loadAssignments(conn, user);
                list.add(user);
            }
        }
        return list;
    }

    private void loadAssignments(Connection conn, User user) throws SQLException {
        String sql =
                "SELECT uw.warehouse_id, w.warehouse_name "
                + "FROM USER_WAREHOUSE uw "
                + "JOIN WAREHOUSE w "
                + "ON uw.warehouse_id = w.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "ORDER BY w.warehouse_id";

        List<String> ids = new ArrayList<String>();
        List<String> names = new ArrayList<String>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getString(1));
                    names.add(rs.getString(2));
                }
            }
        }

        user.setWarehouseIds(ids);
        user.setWarehouseNames(names);
    }

    public boolean existsUsername(String username) throws Exception {
        return DBContext.scalar(
                "SELECT COUNT(*) FROM USERS WHERE username = ?",
                username
        ) > 0;
    }

    public boolean existsUserId(String userId) throws Exception {
        return DBContext.scalar(
                "SELECT COUNT(*) FROM USERS WHERE user_id = ?",
                userId
        ) > 0;
    }

    public void add(String userId, String username, String password, String fullName, String role) throws Exception {
        String sql =
                "INSERT INTO USERS "
                + "(user_id, username, password, full_name, role, status) "
                + "VALUES (?, ?, ?, ?, ?, 'ACTIVE')";
        DBContext.exec(sql, userId, username, password, fullName, role);
    }

    public void updateFullName(String userId, String fullName) throws Exception {
        DBContext.exec(
                "UPDATE USERS SET full_name = ? WHERE user_id = ?",
                fullName, userId
        );
    }

    public void updateRole(String userId, String role) throws Exception {
        DBContext.exec(
                "UPDATE USERS SET role = ? WHERE user_id = ?",
                role, userId
        );
    }

    public void toggleStatus(String userId) throws Exception {
        DBContext.exec(
                "UPDATE USERS "
                + "SET status = "
                + "CASE "
                + "WHEN status = 'ACTIVE' THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE user_id = ?",
                userId
        );
    }

    public void clearUserWarehouses(String userId) throws Exception {
        DBContext.exec(
                "DELETE FROM USER_WAREHOUSE WHERE user_id = ?",
                userId
        );
    }

    public void setUserWarehouses(String userId, String[] warehouseIds) throws Exception {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement delete = conn.prepareStatement("DELETE FROM USER_WAREHOUSE WHERE user_id = ?")) {
                delete.setString(1, userId);
                delete.executeUpdate();
            }

            if (warehouseIds != null) {
                String sql = "INSERT INTO USER_WAREHOUSE (user_id, warehouse_id) VALUES (?, ?)";
                try (PreparedStatement insert = conn.prepareStatement(sql)) {
                    for (String warehouseId : warehouseIds) {
                        if (warehouseId == null || warehouseId.trim().isEmpty()) {
                            continue;
                        }
                        insert.setString(1, userId);
                        insert.setString(2, warehouseId);
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

    public int countAll() throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM USERS");
    }

    public int countActive() throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM USERS WHERE status = 'ACTIVE'");
    }
}
