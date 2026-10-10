/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DryingBatchDAO;
import dao.EventLogDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DryingBatch;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "BatchController", urlPatterns = {"/batch"})
public class BatchController extends HttpServlet {

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

        HttpSession session = request.getSession();
        User user
                = (User) session.getAttribute("LOGIN_USER");

        try {

            if ("GET".equalsIgnoreCase(request.getMethod())) {

                loadBatchPage(request, response, user);

            } else {

                handleBatchAction(request, response, user);

            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Error in BatchController",
                    e
            );
        }
    }

    // ==============================
    // LOAD BATCH PAGE
    // ==============================
    private void loadBatchPage(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        WarehouseDAO warehouseDAO
                = new WarehouseDAO();

        DryingBatchDAO batchDAO
                = new DryingBatchDAO();

        Warehouse warehouse = null;

        List<Warehouse> warehouseList
                = new ArrayList<>();

        // =========================================
        // 1. MANAGER
        // =========================================
        if ("MANAGER".equals(user.getRole())) {

            warehouseList
                    = warehouseDAO.getWarehousesByManager(
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
                        "/WEB-INF/views/batch.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            String warehouseId
                    = request.getParameter(
                            "warehouseId"
                    );

            // Manager đã chọn warehouse
            if (warehouseId != null
                    && !warehouseId.trim().isEmpty()) {

                for (Warehouse w : warehouseList) {

                    if (warehouseId.equals(
                            w.getWarehouseId())) {

                        warehouse = w;

                        break;
                    }
                }
            }

            // Chưa chọn -> warehouse đầu tiên
            if (warehouse == null) {

                warehouse
                        = warehouseList.get(0);
            }
        } // =========================================
        // 2. OPERATOR
        // =========================================
        else if ("OPERATOR".equals(user.getRole())) {

            warehouse
                    = warehouseDAO.getWarehouseByUser(
                            user.getUserId()
                    );

            if (warehouse != null) {

                warehouseList.add(
                        warehouse
                );
            }
        }

        // =========================================
        // 3. KHÔNG CÓ WAREHOUSE
        // =========================================
        if (warehouse == null) {

            request.setAttribute(
                    "error",
                    "No warehouse assigned."
            );

            request.setAttribute(
                    "warehouseList",
                    warehouseList
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/batch.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // =========================================
        // 4. SEARCH
        // =========================================
        String keyword
                = request.getParameter(
                        "keyword"
                );

        if (keyword == null) {

            keyword = "";
        }

        // =========================================
        // 5. FILTER STATUS
        // =========================================
        String statusFilter
                = request.getParameter(
                        "status"
                );

        if (!"DRYING".equals(statusFilter)
                && !"COMPLETED".equals(statusFilter)) {

            statusFilter = "";
        }

        // =========================================
        // 6. SORT
        // =========================================
        String sortBy
                = request.getParameter(
                        "sortBy"
                );

        String sortOrder
                = request.getParameter(
                        "sortOrder"
                );

        if (sortBy == null
                || sortBy.trim().isEmpty()) {

            sortBy = "startTime";
        }

        if (!"ASC".equalsIgnoreCase(sortOrder)) {

            sortOrder = "DESC";
        }

        // =========================================
        // 7. PAGINATION
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
        // 8. COUNT BATCHES
        // =========================================
        int totalRecords
                = batchDAO.countBatchesByWarehouse(
                        warehouse.getWarehouseId(),
                        keyword,
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
        // 9. ACTIVE BATCHES
        // KHÔNG SEARCH / FILTER / PAGINATION
        // =========================================
        List<DryingBatch> activeBatches
                = batchDAO.getActiveBatchesByWarehouse(
                        warehouse.getWarehouseId()
                );

        // =========================================
        // 10. ALL BATCHES
        // SEARCH + FILTER + SORT + PAGINATION
        // =========================================
        List<DryingBatch> batches
                = batchDAO.searchBatchesByWarehouse(
                        warehouse.getWarehouseId(),
                        keyword,
                        statusFilter,
                        sortBy,
                        sortOrder,
                        page,
                        pageSize
                );

        // =========================================
        // 11. SEND DATA TO JSP
        // =========================================
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
                "batches",
                batches
        );

        // SEARCH
        request.setAttribute(
                "keyword",
                keyword
        );

        // FILTER
        request.setAttribute(
                "selectedStatus",
                statusFilter
        );

        // SORT
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
                "totalRecords",
                totalRecords
        );

        request.setAttribute(
                "totalPages",
                totalPages
        );

        // =========================================
        // 12. FORWARD
        // =========================================
        request.getRequestDispatcher(
                "/WEB-INF/views/batch.jsp"
        ).forward(
                request,
                response
        );
    }
//    private void loadBatchPage(
//            HttpServletRequest request,
//            HttpServletResponse response,
//            User user)
//            throws Exception {
//
//        WarehouseDAO warehouseDAO
//                = new WarehouseDAO();
//
//        DryingBatchDAO batchDAO
//                = new DryingBatchDAO();
//
//        Warehouse warehouse = null;
//
//        List<Warehouse> warehouseList
//                = new ArrayList<>();
//
//        // =========================================
//        // MANAGER
//        // =========================================
//        if ("MANAGER".equals(user.getRole())) {
//
//            warehouseList
//                    = warehouseDAO.getWarehousesByManager(
//                            user.getUserId()
//                    );
//
//            if (warehouseList == null
//                    || warehouseList.isEmpty()) {
//
//                request.setAttribute(
//                        "error",
//                        "No warehouse assigned."
//                );
//
//                request.setAttribute(
//                        "warehouseList",
//                        warehouseList
//                );
//
//                request.getRequestDispatcher(
//                        "/WEB-INF/views/batch.jsp"
//                ).forward(request, response);
//
//                return;
//            }
//
//            String warehouseId
//                    = request.getParameter(
//                            "warehouseId"
//                    );
//
//            // Manager đã chọn warehouse
//            if (warehouseId != null
//                    && !warehouseId.trim().isEmpty()) {
//
//                for (Warehouse w : warehouseList) {
//
//                    if (warehouseId.equals(
//                            w.getWarehouseId())) {
//
//                        warehouse = w;
//                        break;
//                    }
//                }
//            }
//
//            // Chưa chọn -> warehouse đầu tiên
//            if (warehouse == null) {
//
//                warehouse
//                        = warehouseList.get(0);
//            }
//        } // =========================================
//        // OPERATOR
//        // =========================================
//        else if ("OPERATOR".equals(user.getRole())) {
//
//            warehouse
//                    = warehouseDAO.getWarehouseByUser(
//                            user.getUserId()
//                    );
//
//            if (warehouse != null) {
//
//                warehouseList.add(
//                        warehouse
//                );
//            }
//        }
//
//        // =========================================
//        // KHÔNG CÓ WAREHOUSE
//        // =========================================
//        if (warehouse == null) {
//
//            request.setAttribute(
//                    "error",
//                    "No warehouse assigned."
//            );
//
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/batch.jsp"
//            ).forward(request, response);
//
//            return;
//        }
//
//        // =========================================
//        // BATCH LIST
//        // =========================================
//        List<DryingBatch> batches
//                = batchDAO.getBatchesByWarehouse(
//                        warehouse.getWarehouseId()
//                );
//
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
//                "batches",
//                batches
//        );
//
//        request.getRequestDispatcher(
//                "/WEB-INF/views/batch.jsp"
//        ).forward(request, response);
//    }

    // ==============================
    // POST ACTION
    // ==============================
    private void handleBatchAction(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        String action
                = request.getParameter("action");

        if (action == null) {

            response.sendRedirect(
                    request.getContextPath() + "/batch"
            );

            return;
        }

        if ("start".equals(action)) {

            startBatch(request, response, user);

        } else if ("complete".equals(action)) {

            completeBatch(request, response, user);

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/batch"
            );
        }
    }

    // ==============================
    // START BATCH
    // ==============================
    private void startBatch(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        WarehouseDAO warehouseDAO
                = new WarehouseDAO();

        DryingBatchDAO batchDAO
                = new DryingBatchDAO();

        EventLogDAO eventLogDAO
                = new EventLogDAO();

        Warehouse warehouse = null;

        // =========================================
        // OPERATOR
        // =========================================
        if ("OPERATOR".equals(user.getRole())) {

            warehouse
                    = warehouseDAO.getWarehouseByUser(
                            user.getUserId()
                    );
        } // =========================================
        // MANAGER
        // =========================================
        else if ("MANAGER".equals(user.getRole())) {

            String warehouseId
                    = request.getParameter(
                            "warehouseId"
                    );

            if (warehouseId == null
                    || warehouseId.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/batch"
                );

                return;
            }

            warehouseId
                    = warehouseId.trim();

            boolean allowed
                    = warehouseDAO.isAssignedToManager(
                            user.getUserId(),
                            warehouseId
                    );

            if (!allowed) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/batch"
                );

                return;
            }

            warehouse
                    = warehouseDAO.getById(
                            warehouseId
                    );
        }

        // =========================================
        // INVALID ROLE / NO WAREHOUSE
        // =========================================
        if (warehouse == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/batch"
            );

            return;
        }

        // =========================================
        // FORM DATA
        // =========================================
        String productName
                = request.getParameter(
                        "productName"
                );

        String weightText
                = request.getParameter(
                        "weightKg"
                );

        String notes
                = request.getParameter(
                        "notes"
                );

        // =========================================
        // VALIDATE REQUIRED DATA
        // =========================================
        if (productName == null
                || productName.trim().isEmpty()
                || weightText == null
                || weightText.trim().isEmpty()) {

            request.getSession().setAttribute(
                    "message",
                    "Product name and weight are required."
            );

            redirectBatch(
                    request,
                    response,
                    user,
                    warehouse.getWarehouseId()
            );

            return;
        }

        productName
                = productName.trim();

        // =========================================
        // VALIDATE WEIGHT
        // =========================================
        double weightKg;

        try {

            weightKg
                    = Double.parseDouble(
                            weightText.trim()
                    );

            if (weightKg <= 0) {

                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            request.getSession().setAttribute(
                    "message",
                    "Weight must be greater than 0."
            );

            redirectBatch(
                    request,
                    response,
                    user,
                    warehouse.getWarehouseId()
            );

            return;
        }

        // =========================================
        // NORMALIZE NOTES
        // =========================================
        if (notes != null) {

            notes
                    = notes.trim();

            if (notes.isEmpty()) {

                notes = null;
            }
        }

        // =========================================
        // CREATE BATCH
        //
        // B006 / B007 / ...
        // =========================================
        String batchId
                = batchDAO.createBatch(
                        warehouse.getWarehouseId(),
                        user.getUserId(),
                        productName,
                        weightKg,
                        notes
                );

        // =========================================
        // SUCCESS
        // =========================================
        if (batchId != null) {

            // =====================================
            // EVENT LOG
            // =====================================
            eventLogDAO.addEvent(
                    warehouse.getWarehouseId(),
                    null, // deviceId

                    batchId, // batchId thật

                    user.getUserId(),
                    "BATCH_STARTED",
                    "WEB",
                    "Started drying batch "
                    + batchId
                    + " for "
                    + productName
                    + " - "
                    + weightKg
                    + " kg"
            );

            request.getSession().setAttribute(
                    "message",
                    "Batch "
                    + batchId
                    + " started successfully."
            );

        } else {

            request.getSession().setAttribute(
                    "message",
                    "Cannot start batch."
            );
        }

        // =========================================
        // REDIRECT
        // =========================================
        redirectBatch(
                request,
                response,
                user,
                warehouse.getWarehouseId()
        );
    }
