/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DeviceDAO;
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // kiem tra login

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(request.getContextPath() + "/login");

            return;
        }

        // ============================
        // 2. lay USER
        // ============================
        User user = (User) session.getAttribute("LOGIN_USER");

        if (!"OPERATOR".equals(user.getRole())
                && !"MANAGER".equals(user.getRole())) {

            response.sendRedirect(request.getContextPath() + "/dashboard");

            return;
        }
        // ============================
        // 3. lay ACTION
        // ============================

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");

            return;
        }

        try {

            WarehouseDAO warehouseDAO
                    = new WarehouseDAO();

            DeviceDAO deviceDAO
                    = new DeviceDAO();

            // ============================
            // 4. LẤY WAREHOUSE
            // ============================
            Warehouse warehouse
                    = warehouseDAO.getWarehouseByUser(
                            user.getUserId()
                    );

            if (warehouse == null) {

                response.sendRedirect(
                        request.getContextPath() + "/dashboard"
                );

                return;
            }
// ============================
            // 5. LẤY DEVICE
            // ============================

            Device device
                    = deviceDAO.getDeviceByWarehouse(
                            warehouse.getWarehouseId()
                    );

            if (device == null) {

                response.sendRedirect(
                        request.getContextPath() + "/dashboard"
                );

                return;
            }

            // ============================
            // 6. XỬ LÝ ACTION
            // ============================
            switch (action) {

                case "AUTO":

                    deviceDAO.updateMode(
                            device.getDeviceId(),
                            "AUTO"
                    );

                    break;

                case "MANUAL":

                    deviceDAO.updateMode(
                            device.getDeviceId(),
                            "MANUAL"
                    );

                    break;

                case "OPEN":

                    // Chỉ được mở mái khi MANUAL
                    if ("MANUAL".equals(device.getMode())) {

                        deviceDAO.updateRoofStatus(
                                device.getDeviceId(),
                                "OPEN"
                        );
                    }

                    break;

                case "CLOSE":

                    // Chỉ được đóng mái khi MANUAL
                    if ("MANUAL".equals(device.getMode())) {

                        deviceDAO.updateRoofStatus(
                                device.getDeviceId(),
                                "CLOSED"
                        );
                    }

                    break;

                default:
                    break;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        // ============================
        // 7. QUAY LẠI DASHBOARD
        // ============================
        response.sendRedirect(
                request.getContextPath() + "/dashboard"
        );

    }


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
