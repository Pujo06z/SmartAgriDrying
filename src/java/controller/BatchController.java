package controller;

import dao.DryingBatchDAO;
import dao.WarehouseDAO;
import model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BatchController", urlPatterns = {"/batch"})
public class BatchController extends HttpServlet {

    private final DryingBatchDAO dao = new DryingBatchDAO();

    protected void processRequest(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {
        User user = (User) rq.getSession().getAttribute("LOGIN_USER");
        try {
            String warehouseId = rq.getParameter("warehouseId");
            String search = rq.getParameter("search");

            rq.setAttribute("warehouseList", new WarehouseDAO().getWarehousesByManager(user.getUserId()));
            rq.setAttribute("batchList", dao.getByManager(user.getUserId(), warehouseId, search));
            rq.setAttribute("selectedWarehouse", warehouseId);
            rq.setAttribute("search", search);

            rq.getRequestDispatcher("/WEB-INF/views/batch.jsp").forward(rq, rs);
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
        User user = (User) rq.getSession().getAttribute("LOGIN_USER");
        String action = rq.getParameter("action");
        String msg = null;

        try {
            if ("start".equals(action)) {
                String batchId = rq.getParameter("batchId");
                String warehouseId = rq.getParameter("warehouseId");

                if (dao.exists(batchId)) {
                    msg = "Batch ID đã tồn tại.";
                } else if (dao.hasActiveBatch(warehouseId)) {
                    msg = "Warehouse này đang có batch đang sấy.";
                } else {
                    dao.startBatch(batchId, warehouseId, user.getUserId());
                }
            } else if ("complete".equals(action)) {
                dao.completeBatch(rq.getParameter("batchId"), user.getUserId());
            }
        } catch (Exception e) {
            msg = "Lỗi: " + e.getMessage();
        }

        if (msg != null) {
            rq.getSession().setAttribute("flash", msg);
        }

        rs.sendRedirect(rq.getContextPath() + "/batch");
    }

    @Override
    public String getServletInfo() {
        return "Batch Management Controller";
    }
}
