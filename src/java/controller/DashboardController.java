///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import dao.DeviceDAO;
//import dao.DryingBatchDAO;
//import dao.SensorDataDAO;
//import dao.UserDAO;
//import dao.WarehouseDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import model.DashboardData;
//import model.Device;
//import model.DryingBatch;
//import model.SensorData;
//import model.User;
//import model.Warehouse;
//
///**
// *
// * @author ADMIN
// */
//@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
//public class DashboardController extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//
//        User user
//                = (User) session.getAttribute("LOGIN_USER");
//
//        String role = user.getRole();
//        try {
//            if ("ADMIN".equals(role)) {
//
//                loadAdminDashboard(
//                        request,
//                        response
//                );
//
//                return;
//            } else if ("MANAGER".equals(role)) {
//
//                loadManagerDashboard(
//                        request,
//                        response,
//                        user
//                );
//
//                return;
//            } else if ("OPERATOR".equals(role)) {
//
//                loadOperatorDashboard(request, response, user);
//                return;
//
//            } else {
//
//                response.sendRedirect(
//                        request.getContextPath() + "/login"
//                );
//            }
//        } catch (Exception e) {
//
//            log("Error at DashboardController: " + e.toString());
//
//            request.setAttribute(
//                    "error",
//                    "Cannot load dashboard."
//            );
//
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/operator-dashboard.jsp"
//            ).forward(request, response);
//        }
//    }
//
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
//        // ==============================
//        // 1. GET WAREHOUSE
//        // ==============================
//        Warehouse warehouse
//                = warehouseDAO.getWarehouseByUser(
//                        user.getUserId()
//                );
//
//        if (warehouse == null) {
//
//            request.setAttribute(
//                    "error",
//                    "No warehouse assigned."
//            );
//
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/operator-dashboard.jsp"
//            ).forward(request, response);
//
//            return;
//        }
//
//        // ==============================
//        // 2. GET DEVICE
//        // ==============================
//        Device device
//                = deviceDAO.getDeviceByWarehouse(
//                        warehouse.getWarehouseId()
//                );
//
//        DashboardData dashboard
//                = new DashboardData();
//
//        SensorData latestSensor = null;
//
//        List<SensorData> recentSensors = null;
//
//        // ==============================
//        // 3. IF DEVICE EXISTS
//        // ==============================
//        if (device != null) {
//
//            // Device data
//            dashboard.setMode(
//                    device.getMode()
//            );
//
//            dashboard.setRoofStatus(
//                    device.getRoofStatus()
//            );
//
//            dashboard.setLastSeen(
//                    device.getLastSeen()
//            );
//
//            // ==============================
//            // 4. ONLINE / OFFLINE
//            // ==============================
//            String connectionStatus = "OFFLINE";
//
//            if (device.getLastSeen() != null) {
//
//                long diff
//                        = System.currentTimeMillis()
//                        - device.getLastSeen().getTime();
//
//                if (diff <= 30000) {
//                    connectionStatus = "ONLINE";
//                }
//            }
//
//            dashboard.setConnectionStatus(
//                    connectionStatus
//            );
//
//            // ==============================
//            // 5. SENSOR DATA
//            // ==============================
//            latestSensor
//                    = sensorDAO.getLatestSensorData(
//                            device.getDeviceId()
//                    );
//
//            recentSensors
//                    = sensorDAO.getRecentSensorData(
//                            device.getDeviceId(),
//                            6
//                    );
//
//            if (latestSensor != null) {
//
//                dashboard.setTemperature(
//                        latestSensor.getTemperature()
//                );
//
//                dashboard.setHumidity(
//                        latestSensor.getHumidity()
//                );
//
//                dashboard.setRainStatus(
//                        latestSensor.getRainStatus()
//                );
//
//                dashboard.setLightStatus(
//                        latestSensor.getLightStatus()
//                );
//
//                dashboard.setRecordedAt(
//                        latestSensor.getRecordedAt()
//                );
//
//                // ==============================
//                // 6. WARNING
//                // ==============================
//                String warning = "NORMAL";
//
//                if ("OFFLINE".equals(connectionStatus)) {
//
//                    warning = "DEVICE OFFLINE";
//
//                } else if ("RAINING".equals(
//                        latestSensor.getRainStatus())) {
//
//                    warning = "RAIN DETECTED";
//                }
//
//                dashboard.setWarning(
//                        warning
//                );
//
//            } else {
//
//                // Has device but no sensor data yet
//                dashboard.setWarning(
//                        "NO SENSOR DATA"
//                );
//            }
//
//        } else {
//
//            // ==============================
//            // NO DEVICE
//            // ==============================
//            dashboard.setConnectionStatus(
//                    "OFFLINE"
//            );
//
//            dashboard.setWarning(
//                    "NO DEVICE"
//            );
//        }
//
//        // ==============================
//        // 7. ACTIVE BATCH
//        // ==============================
//        DryingBatch activeBatch
//                = batchDAO.getActiveBatchByOperator(
//                        user.getUserId()
//                );
//
//        // ==============================
//        // 8. SET REQUEST ATTRIBUTES
//        // ==============================
//        request.setAttribute(
//                "warehouse",
//                warehouse
//        );
//
//        request.setAttribute(
//                "device",
//                device
//        );
//
//        request.setAttribute(
//                "dashboard",
//                dashboard
//        );
//
//        request.setAttribute(
//                "activeBatch",
//                activeBatch
//        );
//
//        request.setAttribute(
//                "recentSensors",
//                recentSensors
//        );
//
//        // ==============================
//        // 9. FORWARD JSP
//        // ==============================
//        request.getRequestDispatcher(
//                "/WEB-INF/views/operator-dashboard.jsp"
//        ).forward(request, response);
//    }
//
//    // =========================================================
//    // ADMIN DASHBOARD
//    // =========================================================
//    private void loadAdminDashboard(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws Exception {
//
//        UserDAO userDAO
//                = new UserDAO();
//
//        WarehouseDAO warehouseDAO
//                = new WarehouseDAO();
//
//        DeviceDAO deviceDAO
//                = new DeviceDAO();
//
//        DryingBatchDAO batchDAO
//                = new DryingBatchDAO();
//
//        // =====================================================
//        // USER
//        // =====================================================
//        int totalUsers
//                = userDAO.countAll();
//
//        int activeUsers
//                = userDAO.countActive();
//
//        int inactiveUsers
//                = totalUsers - activeUsers;
//
//        // =====================================================
//        // WAREHOUSE
//        // =====================================================
//        int totalWarehouses
//                = warehouseDAO.countAll();
//
//        int activeWarehouses
//                = warehouseDAO.countActive();
//
//        int inactiveWarehouses
//                = totalWarehouses - activeWarehouses;
//
//        // =====================================================
//        // DEVICE
//        // =====================================================
//        int totalDevices
//                = deviceDAO.countAll();
//
//        int onlineDevices
//                = deviceDAO.countOnline();
//
//        int offlineDevices
//                = totalDevices - onlineDevices;
//
//        // =====================================================
//        // DRYING BATCH
//        // =====================================================
//        int activeBatches
//                = batchDAO.countAllActive();
//
//        // =====================================================
//        // SET ATTRIBUTE
//        // =====================================================
//        request.setAttribute(
//                "totalUsers",
//                totalUsers
//        );
//
//        request.setAttribute(
//                "activeUsers",
//                activeUsers
//        );
//
//        request.setAttribute(
//                "inactiveUsers",
//                inactiveUsers
//        );
//
//        request.setAttribute(
//                "totalWarehouses",
//                totalWarehouses
//        );
//
//        request.setAttribute(
//                "activeWarehouses",
//                activeWarehouses
//        );
//
//        request.setAttribute(
//                "inactiveWarehouses",
//                inactiveWarehouses
//        );
//
//        request.setAttribute(
//                "totalDevices",
//                totalDevices
//        );
//
//        request.setAttribute(
//                "onlineDevices",
//                onlineDevices
//        );
//
//        request.setAttribute(
//                "offlineDevices",
//                offlineDevices
//        );
//
//        request.setAttribute(
//                "activeBatches",
//                activeBatches
//        );
//
//        // =====================================================
//        // JSP
//        // =====================================================
//        request.getRequestDispatcher(
//                "/WEB-INF/views/admin-dashboard.jsp"
//        ).forward(
//                request,
//                response
//        );
//    }
//
//    private void loadManagerDashboard(
//            HttpServletRequest request,
//            HttpServletResponse response,
//            User user)
//            throws Exception {
//
//        WarehouseDAO warehouseDAO
//                = new WarehouseDAO();
//
//        DeviceDAO deviceDAO
//                = new DeviceDAO();
//
//        SensorDataDAO sensorDAO
//                = new SensorDataDAO();
//
//        DryingBatchDAO batchDAO
//                = new DryingBatchDAO();
//
//        // ==========================================
//        // 1. GET MANAGER'S WAREHOUSE LIST
//        // ==========================================
//        List<Warehouse> warehouseList
//                = warehouseDAO.getWarehousesByManager(
//                        user.getUserId()
//                );
//
//        if (warehouseList == null
//                || warehouseList.isEmpty()) {
//
//            request.setAttribute(
//                    "error",
//                    "No warehouse assigned."
//            );
//
//            request.setAttribute(
//                    "warehouseList",
//                    warehouseList
//            );
//
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/manager-dashboard.jsp"
//            ).forward(request, response);
//
//            return;
//        }
//
//        // ==========================================
//        // 2. WAREHOUSE BEING VIEWED BY MANAGER
//        // ==========================================
//        String selectedWarehouseId
//                = request.getParameter(
//                        "warehouseId"
//                );
//
//        Warehouse warehouse = null;
//
//        // If Manager selects a Warehouse from the dropdown
//        if (selectedWarehouseId != null
//                && !selectedWarehouseId.trim().isEmpty()) {
//
//            for (Warehouse w : warehouseList) {
//
//                if (selectedWarehouseId.equals(
//                        w.getWarehouseId())) {
//
//                    warehouse = w;
//                    break;
//                }
//            }
//        }
//
//        // If not selected
//        // default to the first Warehouse
//        if (warehouse == null) {
//
//            warehouse
//                    = warehouseList.get(0);
//        }
//
//        // ==========================================
//        // 3. WAREHOUSE DEVICE
//        // ==========================================
//        Device device
//                = deviceDAO.getDeviceByWarehouse(
//                        warehouse.getWarehouseId()
//                );
//
//        DashboardData dashboard
//                = new DashboardData();
//
//        List<SensorData> recentSensors
//                = new java.util.ArrayList<>();
//
//        // ==========================================
//        // 4. DEVICE + SENSOR
//        // ==========================================
//        if (device != null) {
//
//            dashboard.setMode(
//                    device.getMode()
//            );
//
//            dashboard.setRoofStatus(
//                    device.getRoofStatus()
//            );
//
//            dashboard.setLastSeen(
//                    device.getLastSeen()
//            );
//
//            // ======================================
//            // ONLINE / OFFLINE
//            // ======================================
//            String connectionStatus
//                    = "OFFLINE";
//
//            if (device.getLastSeen() != null) {
//
//                long diff
//                        = System.currentTimeMillis()
//                        - device.getLastSeen().getTime();
//
//                if (diff <= 30000) {
//
//                    connectionStatus
//                            = "ONLINE";
//                }
//            }
//
//            dashboard.setConnectionStatus(
//                    connectionStatus
//            );
//
//            // ======================================
//            // LATEST SENSOR
//            // ======================================
//            SensorData latestSensor
//                    = sensorDAO.getLatestSensorData(
//                            device.getDeviceId()
//                    );
//
//            // ======================================
//            // 6 RECENT SENSORS
//            // ======================================
//            recentSensors
//                    = sensorDAO.getRecentSensorData(
//                            device.getDeviceId(),
//                            6
//                    );
//
//            if (latestSensor != null) {
//
//                dashboard.setTemperature(
//                        latestSensor.getTemperature()
//                );
//
//                dashboard.setHumidity(
//                        latestSensor.getHumidity()
//                );
//
//                dashboard.setRainStatus(
//                        latestSensor.getRainStatus()
//                );
//
//                dashboard.setLightStatus(
//                        latestSensor.getLightStatus()
//                );
//
//                dashboard.setRecordedAt(
//                        latestSensor.getRecordedAt()
//                );
//
//                // ==================================
//                // WARNING
//                // ==================================
//                String warning
//                        = "NORMAL";
//
//                if ("OFFLINE".equals(
//                        connectionStatus)) {
//
//                    warning
//                            = "DEVICE OFFLINE";
//
//                } else if ("RAINING".equals(
//                        latestSensor.getRainStatus())) {
//
//                    warning
//                            = "RAIN DETECTED";
//                }
//
//                dashboard.setWarning(
//                        warning
//                );
//
//            } else {
//
//                dashboard.setWarning(
//                        "NO SENSOR DATA"
//                );
//            }
//
//        } else {
//
//            dashboard.setConnectionStatus(
//                    "OFFLINE"
//            );
//
//            dashboard.setWarning(
//                    "NO DEVICE"
//            );
//        }
//
//        // ==========================================
//        // 5. WAREHOUSE ACTIVE BATCHES
//        // ==========================================
//        List<DryingBatch> activeBatches
//                = batchDAO.getActiveBatchesByWarehouse(
//                        warehouse.getWarehouseId()
//                );
//
//        // ==========================================
//        // 6. SEND DATA TO JSP
//        // ==========================================
//        request.setAttribute(
//                "warehouseList",
//                warehouseList
//        );
//
//        request.setAttribute(
//                "warehouse",
//                warehouse
//        );
//
//        request.setAttribute(
//                "device",
//                device
//        );
//
//        request.setAttribute(
//                "dashboard",
//                dashboard
//        );
//
//        request.setAttribute(
//                "activeBatches",
//                activeBatches
//        );
//
//        request.setAttribute(
//                "activeBatchCount",
//                activeBatches.size()
//        );
//
//        request.setAttribute(
//                "recentSensors",
//                recentSensors
//        );
//
//        // ==========================================
//        // 7. FORWARD
//        // ==========================================
//        request.getRequestDispatcher(
//                "/WEB-INF/views/manager-dashboard.jsp"
//        ).forward(request, response);
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Dashboard Controller";
//    }// </editor-fold>
//
//}


