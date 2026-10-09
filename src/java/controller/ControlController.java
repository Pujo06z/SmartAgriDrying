/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DeviceDAO;
import dao.EventLogDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Device;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ControlController", urlPatterns = {"/control"})
public class ControlController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ============================================
        // 1. KIỂM TRA LOGIN
        // ============================================
        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        // ============================================
        // 2. LẤY USER
        // ============================================
        User user
                = (User) session.getAttribute(
                        "LOGIN_USER"
                );

        String role
                = user.getRole();

        // Chỉ Operator và Manager được control
        if (!"OPERATOR".equals(role)
                && !"MANAGER".equals(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/dashboard"
            );

            return;
        }

        // ============================================
        // 3. LẤY ACTION
        // ============================================
        String action
                = request.getParameter("action");

        if (action == null
                || action.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/dashboard"
            );

            return;
        }

        // Dùng để Manager quay lại đúng warehouse
        String redirectWarehouseId = null;

        try {

            WarehouseDAO warehouseDAO
                    = new WarehouseDAO();

            DeviceDAO deviceDAO
                    = new DeviceDAO();
            EventLogDAO eventLogDAO
                    = new EventLogDAO();
            Warehouse warehouse = null;

            Device device = null;

            // ============================================
            // 4. OPERATOR
            // ============================================
            if ("OPERATOR".equals(role)) {

                // Operator chỉ có warehouse được assign
                warehouse
                        = warehouseDAO.getWarehouseByUser(
                                user.getUserId()
                        );

                if (warehouse == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard"
                    );

                    return;
                }

                // Device của warehouse Operator
                device
                        = deviceDAO.getDeviceByWarehouse(
                                warehouse.getWarehouseId()
                        );

            } // ============================================
            // 5. MANAGER
            // ============================================
            else if ("MANAGER".equals(role)) {

                String warehouseId
                        = request.getParameter(
                                "warehouseId"
                        );

                String deviceId
                        = request.getParameter(
                                "deviceId"
                        );

                // Thiếu thông tin
                if (warehouseId == null
                        || warehouseId.trim().isEmpty()
                        || deviceId == null
                        || deviceId.trim().isEmpty()) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard"
                    );

                    return;
                }

                redirectWarehouseId
                        = warehouseId;

                // ========================================
                // Kiểm tra warehouse có thuộc Manager
                // ========================================
                boolean warehouseAllowed
                        = warehouseDAO.isAssignedToManager(
                                user.getUserId(),
                                warehouseId
                        );

                if (!warehouseAllowed) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard"
                    );

                    return;
                }

                // ========================================
                // Kiểm tra device có thuộc Manager
                // ========================================
                boolean deviceAllowed
                        = deviceDAO.isAssignedToManager(
                                user.getUserId(),
                                deviceId
                        );

                if (!deviceAllowed) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard?warehouseId="
                            + warehouseId
                    );

                    return;
                }

                // ========================================
                // Lấy đúng Device
                // ========================================
                device
                        = deviceDAO.getById(
                                deviceId
                        );

                if (device == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard?warehouseId="
                            + warehouseId
                    );

                    return;
                }

                // ========================================
                // Device phải đúng Warehouse đang chọn
                // ========================================
                if (!warehouseId.equals(
                        device.getWarehouseId())) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard?warehouseId="
                            + warehouseId
                    );

                    return;
                }
            }

            // ============================================
            // 6. KHÔNG CÓ DEVICE
            // ============================================
            if (device == null) {

                if ("MANAGER".equals(role)
                        && redirectWarehouseId != null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard?warehouseId="
                            + redirectWarehouseId
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/dashboard"
                    );
                }

                return;
            }
            String eventWarehouseId
                    = device.getWarehouseId();
            // ============================================
            // 7. XỬ LÝ ACTION
            // ============================================
            switch (action) {

                // ========================================
                // AUTO
                // ========================================
                case "AUTO":

                    // Chỉ ghi khi mode thật sự thay đổi
                    if (!"AUTO".equals(device.getMode())) {

                        boolean updated
                                = deviceDAO.updateMode(
                                        device.getDeviceId(),
                                        "AUTO"
                                );

                        if (updated) {

                            eventLogDAO.addEvent(
                                    eventWarehouseId,
                                    device.getDeviceId(),
                                    null,
                                    user.getUserId(),
                                    "MODE_CHANGED",
                                    "WEB",
                                    "Changed device mode to AUTO"
                            );
                        }
                    }

                    break;

                // ========================================
                // MANUAL
                // ========================================
                case "MANUAL":

                    if (!"MANUAL".equals(device.getMode())) {

                        boolean updated
                                = deviceDAO.updateMode(
                                        device.getDeviceId(),
                                        "MANUAL"
                                );

                        if (updated) {

                            eventLogDAO.addEvent(
                                    eventWarehouseId,
                                    device.getDeviceId(),
                                    null,
                                    user.getUserId(),
                                    "MODE_CHANGED",
                                    "WEB",
                                    "Changed device mode to MANUAL"
                            );
                        }
                    }

                    break;

                // ========================================
                // OPEN
                // ========================================
                case "OPEN":

                    // Chỉ control mái khi MANUAL
                    if ("MANUAL".equals(device.getMode())
                            && !"OPEN".equals(device.getRoofStatus())) {

                        boolean updated
                                = deviceDAO.updateRoofStatus(
                                        device.getDeviceId(),
                                        "OPEN"
                                );

                        if (updated) {

                            eventLogDAO.addEvent(
                                    eventWarehouseId,
                                    device.getDeviceId(),
                                    null,
                                    user.getUserId(),
                                    "ROOF_OPENED",
                                    "MANUAL",
                                    "Roof manually opened"
                            );
                        }
                    }

                    break;

                // ========================================
                // CLOSE
                // ========================================
                case "CLOSE":

                    // Chỉ control mái khi MANUAL
                    if ("MANUAL".equals(device.getMode())
                            && !"CLOSED".equals(device.getRoofStatus())) {

                        boolean updated
                                = deviceDAO.updateRoofStatus(
                                        device.getDeviceId(),
                                        "CLOSED"
                                );

                        if (updated) {

                            eventLogDAO.addEvent(
                                    eventWarehouseId,
                                    device.getDeviceId(),
                                    null,
                                    user.getUserId(),
                                    "ROOF_CLOSED",
                                    "MANUAL",
                                    "Roof manually closed"
                            );
                        }
                    }

                    break;

                default:
                    break;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        // ============================================
        // 8. QUAY LẠI DASHBOARD
        // ============================================
        if ("MANAGER".equals(role)
                && redirectWarehouseId != null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard?warehouseId="
                    + redirectWarehouseId
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );
        }
    }
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // kiem tra login
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("LOGIN_USER") == null) {
//
//            response.sendRedirect(request.getContextPath() + "/login");
//
//            return;
//        }
//
//        // ============================
//        // 2. lay USER
//        // ============================
//        User user = (User) session.getAttribute("LOGIN_USER");
//
//        if (!"OPERATOR".equals(user.getRole())
//                && !"MANAGER".equals(user.getRole())) {
//
//            response.sendRedirect(request.getContextPath() + "/dashboard");
//
//            return;
//        }
//        // ============================
//        // 3. lay ACTION
//        // ============================
//
//        String action = request.getParameter("action");
//
//        if (action == null) {
//            response.sendRedirect(request.getContextPath() + "/dashboard");
//
//            return;
//        }
//
//        try {
//
//            WarehouseDAO warehouseDAO
//                    = new WarehouseDAO();
//
//            DeviceDAO deviceDAO
//                    = new DeviceDAO();
//
//            // ============================
//            // 4. LẤY WAREHOUSE
//            // ============================
//            Warehouse warehouse
//                    = warehouseDAO.getWarehouseByUser(
//                            user.getUserId()
//                    );
//
//            if (warehouse == null) {
//
//                response.sendRedirect(
//                        request.getContextPath() + "/dashboard"
//                );
//
//                return;
//            }
//// ============================
//            // 5. LẤY DEVICE
//            // ============================
//
//            Device device
//                    = deviceDAO.getDeviceByWarehouse(
//                            warehouse.getWarehouseId()
//                    );
//
//            if (device == null) {
//
//                response.sendRedirect(
//                        request.getContextPath() + "/dashboard"
//                );
//
//                return;
//            }
//
//            // ============================
//            // 6. XỬ LÝ ACTION
//            // ============================
//            switch (action) {
//
//                case "AUTO":
//
//                    deviceDAO.updateMode(
//                            device.getDeviceId(),
//                            "AUTO"
//                    );
//
//                    break;
//
//                case "MANUAL":
//
//                    deviceDAO.updateMode(
//                            device.getDeviceId(),
//                            "MANUAL"
//                    );
//
//                    break;
//
//                case "OPEN":
//
//                    // Chỉ được mở mái khi MANUAL
//                    if ("MANUAL".equals(device.getMode())) {
//
//                        deviceDAO.updateRoofStatus(
//                                device.getDeviceId(),
//                                "OPEN"
//                        );
//                    }
//
//                    break;
//
//                case "CLOSE":
//
//                    // Chỉ được đóng mái khi MANUAL
//                    if ("MANUAL".equals(device.getMode())) {
//
//                        deviceDAO.updateRoofStatus(
//                                device.getDeviceId(),
//                                "CLOSED"
//                        );
//                    }
//
//                    break;
//
//                default:
//                    break;
//            }
//
//        } catch (Exception e) {
//
//            e.printStackTrace();
//        }
//
//        // ============================
//        // 7. QUAY LẠI DASHBOARD
//        // ============================
//        response.sendRedirect(
//                request.getContextPath() + "/dashboard"
//        );
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
        return "Short description";
    }// </editor-fold>

}
