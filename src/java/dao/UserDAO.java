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
import model.User;
import util.DBContext;
import util.PasswordUtil;

/**
 *
 * @author ADMIN
 */
public class UserDAO {
//     public User checkLogin(String username,String password){
//            
//            try {
//                  String sql = "SELECT user_id, username, password, full_name, "
//                   + "role, status, created_at "
//                   + "FROM USERS "
//                   + "WHERE username = ? "
//                   + "AND password = ? "
//                   + "AND status = 'ACTIVE'";
//                Connection conn = DBContext.getConnection();
//                PreparedStatement ptm = conn.prepareStatement(sql);
//                ResultSet rs = null;
//                
//                ptm.setString(1, username);
//                ptm.setString(2, password);
//                
//                rs= ptm.executeQuery();
//                if (rs.next()) {
//                    User user = new User();
//                   user.setUserId(rs.getString("user_id"));
//                    user.setUsername(rs.getString("username"));
//                    user.setPassword(rs.getString("password"));
//                    user.setFullName(rs.getString("full_name"));
//                    user.setRole(rs.getString("role"));
//                    user.setStatus(rs.getString("status"));
//                    user.setCreatedAt(rs.getTimestamp("created_at"));
//                    
//                    return user;
//                }
//            } catch (SQLException ex) {
//                 ex.printStackTrace();
//            }
//            return null;
//        }
//     

    private static final String BASE_SELECT
            = "SELECT user_id, username, full_name, role, status, created_at "
            + "FROM USERS ";

    // =========================================================
    // LOGIN - GIỮ LOGIC CỦA BẠN
    // =========================================================
  public User checkLogin(String username, String password) {

    String sql
            = "SELECT user_id, username, password, full_name, "
            + "role, status, created_at "
            + "FROM USERS "
            + "WHERE username = ? "
            + "AND status = 'ACTIVE'";

    try (
            Connection conn = DBContext.getConnection();
            PreparedStatement ptm = conn.prepareStatement(sql)
    ) {

        ptm.setString(1, username);

        try (ResultSet rs = ptm.executeQuery()) {

            if (rs.next()) {

                String storedPassword
                        = rs.getString("password");

                // Kiểm tra password nhập vào
                // với password đã hash trong database
                boolean passwordCorrect
                        = PasswordUtil.verifyPassword(
                                password,
                                storedPassword
                        );

                if (!passwordCorrect) {
                    return null;
                }

                User user = new User();

                user.setUserId(
                        rs.getString("user_id")
                );

                user.setUsername(
                        rs.getString("username")
                );

                user.setFullName(
                        rs.getString("full_name")
                );

                user.setRole(
                        rs.getString("role")
                );

                user.setStatus(
                        rs.getString("status")
                );

                user.setCreatedAt(
                        rs.getTimestamp("created_at")
                );

                return user;
            }
        }

    } catch (Exception ex) {

        ex.printStackTrace();
    }

    return null;
}

    // =========================================================
// GET ALL USERS
// =========================================================
    public List<User> getAllUsers() throws Exception {

        List<User> list = new ArrayList<User>();

        String sql
                = "SELECT user_id, username, full_name, role, status, created_at "
                + "FROM USERS "
                + "ORDER BY role, user_id";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getString("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(user);
            }
        }

        return list;
    }

