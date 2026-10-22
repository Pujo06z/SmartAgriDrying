package api;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import dao.DeviceDAO;
import dao.SensorDataDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Device;
import model.SensorData;
import model.User;
import model.Warehouse;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(
        name = "DashboardDataApi",
        urlPatterns = {"/api/dashboard-data"}
)
public class DashboardDataApi extends HttpServlet {

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        PrintWriter out
                = response.getWriter();

        try {

            // =====================================
            // Check login session
            // =====================================
            HttpSession session
                    = request.getSession(false);

            if (session == null
                    || session.getAttribute("LOGIN_USER") == null) {

                response.setStatus(
                        HttpServletResponse.SC_UNAUTHORIZED
                );

                out.print(
                        "{\"error\":\"NOT_LOGGED_IN\"}"
                );

                return;
            }

            User user
                    = (User) session.getAttribute(
                            "LOGIN_USER"
                    );

            String role
                    = user.getRole();

            WarehouseDAO warehouseDAO
                    = new WarehouseDAO();

            DeviceDAO deviceDAO
                    = new DeviceDAO();

            SensorDataDAO sensorDAO
                    = new SensorDataDAO();

            Warehouse warehouse = null;

            // =====================================
            // Resolve warehouse for OPERATOR
            // =====================================
            if ("OPERATOR".equals(role)) {

                warehouse
                        = warehouseDAO.getWarehouseByUser(
                                user.getUserId()
                        );
            } // =====================================
            // Resolve warehouse for MANAGER
            // =====================================
            else if ("MANAGER".equals(role)) {

                String warehouseId
                        = request.getParameter(
                                "warehouseId"
                        );

                if (warehouseId == null
                        || warehouseId.trim().isEmpty()) {

                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );

                    out.print(
                            "{\"error\":\"MISSING_WAREHOUSE\"}"
                    );

                    return;
                }

                // =====================================
                // Verify manager warehouse permission
                // =====================================
                boolean warehouseAllowed
                        = warehouseDAO.isAssignedToManager(
                                user.getUserId(),
                                warehouseId.trim()
                        );

                if (!warehouseAllowed) {

                    response.setStatus(
                            HttpServletResponse.SC_FORBIDDEN
                    );

                    out.print(
                            "{\"error\":\"WAREHOUSE_NOT_ALLOWED\"}"
                    );

                    return;
                }

                warehouse
                        = warehouseDAO.getById(
                                warehouseId.trim()
                        );
            } // =====================================
            // Reject unsupported roles
            // =====================================
            else {

                response.setStatus(
                        HttpServletResponse.SC_FORBIDDEN
                );

                out.print(
                        "{\"error\":\"FORBIDDEN\"}"
                );

                return;
            }

            // =====================================
            // Validate warehouse
            // =====================================
            if (warehouse == null) {

                response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND
                );

                out.print(
                        "{\"error\":\"WAREHOUSE_NOT_FOUND\"}"
                );

                return;
            }

            // =====================================
            // Get active device
            // =====================================
            Device device
                    = deviceDAO.getDeviceByWarehouse(
                            warehouse.getWarehouseId()
                    );

            if (device == null) {

                out.print(
                        "{"
                        + "\"connectionStatus\":\"OFFLINE\","
                        + "\"mode\":\"N/A\","
                        + "\"roofStatus\":\"N/A\","
                        + "\"temperature\":null,"
                        + "\"humidity\":null,"
                        + "\"rainStatus\":\"N/A\","
                        + "\"lightStatus\":\"N/A\","
                        + "\"warning\":\"NO DEVICE\""
                        + "}"
                );

                return;
            }

            // =====================================
            // Calculate connection status
            // =====================================
            String connectionStatus
                    = "OFFLINE";

            if (device.getLastSeen() != null) {

                long difference
                        = System.currentTimeMillis()
                        - device.getLastSeen().getTime();

                if (difference <= 30000) {

                    connectionStatus
                            = "ONLINE";
                }
            }

            // =====================================
            // Get latest sensor data
            // =====================================
            SensorData latestSensor
                    = sensorDAO.getLatestSensorData(
                            device.getDeviceId()
                    );
