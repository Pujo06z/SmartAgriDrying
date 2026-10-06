/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.WarehouseDAO;
import model.Warehouse;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouses"})
public class WarehouseController extends HttpServlet {

    private final WarehouseDAO dao = new WarehouseDAO();

    protected void processRequest(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {

        try {
            List<Warehouse> list = dao.getAllWarehouses();
            int active = 0;
            int inactive = 0;

            for (Warehouse w : list) {
                if (w.isActive()) {
                    active++;
                } else {
                    inactive++;
                }
            }

            rq.setAttribute("warehouses", list); // Match JSP ${warehouses}
            rq.setAttribute("activeCount", active); // Match JSP ${activeCount}

            rq.getRequestDispatcher("/WEB-INF/views/warehouses.jsp").forward(rq, rs);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {
        processRequest(rq, rs);
    }

    @Override
    protected void doPost(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {

        rq.setCharacterEncoding("UTF-8");

        String action = rq.getParameter("action");
        String id = rq.getParameter("id"); // JSP uses "id"

        try {
            if ("add".equals(action)) {
                dao.add(
                        id.trim().toUpperCase(),
                        rq.getParameter("name").trim(),
                        rq.getParameter("location").trim()
                );
            } else if ("edit".equals(action)) {
                dao.update(
                        id,
                        rq.getParameter("name").trim(),
                        rq.getParameter("location").trim()
                );
            } else if ("toggle".equals(action)) {
                dao.toggleStatus(id);
            }
        } catch (Exception e) {
            rq.getSession().setAttribute("flash", "Lỗi: " + e.getMessage());
        }

        rs.sendRedirect(rq.getContextPath() + "/warehouses");
    }

    @Override
    public String getServletInfo() {
        return "Warehouse Management Controller";
    }
}