package controller;

import dao.DeviceDAO;
import dao.DryingBatchDAO;
import dao.UserDAO;
import dao.WarehouseDAO;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DryingBatch;
import model.User;
import model.Warehouse;

@WebServlet(
        name = "DashboardController",
        urlPatterns = {"/dashboard"}
)
public class DashboardController extends HttpServlet {

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // ==========================================
        // CHECK LOGIN
        // ==========================================
        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        User user =
                (User) session.getAttribute(
                        "LOGIN_USER"
                );

        String role =
                user.getRole();

        try {

            // ==========================================
            // LOAD DASHBOARD BY ROLE
            // ==========================================
            if ("ADMIN".equals(role)) {

                loadAdminDashboard(
                        request,
                        response
                );

                return;
            }

            if ("MANAGER".equals(role)) {

                loadManagerDashboard(
                        request,
                        response,
                        user
                );

                return;
            }

            if ("OPERATOR".equals(role)) {

                loadOperatorDashboard(
                        request,
                        response,
                        user
                );

                return;
            }

            // Unknown role
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

        } catch (Exception e) {

            log(
                    "Error at DashboardController: "
                    + e.toString()
            );

            request.setAttribute(
                    "error",
                    "Cannot load dashboard."
            );

            if ("ADMIN".equals(role)) {

                request.getRequestDispatcher(
                        "/WEB-INF/views/admin-dashboard.jsp"
                ).forward(
                        request,
                        response
                );

            } else if ("MANAGER".equals(role)) {

                request.getRequestDispatcher(
                        "/WEB-INF/views/manager-dashboard.jsp"
                ).forward(
                        request,
                        response
                );

            } else {

                request.getRequestDispatcher(
                        "/WEB-INF/views/operator-dashboard.jsp"
                ).forward(
                        request,
                        response
                );
            }
        }
    }


    // =========================================================
    // OPERATOR DASHBOARD
    // =========================================================
    private void loadOperatorDashboard(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        WarehouseDAO warehouseDAO =
                new WarehouseDAO();

        DryingBatchDAO batchDAO =
                new DryingBatchDAO();


        // ==========================================
        // 1. GET OPERATOR'S WAREHOUSE
        // ==========================================
        Warehouse warehouse =
                warehouseDAO.getWarehouseByUser(
                        user.getUserId()
                );


        if (warehouse == null) {

            request.setAttribute(
                    "error",
                    "No warehouse assigned."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/operator-dashboard.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // 2. GET ACTIVE BATCH
        // ==========================================
        DryingBatch activeBatch =
                batchDAO.getActiveBatchByOperator(
                        user.getUserId()
                );


        // ==========================================
        // 3. SEND INITIAL BUSINESS DATA TO JSP
        // ==========================================
        request.setAttribute(
                "warehouse",
                warehouse
        );

        request.setAttribute(
                "activeBatch",
                activeBatch
        );


        // ==========================================
        // 4. FORWARD TO JSP
        // ==========================================
        request.getRequestDispatcher(
                "/WEB-INF/views/operator-dashboard.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // ADMIN DASHBOARD
    // =========================================================
    private void loadAdminDashboard(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        UserDAO userDAO =
                new UserDAO();

        WarehouseDAO warehouseDAO =
                new WarehouseDAO();

        DeviceDAO deviceDAO =
                new DeviceDAO();

        DryingBatchDAO batchDAO =
                new DryingBatchDAO();


        // ==========================================
        // USER STATISTICS
        // ==========================================
        int totalUsers =
                userDAO.countAll();

        int activeUsers =
                userDAO.countActive();

        int inactiveUsers =
                totalUsers - activeUsers;


        // ==========================================
        // WAREHOUSE STATISTICS
        // ==========================================
        int totalWarehouses =
                warehouseDAO.countAll();

        int activeWarehouses =
                warehouseDAO.countActive();

        int inactiveWarehouses =
                totalWarehouses
                - activeWarehouses;


        // ==========================================
        // DEVICE STATISTICS
        // ==========================================
        int totalDevices =
                deviceDAO.countAll();


        // ==========================================
        // BATCH STATISTICS
        // ==========================================
        int activeBatches =
                batchDAO.countAllActive();


        // ==========================================
        // SEND INITIAL DATA TO JSP
        // ==========================================
        request.setAttribute(
                "totalUsers",
                totalUsers
        );

        request.setAttribute(
                "activeUsers",
                activeUsers
        );

        request.setAttribute(
                "inactiveUsers",
                inactiveUsers
        );

        request.setAttribute(
                "totalWarehouses",
                totalWarehouses
        );

        request.setAttribute(
                "activeWarehouses",
                activeWarehouses
        );

        request.setAttribute(
                "inactiveWarehouses",
                inactiveWarehouses
        );

        request.setAttribute(
                "totalDevices",
                totalDevices
        );

        request.setAttribute(
                "activeBatches",
                activeBatches
        );


        // ==========================================
        // FORWARD TO JSP
        // ==========================================
        request.getRequestDispatcher(
                "/WEB-INF/views/admin-dashboard.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // MANAGER DASHBOARD
    // =========================================================
    private void loadManagerDashboard(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        WarehouseDAO warehouseDAO =
                new WarehouseDAO();

        DryingBatchDAO batchDAO =
                new DryingBatchDAO();


        // ==========================================
        // 1. GET MANAGER'S WAREHOUSE LIST
        // ==========================================
        List<Warehouse> warehouseList =
                warehouseDAO.getWarehousesByManager(
                        user.getUserId()
                );


        if (warehouseList == null
                || warehouseList.isEmpty()) {

            request.setAttribute(
                    "error",
                    "No warehouse assigned."
            );

            request.setAttribute(
                    "warehouseList",
                    warehouseList
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager-dashboard.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // 2. GET SELECTED WAREHOUSE
        // ==========================================
        String selectedWarehouseId =
                request.getParameter(
                        "warehouseId"
                );

        Warehouse warehouse =
                null;


        if (selectedWarehouseId != null
                && !selectedWarehouseId
                        .trim()
                        .isEmpty()) {

            for (Warehouse w : warehouseList) {

                if (selectedWarehouseId.equals(
                        w.getWarehouseId())) {

                    warehouse =
                            w;

                    break;
                }
            }
        }


        // Default to first assigned warehouse
        if (warehouse == null) {

            warehouse =
                    warehouseList.get(0);
        }


        // ==========================================
        // 3. GET ACTIVE BATCHES
        // ==========================================
        List<DryingBatch> activeBatches =
                batchDAO.getActiveBatchesByWarehouse(
                        warehouse.getWarehouseId()
                );


        // ==========================================
        // 4. SEND INITIAL BUSINESS DATA TO JSP
        // ==========================================
        request.setAttribute(
                "warehouseList",
                warehouseList
        );

        request.setAttribute(
                "warehouse",
                warehouse
        );

        request.setAttribute(
                "activeBatches",
                activeBatches
        );

        request.setAttribute(
                "activeBatchCount",
                activeBatches.size()
        );


        // ==========================================
        // 5. FORWARD TO JSP
        // ==========================================
        request.getRequestDispatcher(
                "/WEB-INF/views/manager-dashboard.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }


    @Override
    public String getServletInfo() {

        return "Dashboard Controller";
    }
}