// =========================================================
// CHECK USERNAME EXISTS
// =========================================================
    public boolean existsUsername(String username)
            throws Exception {

        String sql
                = "SELECT COUNT(*) "
                + "FROM USERS "
                + "WHERE username = ?";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try ( ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

// =========================================================
// CHECK USER ID EXISTS
// =========================================================
    public boolean existsUserId(String userId)
            throws Exception {

        String sql
                = "SELECT COUNT(*) "
                + "FROM USERS "
                + "WHERE user_id = ?";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

// =========================================================
// ADD USER
// =========================================================
    public boolean add(
            String userId,
            String username,
            String password,
            String fullName,
            String role)
            throws Exception {

        String sql
                = "INSERT INTO USERS "
                + "(user_id, username, password, full_name, role, status) "
                + "VALUES (?, ?, ?, ?, ?, 'ACTIVE')";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, fullName);
            ps.setString(5, role);

            return ps.executeUpdate() > 0;
        }
    }

// =========================================================
// UPDATE FULL NAME
// =========================================================
    public boolean updateFullName(
            String userId,
            String fullName)
            throws Exception {

        String sql
                = "UPDATE USERS "
                + "SET full_name = ? "
                + "WHERE user_id = ?";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

// =========================================================
// UPDATE ROLE
// =========================================================
    public boolean updateRole(
            String userId,
            String role)
            throws Exception {

        String sql
                = "UPDATE USERS "
                + "SET role = ? "
                + "WHERE user_id = ?";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

// =========================================================
// TOGGLE ACTIVE / INACTIVE
// =========================================================
    public boolean toggleStatus(String userId)
            throws Exception {

        String sql
                = "UPDATE USERS "
                + "SET status = CASE "
                + "WHEN status = 'ACTIVE' THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE user_id = ?";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);

            return ps.executeUpdate() > 0;
        }
    }

// =========================================================
// COUNT ALL USERS
// =========================================================
    public int countAll() throws Exception {

        String sql
                = "SELECT COUNT(*) FROM USERS";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

// =========================================================
// COUNT ACTIVE USERS
// =========================================================
    public int countActive() throws Exception {

        String sql
                = "SELECT COUNT(*) "
                + "FROM USERS "
                + "WHERE status = 'ACTIVE'";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }
    
    
    // Lay danh sach
    public List<User> searchUsers(
        String keyword,
        String role,
        String status,
        String sortBy,
        String sortOrder,
        int page,
        int pageSize) {

    List<User> list = new ArrayList<>();

    String sortColumn;

    switch (sortBy) {

        case "username":
            sortColumn = "username";
            break;

        case "fullName":
            sortColumn = "full_name";
            break;

        case "role":
            sortColumn = "role";
            break;

        case "status":
            sortColumn = "status";
            break;

        case "createdAt":
            sortColumn = "created_at";
            break;

        default:
            sortColumn = "user_id";
            break;
    }

    if (!"ASC".equalsIgnoreCase(sortOrder)) {
        sortOrder = "DESC";
    }


    StringBuilder sql = new StringBuilder();

    sql.append(
            "SELECT user_id, username, password, full_name, "
            + "role, status, created_at "
            + "FROM USERS "
            + "WHERE 1 = 1 "
    );


    if (keyword != null
            && !keyword.trim().isEmpty()) {

        sql.append(
                "AND (user_id LIKE ? "
                + "OR username LIKE ? "
                + "OR full_name LIKE ?) "
        );
    }


    if (role != null
            && !role.trim().isEmpty()) {

        sql.append(
                "AND role = ? "
        );
    }


    if (status != null
            && !status.trim().isEmpty()) {

        sql.append(
                "AND status = ? "
        );
    }


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
            Connection conn = DBContext.getConnection();
            PreparedStatement ps =
                    conn.prepareStatement(
                            sql.toString()
                    )
    ) {

        int index = 1;


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


        if (role != null
                && !role.trim().isEmpty()) {

            ps.setString(
                    index++,
                    role
            );
        }


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


        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(
                        rs.getString("user_id")
                );

                user.setUsername(
                        rs.getString("username")
                );

                user.setFullName(
                        rs.getString("full_name")
                );

                user.setRole(
                        rs.getString("role")
                );

                user.setStatus(
                        rs.getString("status")
                );

                user.setCreatedAt(
                        rs.getTimestamp("created_at")
                );

                list.add(user);
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return list;
}
    
    // dem trang
    public int countUsers(
        String keyword,
        String role,
        String status) {

    StringBuilder sql
            = new StringBuilder();

    sql.append(
            "SELECT COUNT(*) AS total "
            + "FROM USERS "
            + "WHERE 1 = 1 "
    );


    if (keyword != null
            && !keyword.trim().isEmpty()) {

        sql.append(
                "AND (user_id LIKE ? "
                + "OR username LIKE ? "
                + "OR full_name LIKE ?) "
        );
    }


    if (role != null
            && !role.trim().isEmpty()) {

        sql.append(
                "AND role = ? "
        );
    }


    if (status != null
            && !status.trim().isEmpty()) {

        sql.append(
                "AND status = ? "
        );
    }


    try (
            Connection conn = DBContext.getConnection();
            PreparedStatement ps =
                    conn.prepareStatement(
                            sql.toString()
                    )
    ) {

        int index = 1;


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


        if (role != null
                && !role.trim().isEmpty()) {

            ps.setString(
                    index++,
                    role
            );
        }


        if (status != null
                && !status.trim().isEmpty()) {

            ps.setString(
                    index,
                    status
            );
        }


        try (ResultSet rs = ps.executeQuery()) {

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
}
