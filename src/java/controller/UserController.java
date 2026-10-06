/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import dao.WarehouseDAO;
import model.User;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserController", urlPatterns = {"/users"})
public class UserController extends HttpServlet {

    private final UserDAO dao = new UserDAO();

    protected void processRequest(HttpServletRequest rq, HttpServletResponse rs)
            throws ServletException, IOException {

        HttpSession session = rq.getSession(false);
        User me = session == null ? null : (User) session.getAttribute("LOGIN_USER");

        if (me == null) {
            rs.sendRedirect(rq.getContextPath() + "/login");
            return;
        }

        try {
            List<User> users = dao.getAllUsers();
            int active = 0;
            int inactive = 0;

            for (User u : users) {
                if (u.isActive()) {
                    active++;
                } else {
                    inactive++;
                }
            }

            rq.setAttribute("users", users); // Using "users" to match NB13 users.jsp
            rq.setAttribute("totalUsers", users.size());
            rq.setAttribute("activeCount", active); // Using "activeCount" to match JSP
            rq.setAttribute("warehouses", new WarehouseDAO().getAllWarehouses()); // Using "warehouses"

            rq.getRequestDispatcher("/WEB-INF/views/users.jsp").forward(rq, rs);

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
        HttpSession session = rq.getSession();
        User me = (User) session.getAttribute("LOGIN_USER");

        String action = rq.getParameter("action");
        String id = rq.getParameter("id"); // JSP sends "id" not "userId"

        String msg = null;

        try {
            if ("add".equals(action)) {
                String username = rq.getParameter("username");
                String password = rq.getParameter("password");
                String fullName = rq.getParameter("fullName");
                String role = rq.getParameter("role");
                
                // JSP doesn't send "userId" for add, we need to generate one or JSP doesn't send it. Wait, in NB13 JSP, it just has username and fullName. No userId.
                // Let's use username as userId for simplicity, or if there's no input for ID.
                // Looking at users.jsp: <input name="username">, <input name="fullName">. No ID field for add.
                String userId = username; // Use username as ID if not provided

                String[] warehouseIds = rq.getParameterValues("warehouseId"); // JSP uses warehouseId

                if (!"ADMIN".equals(role) && !"MANAGER".equals(role) && !"OPERATOR".equals(role)) {
                    msg = "Role không hợp lệ.";
                } else if (dao.existsUserId(userId)) {
                    msg = "User ID đã tồn tại.";
                } else if (dao.existsUsername(username)) {
                    msg = "Username đã tồn tại.";
                } else {
                    dao.add(userId, username, password, fullName, role);
                    if ("MANAGER".equals(role)) {
                        dao.setUserWarehouses(userId, warehouseIds);
                    }
                }
            } else if ("edit".equals(action)) {
                dao.updateFullName(id, rq.getParameter("fullName"));
            } else if ("role".equals(action)) {
                if (id.equals(me.getUserId())) {
                    msg = "Không thể tự đổi role của chính mình.";
                } else {
                    String role = rq.getParameter("role");
                    if ("ADMIN".equals(role) || "MANAGER".equals(role) || "OPERATOR".equals(role)) {
                        dao.updateRole(id, role);
                        if ("ADMIN".equals(role)) {
                            dao.clearUserWarehouses(id);
                        }
                    }
                }
            } else if ("assign".equals(action)) {
                dao.setUserWarehouses(id, rq.getParameterValues("warehouseId"));
            } else if ("toggle".equals(action)) {
                if (id.equals(me.getUserId())) {
                    msg = "Không thể tự khóa chính mình.";
                } else {
                    dao.toggleStatus(id);
                }
            }
        } catch (Exception e) {
            msg = "Lỗi: " + e.getMessage();
        }

        if (msg != null) {
            session.setAttribute("flash", msg);
        }
        rs.sendRedirect(rq.getContextPath() + "/users");
    }

    @Override
    public String getServletInfo() {
        return "User Management Controller";
    }
}
