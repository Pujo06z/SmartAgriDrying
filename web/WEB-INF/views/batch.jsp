<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<%@taglib prefix="fmt"
          uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Drying Batch</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/batch.css">

</head>


<body>

<div class="app-layout">


    <jsp:include page="/WEB-INF/views/includes/sidebar.jsp"/>


    <main class="main-content">


        <%-- HEADER --%>

        <header class="batch-page-header">

            <div>

                <h1>Drying Batch</h1>

                <p>
                    Manage drying batches in your assigned warehouse.
                </p>

            </div>


            <div class="warehouse-summary">

                <span class="summary-label">
                    Warehouse
                </span>

                <strong>

                    <c:choose>

                        <c:when test="${warehouse ne null}">

                            ${warehouse.warehouseCode}
                            -
                            ${warehouse.warehouseName}

                        </c:when>

                        <c:otherwise>

                            No Warehouse

                        </c:otherwise>

                    </c:choose>

                </strong>

            </div>

        </header>



        <%-- MESSAGE --%>

        <c:if test="${not empty sessionScope.message}">

            <div class="alert alert-success">

                ${sessionScope.message}

            </div>

            <c:remove var="message"
                      scope="session"/>

        </c:if>



        <%-- ERROR --%>

        <c:if test="${not empty error}">

            <div class="alert alert-error">

                ${error}

            </div>

        </c:if>



        <%-- ===================================== --%>
        <%-- START NEW BATCH --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">

            <div class="section-header">

                <h2>
                    Start New Batch
                </h2>

            </div>


            <form action="${pageContext.request.contextPath}/batch"
                  method="post"
                  class="batch-form">


                <input type="hidden"
                       name="action"
                       value="start">


                <div class="form-group">

                    <label for="productName">

                        Product Name
                        <span class="required">*</span>

                    </label>


                    <input type="text"
                           id="productName"
                           name="productName"
                           placeholder="Example: Coffee"
                           maxlength="100"
                           required>

                </div>


                <div class="form-group">

                    <label for="weightKg">

                        Weight (kg)
                        <span class="required">*</span>

                    </label>


                    <input type="number"
                           id="weightKg"
                           name="weightKg"
                           min="0.1"
                           step="0.1"
                           placeholder="Example: 50"
                           required>

                </div>


                <div class="form-group full-width">

                    <label for="notes">
                        Notes
                    </label>


                    <textarea id="notes"
                              name="notes"
                              rows="4"
                              maxlength="500"
                              placeholder="Optional notes..."></textarea>

                </div>


                <div class="form-actions full-width">

                    <button type="submit"
                            class="primary-button">

                        Start Batch

                    </button>

                </div>


            </form>

        </section>



        <%-- ===================================== --%>
        <%-- ACTIVE BATCHES --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">

            <div class="section-header">

                <h2>
                    Active Batches
                </h2>

            </div>


            <div class="table-wrapper">


                <table class="data-table batch-table">


                    <thead>

                    <tr>

                        <th>Batch ID</th>

                        <th>Product</th>

                        <th>Operator</th>

                        <th>Weight</th>

                        <th>Start Time</th>

                        <th>Status</th>

                        <th>Action</th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:forEach var="batch"
                               items="${batches}">


                        <c:if test="${batch.status eq 'DRYING'}">


                            <tr>


                                <td>
                                    ${batch.batchId}
                                </td>


                                <td>
                                    ${batch.productName}
                                </td>


                                <td>
                                    ${batch.operatorName}
                                </td>


                                <td>

                                    <fmt:formatNumber
                                        value="${batch.weightKg}"
                                        maxFractionDigits="2"/>

                                    kg

                                </td>


                                <td>

                                    <fmt:formatDate
                                        value="${batch.startTime}"
                                        pattern="dd/MM/yyyy HH:mm"/>

                                </td>


                                <td>

                                    <span class="status-badge status-drying">

                                        DRYING

                                    </span>

                                </td>


                                <td>


                                    <c:if test="${batch.operatorId eq sessionScope.LOGIN_USER.userId}">


                                        <form action="${pageContext.request.contextPath}/batch"
                                              method="post">


                                            <input type="hidden"
                                                   name="action"
                                                   value="complete">


                                            <input type="hidden"
                                                   name="batchId"
                                                   value="${batch.batchId}">


                                            <button type="submit"
                                                    class="table-action-button">

                                                Complete

                                            </button>


                                        </form>


                                    </c:if>


                                </td>


                            </tr>


                        </c:if>


                    </c:forEach>


                    </tbody>


                </table>


            </div>

        </section>



        <%-- ===================================== --%>
        <%-- ALL BATCHES --%>
        <%-- ===================================== --%>

        <section class="dashboard-section">

            <div class="section-header">

                <h2>
                    Batch History
                </h2>

            </div>


            <div class="table-wrapper">


                <table class="data-table batch-table">


                    <thead>

                    <tr>

                        <th>Batch ID</th>

                        <th>Product</th>

                        <th>Operator</th>

                        <th>Weight</th>

                        <th>Start Time</th>

                        <th>End Time</th>

                        <th>Status</th>

                        <th>Notes</th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:choose>


                        <c:when test="${not empty batches}">


                            <c:forEach var="batch"
                                       items="${batches}">


                                <tr>


                                    <td>
                                        ${batch.batchId}
                                    </td>


                                    <td>
                                        ${batch.productName}
                                    </td>


                                    <td>
                                        ${batch.operatorName}
                                    </td>


                                    <td>

                                        <fmt:formatNumber
                                            value="${batch.weightKg}"
                                            maxFractionDigits="2"/>

                                        kg

                                    </td>


                                    <td>

                                        <fmt:formatDate
                                            value="${batch.startTime}"
                                            pattern="dd/MM/yyyy HH:mm"/>

                                    </td>


                                    <td>


                                        <c:choose>


                                            <c:when test="${batch.endTime ne null}">

                                                <fmt:formatDate
                                                    value="${batch.endTime}"
                                                    pattern="dd/MM/yyyy HH:mm"/>

                                            </c:when>


                                            <c:otherwise>

                                                -

                                            </c:otherwise>


                                        </c:choose>


                                    </td>


                                    <td>


                                        <c:choose>


                                            <c:when test="${batch.status eq 'DRYING'}">

                                                <span class="status-badge status-drying">

                                                    DRYING

                                                </span>

                                            </c:when>


                                            <c:otherwise>

                                                <span class="status-badge status-completed">

                                                    COMPLETED

                                                </span>

                                            </c:otherwise>


                                        </c:choose>


                                    </td>


                                    <td>


                                        <c:choose>


                                            <c:when test="${not empty batch.notes}">

                                                ${batch.notes}

                                            </c:when>


                                            <c:otherwise>

                                                -

                                            </c:otherwise>


                                        </c:choose>


                                    </td>


                                </tr>


                            </c:forEach>


                        </c:when>


                        <c:otherwise>


                            <tr>

                                <td colspan="8"
                                    class="empty-table">

                                    No drying batches found.

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


</body>

</html>