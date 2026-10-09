<%-- 
    Document   : sidebar
    Created on : Oct 5, 2026, 10:29:44 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<%@taglib prefix="fn"
          uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="currentURI"
       value="${pageContext.request.requestURI}" />
<button class="sidebar-toggle"
        type="button"
        onclick="toggleSidebar()">
    ☰
</button>
<aside class="sidebar" id="sidebar">

    <!-- ===================== -->
    <!-- LOGO / SYSTEM NAME -->
    <!-- ===================== -->

    <div class="sidebar-header">

        <div class="sidebar-logo">
            SA
        </div>

        <div class="sidebar-brand">
            <h2>Smart Drying</h2>
            <span>IoT System</span>
        </div>

    </div>


    <!-- ===================== -->
    <!-- USER INFORMATION -->
    <!-- ===================== -->

    <div class="sidebar-user">

        <div class="user-avatar">
            ${fn:substring(sessionScope.LOGIN_USER.fullName, 0, 1)}
        </div>

        <div class="user-info">

            <strong>
                ${sessionScope.LOGIN_USER.fullName}
            </strong>

            <span>
                ${sessionScope.LOGIN_USER.role}
            </span>

        </div>

    </div>


    <!-- ===================== -->
    <!-- NAVIGATION -->
    <!-- ===================== -->

    <nav class="sidebar-nav">

        <!-- DASHBOARD -->
        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar-link
           ${fn:contains(currentURI, 'dashboard') ? 'active' : ''}">

            <span class="sidebar-icon">
                ▦
            </span>

            <span class="sidebar-text">
                Dashboard
            </span>

        </a>


        <!-- ================================= -->
        <!-- OPERATOR + MANAGER -->
        <!-- ================================= -->

        <c:if test="${sessionScope.LOGIN_USER.role == 'OPERATOR'
                      || sessionScope.LOGIN_USER.role == 'MANAGER'}">


              <!-- DRYING BATCH -->
              <a href="${pageContext.request.contextPath}/batch"
                 class="sidebar-link
                 ${fn:contains(currentURI, 'batch') ? 'active' : ''}">

                  <span class="sidebar-icon">
                      ◫
                  </span>

                  <span class="sidebar-text">
                      Drying Batch
                  </span>

              </a>


              <!-- HISTORY -->
              <a href="${pageContext.request.contextPath}/history"
                 class="sidebar-link
                 ${fn:contains(currentURI, 'history') ? 'active' : ''}">

                  <span class="sidebar-icon">
                      ◷
                  </span>

                  <span class="sidebar-text">
                      History
                  </span>

              </a>
              <!-- ================================= -->
              <!-- EVENT LOG - ALL ROLES -->
              <!-- ================================= -->

              <a href="${pageContext.request.contextPath}/events"
                 class="sidebar-link
                 ${fn:contains(currentURI, 'event') ? 'active' : ''}">

                  <span class="sidebar-icon">
                      ☷
                  </span>

                  <span class="sidebar-text">
                      Event Log
                  </span>

              </a>

        </c:if>


        <!-- ================================= -->
        <!-- MANAGER -->
        <!-- ================================= -->

        <c:if test="${sessionScope.LOGIN_USER.role == 'MANAGER'}">


            <!-- USER MANAGEMENT -->
            <a href="${pageContext.request.contextPath}/users"
               class="sidebar-link
               ${fn:contains(currentURI, 'user') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ♙
                </span>

                <span class="sidebar-text">
                    User Management
                </span>

            </a>


            <!-- WAREHOUSE -->
            <a href="${pageContext.request.contextPath}/warehouses"
               class="sidebar-link
               ${fn:contains(currentURI, 'warehouse') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ⌂
                </span>

                <span class="sidebar-text">
                    Warehouse
                </span>

            </a>
           

        </c:if>


        <!-- ================================= -->
        <!-- ADMIN -->
        <!-- ================================= -->

        <c:if test="${sessionScope.LOGIN_USER.role == 'ADMIN'}">


            <!-- USER MANAGEMENT -->
            <a href="${pageContext.request.contextPath}/users"
               class="sidebar-link
               ${fn:contains(currentURI, 'user') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ♙
                </span>

                <span class="sidebar-text">
                    User Management
                </span>

            </a>


            <!-- WAREHOUSE MANAGEMENT -->
            <a href="${pageContext.request.contextPath}/warehouses"
               class="sidebar-link
               ${fn:contains(currentURI, 'warehouse') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ⌂
                </span>

                <span class="sidebar-text">
                    Warehouse Management
                </span>

            </a>


            <!-- DEVICE MANAGEMENT -->
            <a href="${pageContext.request.contextPath}/devices"
               class="sidebar-link
               ${fn:contains(currentURI, 'device') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ⚙
                </span>

                <span class="sidebar-text">
                    Device Management
                </span>

            </a>
            <!-- ================================= -->
            <!-- EVENT LOG - ALL ROLES -->
            <!-- ================================= -->

            <a href="${pageContext.request.contextPath}/events"
               class="sidebar-link
               ${fn:contains(currentURI, 'event') ? 'active' : ''}">

                <span class="sidebar-icon">
                    ☷
                </span>

                <span class="sidebar-text">
                    Event Log
                </span>

            </a>
        </c:if>


    </nav>

    <!-- ===================== -->
    <!-- LOGOUT -->
    <!-- ===================== -->

    <div class="sidebar-footer">

        <a href="${pageContext.request.contextPath}/logout"
           class="sidebar-link logout-link">

            <span class="sidebar-icon">
                ↪
            </span>

            <span class="sidebar-text">
                Logout
            </span>

        </a>

    </div>

</aside>
<script>
    function toggleSidebar() {
        document
            .getElementById("sidebar")
            .classList.toggle("open");
    }
</script>