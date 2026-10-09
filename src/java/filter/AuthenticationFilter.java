/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

/**
 *
 * @author ADMIN
 */
@WebFilter(
        filterName = "AuthenticationFilter",
        urlPatterns = {
            "/dashboard",
            "/batch",
            "/control",
            "/history",
            "/users",
            "/warehouses",
            "/devices",
            "/events"
        }
)
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest
                = (HttpServletRequest) request;

        HttpServletResponse httpResponse
                = (HttpServletResponse) response;


        HttpSession session
                = httpRequest.getSession(false);


        // =====================================
        // CHƯA LOGIN
        // =====================================
        if (session == null
                || session.getAttribute("LOGIN_USER") == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login"
            );

            return;
        }


        // =====================================
        // ĐÃ LOGIN
        // CHO REQUEST ĐI TIẾP TỚI SERVLET
        // =====================================
        chain.doFilter(
                request,
                response
        );
    }


    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
    }


    @Override
    public void destroy() {
    }
}