// =====================================
// Get recent sensor readings
// =====================================

            List<SensorData> recentSensors
                    = sensorDAO.getRecentSensorData(
                            device.getDeviceId(),
                            6
                    );
            Double temperature = null;
            Double humidity = null;

            String rainStatus
                    = "N/A";

            String lightStatus
                    = "N/A";

            String warning
                    = "NORMAL";

            if (latestSensor != null) {

                temperature
                        = latestSensor.getTemperature();

                humidity
                        = latestSensor.getHumidity();

                rainStatus
                        = latestSensor.getRainStatus();

                lightStatus
                        = latestSensor.getLightStatus();

                if ("OFFLINE".equals(
                        connectionStatus)) {

                    warning = "DEVICE OFFLINE";

                } else if ("RAINING".equals(
                        latestSensor.getRainStatus())) {

                    warning = "RAIN DETECTED";

                } else if (temperature >= 40.0) {

                    warning = "HIGH TEMPERATURE";

                } else if (temperature <= 15.0) {

                    warning = "LOW TEMPERATURE";
                }

            } else {

                warning
                        = "NO SENSOR DATA";
            }
// =====================================
// Build recent sensor JSON array
// =====================================

            StringBuilder recentSensorJson
                    = new StringBuilder();

            recentSensorJson.append("[");

            SimpleDateFormat dateFormat
                    = new SimpleDateFormat(
                            "dd/MM/yyyy HH:mm:ss"
                    );

            for (int i = 0;
                    i < recentSensors.size();
                    i++) {

                SensorData sensor
                        = recentSensors.get(i);

                if (i > 0) {
                    recentSensorJson.append(",");
                }

                recentSensorJson.append("{");

                recentSensorJson.append(
                        "\"recordedAt\":\""
                );

                recentSensorJson.append(
                        dateFormat.format(
                                sensor.getRecordedAt()
                        )
                );

                recentSensorJson.append("\",");

                recentSensorJson.append(
                        "\"temperature\":"
                );

                recentSensorJson.append(
                        sensor.getTemperature()
                );

                recentSensorJson.append(",");

                recentSensorJson.append(
                        "\"humidity\":"
                );

                recentSensorJson.append(
                        sensor.getHumidity()
                );

                recentSensorJson.append(",");

                recentSensorJson.append(
                        "\"rainStatus\":\""
                );

                recentSensorJson.append(
                        sensor.getRainStatus()
                );

                recentSensorJson.append("\",");

                recentSensorJson.append(
                        "\"lightStatus\":\""
                );

                recentSensorJson.append(
                        sensor.getLightStatus()
                );

                recentSensorJson.append("\",");

                recentSensorJson.append(
                        "\"roofStatus\":\""
                );

                recentSensorJson.append(
                        sensor.getRoofStatus()
                );

                recentSensorJson.append("\"");

                recentSensorJson.append("}");
            }

            recentSensorJson.append("]");
            // =====================================
            // Return JSON
            // =====================================
            out.print(
                    "{"
                    + "\"connectionStatus\":\""
                    + connectionStatus
                    + "\","
                    + "\"mode\":\""
                    + device.getMode()
                    + "\","
                    + "\"roofStatus\":\""
                    + device.getRoofStatus()
                    + "\","
                    + "\"temperature\":"
                    + (temperature == null
                            ? "null"
                            : temperature)
                    + ","
                    + "\"humidity\":"
                    + (humidity == null
                            ? "null"
                            : humidity)
                    + ","
                    + "\"rainStatus\":\""
                    + rainStatus
                    + "\","
                    + "\"lightStatus\":\""
                    + lightStatus
                    + "\","
                    + "\"warning\":\""
                    + warning
                    + "\","
                    + "\"recentSensors\":"
                    + recentSensorJson.toString()
                    + "}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            out.print(
                    "{\"error\":\"SERVER_ERROR\"}"
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }

    @Override
    public String getServletInfo() {

        return "Live dashboard data API";
    }
}
