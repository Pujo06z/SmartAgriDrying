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

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        User user
                = (User) session.getAttribute(
                        "LOGIN_USER"
                );


        try {

            WarehouseDAO warehouseDAO
                    = new WarehouseDAO();

            DeviceDAO deviceDAO
                    = new DeviceDAO();

            SensorDataDAO sensorDAO
                    = new SensorDataDAO();

            DryingBatchDAO batchDAO
                    = new DryingBatchDAO();


            // 1. Warehouse
            Warehouse warehouse
                    = warehouseDAO.getWarehouseByUser(
                            user.getUserId()
                    );


            if (warehouse == null) {

                request.setAttribute(
                        "error",
                        "No warehouse assigned."
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/history.jsp"
                ).forward(request, response);

                return;
            }


            // 2. Device
            Device device
                    = deviceDAO.getDeviceByWarehouse(
                            warehouse.getWarehouseId()
                    );


            // 3. Sensor History
            List<SensorData> sensors
                    = new ArrayList<>();

            if (device != null) {

                sensors
                        = sensorDAO.getSensorHistory(
                                device.getDeviceId()
                        );
            }


            // 4. Batch History
            List<DryingBatch> batches
                    = batchDAO
                    .getCompletedBatchesByWarehouse(
                            warehouse.getWarehouseId()
                    );


            // 5. Tab hiện tại
            String tab
                    = request.getParameter("tab");

            if (tab == null) {
                tab = "sensor";
            }


            // 6. Set attributes
            request.setAttribute(
                    "warehouse",
                    warehouse
            );

            request.setAttribute(
                    "device",
                    device
            );

            request.setAttribute(
                    "sensors",
                    sensors
            );

            request.setAttribute(
                    "batches",
                    batches
            );

            request.setAttribute(
                    "tab",
                    tab
            );


            // 7. JSP
            request.getRequestDispatcher(
                    "/WEB-INF/views/history.jsp"
            ).forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Error in HistoryController",
                    e
            );
        }
    }


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
