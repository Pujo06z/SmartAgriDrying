/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
public class DBContext {
    private static final String URL
            = "jdbc:sqlserver://localhost:1433;"
            + "databaseName=SmartAgriDrying;"
            + "encrypt=false";

    private static final String USER = "sa";

    private static final String PASSWORD = "12345";
    public static Connection getConnection()throws SQLException{
        try {
            Class.forName(
                    "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            );
        } catch (ClassNotFoundException ex) {
            throw new SQLException("JDBC Driver not found",ex);
        }
         return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }
   
}
