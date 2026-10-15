/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.EventLogDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.EventLog;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
public class EventLogController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    private EventLogDAO eventLogDAO;
    private WarehouseDAO warehouseDAO;


    @Override
    public void init()
            throws ServletException {

        eventLogDAO =
                new EventLogDAO();

        warehouseDAO =
                new WarehouseDAO();
    }


    // =========================================================
    // PROCESS REQUEST
    // =========================================================

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // =================================================
            // 1. CHECK LOGIN
            // =================================================

            HttpSession session =
                    request.getSession(false);


            User loginUser =
                    (User) session.getAttribute(
                            "LOGIN_USER"
                    );


            String role =
                    loginUser.getRole();


            // =================================================
            // 2. ADMIN
            // =================================================

            if ("ADMIN".equals(role)) {

                loadAdminEvents(
                        request,
                        response
                );

                return;
            }


            // =================================================
            // 3. MANAGER
            // =================================================

            if ("MANAGER".equals(role)) {

                loadManagerEvents(
                        request,
                        response,
                        loginUser
                );

                return;
            }


            // =================================================
            // 4. OPERATOR
            // =================================================

            if ("OPERATOR".equals(role)) {

                loadOperatorEvents(
                        request,
                        response,
                        loginUser
                );

                return;
            }


            // =================================================
            // UNKNOWN ROLE
            // =================================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );


        } catch (Exception e) {

            throw new ServletException(e);
        }
    }


    // =========================================================
    // ADMIN
    // =========================================================

    private void loadAdminEvents(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        // =============================================
        // Admin can view all warehouses
        // =============================================

        List<Warehouse> warehouseList =
                warehouseDAO.getAllWarehouses();


        String warehouseId =
                request.getParameter(
                        "warehouseId"
                );


        // =============================================
        // If no warehouse is selected
        // → view the entire system
        // =============================================

        if (warehouseId == null) {

            warehouseId = "";

        } else {

            warehouseId =
                    warehouseId.trim();
        }


        // =============================================
        // If a warehouse is selected
        // → check if the warehouse exists
        // =============================================

        if (!warehouseId.isEmpty()) {

            Warehouse warehouse =
                    warehouseDAO.getById(
                            warehouseId
                    );


            if (warehouse == null) {

                request.setAttribute(
                        "error",
                        "Warehouse does not exist."
                );

                warehouseId = "";
            }
        }


        // =============================================
        // SEARCH + FILTER + SORT + PAGE
        // =============================================

        loadEventPage(
                request,
                warehouseId
        );


        request.setAttribute(
                "warehouseList",
                warehouseList
        );


        request.setAttribute(
                "selectedWarehouseId",
                warehouseId
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/event-log.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // MANAGER
    // =========================================================

    private void loadManagerEvents(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {


        String managerId =
                loginUser.getUserId();


        // =============================================
        // Warehouses assigned to the Manager
        // =============================================

        List<Warehouse> warehouseList =
                warehouseDAO
                        .getWarehousesByManager(
                                managerId
                        );


        // =============================================
        // No warehouse assigned yet
        // =============================================

        if (warehouseList == null
                || warehouseList.isEmpty()) {


            request.setAttribute(
                    "warehouseList",
                    new ArrayList<Warehouse>()
            );


            request.setAttribute(
                    "eventList",
                    new ArrayList<EventLog>()
            );


            request.setAttribute(
                    "totalRecords",
                    0
            );


            request.setAttribute(
                    "totalPages",
                    1
            );


            request.setAttribute(
                    "currentPage",
                    1
            );


            request.setAttribute(
                    "pageSize",
                    10
            );


            request.setAttribute(
                    "error",
                    "No warehouse has been assigned to this manager."
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/event-log.jsp"
            ).forward(
                    request,
                    response
            );


            return;
        }


        String warehouseId =
                request.getParameter(
                        "warehouseId"
                );


        // =============================================
        // No warehouse selected
        // → default to the first warehouse
        // =============================================

        if (warehouseId == null
                || warehouseId.trim().isEmpty()) {

            warehouseId =
                    warehouseList
                            .get(0)
                            .getWarehouseId();

        } else {

            warehouseId =
                    warehouseId.trim();
        }


        // =============================================
        // SECURITY
        //
        // Manager is not allowed to modify the URL
        // to view warehouses they do not own
        // =============================================

        boolean allowed =
                warehouseDAO
                        .isAssignedToManager(
                                managerId,
                                warehouseId
                        );


        if (!allowed) {

            request.setAttribute(
                    "error",
                    "You are not allowed to access that warehouse."
            );


            warehouseId =
                    warehouseList
                            .get(0)
                            .getWarehouseId();
        }


        // =============================================
        // SEARCH + FILTER + SORT + PAGE
        // =============================================

        loadEventPage(
                request,
                warehouseId
        );


        request.setAttribute(
                "warehouseList",
                warehouseList
        );


        request.setAttribute(
                "selectedWarehouseId",
                warehouseId
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/event-log.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // OPERATOR
    // =========================================================

    private void loadOperatorEvents(
            HttpServletRequest request,
            HttpServletResponse response,
            User loginUser)
            throws Exception {


        String operatorId =
                loginUser.getUserId();


        // =============================================
        // Operator only uses the assigned warehouse
        // =============================================

        Warehouse warehouse =
                warehouseDAO
                        .getWarehouseByUser(
                                operatorId
                        );


        // =============================================
        // No warehouse assigned
        // =============================================

        if (warehouse == null) {


            request.setAttribute(
                    "eventList",
                    new ArrayList<EventLog>()
            );


            request.setAttribute(
                    "totalRecords",
                    0
            );


            request.setAttribute(
                    "totalPages",
                    1
            );


            request.setAttribute(
                    "currentPage",
                    1
            );


            request.setAttribute(
                    "pageSize",
                    10
            );


            request.setAttribute(
                    "error",
                    "No warehouse has been assigned to this operator."
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/event-log.jsp"
            ).forward(
                    request,
                    response
            );


            return;
        }


        String warehouseId =
                warehouse.getWarehouseId();


        // =============================================
        // Operator does NOT get warehouseId from URL
        //
        // → always locked to the Operator's own warehouse
        // =============================================

        loadEventPage(
                request,
                warehouseId
        );


        request.setAttribute(
                "selectedWarehouse",
                warehouse
        );


        request.setAttribute(
                "selectedWarehouseId",
                warehouseId
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/event-log.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // COMMON:
    //
    // SEARCH
    // FILTER
    // SORT
    // PAGINATION
    // =========================================================

    private void loadEventPage(
            HttpServletRequest request,
            String warehouseId)
            throws Exception {


        // =====================================================
        // 1. SEARCH KEYWORD
        // =====================================================

        String keyword =
                request.getParameter(
                        "keyword"
                );


        if (keyword == null) {

            keyword = "";

        } else {

            keyword =
                    keyword.trim();
        }


        // =====================================================
        // 2. EVENT TYPE FILTER
        // =====================================================

        String eventType =
                request.getParameter(
                        "eventType"
                );


        if (eventType == null) {

            eventType = "";

        } else {

            eventType =
                    eventType.trim();
        }


        // =====================================================
        // 3. SOURCE FILTER
        // =====================================================

        String source =
                request.getParameter(
                        "source"
                );


        if (source == null) {

            source = "";

        } else {

            source =
                    source.trim();
        }


        // =====================================================
        // Only allow valid sources
        // =====================================================

        if (!source.isEmpty()
                && !"AUTO".equals(source)
                && !"MANUAL".equals(source)
                && !"WEB".equals(source)) {

            source = "";
        }


        // =====================================================
        // 4. SORT BY
        // =====================================================

        String sortBy =
                request.getParameter(
                        "sortBy"
                );


        if (!"eventType".equals(sortBy)
                && !"source".equals(sortBy)
                && !"createdAt".equals(sortBy)) {

            sortBy =
                    "createdAt";
        }


        // =====================================================
        // 5. SORT ORDER
        // =====================================================

        String sortOrder =
                request.getParameter(
                        "sortOrder"
                );


        if (!"ASC".equalsIgnoreCase(sortOrder)) {

            sortOrder =
                    "DESC";

        } else {

            sortOrder =
                    "ASC";
        }


        // =====================================================
        // 6. PAGE
        // =====================================================

        int page =
                parsePositiveInt(
                        request.getParameter(
                                "page"
                        ),
                        1
                );


        // =====================================================
        // PAGE SIZE
        //
        // Fixed to 10 rows / page
        // =====================================================

        int pageSize = 10;


        // =====================================================
        // 7. COUNT TOTAL RECORDS
        // =====================================================

        int totalRecords =
                eventLogDAO.countEvents(
                        warehouseId,
                        keyword,
                        eventType,
                        source
                );


        // =====================================================
        // 8. CALCULATE TOTAL PAGES
        // =====================================================

        int totalPages =
                (int) Math.ceil(
                        (double) totalRecords
                        / pageSize
                );


        // =============================================
        // If there are no records,
        // still treat it as page 1
        // =============================================

        if (totalPages < 1) {

            totalPages = 1;
        }


        // =============================================
        // If the user modifies the URL page to be too large
        //
        // page=999
        // → redirect to the last page
        // =============================================

        if (page > totalPages) {

            page =
                    totalPages;
        }


        // =====================================================
        // 9. LOAD CURRENT PAGE
        // =====================================================

        List<EventLog> eventList =
                eventLogDAO.searchEvents(
                        warehouseId,
                        keyword,
                        eventType,
                        source,
                        sortBy,
                        sortOrder,
                        page,
                        pageSize
                );


        // =====================================================
        // 10. RECORD RANGE
        //
        // Used in JSP to display:
        //
        // Showing 11 - 20 of 47 events
        // =====================================================

        int startRecord;
        int endRecord;


        if (totalRecords == 0) {

            startRecord = 0;
            endRecord = 0;

        } else {

            startRecord =
                    (page - 1)
                    * pageSize
                    + 1;


            endRecord =
                    Math.min(
                            page * pageSize,
                            totalRecords
                    );
        }


        // =====================================================
        // 11. SEND TO JSP
        // =====================================================

        request.setAttribute(
                "eventList",
                eventList
        );


        request.setAttribute(
                "keyword",
                keyword
        );


        request.setAttribute(
                "selectedEventType",
                eventType
        );


        request.setAttribute(
                "selectedSource",
                source
        );


        request.setAttribute(
                "sortBy",
                sortBy
        );


        request.setAttribute(
                "sortOrder",
                sortOrder
        );


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


        request.setAttribute(
                "startRecord",
                startRecord
        );


        request.setAttribute(
                "endRecord",
                endRecord
        );
    }


    // =========================================================
    // PARSE POSITIVE INTEGER
    // =========================================================

    private int parsePositiveInt(
            String value,
            int defaultValue) {


        try {

            int number =
                    Integer.parseInt(
                            value
                    );


            if (number > 0) {

                return number;
            }


        } catch (Exception e) {
            // Do nothing
            // → use default
        }


        return defaultValue;
    }


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