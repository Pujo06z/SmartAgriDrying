package controller;

import dao.DeviceDAO;
import dao.WarehouseDAO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Device;
import model.User;
import model.Warehouse;

@WebServlet(
        name = "DeviceManagementController",
        urlPatterns = {"/devices"}
)
public class DeviceManagementController extends HttpServlet {

    private DeviceDAO deviceDAO;
    private WarehouseDAO warehouseDAO;

    @Override
    public void init()
            throws ServletException {

        deviceDAO = new DeviceDAO();
        warehouseDAO = new WarehouseDAO();
    }

    // =========================================================
    // PROCESS REQUEST
    // =========================================================
    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession();

       

        User loginUser
                = (User) session.getAttribute(
                        "LOGIN_USER"
                );

        String role
                = loginUser.getRole();

        // =====================================================
        // 2. ADMIN + MANAGER
        // =====================================================
        if (!"ADMIN".equals(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );

            return;
        }

        try {

            // =================================================
            // GET
            // =================================================
            if ("GET".equalsIgnoreCase(
                    request.getMethod())) {

                loadPage(
                        request,
                        response
                );

                return;
            }

            // =================================================
            // POST - ADMIN ONLY
            // =================================================
            if ("POST".equalsIgnoreCase(
                    request.getMethod())) {

                if (!"ADMIN".equals(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/devices"
                    );

                    return;
                }

                String action
                        = request.getParameter(
                                "action"
                        );

                if (action == null
                        || action.trim().isEmpty()) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/devices"
                    );

                    return;
                }

                switch (action) {

                    case "add":

                        addDevice(
                                request,
                                response,
                                loginUser
                        );

                        break;

                    case "update":

                        updateDevice(
                                request,
                                response,
                                loginUser
                        );

                        break;

                    case "toggleStatus":

                        toggleStatus(
                                request,
                                response
                        );

                        break;

                    default:

                        response.sendRedirect(
                                request.getContextPath()
                                + "/devices"
                        );

                        break;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to process Device Management."
            );

            try {

                loadPage(
                        request,
                        response
                );

            } catch (Exception ex) {

                throw new ServletException(
                        ex
                );
            }
        }
    }

    // =========================================================
    // LOAD PAGE
    // =========================================================
    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        // =====================================================
        // 1. GET ALL DEVICES
        // =====================================================
        List<Device> deviceList
                = deviceDAO.getAllDevices();

        // =====================================================
        // 2. ONLINE / OFFLINE MAP
        // =====================================================
        Map<String, Boolean> deviceOnlineMap
                = new HashMap<String, Boolean>();

        long now
                = System.currentTimeMillis();

        for (Device device : deviceList) {

            boolean online = false;

            if (device.getLastSeen() != null
                    && "ACTIVE".equals(device.getStatus())) {

                long diff
                        = now
                        - device.getLastSeen().getTime();

                online
                        = diff <= 30000;
            }

            deviceOnlineMap.put(
                    device.getDeviceId(),
                    online
            );
        }

        // =====================================================
        // 3. GET WAREHOUSES
        // =====================================================
        List<Warehouse> warehouseList
                = warehouseDAO.getAllWarehouses();

        // =====================================================
        // 4. STATISTICS
        // =====================================================
        int totalDevices
                = deviceList.size();

        int activeDevices = 0;

        for (Device device : deviceList) {

            if ("ACTIVE".equals(
                    device.getStatus())) {

                activeDevices++;
            }
        }

        int inactiveDevices
                = totalDevices - activeDevices;

        int onlineDevices
                = deviceDAO.countOnline();

        // =====================================================
        // 5. SET ATTRIBUTE
        // =====================================================
        request.setAttribute(
                "deviceList",
                deviceList
        );

        request.setAttribute(
                "deviceOnlineMap",
                deviceOnlineMap
        );

        request.setAttribute(
                "warehouseList",
                warehouseList
        );

        request.setAttribute(
                "totalDevices",
                totalDevices
        );

        request.setAttribute(
                "activeDevices",
                activeDevices
        );

        request.setAttribute(
                "inactiveDevices",
                inactiveDevices
        );

        request.setAttribute(
                "onlineDevices",
                onlineDevices
        );

        // =====================================================
        // 6. FORWARD
        // =====================================================
        request.getRequestDispatcher(
                "/WEB-INF/views/device-management.jsp"
        ).forward(
                request,
                response
        );
    }
