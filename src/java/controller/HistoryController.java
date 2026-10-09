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
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Device;
import model.DryingBatch;
import model.SensorData;
import model.User;
import model.Warehouse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "HistoryController", urlPatterns = {"/history"})
public class HistoryController extends HttpServlet {

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

    // =========================================
    // 1. LOGIN USER
    // AuthenticationFilter đã kiểm tra login
    // =========================================

    HttpSession session
            = request.getSession();

    User user
            = (User) session.getAttribute(
                    "LOGIN_USER"
            );

    String role
            = user.getRole();


    // History chỉ dành cho Operator + Manager
    if (!"OPERATOR".equals(role)
            && !"MANAGER".equals(role)) {

        response.sendRedirect(
                request.getContextPath()
                + "/dashboard"
        );

        return;
    }


    try {

        WarehouseDAO warehouseDAO
                = new WarehouseDAO();

        DeviceDAO deviceDAO
                = new DeviceDAO();

        SensorDataDAO sensorDAO
                = new SensorDataDAO();

        DryingBatchDAO batchDAO
                = new DryingBatchDAO();


        Warehouse warehouse = null;

        List<Warehouse> warehouseList
                = new ArrayList<>();


        // =========================================
        // 2. MANAGER
        // =========================================

        if ("MANAGER".equals(role)) {

            warehouseList
                    = warehouseDAO
                            .getWarehousesByManager(
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
                        "/WEB-INF/views/history.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            String selectedWarehouseId
                    = request.getParameter(
                            "warehouseId"
                    );


            // Manager đã chọn warehouse
            if (selectedWarehouseId != null
                    && !selectedWarehouseId
                            .trim()
                            .isEmpty()) {

                for (Warehouse w
                        : warehouseList) {

                    if (selectedWarehouseId.equals(
                            w.getWarehouseId())) {

                        warehouse = w;

                        break;
                    }
                }
            }


            // Chưa chọn hoặc warehouseId sai
            // -> lấy warehouse đầu tiên
            if (warehouse == null) {

                warehouse
                        = warehouseList.get(0);
            }
        }


        // =========================================
        // 3. OPERATOR
        // =========================================

        else {

            warehouse
                    = warehouseDAO
                            .getWarehouseByUser(
                                    user.getUserId()
                            );


            if (warehouse != null) {

                warehouseList.add(
                        warehouse
                );
            }
        }


        // =========================================
        // 4. KHÔNG CÓ WAREHOUSE
        // =========================================

        if (warehouse == null) {

            request.setAttribute(
                    "error",
                    "No warehouse assigned."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/history.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // =========================================
        // 5. DEVICE
        // =========================================

        Device device
                = deviceDAO
                        .getDeviceByWarehouse(
                                warehouse
                                        .getWarehouseId()
                        );


        // =========================================
        // 6. TAB
        // =========================================

        String tab
                = request.getParameter(
                        "tab"
                );


        if (!"sensor".equals(tab)
                && !"batch".equals(tab)) {

            tab = "sensor";
        }


        // =================================================
        // 7. SENSOR HISTORY
        // Search + Rain Filter + Light Filter + Pagination
        // =================================================

        String sensorKeyword
                = request.getParameter(
                        "sensorKeyword"
                );

        String rainStatus
                = request.getParameter(
                        "rainStatus"
                );

        String lightStatus
                = request.getParameter(
                        "lightStatus"
                );


        if (sensorKeyword == null) {

            sensorKeyword = "";
        }


        // Chỉ nhận giá trị hợp lệ trong database
        if (!"NO_RAIN".equals(rainStatus)
                && !"RAINING".equals(rainStatus)) {

            rainStatus = "";
        }


        if (!"BRIGHT".equals(lightStatus)
                && !"DARK".equals(lightStatus)) {

            lightStatus = "";
        }


        // =========================================
        // SENSOR PAGINATION
        // =========================================

        int sensorPage = 1;

        int sensorPageSize = 10;


        String sensorPageParam
                = request.getParameter(
                        "sensorPage"
                );


        if (sensorPageParam != null) {

            try {

                sensorPage
                        = Integer.parseInt(
                                sensorPageParam
                        );

            } catch (NumberFormatException e) {

                sensorPage = 1;
            }
        }


        if (sensorPage < 1) {

            sensorPage = 1;
        }


        int sensorTotalRecords = 0;

        int sensorTotalPages = 1;


        List<SensorData> sensors
                = new ArrayList<>();


        // Có device mới có sensor history
        if (device != null) {

            sensorTotalRecords
                    = sensorDAO
                            .countSensorHistory(
                                    device.getDeviceId(),
                                    sensorKeyword,
                                    rainStatus,
                                    lightStatus
                            );


            sensorTotalPages
                    = (int) Math.ceil(
                            (double) sensorTotalRecords
                            / sensorPageSize
                    );


            if (sensorTotalPages < 1) {

                sensorTotalPages = 1;
            }


            if (sensorPage
                    > sensorTotalPages) {

                sensorPage
                        = sensorTotalPages;
            }


            sensors
                    = sensorDAO
                            .searchSensorHistory(
                                    device.getDeviceId(),
                                    sensorKeyword,
                                    rainStatus,
                                    lightStatus,
                                    sensorPage,
                                    sensorPageSize
                            );
        }


        // =================================================
        // 8. BATCH HISTORY
        // Search + Date Filter + Pagination
        // =================================================

        String batchKeyword
                = request.getParameter(
                        "batchKeyword"
                );

        String fromDate
                = request.getParameter(
                        "fromDate"
                );

        String toDate
                = request.getParameter(
                        "toDate"
                );


        if (batchKeyword == null) {

            batchKeyword = "";
        }


        if (fromDate == null) {

            fromDate = "";
        }


        if (toDate == null) {

            toDate = "";
        }


        // =========================================
        // BATCH PAGINATION
        // =========================================

        int batchPage = 1;

        int batchPageSize = 10;


        String batchPageParam
                = request.getParameter(
                        "batchPage"
                );


        if (batchPageParam != null) {

            try {

                batchPage
                        = Integer.parseInt(
                                batchPageParam
                        );

            } catch (NumberFormatException e) {

                batchPage = 1;
            }
        }


        if (batchPage < 1) {

            batchPage = 1;
        }


        // =========================================
        // COUNT BATCH HISTORY
        // =========================================

        int batchTotalRecords
                = batchDAO
                        .countCompletedBatchHistory(
                                warehouse
                                        .getWarehouseId(),
                                batchKeyword,
                                fromDate,
                                toDate
                        );


        int batchTotalPages
                = (int) Math.ceil(
                        (double) batchTotalRecords
                        / batchPageSize
                );


        if (batchTotalPages < 1) {

            batchTotalPages = 1;
        }


        if (batchPage
                > batchTotalPages) {

            batchPage
                    = batchTotalPages;
        }


        // =========================================
        // GET BATCH HISTORY
        // =========================================

        List<DryingBatch> batches
                = batchDAO
                        .searchCompletedBatchHistory(
                                warehouse
                                        .getWarehouseId(),
                                batchKeyword,
                                fromDate,
                                toDate,
                                batchPage,
                                batchPageSize
                        );


        // =========================================
        // 9. COMMON ATTRIBUTES
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
                "device",
                device
        );

        request.setAttribute(
                "tab",
                tab
        );


        // =========================================
        // 10. SENSOR ATTRIBUTES
        // =========================================

        request.setAttribute(
                "sensors",
                sensors
        );

        request.setAttribute(
                "sensorKeyword",
                sensorKeyword
        );

        request.setAttribute(
                "selectedRainStatus",
                rainStatus
        );

        request.setAttribute(
                "selectedLightStatus",
                lightStatus
        );

        request.setAttribute(
                "sensorCurrentPage",
                sensorPage
        );

        request.setAttribute(
                "sensorTotalPages",
                sensorTotalPages
        );

        request.setAttribute(
                "sensorTotalRecords",
                sensorTotalRecords
        );


        // =========================================
        // 11. BATCH ATTRIBUTES
        // =========================================

        request.setAttribute(
                "batches",
                batches
        );

        request.setAttribute(
                "batchKeyword",
                batchKeyword
        );

        request.setAttribute(
                "fromDate",
                fromDate
        );

        request.setAttribute(
                "toDate",
                toDate
        );

        request.setAttribute(
                "batchCurrentPage",
                batchPage
        );

        request.setAttribute(
                "batchTotalPages",
                batchTotalPages
        );

        request.setAttribute(
                "batchTotalRecords",
                batchTotalRecords
        );


        // =========================================
        // 12. JSP
        // =========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/history.jsp"
        ).forward(
                request,
                response
        );


    } catch (Exception e) {

        e.printStackTrace();

        throw new ServletException(
                "Error in HistoryController",
                e
        );
    }
}
//    protected void processRequest(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session
//                = request.getSession(false);
//
//        if (session == null
//                || session.getAttribute("LOGIN_USER") == null) {
//
//            response.sendRedirect(
//                    request.getContextPath() + "/login"
//            );
//
//            return;
//        }
//
//
//        User user
//                = (User) session.getAttribute(
//                        "LOGIN_USER"
//                );
//
//
//        try {
//
//            WarehouseDAO warehouseDAO
//                    = new WarehouseDAO();
//
//            DeviceDAO deviceDAO
//                    = new DeviceDAO();
//
//            SensorDataDAO sensorDAO
//                    = new SensorDataDAO();
//
//            DryingBatchDAO batchDAO
//                    = new DryingBatchDAO();
//
//
//            // 1. Warehouse
//            Warehouse warehouse
//                    = warehouseDAO.getWarehouseByUser(
//                            user.getUserId()
//                    );
//
//
//            if (warehouse == null) {
//
//                request.setAttribute(
//                        "error",
//                        "No warehouse assigned."
//                );
//
//                request.getRequestDispatcher(
//                        "/WEB-INF/views/history.jsp"
//                ).forward(request, response);
//
//                return;
//            }
//
//
//            // 2. Device
//            Device device
//                    = deviceDAO.getDeviceByWarehouse(
//                            warehouse.getWarehouseId()
//                    );
//
//
//            // 3. Sensor History
//            List<SensorData> sensors
//                    = new ArrayList<>();
//
//            if (device != null) {
//
//                sensors
//                        = sensorDAO.getSensorHistory(
//                                device.getDeviceId()
//                        );
//            }
//
//
//            // 4. Batch History
//            List<DryingBatch> batches
//                    = batchDAO
//                    .getCompletedBatchesByWarehouse(
//                            warehouse.getWarehouseId()
//                    );
//
//
//            // 5. Tab hiện tại
//            String tab
//                    = request.getParameter("tab");
//
//            if (tab == null) {
//                tab = "sensor";
//            }
//
//
//            // 6. Set attributes
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
//                    "sensors",
//                    sensors
//            );
//
//            request.setAttribute(
//                    "batches",
//                    batches
//            );
//
//            request.setAttribute(
//                    "tab",
//                    tab
//            );
//
//
//            // 7. JSP
//            request.getRequestDispatcher(
//                    "/WEB-INF/views/history.jsp"
//            ).forward(request, response);
//
//
//        } catch (Exception e) {
//
//            e.printStackTrace();
//
//            throw new ServletException(
//                    "Error in HistoryController",
//                    e
//            );
//        }
//    }
//    @Override
//    protected void doGet(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws ServletException, IOException {
//
//        processRequest(request, response);
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
