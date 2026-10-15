/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import dao.UserWarehouseDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "UserManagementController", urlPatterns = {"/users"})

public class UserManagementController extends HttpServlet {

    private UserDAO userDAO;
    private UserWarehouseDAO userWarehouseDAO;
    private WarehouseDAO warehouseDAO;

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAO();
        userWarehouseDAO = new UserWarehouseDAO();
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

        // =========================================
        // 2. CHECK ROLE
        // ADMIN + MANAGER CAN ACCESS PAGE
        // =========================================
        if (!"ADMIN".equals(role)
                && !"MANAGER".equals(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );

            return;
        }

        try {

            // =========================================
            // 3. GET
            // ONLY LOAD PAGE
            // =========================================
            if ("GET".equalsIgnoreCase(
                    request.getMethod())) {

                loadPage(
                        request,
                        response
                );

                return;
            }

            // =========================================
            // 4. POST
            // ONLY ADMIN CAN MODIFY
            // =========================================
            if ("POST".equalsIgnoreCase(
                    request.getMethod())) {

                if (!"ADMIN".equals(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/users"
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
                            + "/users"
                    );

                    return;
                }

                switch (action) {

                    case "add":

                        addUser(
                                request,
                                response
                        );

                        break;

                    case "updateName":

                        updateName(
                                request,
                                response
                        );

                        break;

                    case "updateRole":

                        updateRole(
                                request,
                                response
                        );

                        break;

                    case "toggleStatus":

                        toggleStatus(
                                request,
                                response,
                                loginUser
                        );

                        break;
                    case "delete":

                        deleteUser(
                                request,
                                response,
                                loginUser
                        );

                        break;

                    case "assignWarehouse":

                        assignWarehouse(
                                request,
                                response
                        );

                        break;

                    default:

                        response.sendRedirect(
                                request.getContextPath()
                                + "/users"
                        );

                        break;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to process User Management."
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

    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        // =========================================
        // 1. GET SEARCH / FILTER / SORT
        // =========================================
        String keyword
                = request.getParameter(
                        "keyword"
                );

        String roleFilter
                = request.getParameter(
                        "role"
                );

        String statusFilter
                = request.getParameter(
                        "status"
                );

        String sortBy
                = request.getParameter(
                        "sortBy"
                );

        String sortOrder
                = request.getParameter(
                        "sortOrder"
                );

        if (keyword == null) {
            keyword = "";
        }

        if (roleFilter == null) {
            roleFilter = "";
        }

        if (statusFilter == null) {
            statusFilter = "";
        }

        if (sortBy == null
                || sortBy.trim().isEmpty()) {

            sortBy = "userId";
        }

        if (!"ASC".equalsIgnoreCase(sortOrder)) {
            sortOrder = "DESC";
        }

        // =========================================
        // 2. PAGINATION
        // =========================================
        int page = 1;

        int pageSize = 10;

        String pageParam
                = request.getParameter(
                        "page"
                );

        if (pageParam != null) {

            try {

                page
                        = Integer.parseInt(
                                pageParam
                        );

            } catch (NumberFormatException e) {

                page = 1;
            }
        }

        if (page < 1) {

            page = 1;
        }

        // =========================================
        // 3. COUNT FILTERED USERS
        // =========================================
        int totalRecords
                = userDAO.countUsers(
                        keyword,
                        roleFilter,
                        statusFilter
                );

        int totalPages
                = (int) Math.ceil(
                        (double) totalRecords
                        / pageSize
                );

        if (totalPages < 1) {

            totalPages = 1;
        }

        if (page > totalPages) {

            page = totalPages;
        }

        // =========================================
        // 4. GET USERS
        // SEARCH + FILTER + SORT + PAGINATION
        // =========================================
        List<User> users
                = userDAO.searchUsers(
                        keyword,
                        roleFilter,
                        statusFilter,
                        sortBy,
                        sortOrder,
                        page,
                        pageSize
                );

        // =========================================
        // 5. GET ALL WAREHOUSES
        // =========================================
        List<Warehouse> warehouseList
                = warehouseDAO.getAllWarehouses();

        // =========================================
        // 6. USER -> WAREHOUSE MAP
        // =========================================
        Map<String, List<Warehouse>> userWarehouseMap
                = new HashMap<String, List<Warehouse>>();

        for (User user : users) {

            List<Warehouse> assignedWarehouses
                    = userWarehouseDAO.getWarehousesByUser(
                            user.getUserId()
                    );

            userWarehouseMap.put(
                    user.getUserId(),
                    assignedWarehouses
            );
        }

        // =========================================
        // 7. DASHBOARD COUNT
        // =========================================
        int totalUsers
                = userDAO.countAll();

        int activeUsers
                = userDAO.countActive();

        // =========================================
        // 8. SEND DATA TO JSP
        // =========================================
        request.setAttribute(
                "users",
                users
        );

        request.setAttribute(
                "warehouseList",
                warehouseList
        );

        request.setAttribute(
                "userWarehouseMap",
                userWarehouseMap
        );

        request.setAttribute(
                "totalUsers",
                totalUsers
        );

        request.setAttribute(
                "activeUsers",
                activeUsers
        );

        // SEARCH / FILTER / SORT
        request.setAttribute(
                "keyword",
                keyword
        );

        request.setAttribute(
                "selectedRole",
                roleFilter
        );

        request.setAttribute(
                "selectedStatus",
                statusFilter
        );

        request.setAttribute(
                "sortBy",
                sortBy
        );

        request.setAttribute(
                "sortOrder",
                sortOrder
        );

        // PAGINATION
        request.setAttribute(
                "currentPage",
                page
        );

        request.setAttribute(
                "pageSize",
                pageSize
        );

        request.setAttribute(
                "totalPages",
                totalPages
        );

        request.setAttribute(
                "totalRecords",
                totalRecords
        );

        // =========================================
        // 9. FORWARD
        // =========================================
        request.getRequestDispatcher(
                "/WEB-INF/views/user-management.jsp"
        ).forward(
                request,
                response
        );
    }

    private void addUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String userId
                = request.getParameter("userId");

        String username
                = request.getParameter("username");

        String password
                = request.getParameter("password");

        String fullName
                = request.getParameter("fullName");

        String role
                = request.getParameter("role");

        String[] warehouseIds
                = request.getParameterValues(
                        "warehouseIds"
                );

        // =========================================
        // VALIDATION
        // =========================================
        if (userId == null
                || userId.trim().isEmpty()
                || username == null
                || username.trim().isEmpty()
                || password == null
                || password.trim().isEmpty()
                || fullName == null
                || fullName.trim().isEmpty()
                || !isValidRole(role)) {

            request.setAttribute(
                    "error",
                    "Please enter all required information."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        userId = userId.trim();
        username = username.trim();
        fullName = fullName.trim();

        // =========================================
        // CHECK USER ID
        // =========================================
        if (userDAO.existsUserId(userId)) {

            request.setAttribute(
                    "error",
                    "User ID already exists."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =========================================
        // CHECK USERNAME
        // =========================================
        if (userDAO.existsUsername(username)) {

            request.setAttribute(
                    "error",
                    "Username already exists."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =========================================
        // ADD USER
        // =========================================
        boolean success
                = userDAO.add(
                        userId,
                        username,
                        password,
                        fullName,
                        role
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to add user."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =========================================
        // ASSIGN WAREHOUSE
        // ADMIN không cần warehouse
        // =========================================
        if (!"ADMIN".equals(role)) {

            userWarehouseDAO
                    .setUserWarehouses(
                            userId,
                            warehouseIds
                    );
        }

        // =========================================
        // REDIRECT
        // =========================================
        response.sendRedirect(
                request.getContextPath()
                + "/users"
        );
    }

    private void updateName(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String userId
                = request.getParameter("userId");

        String fullName
                = request.getParameter("fullName");

        if (userId == null
                || userId.trim().isEmpty()
                || fullName == null
                || fullName.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Full name cannot be empty."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        userId = userId.trim();
        fullName = fullName.trim();

        boolean success
                = userDAO.updateFullName(
                        userId,
                        fullName
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to update full name."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/users"
        );
    }

    private void updateRole(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String userId
                = request.getParameter("userId");

        String role
                = request.getParameter("role");

        if (userId == null
                || userId.trim().isEmpty()
                || !isValidRole(role)) {

            request.setAttribute(
                    "error",
                    "Invalid user or role."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        userId = userId.trim();

        boolean success
                = userDAO.updateRole(
                        userId,
                        role
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to update role."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        // =========================================
        // IF SWITCH TO ADMIN
        // DELETE warehouse assignment
        // =========================================
        if ("ADMIN".equals(role)) {

            userWarehouseDAO
                    .setUserWarehouses(
                            userId,
                            null
                    );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/users"
        );
    }

    private void toggleStatus(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String userId
                = request.getParameter("userId");

        if (userId == null
                || userId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/users"
            );

            return;
        }

        userId = userId.trim();

        // =========================================
        //  ADMIN CANNOT BE disable myself
        // =========================================
        if (userId.equals(
                loginUser.getUserId())) {

            request.setAttribute(
                    "error",
                    "You cannot disable your own account."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        boolean success
                = userDAO.toggleStatus(
                        userId
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to update user status."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/users"
        );
    }

    private void assignWarehouse(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String userId
                = request.getParameter("userId");

        String[] warehouseIds
                = request.getParameterValues(
                        "warehouseIds"
                );

        if (userId == null
                || userId.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Invalid user."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        userId = userId.trim();

        userWarehouseDAO
                .setUserWarehouses(
                        userId,
                        warehouseIds
                );

        response.sendRedirect(
                request.getContextPath()
                + "/users"
        );
    }

    private boolean isValidRole(
            String role) {

        return "ADMIN".equals(role)
                || "MANAGER".equals(role)
                || "OPERATOR".equals(role);
    }

    private void deleteUser(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {

        String userId
                = request.getParameter(
                        "userId"
                );

        if (userId == null
                || userId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/users"
            );

            return;
        }

        userId
                = userId.trim();

        // Prevent admin from deleting their own account
        if (userId.equals(
                loginUser.getUserId())) {

            request.setAttribute(
                    "error",
                    "You cannot delete your own account."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        if (!userDAO.canDeleteUser(
                userId)) {

            request.setAttribute(
                    "error",
                    "This user has existing batch or event history. "
                    + "Please disable the account instead."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        boolean success
                = userDAO.deleteUser(
                        userId
                );

        if (!success) {

            request.setAttribute(
                    "error",
                    "Unable to delete user."
            );

            loadPage(
                    request,
                    response
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/users"
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
