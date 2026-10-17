package api;

import dao.DeviceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Device;
import model.User;

@WebServlet(
        name = "AdminDashboardDataApi",
        urlPatterns = {"/api/admin-dashboard-data"}
)
public class AdminDashboardDataApi extends HttpServlet {

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

        PrintWriter out =
                response.getWriter();

        try {

            // =====================================
            // Check login session
            // =====================================

            HttpSession session =
                    request.getSession(false);

            if (session == null
                    || session.getAttribute(
                            "LOGIN_USER"
                    ) == null) {

                response.setStatus(
                        HttpServletResponse.SC_UNAUTHORIZED
                );

                out.print(
                        "{\"error\":\"NOT_LOGGED_IN\"}"
                );

                return;
            }


            User user =
                    (User) session.getAttribute(
                            "LOGIN_USER"
                    );


            // =====================================
            // Allow ADMIN only
            // =====================================

            if (!"ADMIN".equals(
                    user.getRole()
            )) {

                response.setStatus(
                        HttpServletResponse.SC_FORBIDDEN
                );

                out.print(
                        "{\"error\":\"FORBIDDEN\"}"
                );

                return;
            }


            // =====================================
            // Get all devices
            // =====================================

            DeviceDAO deviceDAO =
                    new DeviceDAO();

            List<Device> devices =
                    deviceDAO.getAllDevices();


            int onlineDevices = 0;
            int offlineDevices = 0;


            long currentTime =
                    System.currentTimeMillis();


            // =====================================
            // Calculate live connection status
            // =====================================

            for (Device device : devices) {

                // Ignore inactive devices.
                if (!"ACTIVE".equals(
                        device.getStatus()
                )) {

                    continue;
                }


                boolean online =
                        false;


                if (device.getLastSeen()
                        != null) {

                    long difference =
                            currentTime
                            - device.getLastSeen()
                                    .getTime();


                    if (difference
                            <= 30000) {

                        online =
                                true;
                    }
                }


                if (online) {

                    onlineDevices++;

                } else {

                    offlineDevices++;
                }
            }


            // =====================================
            // Return JSON
            // =====================================

            out.print(
                    "{"
                    + "\"onlineDevices\":"
                    + onlineDevices
                    + ","
                    + "\"offlineDevices\":"
                    + offlineDevices
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

        return "Admin dashboard live data API";
    }
}