//   private void startBatch(
//        HttpServletRequest request,
//        HttpServletResponse response,
//        User user)
//        throws Exception {
//
//    WarehouseDAO warehouseDAO
//            = new WarehouseDAO();
//
//    DryingBatchDAO batchDAO
//            = new DryingBatchDAO();
//
//
//    // Lấy warehouse của operator
//    Warehouse warehouse
//            = warehouseDAO.getWarehouseByUser(
//                    user.getUserId()
//            );
//
//
//    if (warehouse == null) {
//
//        response.sendRedirect(
//                request.getContextPath() + "/batch"
//        );
//
//        return;
//    }
//
//
//    // Lấy dữ liệu từ form
//    String productName
//            = request.getParameter("productName");
//
//    String weightText
//            = request.getParameter("weightKg");
//
//    String notes
//            = request.getParameter("notes");
//
//
//    // Validate
//    if (productName == null
//            || productName.trim().isEmpty()
//            || weightText == null
//            || weightText.trim().isEmpty()) {
//
//        request.getSession().setAttribute(
//                "message",
//                "Product name and weight are required."
//        );
//
//        response.sendRedirect(
//                request.getContextPath() + "/batch"
//        );
//
//        return;
//    }
//
//
//    double weightKg;
//
//    try {
//
//        weightKg
//                = Double.parseDouble(weightText);
//
//        if (weightKg <= 0) {
//            throw new NumberFormatException();
//        }
//
//    } catch (NumberFormatException e) {
//
//        request.getSession().setAttribute(
//                "message",
//                "Weight must be greater than 0."
//        );
//
//        response.sendRedirect(
//                request.getContextPath() + "/batch"
//        );
//
//        return;
//    }
//
//
//    // Tạo batch mới
//    boolean success
//            = batchDAO.createBatch(
//                    warehouse.getWarehouseId(),
//                    user.getUserId(),
//                    productName.trim(),
//                    weightKg,
//                    notes
//            );
//
//
//    if (success) {
//
//        request.getSession().setAttribute(
//                "message",
//                "Batch started successfully."
//        );
//
//    } else {
//
//        request.getSession().setAttribute(
//                "message",
//                "Cannot start batch."
//        );
//    }
//
//
//    response.sendRedirect(
//            request.getContextPath() + "/batch"
//    );
//}

    // ==============================
    // COMPLETE BATCH
    // ==============================
    private void completeBatch(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        DryingBatchDAO batchDAO
                = new DryingBatchDAO();

        EventLogDAO eventLogDAO
                = new EventLogDAO();

        String batchId
                = request.getParameter(
                        "batchId"
                );

        String warehouseId
                = request.getParameter(
                        "warehouseId"
                );

        if (batchId == null
                || batchId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/batch"
            );

            return;
        }

        batchId = batchId.trim();

        boolean success = false;

        // =========================================
        // OPERATOR
        // =========================================
        if ("OPERATOR".equals(user.getRole())) {

            success
                    = batchDAO.completeBatch(
                            batchId,
                            user.getUserId()
                    );
        } // =========================================
        // MANAGER
        // =========================================
        else if ("MANAGER".equals(user.getRole())) {

            success
                    = batchDAO.completeBatchByManager(
                            batchId,
                            user.getUserId()
                    );
        }

        // =========================================
        // SUCCESS
        // =========================================
        if (success) {

            // =====================================
            // WRITE EVENT LOG
            // =====================================
            eventLogDAO.addEvent(
                    warehouseId,
                    null, // deviceId
                    batchId,
                    user.getUserId(),
                    "BATCH_COMPLETED",
                    "WEB",
                    "Completed drying batch "
                    + batchId
            );

            request.getSession().setAttribute(
                    "message",
                    "Batch completed successfully."
            );

        } else {

            request.getSession().setAttribute(
                    "message",
                    "Cannot complete batch."
            );
        }

        // =========================================
        // REDIRECT
        // =========================================
        redirectBatch(
                request,
                response,
                user,
                warehouseId
        );
    }

    private void redirectBatch(
            HttpServletRequest request,
            HttpServletResponse response,
            User user,
            String warehouseId)
            throws IOException {

        if ("MANAGER".equals(user.getRole())
                && warehouseId != null
                && !warehouseId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/batch?warehouseId="
                    + warehouseId
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/batch"
            );
        }
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
