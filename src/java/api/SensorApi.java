package api;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import dao.DeviceDAO;
import dao.SensorDataDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Device;
import util.NotificationService;
/**
 *
 * @author ADMIN
 */




@WebServlet(
        name = "SensorApi",
        urlPatterns = {"/api/sensor"}
)
public class SensorApi extends HttpServlet {

    private SensorDataDAO sensorDAO;
    private DeviceDAO deviceDAO;

    @Override
    public void init()
            throws ServletException {

        sensorDAO
                = new SensorDataDAO();

        deviceDAO
                = new DeviceDAO();
    }

    protected void processRequest(
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

            String temperatureRaw
                    = request.getParameter(
                            "temperature"
                    );

            String humidityRaw
                    = request.getParameter(
                            "humidity"
                    );

            String rainStatus
                    = request.getParameter(
                            "rainStatus"
                    );

            String lightStatus
                    = request.getParameter(
                            "lightStatus"
                    );

            String roofStatus
                    = request.getParameter(
                            "roofStatus"
                    );

            // =====================================
            // Validate required data
            // =====================================

            if (deviceId == null
                    || temperatureRaw == null
                    || humidityRaw == null
                    || rainStatus == null
                    || lightStatus == null
                    || roofStatus == null) {

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

            rainStatus
                    = rainStatus.trim();

            lightStatus
                    = lightStatus.trim();

            roofStatus
                    = roofStatus.trim();

            // =====================================
            // Validate active device
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
            // Convert numeric values
            // =====================================

            double temperature
                    = Double.parseDouble(
                            temperatureRaw
                    );

            double humidity
                    = Double.parseDouble(
                            humidityRaw
                    );

            // =====================================
            // Validate humidity
            // =====================================

            if (humidity < 0
                    || humidity > 100) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=INVALID_HUMIDITY"
                );

                return;
            }

            // =====================================
            // Validate rain status
            // =====================================

            if (!"RAINING".equals(
                    rainStatus)
                    && !"NO_RAIN".equals(
                            rainStatus)) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=INVALID_RAIN"
                );

                return;
            }

            // =====================================
            // Validate light status
            // =====================================

            if (!"BRIGHT".equals(
                    lightStatus)
                    && !"DARK".equals(
                            lightStatus)) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=INVALID_LIGHT"
                );

                return;
            }

            // =====================================
            // Validate roof status
            // =====================================

            if (!"OPEN".equals(
                    roofStatus)
                    && !"CLOSED".equals(
                            roofStatus)) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                out.println(
                        "ERROR=INVALID_ROOF"
                );

                return;
            }

            // =====================================
            // Save sensor history
            // =====================================

            boolean inserted
                    = sensorDAO.insertSensorData(
                            deviceId,
                            temperature,
                            humidity,
                            rainStatus,
                            lightStatus,
                            roofStatus
                    );

            if (!inserted) {

                response.setStatus(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );

                out.println(
                        "ERROR=INSERT_FAILED"
                );

                return;
            }

            // =====================================
            // Refresh device last seen
            // =====================================

            deviceDAO.updateLastSeen(
                    deviceId
            );
               // =====================================
            // Check & send email alerts
            // =====================================

            if ("RAINING".equals(rainStatus)) {

                NotificationService.alertRainDetected(
                        deviceId,
                        temperature,
                        humidity,
                        roofStatus
                );
            }

            if (temperature >= 40.0) {

                NotificationService.alertHighTemperature(
                        deviceId,
                        temperature,
                        humidity
                );
            }

            if (temperature <= 15.0) {

                NotificationService.alertLowTemperature(
                        deviceId,
                        temperature,
                        humidity
                );
            }

        

            // =====================================
            // Return success response
            // =====================================

            out.println(
                    "OK"
            );

        } catch (NumberFormatException e) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            out.println(
                    "ERROR=INVALID_NUMBER"
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

        return "ESP32 sensor data API";
    }
}