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
import model.User;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class UserDAO {
     public User checkLogin(String username,String password){
            
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
                
                rs= ptm.executeQuery();
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
     
   
}
