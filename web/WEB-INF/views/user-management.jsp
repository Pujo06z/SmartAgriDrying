<%-- 
    Document   : user-management
    Created on : Oct 4, 2026, 12:45:33 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt"
           uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>User Management</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/common.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/user-management.css">

    </head>


    <body>


        <div class="app-layout">


            <%-- ============================================= --%>
            <%-- SIDEBAR --%>
            <%-- ============================================= --%>

            <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


            <%-- ============================================= --%>
            <%-- MAIN --%>
            <%-- ============================================= --%>

            <main class="main-content">


                <%-- ============================================= --%>
                <%-- HEADER --%>
                <%-- ============================================= --%>

                <header class="user-page-header">

                    <div>

                        <h1>
                            User Management
                        </h1>

                        <p>
                            View and manage system users.
                        </p>

                    </div>

                </header>


                <%-- ============================================= --%>
                <%-- USER STATISTICS --%>
                <%-- ============================================= --%>

                <section class="user-summary">


                    <%-- TOTAL USERS --%>

                    <div class="summary-box summary-total">

                        <div class="summary-icon">
                            👥
                        </div>

                        <div class="summary-info">

                            <span>
                                Total Users
                            </span>

                            <strong>
                                ${totalUsers}
                            </strong>

                        </div>

                    </div>


                    <%-- ACTIVE USERS --%>

                    <div class="summary-box summary-active">

                        <div class="summary-icon">
                            👤
                        </div>

                        <div class="summary-info">

                            <span>
                                Active Users
                            </span>

                            <strong>
                                ${activeUsers}
                            </strong>

                        </div>

                    </div>


                    <%-- INACTIVE USERS --%>

                    <div class="summary-box summary-inactive">

                        <div class="summary-icon">
                            👤
                        </div>

                        <div class="summary-info">

                            <span>
                                Inactive Users
                            </span>

                            <strong>
                                ${totalUsers - activeUsers}
                            </strong>

                        </div>

                    </div>


                </section>

                <%-- ============================================= --%>
                <%-- ERROR --%>
                <%-- ============================================= --%>

                <c:if test="${not empty error}">

                    <div class="alert-error">

                        ${error}

                    </div>

                </c:if>



                <%-- ============================================= --%>
                <%-- ADD USER - ADMIN ONLY --%>
                <%-- ============================================= --%>

                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                    <section class="user-section">


                        <div class="section-header">

                            <h2>
                                Add New User
                            </h2>

                        </div>


                        <form action="${pageContext.request.contextPath}/users"
                              method="post"
                              class="user-form">


                            <input type="hidden"
                                   name="action"
                                   value="add">


                            <div class="form-grid">


                                <div class="form-group">

                                    <label>
                                        User ID
                                    </label>

                                    <input type="text"
                                           name="userId"
                                           required
                                           placeholder="U001">

                                </div>


                                <div class="form-group">

                                    <label>
                                        Username
                                    </label>

                                    <input type="text"
                                           name="username"
                                           required
                                           placeholder="username">

                                </div>


                                <div class="form-group">

                                    <label>
                                        Password
                                    </label>

                                    <input type="password"
                                           name="password"
                                           required
                                           placeholder="Password">

                                </div>


                                <div class="form-group">

                                    <label>
                                        Full Name
                                    </label>

                                    <input type="text"
                                           name="fullName"
                                           required
                                           placeholder="Full name">

                                </div>


                                <div class="form-group">

                                    <label>
                                        Role
                                    </label>

                                    <select name="role"
                                            required>

                                        <option value="">
                                            Select role
                                        </option>

                                        <option value="ADMIN">
                                            Admin
                                        </option>

                                        <option value="MANAGER">
                                            Manager
                                        </option>

                                        <option value="OPERATOR">
                                            Operator
                                        </option>

                                    </select>

                                </div>


                                <div class="form-group">

                                    <label>
                                        Assign Warehouses
                                    </label>

                                    <select name="warehouseIds"
                                            multiple>

                                        <c:forEach var="warehouse"
                                                   items="${warehouseList}">

                                            <option value="${warehouse.warehouseId}">

                                                ${warehouse.warehouseCode}
                                                -
                                                ${warehouse.warehouseName}

                                            </option>

                                        </c:forEach>

                                    </select>

                                </div>

                            </div>


                            <div class="form-actions">

                                <button type="submit"
                                        class="btn-primary">

                                    Add User

                                </button>

                            </div>


                        </form>


                    </section>


                </c:if>



                <%-- ============================================= --%>
                <%-- USER LIST --%>
                <%-- ============================================= --%>

                <section class="user-section">


                    <div class="section-header">

                        <h2>
                            User List
                        </h2>

                    </div>
                    <form action="${pageContext.request.contextPath}/users"
                          method="get"
                          class="user-filter-form">


                        <!-- SEARCH -->

                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Search user...">


                        <!-- ROLE -->

                        <select name="role">

                            <option value="">
                                All Roles
                            </option>

                            <option value="ADMIN"
                                    ${selectedRole eq 'ADMIN'
                                      ? 'selected' : ''}>
                                ADMIN
                            </option>

                            <option value="MANAGER"
                                    ${selectedRole eq 'MANAGER'
                                      ? 'selected' : ''}>
                                MANAGER
                            </option>

                            <option value="OPERATOR"
                                    ${selectedRole eq 'OPERATOR'
                                      ? 'selected' : ''}>
                                OPERATOR
                            </option>

                        </select>


                        <!-- STATUS -->

                        <select name="status">

                            <option value="">
                                All Status
                            </option>

                            <option value="ACTIVE"
                                    ${selectedStatus eq 'ACTIVE'
                                      ? 'selected' : ''}>
                                ACTIVE
                            </option>

                            <option value="INACTIVE"
                                    ${selectedStatus eq 'INACTIVE'
                                      ? 'selected' : ''}>
                                INACTIVE
                            </option>

                        </select>


                        <!-- SORT -->

                        <select name="sortBy">

                            <option value="userId">
                                User ID
                            </option>

                            <option value="username"
                                    ${sortBy eq 'username'
                                      ? 'selected' : ''}>
                                Username
                            </option>

                            <option value="fullName"
                                    ${sortBy eq 'fullName'
                                      ? 'selected' : ''}>
                                Full Name
                            </option>

                            <option value="role"
                                    ${sortBy eq 'role'
                                      ? 'selected' : ''}>
                                Role
                            </option>

                            <option value="createdAt"
                                    ${sortBy eq 'createdAt'
                                      ? 'selected' : ''}>
                                Created Date
                            </option>

                        </select>


                        <!-- ASC / DESC -->

                        <select name="sortOrder">

                            <option value="ASC"
                                    ${sortOrder eq 'ASC'
                                      ? 'selected' : ''}>
                                Ascending
                            </option>

                            <option value="DESC"
                                    ${sortOrder eq 'DESC'
                                      ? 'selected' : ''}>
                                Descending
                            </option>

                        </select>


                        <input type="hidden"
                               name="page"
                               value="1">


                        <button type="submit"
                                class="primary-button">
                            Apply
                        </button>


                        <a href="${pageContext.request.contextPath}/users">
                            Reset
                        </a>

                    </form>

                    <div class="table-wrapper">


                        <table class="user-table">


                            <thead>

                                <tr>

                                    <th>
                                        User ID
                                    </th>

                                    <th>
                                        Username
                                    </th>

                                    <th>
                                        Full Name
                                    </th>

                                    <th>
                                        Role
                                    </th>

                                    <th>
                                        Warehouse
                                    </th>

                                    <th>
                                        Status
                                    </th>

                                    <th>
                                        Created At
                                    </th>


                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">

                                        <th>
                                            Actions
                                        </th>

                                    </c:if>

                                </tr>

                            </thead>



                            <tbody>


                                <c:choose>


                                    <%-- CÓ USER --%>

                                    <c:when test="${not empty users}">


                                        <c:forEach var="user"
                                                   items="${users}">


                                            <tr>


                                                <td>

                                                    ${user.userId}

                                                </td>


                                                <td>

                                                    ${user.username}

                                                </td>


                                                <td>

                                                    ${user.fullName}

                                                </td>


                                                <td>

                                                    <span class="role-badge">

                                                        ${user.role}

                                                    </span>

                                                </td>



                                                <%-- WAREHOUSE ASSIGNMENTS --%>

                                                <td>


                                                    <c:set var="assignedWarehouses"
                                                           value="${userWarehouseMap[user.userId]}"/>


                                                    <c:choose>


                                                        <c:when test="${not empty assignedWarehouses}">


                                                            <c:forEach var="warehouse"
                                                                       items="${assignedWarehouses}">


                                                                <div class="warehouse-tag">

                                                                    ${warehouse.warehouseCode}
                                                                    -
                                                                    ${warehouse.warehouseName}

                                                                </div>


                                                            </c:forEach>


                                                        </c:when>


                                                        <c:otherwise>

                                                            <span class="text-muted">
                                                                No assignment
                                                            </span>

                                                        </c:otherwise>


                                                    </c:choose>


                                                </td>



                                                <%-- STATUS --%>

                                                <td>


                                                    <c:choose>


                                                        <c:when test="${user.status eq 'ACTIVE'}">

                                                            <span class="status-active">

                                                                ACTIVE

                                                            </span>

                                                        </c:when>


                                                        <c:otherwise>

                                                            <span class="status-inactive">

                                                                INACTIVE

                                                            </span>

                                                        </c:otherwise>


                                                    </c:choose>


                                                </td>



                                                <%-- CREATED --%>

                                                <td>

                                                    <fmt:formatDate
                                                        value="${user.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm"/>

                                                </td>



                                                <%-- ============================================= --%>
                                                <%-- ADMIN ACTIONS --%>
                                                <%-- ============================================= --%>

                                                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                                                    <td class="actions-cell">


                                                        <%-- UPDATE NAME --%>

                                                        <form action="${pageContext.request.contextPath}/users"
                                                              method="post"
                                                              class="inline-form">


                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="updateName">


                                                            <input type="hidden"
                                                                   name="userId"
                                                                   value="${user.userId}">


                                                            <input type="text"
                                                                   name="fullName"
                                                                   value="${user.fullName}"
                                                                   required>


                                                            <button type="submit"
                                                                    class="btn-small">

                                                                Update Name

                                                            </button>


                                                        </form>



                                                        <%-- UPDATE ROLE --%>

                                                        <form action="${pageContext.request.contextPath}/users"
                                                              method="post"
                                                              class="inline-form">


                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="updateRole">


                                                            <input type="hidden"
                                                                   name="userId"
                                                                   value="${user.userId}">


                                                            <select name="role">


                                                                <option value="ADMIN"
                                                                        <c:if test="${user.role eq 'ADMIN'}">
                                                                            selected
                                                                        </c:if>>

                                                                    ADMIN

                                                                </option>


                                                                <option value="MANAGER"
                                                                        <c:if test="${user.role eq 'MANAGER'}">
                                                                            selected
                                                                        </c:if>>

                                                                    MANAGER

                                                                </option>


                                                                <option value="OPERATOR"
                                                                        <c:if test="${user.role eq 'OPERATOR'}">
                                                                            selected
                                                                        </c:if>>

                                                                    OPERATOR

                                                                </option>


                                                            </select>




                                                            <button type="submit"
                                                                    class="btn-small">

                                                                Update Role

                                                            </button>


                                                        </form>



                                                        <%-- ASSIGN WAREHOUSE --%>

                                                        <c:if test="${user.role ne 'ADMIN'}">


                                                            <form action="${pageContext.request.contextPath}/users"
                                                                  method="post"
                                                                  class="inline-form">


                                                                <input type="hidden"
                                                                       name="action"
                                                                       value="assignWarehouse">


                                                                <input type="hidden"
                                                                       name="userId"
                                                                       value="${user.userId}">


                                                                <select name="warehouseIds"
                                                                        multiple>


                                                                    <c:forEach var="warehouse"
                                                                               items="${warehouseList}">


                                                                        <option value="${warehouse.warehouseId}">

                                                                            ${warehouse.warehouseCode}
                                                                            -
                                                                            ${warehouse.warehouseName}

                                                                        </option>


                                                                    </c:forEach>


                                                                </select>


                                                                <button type="submit"
                                                                        class="btn-small">

                                                                    Assign

                                                                </button>


                                                            </form>


                                                        </c:if>



                                                        <%-- ACTIVE / INACTIVE --%>

                                                        <c:if test="${user.userId ne sessionScope.LOGIN_USER.userId}">


                                                            <form action="${pageContext.request.contextPath}/users"
                                                                  method="post"
                                                                  class="inline-form">


                                                                <input type="hidden"
                                                                       name="action"
                                                                       value="toggleStatus">


                                                                <input type="hidden"
                                                                       name="userId"
                                                                       value="${user.userId}">


                                                                <button type="submit"
                                                                        class="btn-small btn-status">


                                                                    <c:choose>


                                                                        <c:when test="${user.status eq 'ACTIVE'}">

                                                                            Disable

                                                                        </c:when>


                                                                        <c:otherwise>

                                                                            Activate

                                                                        </c:otherwise>


                                                                    </c:choose>


                                                                </button>


                                                            </form>


                                                        </c:if>


                                                    </td>


                                                </c:if>


                                            </tr>


                                        </c:forEach>


                                    </c:when>



                                    <%-- KHÔNG CÓ USER --%>

                                    <c:otherwise>


                                        <tr>

                                            <td colspan="8"
                                                class="empty-row">

                                                No users found.

                                            </td>

                                        </tr>


                                    </c:otherwise>


                                </c:choose>


                            </tbody>


                        </table>
                        <c:if test="${totalPages > 1}">

                            <div class="pagination">


                                <!-- PREVIOUS -->

                                <c:if test="${currentPage > 1}">

                                    <c:url var="prevUrl"
                                           value="/users">

                                        <c:param name="page"
                                                 value="${currentPage - 1}"/>

                                        <c:param name="keyword"
                                                 value="${keyword}"/>

                                        <c:param name="role"
                                                 value="${selectedRole}"/>

                                        <c:param name="status"
                                                 value="${selectedStatus}"/>

                                        <c:param name="sortBy"
                                                 value="${sortBy}"/>

                                        <c:param name="sortOrder"
                                                 value="${sortOrder}"/>

                                    </c:url>

                                    <a href="${prevUrl}">
                                        Previous
                                    </a>

                                </c:if>


                                <!-- PAGE NUMBERS -->

                                <c:forEach begin="1"
                                           end="${totalPages}"
                                           var="i">

                                    <c:url var="pageUrl"
                                           value="/users">

                                        <c:param name="page"
                                                 value="${i}"/>

                                        <c:param name="keyword"
                                                 value="${keyword}"/>

                                        <c:param name="role"
                                                 value="${selectedRole}"/>

                                        <c:param name="status"
                                                 value="${selectedStatus}"/>

                                        <c:param name="sortBy"
                                                 value="${sortBy}"/>

                                        <c:param name="sortOrder"
                                                 value="${sortOrder}"/>

                                    </c:url>


                                    <a href="${pageUrl}"
                                       class="${i eq currentPage
                                                ? 'active'
                                                : ''}">

                                        ${i}

                                    </a>

                                </c:forEach>


                                <!-- NEXT -->

                                <c:if test="${currentPage < totalPages}">

                                    <c:url var="nextUrl"
                                           value="/users">

                                        <c:param name="page"
                                                 value="${currentPage + 1}"/>

                                        <c:param name="keyword"
                                                 value="${keyword}"/>

                                        <c:param name="role"
                                                 value="${selectedRole}"/>

                                        <c:param name="status"
                                                 value="${selectedStatus}"/>

                                        <c:param name="sortBy"
                                                 value="${sortBy}"/>

                                        <c:param name="sortOrder"
                                                 value="${sortOrder}"/>

                                    </c:url>

                                    <a href="${nextUrl}">
                                        Next
                                    </a>

                                </c:if>

                            </div>

                        </c:if>

                    </div>


                </section>


            </main>


        </div>


    </body>

</html>
