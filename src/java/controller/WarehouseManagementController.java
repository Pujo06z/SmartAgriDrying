/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.WarehouseDAO;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Warehouse;

@WebServlet(
        name = "WarehouseManagementController",
        urlPatterns = {"/warehouses"}
)
public class WarehouseManagementController extends HttpServlet {

    private WarehouseDAO warehouseDAO;

    @Override
    public void init()
            throws ServletException {

        warehouseDAO
                = new WarehouseDAO();
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
        // 2. CHECK ROLE
        // ADMIN + MANAGER can access
        // =====================================================
        if (!"ADMIN".equals(role)
                && !"MANAGER".equals(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );

            return;
        }

        try {

            // =================================================
            // 3. GET
            // =================================================
            if ("GET".equalsIgnoreCase(
                    request.getMethod())) {

                loadPage(
                        request,
                        response,
                        loginUser
                );

                return;
            }

            // =================================================
            // 4. POST
            // ADMIN ONLY
            // =================================================
            if ("POST".equalsIgnoreCase(
                    request.getMethod())) {

                if (!"ADMIN".equals(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/warehouses"
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
                            + "/warehouses"
                    );

                    return;
                }

                switch (action) {

                    case "add":

                        addWarehouse(
                                request,
                                response,
                                loginUser
                        );

                        break;

                    case "update":

                        updateWarehouse(
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
                    case "delete":

                        deleteWarehouse(
                                request,
                                response,
                                loginUser
                        );

                        break;
                    default:

                        response.sendRedirect(
                                request.getContextPath()
                                + "/warehouses"
                        );

                        break;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to process Warehouse Management."
            );

            try {

                loadPage(
                        request,
                        response,
                        loginUser
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
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        List<Warehouse> warehouseList;

        // =====================================================
        // ADMIN
        // =====================================================
        if ("ADMIN".equals(
                loginUser.getRole())) {

            warehouseList
                    = warehouseDAO
                            .getAllWarehouses();
        } // =====================================================
        // MANAGER
        // =====================================================
        else {

            warehouseList
                    = warehouseDAO
                            .getWarehousesByManager(
                                    loginUser.getUserId()
                            );
        }

        // =====================================================
        // STATISTICS
        // =====================================================
        int totalWarehouses
                = warehouseList.size();

        int activeWarehouses = 0;

        for (Warehouse warehouse
                : warehouseList) {

            if ("ACTIVE".equals(
                    warehouse.getStatus())) {

                activeWarehouses++;
            }
        }

        int inactiveWarehouses
                = totalWarehouses
                - activeWarehouses;

        // =====================================================
        // SET ATTRIBUTE
        // =====================================================
        request.setAttribute(
                "warehouseList",
                warehouseList
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

        // =====================================================
        // FORWARD JSP
        // =====================================================
        request.getRequestDispatcher(
                "/WEB-INF/views/warehouse-management.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // ADD WAREHOUSE
    // =========================================================
    private void addWarehouse(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        String warehouseCode
                = request.getParameter(
                        "warehouseCode"
                );

        String warehouseName
                = request.getParameter(
                        "warehouseName"
                );

        String location
                = request.getParameter(
                        "location"
                );

        // =====================================================
        // VALIDATION
        // =====================================================
        if (warehouseId == null
                || warehouseId.trim().isEmpty()
                || warehouseCode == null
                || warehouseCode.trim().isEmpty()
                || warehouseName == null
                || warehouseName.trim().isEmpty()
                || location == null
                || location.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please enter all required warehouse information."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        warehouseId
                = warehouseId.trim();

        warehouseCode
                = warehouseCode.trim();

        warehouseName
                = warehouseName.trim();

        location
                = location.trim();

        // =====================================================
        // CHECK WAREHOUSE ID
        // =====================================================
        if (warehouseDAO
                .existsWarehouseId(
                        warehouseId
                )) {

            request.setAttribute(
                    "error",
                    "Warehouse ID already exists."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        // =====================================================
        // CHECK WAREHOUSE CODE
        // =====================================================
        if (warehouseDAO
                .existsWarehouseCode(
                        warehouseCode
                )) {

            request.setAttribute(
                    "error",
                    "Warehouse code already exists."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        // =====================================================
        // INSERT
        // =====================================================
        boolean success
                = warehouseDAO.add(
                        warehouseId,
                        warehouseCode,
                        warehouseName,
                        location
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to add warehouse."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/warehouses"
        );
    }

    // =========================================================
    // UPDATE WAREHOUSE
    // =========================================================
    private void updateWarehouse(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        String warehouseCode
                = request.getParameter(
                        "warehouseCode"
                );

        String warehouseName
                = request.getParameter(
                        "warehouseName"
                );

        String location
                = request.getParameter(
                        "location"
                );

        // =====================================================
        // VALIDATION
        // =====================================================
        if (warehouseId == null
                || warehouseId.trim().isEmpty()
                || warehouseCode == null
                || warehouseCode.trim().isEmpty()
                || warehouseName == null
                || warehouseName.trim().isEmpty()
                || location == null
                || location.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Warehouse information cannot be empty."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        warehouseId
                = warehouseId.trim();

        warehouseCode
                = warehouseCode.trim();

        warehouseName
                = warehouseName.trim();

        location
                = location.trim();

        // =====================================================
        // CHECK WAREHOUSE EXISTS
        // =====================================================
        Warehouse currentWarehouse
                = warehouseDAO.getById(
                        warehouseId
                );

        if (currentWarehouse == null) {

            request.setAttribute(
                    "error",
                    "Warehouse not found."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        // =====================================================
        // CHECK CODE DUPLICATE
        //
        // If code is unchanged, it's OK
        // If code is changed, check for duplicates
        // =====================================================
        if (!warehouseCode.equalsIgnoreCase(
                currentWarehouse
                        .getWarehouseCode())
                && warehouseDAO
                        .existsWarehouseCode(
                                warehouseCode
                        )) {

            request.setAttribute(
                    "error",
                    "Warehouse code already exists."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        // =====================================================
        // UPDATE
        // =====================================================
        boolean success
                = warehouseDAO.update(
                        warehouseId,
                        warehouseCode,
                        warehouseName,
                        location
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to update warehouse."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/warehouses"
        );
    }

    // =========================================================
    // ACTIVE / INACTIVE
    // =========================================================
    private void toggleStatus(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        if (warehouseId == null
                || warehouseId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/warehouses"
            );

            return;
        }

        warehouseDAO.toggleStatus(
                warehouseId.trim()
        );

        response.sendRedirect(
                request.getContextPath()
                + "/warehouses"
        );
    }

    private void deleteWarehouse(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        if (warehouseId == null
                || warehouseId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/warehouses"
            );

            return;
        }

        warehouseId
                = warehouseId.trim();

        // =========================================
        // CHECK can delete
        // =========================================
        if (!warehouseDAO.canDeleteWarehouse(
                warehouseId)) {

            request.setAttribute(
                    "error",
                    "This warehouse contains devices, batches, "
                    + "or event history. Please disable it instead."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        // =========================================
        // DELETE
        // =========================================
        boolean success
                = warehouseDAO.deleteWarehouse(
                        warehouseId
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to delete warehouse."
            );

            loadPage(
                    request,
                    response,
                    loginUser
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/warehouses"
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