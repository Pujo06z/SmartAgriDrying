/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DeviceDAO;
import dao.DryingBatchDAO;
import dao.SensorDataDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DashboardData;
import model.Device;
import model.DryingBatch;
import model.SensorData;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        User user
                = (User) session.getAttribute("LOGIN_USER");

        String role = user.getRole();
        try {
            if ("ADMIN".equals(role)) {

                request.getRequestDispatcher(
                        "/WEB-INF/views/admin-dashboard.jsp"
                ).forward(request, response);
                return;
            } else if ("MANAGER".equals(role)) {

                request.getRequestDispatcher(
                        "/WEB-INF/views/manager-dashboard.jsp"
                ).forward(request, response);
                return;
            } else if ("OPERATOR".equals(role)) {

                loadOperatorDashboard(request, response, user);
                return;

            } else {

                response.sendRedirect(
                        request.getContextPath() + "/login"
                );
            }
        } catch (Exception e) {

            log("Error at DashboardController: " + e.toString());

            request.setAttribute(
                    "error",
                    "Cannot load dashboard."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/operator-dashboard.jsp"
            ).forward(request, response);
        }
    }

    
    private void loadOperatorDashboard(
        HttpServletRequest request,
        HttpServletResponse response,
        User user) throws Exception {

    WarehouseDAO warehouseDAO = new WarehouseDAO();
    DeviceDAO deviceDAO = new DeviceDAO();
    SensorDataDAO sensorDAO = new SensorDataDAO();
    DryingBatchDAO batchDAO = new DryingBatchDAO();

    // ==============================
    // 1. LẤY WAREHOUSE
    // ==============================
    Warehouse warehouse
            = warehouseDAO.getWarehouseByUser(
                    user.getUserId()
            );

    if (warehouse == null) {

        request.setAttribute(
                "error",
                "No warehouse assigned."
        );

        request.getRequestDispatcher(
                "/WEB-INF/views/operator-dashboard.jsp"
        ).forward(request, response);

        return;
    }


    // ==============================
    // 2. LẤY DEVICE
    // ==============================
    Device device
            = deviceDAO.getDeviceByWarehouse(
                    warehouse.getWarehouseId()
            );


    DashboardData dashboard
            = new DashboardData();

    SensorData latestSensor = null;

    List<SensorData> recentSensors = null;


    // ==============================
    // 3. NẾU CÓ DEVICE
    // ==============================
    if (device != null) {

        // Device data
        dashboard.setMode(
                device.getMode()
        );

        dashboard.setRoofStatus(
                device.getRoofStatus()
        );

        dashboard.setLastSeen(
                device.getLastSeen()
        );


        // ==============================
        // 4. ONLINE / OFFLINE
        // ==============================
        String connectionStatus = "OFFLINE";

        if (device.getLastSeen() != null) {

            long diff
                    = System.currentTimeMillis()
                    - device.getLastSeen().getTime();

            if (diff <= 30000) {
                connectionStatus = "ONLINE";
            }
        }

        dashboard.setConnectionStatus(
                connectionStatus
        );


        // ==============================
        // 5. SENSOR DATA
        // ==============================
        latestSensor
                = sensorDAO.getLatestSensorData(
                        device.getDeviceId()
                );

        recentSensors
                = sensorDAO.getRecentSensorData(
                        device.getDeviceId(),
                        6
                );


        if (latestSensor != null) {

            dashboard.setTemperature(
                    latestSensor.getTemperature()
            );

            dashboard.setHumidity(
                    latestSensor.getHumidity()
            );

            dashboard.setRainStatus(
                    latestSensor.getRainStatus()
            );

            dashboard.setLightStatus(
                    latestSensor.getLightStatus()
            );

            dashboard.setRecordedAt(
                    latestSensor.getRecordedAt()
            );


            // ==============================
            // 6. WARNING
            // ==============================
            String warning = "NORMAL";

            if ("OFFLINE".equals(connectionStatus)) {

                warning = "DEVICE OFFLINE";

            } else if ("RAINING".equals(
                    latestSensor.getRainStatus())) {

                warning = "RAIN DETECTED";
            }

            dashboard.setWarning(
                    warning
            );

        } else {

            // Có device nhưng chưa có sensor data
            dashboard.setWarning(
                    "NO SENSOR DATA"
            );
        }

    } else {

        // ==============================
        // KHÔNG CÓ DEVICE
        // ==============================
        dashboard.setConnectionStatus(
                "OFFLINE"
        );

        dashboard.setWarning(
                "NO DEVICE"
        );
    }


    // ==============================
    // 7. ACTIVE BATCH
    // ==============================
    DryingBatch activeBatch
            = batchDAO.getActiveBatchByOperator(
                    user.getUserId()
            );


    // ==============================
    // 8. SET REQUEST ATTRIBUTES
    // ==============================
    request.setAttribute(
            "warehouse",
            warehouse
    );

    request.setAttribute(
            "device",
            device
    );

    request.setAttribute(
            "dashboard",
            dashboard
    );

    request.setAttribute(
            "activeBatch",
            activeBatch
    );

    request.setAttribute(
            "recentSensors",
            recentSensors
    );


    // ==============================
    // 9. FORWARD JSP
    // ==============================
    request.getRequestDispatcher(
            "/WEB-INF/views/operator-dashboard.jsp"
    ).forward(request, response);
}
//    private void loadOperatorDashboard(
//            HttpServletRequest request,
//            HttpServletResponse response,
//            User user) throws Exception {
//
//        WarehouseDAO warehouseDAO = new WarehouseDAO();
//        DeviceDAO deviceDAO = new DeviceDAO();
//        SensorDataDAO sensorDAO = new SensorDataDAO();
//        DryingBatchDAO batchDAO = new DryingBatchDAO();
//
//        //lay warehouse cua operator
//        Warehouse warehouse = warehouseDAO.getWarehouseByUser(user.getUserId());
//        if (warehouse == null) {
//            request.setAttribute("error", "No warehouse assigned.");
//
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/operator-dashboard.jsp"
//            ).forward(request, response);
//
//            return;
//        }
//
//        // lay device cua warehouse
//        Device device = deviceDAO.getDeviceByWarehouse(
//                warehouse.getWarehouseId());
//        DashboardData dashboard = new DashboardData();
//        SensorData latestSensor = null;
//        List<SensorData> recentSensors = null;
//        if (device != null) {
//            // lay sensor
//
//            latestSensor = sensorDAO.getLatestSensorData(device.getDeviceId());
//            //lay 6 sensor
//            recentSensors = sensorDAO.getRecentSensorData(device.getDeviceId(), 6);
//
//            //device data
//            dashboard.setMode(device.getMode());
//            dashboard.setRoofStatus(device.getRoofStatus());
//            dashboard.setLastSeen(device.getLastSeen());
//
//            //online/offline
//            String connectionStatus = "OFFLINE";
//            if (device.getLastSeen() != null) {
//                long diff = System.currentTimeMillis()
//                        - device.getLastSeen().getTime();
//
//                if (diff <= 30000) {
//                    connectionStatus = "ONLINE";
//
//                }
//                dashboard.setConnectionStatus(connectionStatus);
//                //sensor data
//
//                if (latestSensor != null) {
//                    dashboard.setTemperature(latestSensor.getTemperature());
//                    dashboard.setHumidity(latestSensor.getHumidity());
//                    dashboard.setRainStatus(latestSensor.getRainStatus());
//                    dashboard.setLightStatus(latestSensor.getLightStatus());
//                    dashboard.setRecordedAt(latestSensor.getRecordedAt());
//
//                }
//                //warning
//                String warning = "NORMAL";
//                if ("OFFLINE".equals(connectionStatus)) {
//                    warning = "DEVICE OFFLINE";
//
//                } else if ("RAINING".equals(
//                        latestSensor.getRainStatus())) {
//                    warning = "RAIN DETECTED";
//                    dashboard.setWarning(warning);
//                } else {
//
//                    dashboard.setWarning(
//                            "NO SENSOR DATA"
//                    );
//                }
//            } else {
//
//                // KHONG CO DEVICE
//                dashboard.setConnectionStatus("OFFLINE");
//                dashboard.setWarning("NO DEVICE");
//            }
//
//            DryingBatch activeBatch = batchDAO.getActiveBatchByOperator(
//                    user.getUserId());
//
//            //SET 5 REQUEST
//            request.setAttribute(
//                    "warehouse",
//                    warehouse
//            );
//
//            request.setAttribute(
//                    "device",
//                    device
//            );
//
//            request.setAttribute(
//                    "dashboard",
//                    dashboard
//            );
//
//            request.setAttribute(
//                    "activeBatch",
//                    activeBatch
//            );
//
//            request.setAttribute(
//                    "recentSensors",
//                    recentSensors
//            );
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/operator-dashboard.jsp"
//            ).forward(request, response);
//        
//    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Dashboard Controller";
    }// </editor-fold>

}
