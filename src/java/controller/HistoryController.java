package controller;

import dao.DryingBatchDAO;
import dao.EventLogDAO;
import dao.SensorDataDAO;
import dao.DeviceDAO;
import dao.WarehouseDAO;
import model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "HistoryController", urlPatterns = {"/history"})
public class HistoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {

        User user = (User) rq.getSession().getAttribute("LOGIN_USER");

        try {
            String deviceId = rq.getParameter("deviceId");
            String managerId = user.getUserId();

            rq.setAttribute("warehouseList", new WarehouseDAO().getWarehousesByManager(managerId));
            rq.setAttribute("deviceList", new DeviceDAO().getDevicesByManager(managerId));
            rq.setAttribute("batchHistory", new DryingBatchDAO().getByManager(managerId, null, null));
            rq.setAttribute("sensorHistory", new SensorDataDAO().getHistoryByManager(managerId, deviceId));
            rq.setAttribute("eventHistory", new EventLogDAO().getByManager(managerId));

            rq.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(rq, rs);

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
        processRequest(rq, rs);
    }

    @Override
    public String getServletInfo() {
        return "History Controller";
    }
}
