
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package api;

import dao.DeviceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Device;
/**
 *
 * @author ADMIN
 */



@WebServlet(
        name = "DeviceStateApi",
        urlPatterns = {"/api/device-state"}
)
public class DeviceStateApi extends HttpServlet {

    private DeviceDAO deviceDAO;

    @Override
    public void init()
            throws ServletException {

        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType(
                "text/plain"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        PrintWriter out
                = response.getWriter();

        try {

            // =====================================
            // Read data from ESP32
            // =====================================

            String deviceId
                    = request.getParameter(
                            "deviceId"
                    );

            String espRoofStatus
                    = request.getParameter(
                            "roofStatus"
                    );

            // =====================================
            // Validate required data
            // =====================================

            if (deviceId == null
                    || deviceId.trim().isEmpty()
                    || espRoofStatus == null
                    || espRoofStatus.trim().isEmpty()) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=MISSING_DATA"
                );

                return;
            }

            deviceId
                    = deviceId.trim();

            espRoofStatus
                    = espRoofStatus.trim();

            // =====================================
            // Validate roof status
            // =====================================

            if (!"OPEN".equals(
                    espRoofStatus)
                    && !"CLOSED".equals(
                            espRoofStatus)) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=INVALID_ROOF"
                );

                return;
            }

            // =====================================
            // Find active device
            // =====================================

            Device device
                    = deviceDAO.getById(
                            deviceId
                    );

            if (device == null
                    || !"ACTIVE".equals(
                            device.getStatus())) {

                response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND
                );

                out.println(
                        "ERROR=DEVICE_NOT_FOUND"
                );

                return;
            }

            // =====================================
            // Update device state
            // =====================================

            if ("AUTO".equals(
                    device.getMode())) {

                /*
                 * In AUTO mode, the ESP32 controls
                 * the physical roof based on sensors.
                 */

                deviceDAO.updateAutoRoofStatus(
                        deviceId,
                        espRoofStatus
                );

            } else if ("MANUAL".equals(
                    device.getMode())) {

                /*
                 * In MANUAL mode, the web application
                 * controls DEVICE.roof_status.
                 *
                 * The ESP32 must not overwrite
                 * the server roof command.
                 */

                deviceDAO.updateLastSeen(
                        deviceId
                );
            }

            // =====================================
            // Read the latest server state
            // =====================================

            Device updatedDevice
                    = deviceDAO.getById(
                            deviceId
                    );

            if (updatedDevice == null) {

                response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND
                );

                out.println(
                        "ERROR=DEVICE_NOT_FOUND"
                );

                return;
            }

            // =====================================
            // Return command to ESP32
            // =====================================

            out.println(
                    "OK"
            );

            out.println(
                    "MODE="
                    + updatedDevice.getMode()
            );

            out.println(
                    "ROOF="
                    + updatedDevice.getRoofStatus()
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            out.println(
                    "ERROR=SERVER_ERROR"
            );
        }
    }
}
