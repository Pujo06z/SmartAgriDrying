package controller;

import dao.DeviceDAO;
import dao.EventLogDAO;
import dao.WarehouseDAO;
import model.Device;
import model.User;
import model.Warehouse;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControlController", urlPatterns = {"/control"})
public class ControlController extends HttpServlet {

    private final DeviceDAO deviceDAO = new DeviceDAO();
    private final EventLogDAO eventDAO = new EventLogDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("LOGIN_USER");
        if (!"OPERATOR".equals(user.getRole()) && !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        String deviceIdParam = request.getParameter("deviceId");
        String msg = null;

        try {
            Device device = null;
            if ("MANAGER".equals(user.getRole())) {
                if (deviceIdParam != null && deviceDAO.isAssignedToManager(user.getUserId(), deviceIdParam)) {
                    device = deviceDAO.getById(deviceIdParam);
                } else {
                    msg = "Bạn không có quyền điều khiển device này.";
                }
            } else if ("OPERATOR".equals(user.getRole())) {
                Warehouse warehouse = warehouseDAO.getWarehouseByUser(user.getUserId());
                if (warehouse != null) {
                    device = deviceDAO.getDeviceByWarehouse(warehouse.getWarehouseId());
                }
            }

            if (device != null && msg == null) {
                String deviceId = device.getDeviceId();
                String mode = device.getMode();

                if ("AUTO".equals(action) || "setAuto".equals(action)) {
                    deviceDAO.updateMode(deviceId, "AUTO");
                    eventDAO.add(device.getWarehouseId(), deviceId, "MODE_CHANGED", "Mode changed to AUTO");
                } else if ("MANUAL".equals(action) || "setManual".equals(action)) {
                    deviceDAO.updateMode(deviceId, "MANUAL");
                    eventDAO.add(device.getWarehouseId(), deviceId, "MODE_CHANGED", "Mode changed to MANUAL");
                } else if ("OPEN".equals(action) || "open".equals(action)) {
                    if (!"MANUAL".equals(mode)) {
                        msg = "Phải chuyển sang MANUAL trước.";
                    } else {
                        deviceDAO.updateRoofStatus(deviceId, "OPEN");
                        eventDAO.add(device.getWarehouseId(), deviceId, "ROOF_OPENED", "Roof opened manually");
                    }
                } else if ("CLOSE".equals(action) || "close".equals(action)) {
                    if (!"MANUAL".equals(mode)) {
                        msg = "Phải chuyển sang MANUAL trước.";
                    } else {
                        deviceDAO.updateRoofStatus(deviceId, "CLOSED");
                        eventDAO.add(device.getWarehouseId(), deviceId, "ROOF_CLOSED", "Roof closed manually");
                    }
                }
            } else if (msg == null) {
                msg = "Không tìm thấy device.";
            }
        } catch (Exception e) {
            msg = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        }

        if (msg != null) {
            request.getSession().setAttribute("flash", msg);
            request.getSession().setAttribute("error", msg);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Control Controller";
    }
}