//    private void loadPage(
//            HttpServletRequest request,
//            HttpServletResponse response,
//            User loginUser)
//            throws Exception {
//
//
//        List<Device> deviceList;
//
//
//        // =====================================================
//        // ADMIN
//        // =====================================================
//
//        if ("ADMIN".equals(
//                loginUser.getRole())) {
//
//
//            deviceList =
//                    deviceDAO.getAllDevices();
//        }
//
//
//        // =====================================================
//        // MANAGER
//        // =====================================================
//
//        else {
//
//
//            deviceList =
//                    deviceDAO
//                            .getDevicesByManager(
//                                    loginUser.getUserId()
//                            );
//        }
//
//
//        // =====================================================
//        // WAREHOUSE LIST
//        // Dùng cho form Add / Edit của Admin
//        // =====================================================
//
//        List<Warehouse> warehouseList =
//                warehouseDAO.getAllWarehouses();
//
//
//        // =====================================================
//        // STATISTICS
//        // =====================================================
//
//        int totalDevices =
//                deviceList.size();
//
//
//        int activeDevices = 0;
//
//
//        for (Device device : deviceList) {
//
//            if ("ACTIVE".equals(
//                    device.getStatus())) {
//
//                activeDevices++;
//            }
//        }
//
//
//        int inactiveDevices =
//                totalDevices
//                - activeDevices;
//
//
//        int onlineDevices;
//
//
//        if ("ADMIN".equals(
//                loginUser.getRole())) {
//
//            onlineDevices =
//                    deviceDAO.countOnline();
//
//        } else {
//
//            onlineDevices =
//                    deviceDAO
//                            .countOnlineDevicesByManager(
//                                    loginUser.getUserId()
//                            );
//        }
//
//
//        // =====================================================
//        // SET ATTRIBUTE
//        // =====================================================
//
//        request.setAttribute(
//                "deviceList",
//                deviceList
//        );
//
//
//        request.setAttribute(
//                "warehouseList",
//                warehouseList
//        );
//
//
//        request.setAttribute(
//                "totalDevices",
//                totalDevices
//        );
//
//
//        request.setAttribute(
//                "activeDevices",
//                activeDevices
//        );
//
//
//        request.setAttribute(
//                "inactiveDevices",
//                inactiveDevices
//        );
//
//
//        request.setAttribute(
//                "onlineDevices",
//                onlineDevices
//        );
//
//
//        // =====================================================
//        // JSP
//        // =====================================================
//
//        request.getRequestDispatcher(
//                "/WEB-INF/views/device-management.jsp"
//        ).forward(
//                request,
//                response
//        );
//    }

    // =========================================================
    // ADD DEVICE
    // =========================================================
    private void addDevice(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String deviceId
                = request.getParameter(
                        "deviceId"
                );

        String deviceCode
                = request.getParameter(
                        "deviceCode"
                );

        String deviceName
                = request.getParameter(
                        "deviceName"
                );

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        // =====================================================
        // VALIDATION
        // =====================================================
        if (deviceId == null
                || deviceId.trim().isEmpty()
                || deviceCode == null
                || deviceCode.trim().isEmpty()
                || deviceName == null
                || deviceName.trim().isEmpty()
                || warehouseId == null
                || warehouseId.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please enter all required device information."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        deviceId
                = deviceId.trim();

        deviceCode
                = deviceCode.trim();

        deviceName
                = deviceName.trim();

        warehouseId
                = warehouseId.trim();

        // =====================================================
        // DEVICE ID DUPLICATE
        // =====================================================
        if (deviceDAO.getById(
                deviceId) != null) {

            request.setAttribute(
                    "error",
                    "Device ID already exists."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // DEVICE CODE DUPLICATE
        // =====================================================
        if (deviceDAO.getByCode(
                deviceCode) != null) {

            request.setAttribute(
                    "error",
                    "Device code already exists."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // CHECK WAREHOUSE
        // =====================================================
        Warehouse warehouse
                = warehouseDAO.getById(
                        warehouseId
                );

        if (warehouse == null) {

            request.setAttribute(
                    "error",
                    "Warehouse not found."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // INSERT
        // =====================================================
        boolean success
                = deviceDAO.add(
                        deviceId,
                        deviceCode,
                        deviceName,
                        warehouseId
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to add device."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/devices"
        );
    }

    // =========================================================
    // UPDATE DEVICE
    // =========================================================
    private void updateDevice(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String deviceId
                = request.getParameter(
                        "deviceId"
                );

        String deviceCode
                = request.getParameter(
                        "deviceCode"
                );

        String deviceName
                = request.getParameter(
                        "deviceName"
                );

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        if (deviceId == null
                || deviceId.trim().isEmpty()
                || deviceCode == null
                || deviceCode.trim().isEmpty()
                || deviceName == null
                || deviceName.trim().isEmpty()
                || warehouseId == null
                || warehouseId.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Device information cannot be empty."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        deviceId
                = deviceId.trim();

        deviceCode
                = deviceCode.trim();

        deviceName
                = deviceName.trim();

        warehouseId
                = warehouseId.trim();

        // =====================================================
        // CURRENT DEVICE
        // =====================================================
        Device currentDevice
                = deviceDAO.getById(
                        deviceId
                );

        if (currentDevice == null) {

            request.setAttribute(
                    "error",
                    "Device not found."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // CODE DUPLICATE
        // =====================================================
        Device sameCodeDevice
                = deviceDAO.getByCode(
                        deviceCode
                );

        if (sameCodeDevice != null
                && !sameCodeDevice
                        .getDeviceId()
                        .equals(deviceId)) {

            request.setAttribute(
                    "error",
                    "Device code already exists."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // WAREHOUSE EXISTS
        // =====================================================
        if (warehouseDAO.getById(
                warehouseId) == null) {

            request.setAttribute(
                    "error",
                    "Warehouse not found."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =====================================================
        // UPDATE
        // =====================================================
        boolean success
                = deviceDAO.update(
                        deviceId,
                        deviceCode,
                        deviceName,
                        warehouseId
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to update device."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/devices"
        );
    }

    // =========================================================
    // ACTIVE / INACTIVE
    // =========================================================
    private void toggleStatus(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String deviceId
                = request.getParameter(
                        "deviceId"
                );

        if (deviceId == null
                || deviceId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/devices"
            );

            return;
        }

        deviceDAO.updateStatus(
                deviceId.trim()
        );

        response.sendRedirect(
                request.getContextPath()
                + "/devices"
        );
    }

    // =========================================================
    // GET
    // =========================================================
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

    // =========================================================
    // POST
    // =========================================================
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

        return "Device Management Controller";
    }
}
