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
import java.util.List;
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

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("LOGIN_USER");
        String role = user.getRole();

        try {
            if ("ADMIN".equals(role)) {
                dao.UserDAO userDAO = new dao.UserDAO();
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                DeviceDAO deviceDAO = new DeviceDAO();
                DryingBatchDAO batchDAO = new DryingBatchDAO();

                request.setAttribute("totalUsers", userDAO.countAll());
                request.setAttribute("activeWarehouses", warehouseDAO.countActive());
                request.setAttribute("onlineDevices", deviceDAO.countOnlineDevices());
                request.setAttribute("activeBatches", batchDAO.countAllActive());
                request.setAttribute("warehouseList", warehouseDAO.getAllWarehouses());

                request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
                return;

            } else if ("MANAGER".equals(role)) {
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                DeviceDAO deviceDAO = new DeviceDAO();
                DryingBatchDAO batchDAO = new DryingBatchDAO();
                SensorDataDAO sensorDAO = new SensorDataDAO();

                String managerId = user.getUserId();

                request.setAttribute("warehouseList", warehouseDAO.getWarehousesByManager(managerId));
                request.setAttribute("assignedWarehousesCount", warehouseDAO.getWarehousesByManager(managerId).size());
                request.setAttribute("onlineDevices", deviceDAO.countOnlineDevicesByManager(managerId));
                request.setAttribute("activeBatches", batchDAO.countActiveByManager(managerId));
                request.setAttribute("deviceList", deviceDAO.getDevicesByManager(managerId));
                request.setAttribute("latestSensors", sensorDAO.getLatestByManager(managerId));

                request.getRequestDispatcher("/WEB-INF/views/manager-dashboard.jsp").forward(request, response);
                return;

            } else if ("OPERATOR".equals(role)) {
                loadOperatorDashboard(request, response, user);
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } catch (Exception e) {
            log("Error at DashboardController: " + e.toString());
            request.setAttribute("error", "Cannot load dashboard.");
            request.getRequestDispatcher("/WEB-INF/views/operator-dashboard.jsp").forward(request, response);
        }
    }

    private void loadOperatorDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        DeviceDAO deviceDAO = new DeviceDAO();
        SensorDataDAO sensorDAO = new SensorDataDAO();
        DryingBatchDAO batchDAO = new DryingBatchDAO();

        Warehouse warehouse = warehouseDAO.getWarehouseByUser(user.getUserId());

        if (warehouse == null) {
            request.setAttribute("error", "No warehouse assigned.");
            request.getRequestDispatcher("/WEB-INF/views/operator-dashboard.jsp").forward(request, response);
            return;
        }

        Device device = deviceDAO.getDeviceByWarehouse(warehouse.getWarehouseId());
        DashboardData dashboard = new DashboardData();
        SensorData latestSensor = null;
        List<SensorData> recentSensors = null;

        if (device != null) {
            dashboard.setMode(device.getMode());
            dashboard.setRoofStatus(device.getRoofStatus());
            dashboard.setLastSeen(device.getLastSeen());

            String connectionStatus = "OFFLINE";
            if (device.getLastSeen() != null) {
                long diff = System.currentTimeMillis() - device.getLastSeen().getTime();
                if (diff <= 30000) {
                    connectionStatus = "ONLINE";
                }
            }
            dashboard.setConnectionStatus(connectionStatus);

            latestSensor = sensorDAO.getLatestSensorData(device.getDeviceId());
            recentSensors = sensorDAO.getRecentSensorData(device.getDeviceId(), 6);

            if (latestSensor != null) {
                dashboard.setTemperature(latestSensor.getTemperature());
                dashboard.setHumidity(latestSensor.getHumidity());
                dashboard.setRainStatus(latestSensor.getRainStatus());
                dashboard.setLightStatus(latestSensor.getLightStatus());
                dashboard.setRecordedAt(latestSensor.getRecordedAt());

                String warning = "NORMAL";
                if ("OFFLINE".equals(connectionStatus)) {
                    warning = "DEVICE OFFLINE";
                } else if ("RAINING".equals(latestSensor.getRainStatus())) {
                    warning = "RAIN DETECTED";
                }
                dashboard.setWarning(warning);
            } else {
                dashboard.setWarning("NO SENSOR DATA");
            }
        } else {
            dashboard.setConnectionStatus("OFFLINE");
            dashboard.setWarning("NO DEVICE");
        }

        DryingBatch activeBatch = batchDAO.getActiveBatchByOperator(user.getUserId());

        request.setAttribute("warehouse", warehouse);
        request.setAttribute("device", device);
        request.setAttribute("dashboard", dashboard);
        request.setAttribute("activeBatch", activeBatch);
        request.setAttribute("recentSensors", recentSensors);

        request.getRequestDispatcher("/WEB-INF/views/operator-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Dashboard Controller";
    }
}
