<%-- 
    Document   : warehouse
    Created on : Oct 4, 2026, 12:45:44 PM
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

    <title>Warehouse Management</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/warehouse-management.css">

</head>


<body>


<div class="app-layout">


    <%-- ===================================================== --%>
    <%-- SIDEBAR --%>
    <%-- ===================================================== --%>

    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <%-- ===================================================== --%>
    <%-- MAIN --%>
    <%-- ===================================================== --%>

    <main class="main-content">


        <%-- ================================================= --%>
        <%-- HEADER --%>
        <%-- ================================================= --%>

        <header class="warehouse-page-header">

            <div>

                <h1>
                    Warehouse Overview
                </h1>

                <p>
                    Manage warehouse information and operational status.
                </p>

            </div>

        </header>



        <%-- ================================================= --%>
        <%-- STATISTICS --%>
        <%-- ================================================= --%>

        <section class="warehouse-summary">


            <div class="summary-box summary-total">

                <div class="summary-icon">
                    🏠
                </div>

                <div class="summary-info">

                    <span>
                        Total Warehouses
                    </span>

                    <strong>
                        ${totalWarehouses}
                    </strong>

                </div>

            </div>


            <div class="summary-box summary-active">

                <div class="summary-icon">
                    🏠
                </div>

                <div class="summary-info">

                    <span>
                        Active Warehouses
                    </span>

                    <strong>
                        ${activeWarehouses}
                    </strong>

                </div>

            </div>


            <div class="summary-box summary-inactive">

                <div class="summary-icon">
                    🏠
                </div>

                <div class="summary-info">

                    <span>
                        Inactive Warehouses
                    </span>

                    <strong>
                        ${inactiveWarehouses}
                    </strong>

                </div>

            </div>


        </section>



        <%-- ================================================= --%>
        <%-- ERROR --%>
        <%-- ================================================= --%>

        <c:if test="${not empty error}">

            <div class="alert-error">

                ${error}

            </div>

        </c:if>



        <%-- ================================================= --%>
        <%-- WAREHOUSE LIST --%>
        <%-- ================================================= --%>

        <section class="warehouse-section">


            <div class="section-header">


                <div>

                    <h2>
                        Warehouse List
                    </h2>

                </div>


                <%-- ADMIN ONLY --%>

                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">

                    <button type="button"
                            class="btn-add"
                            onclick="toggleAddWarehouse()">

                        + Add Warehouse

                    </button>

                </c:if>


            </div>



            <%-- ================================================= --%>
            <%-- ADD WAREHOUSE FORM - ADMIN ONLY --%>
            <%-- ================================================= --%>

            <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                <div id="addWarehouseForm"
                     class="add-warehouse-box"
                     style="display:none;">


                    <h3>
                        Add New Warehouse
                    </h3>


                    <form action="${pageContext.request.contextPath}/warehouses"
                          method="post"
                          class="warehouse-form">


                        <input type="hidden"
                               name="action"
                               value="add">


                        <div class="form-grid">


                            <div class="form-group">

                                <label>
                                    Warehouse ID
                                </label>

                                <input type="text"
                                       name="warehouseId"
                                       placeholder="W001"
                                       required>

                            </div>


                            <div class="form-group">

                                <label>
                                    Warehouse Code
                                </label>

                                <input type="text"
                                       name="warehouseCode"
                                       placeholder="WH-001"
                                       required>

                            </div>


                            <div class="form-group">

                                <label>
                                    Warehouse Name
                                </label>

                                <input type="text"
                                       name="warehouseName"
                                       placeholder="Main Drying Area"
                                       required>

                            </div>


                            <div class="form-group">

                                <label>
                                    Location
                                </label>

                                <input type="text"
                                       name="location"
                                       placeholder="Warehouse location"
                                       required>

                            </div>


                        </div>


                        <div class="form-actions">

                            <button type="button"
                                    class="btn-cancel"
                                    onclick="toggleAddWarehouse()">

                                Cancel

                            </button>


                            <button type="submit"
                                    class="btn-primary">

                                Add Warehouse

                            </button>

                        </div>


                    </form>


                </div>


            </c:if>



            <%-- ================================================= --%>
            <%-- TABLE --%>
            <%-- ================================================= --%>

            <div class="table-wrapper">


                <table class="warehouse-table">


                    <thead>

                    <tr>

                        <th>
                            #
                        </th>

                        <th>
                            Warehouse ID
                        </th>

                        <th>
                            Code
                        </th>

                        <th>
                            Warehouse Name
                        </th>

                        <th>
                            Location
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Created At
                        </th>

                        <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">

                            <th>
                                Action
                            </th>

                        </c:if>

                    </tr>

                    </thead>



                    <tbody>


                    <c:choose>


                        <%-- ===================================== --%>
                        <%-- CÓ WAREHOUSE --%>
                        <%-- ===================================== --%>

                        <c:when test="${not empty warehouseList}">


                            <c:forEach var="warehouse"
                                       items="${warehouseList}"
                                       varStatus="loop">


                                <tr>


                                    <td>
                                        ${loop.count}
                                    </td>


                                    <td class="warehouse-id">
                                        ${warehouse.warehouseId}
                                    </td>


                                    <td>
                                        ${warehouse.warehouseCode}
                                    </td>


                                    <td class="warehouse-name">
                                        ${warehouse.warehouseName}
                                    </td>


                                    <td>
                                        ${warehouse.location}
                                    </td>



                                    <%-- STATUS --%>

                                    <td>


                                        <c:choose>


                                            <c:when test="${warehouse.status eq 'ACTIVE'}">

                                                <span class="status-active">

                                                    ● ACTIVE

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="status-inactive">

                                                    ● INACTIVE

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>



                                    <%-- CREATED AT --%>

                                    <td>

                                        <fmt:formatDate
                                                value="${warehouse.createdAt}"
                                                pattern="yyyy-MM-dd HH:mm"/>

                                    </td>



                                    <%-- ================================= --%>
                                    <%-- ADMIN ACTION --%>
                                    <%-- ================================= --%>

                                    <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                                        <td class="action-cell">


                                            <%-- EDIT --%>

                                            <button type="button"
                                                    class="btn-edit"
                                                    onclick="toggleEdit('${warehouse.warehouseId}')">

                                                Edit

                                            </button>



                                            <%-- ACTIVE / INACTIVE --%>

                                            <form action="${pageContext.request.contextPath}/warehouses"
                                                  method="post"
                                                  class="inline-form">


                                                <input type="hidden"
                                                       name="action"
                                                       value="toggleStatus">


                                                <input type="hidden"
                                                       name="warehouseId"
                                                       value="${warehouse.warehouseId}">


                                                <button type="submit"
                                                        class="btn-status-action">


                                                    <c:choose>


                                                        <c:when test="${warehouse.status eq 'ACTIVE'}">

                                                            Disable

                                                        </c:when>


                                                        <c:otherwise>

                                                            Activate

                                                        </c:otherwise>


                                                    </c:choose>


                                                </button>


                                            </form>


                                        </td>


                                    </c:if>


                                </tr>



                                <%-- ===================================== --%>
                                <%-- EDIT FORM ROW --%>
                                <%-- ADMIN ONLY --%>
                                <%-- ===================================== --%>

                                <c:if test="${sessionScope.LOGIN_USER.role eq 'ADMIN'}">


                                    <tr id="edit-${warehouse.warehouseId}"
                                        class="edit-row"
                                        style="display:none;">


                                        <td colspan="8">


                                            <form action="${pageContext.request.contextPath}/warehouses"
                                                  method="post"
                                                  class="edit-form">


                                                <input type="hidden"
                                                       name="action"
                                                       value="update">


                                                <input type="hidden"
                                                       name="warehouseId"
                                                       value="${warehouse.warehouseId}">


                                                <div class="edit-grid">


                                                    <div class="form-group">

                                                        <label>
                                                            Warehouse ID
                                                        </label>

                                                        <input type="text"
                                                               value="${warehouse.warehouseId}"
                                                               disabled>

                                                    </div>


                                                    <div class="form-group">

                                                        <label>
                                                            Warehouse Code
                                                        </label>

                                                        <input type="text"
                                                               name="warehouseCode"
                                                               value="${warehouse.warehouseCode}"
                                                               required>

                                                    </div>


                                                    <div class="form-group">

                                                        <label>
                                                            Warehouse Name
                                                        </label>

                                                        <input type="text"
                                                               name="warehouseName"
                                                               value="${warehouse.warehouseName}"
                                                               required>

                                                    </div>


                                                    <div class="form-group">

                                                        <label>
                                                            Location
                                                        </label>

                                                        <input type="text"
                                                               name="location"
                                                               value="${warehouse.location}"
                                                               required>

                                                    </div>


                                                </div>


                                                <div class="form-actions">


                                                    <button type="button"
                                                            class="btn-cancel"
                                                            onclick="toggleEdit('${warehouse.warehouseId}')">

                                                        Cancel

                                                    </button>


                                                    <button type="submit"
                                                            class="btn-primary">

                                                        Save Changes

                                                    </button>


                                                </div>


                                            </form>


                                        </td>


                                    </tr>


                                </c:if>


                            </c:forEach>


                        </c:when>



                        <%-- ===================================== --%>
                        <%-- KHÔNG CÓ WAREHOUSE --%>
                        <%-- ===================================== --%>

                        <c:otherwise>


                            <tr>


                                <td colspan="8"
                                    class="empty-row">

                                    No warehouses found.

                                </td>


                            </tr>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


        </section>


    </main>


</div>



<%-- ========================================================= --%>
<%-- SIMPLE JAVASCRIPT --%>
<%-- ========================================================= --%>

<script>

    function toggleAddWarehouse() {

        const form =
                document.getElementById(
                        "addWarehouseForm"
                );

        if (form.style.display === "none"
                || form.style.display === "") {

            form.style.display = "block";

        } else {

            form.style.display = "none";
        }
    }


    function toggleEdit(warehouseId) {

        const row =
                document.getElementById(
                        "edit-" + warehouseId
                );

        if (row.style.display === "none"
                || row.style.display === "") {

            row.style.display = "table-row";

        } else {

            row.style.display = "none";
        }
    }

</script>


</body>

</html>