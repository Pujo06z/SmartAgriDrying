package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebFilter(urlPatterns = {
    "/users",
    "/warehouses",
    "/devices",
    "/batch",
    "/history",
    "/control"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) rq;
        HttpServletResponse resp = (HttpServletResponse) rs;
        HttpSession session = req.getSession(false);

        User user = session == null ? null : (User) session.getAttribute("LOGIN_USER");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        boolean allowed = false;

        if ("/users".equals(path) || "/warehouses".equals(path) || "/devices".equals(path)) {
            allowed = "ADMIN".equals(user.getRole());
        } else if ("/batch".equals(path) || "/history".equals(path) || "/control".equals(path)) {
            allowed = "MANAGER".equals(user.getRole()) || "OPERATOR".equals(user.getRole());
        }

        if (!allowed) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        chain.doFilter(rq, rs);
    }

    @Override
    public void destroy() {}
}
