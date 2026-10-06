/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DryingBatchDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
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

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

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


    // Lấy warehouse của user
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
                "/WEB-INF/views/batch.jsp"
        ).forward(request, response);

        return;
    }


    // Lấy tất cả batch trong warehouse
    List<DryingBatch> batches
            = batchDAO.getBatchesByWarehouse(
                    warehouse.getWarehouseId()
            );


    request.setAttribute(
            "warehouse",
            warehouse
    );

    request.setAttribute(
            "batches",
            batches
    );


    request.getRequestDispatcher(
            "/WEB-INF/views/batch.jsp"
    ).forward(request, response);
}

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


    // Lấy warehouse của operator
    Warehouse warehouse
            = warehouseDAO.getWarehouseByUser(
                    user.getUserId()
            );


    if (warehouse == null) {

        response.sendRedirect(
                request.getContextPath() + "/batch"
        );

        return;
    }


    // Lấy dữ liệu từ form
    String productName
            = request.getParameter("productName");

    String weightText
            = request.getParameter("weightKg");

    String notes
            = request.getParameter("notes");


    // Validate
    if (productName == null
            || productName.trim().isEmpty()
            || weightText == null
            || weightText.trim().isEmpty()) {

        request.getSession().setAttribute(
                "message",
                "Product name and weight are required."
        );

        response.sendRedirect(
                request.getContextPath() + "/batch"
        );

        return;
    }


    double weightKg;

    try {

        weightKg
                = Double.parseDouble(weightText);

        if (weightKg <= 0) {
            throw new NumberFormatException();
        }

    } catch (NumberFormatException e) {

        request.getSession().setAttribute(
                "message",
                "Weight must be greater than 0."
        );

        response.sendRedirect(
                request.getContextPath() + "/batch"
        );

        return;
    }


    // Tạo batch mới
    boolean success
            = batchDAO.createBatch(
                    warehouse.getWarehouseId(),
                    user.getUserId(),
                    productName.trim(),
                    weightKg,
                    notes
            );


    if (success) {

        request.getSession().setAttribute(
                "message",
                "Batch started successfully."
        );

    } else {

        request.getSession().setAttribute(
                "message",
                "Cannot start batch."
        );
    }


    response.sendRedirect(
            request.getContextPath() + "/batch"
    );
}

    // ==============================
    // COMPLETE BATCH
    // ==============================
    private void completeBatch(
            HttpServletRequest request,
            HttpServletResponse response,
            User user)
            throws Exception {

        String batchId
                = request.getParameter("batchId");

        if (batchId == null
                || batchId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/batch"
            );

            return;
        }

        DryingBatchDAO batchDAO
                = new DryingBatchDAO();

        boolean success
                = batchDAO.completeBatch(
                        batchId,
                        user.getUserId()
                );

        if (success) {

            request.getSession().setAttribute(
                    "message",
                    "Batch completed successfully."
            );

        } else {

            request.getSession().setAttribute(
                    "message",
                    "Cannot complete this batch."
            );
        }

        response.sendRedirect(
                request.getContextPath() + "/batch"
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
