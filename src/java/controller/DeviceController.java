package controller;

import dao.DeviceDAO;
import dao.WarehouseDAO;
import model.Device;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeviceController", urlPatterns = {"/devices"})
public class DeviceController extends HttpServlet {

    private final DeviceDAO dao = new DeviceDAO();

    protected void processRequest(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {
        try {
            List<Device> devices = dao.getAllDevices();
            rq.setAttribute("devices", devices); // Assuming JSP uses 'devices' based on typical pattern, or 'deviceList'
            rq.setAttribute("deviceList", devices); // Adding both to be safe
            rq.setAttribute("totalDevices", devices.size());
            rq.setAttribute("onlineDevices", dao.countOnlineDevices());
            rq.setAttribute("warehouseList", new WarehouseDAO().getAllWarehouses());
            rq.setAttribute("warehouses", new WarehouseDAO().getAllWarehouses());

            rq.getRequestDispatcher("/WEB-INF/views/devices.jsp").forward(rq, rs);
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
        String deviceId = rq.getParameter("deviceId");
        if (deviceId == null) {
            deviceId = rq.getParameter("id"); // fallback for jsp mismatches
        }

        try {
            if ("add".equals(action)) {
                dao.add(
                        deviceId.trim(),
                        rq.getParameter("deviceCode").trim(),
                        rq.getParameter("deviceName").trim(),
                        rq.getParameter("warehouseId")
                );
            } else if ("edit".equals(action)) {
                dao.update(
                        deviceId,
                        rq.getParameter("deviceCode").trim(),
                        rq.getParameter("deviceName").trim(),
                        rq.getParameter("warehouseId")
                );
            } else if ("toggle".equals(action)) {
                dao.updateStatus(deviceId);
            }
        } catch (Exception e) {
            rq.getSession().setAttribute("flash", "Lỗi: " + e.getMessage());
        }

        rs.sendRedirect(rq.getContextPath() + "/devices");
    }

    @Override
    public String getServletInfo() {
        return "Device Management Controller";
    }
}
