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


                <%-- ===================================== --%>
                <%-- HEADER --%>
                <%-- ===================================== --%>

                <header class="batch-page-header">


                    <div>

                        <h1>
                            Drying Batch
                        </h1>

                        <p>

                            <c:choose>

                                <c:when test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">

                                    Manage drying batches in your assigned warehouses.

                                </c:when>

                                <c:otherwise>

                                    Manage drying batches in your assigned warehouse.

                                </c:otherwise>

                            </c:choose>

                        </p>

                    </div>



                    <%-- MANAGER: CHỌN WAREHOUSE --%>

                    <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">


                        <div class="batch-warehouse-select">


                            <label for="warehouseSelect">
                                Warehouse
                            </label>


                            <form action="${pageContext.request.contextPath}/batch"
                                  method="get">


                                <select id="warehouseSelect"
                                        name="warehouseId"
                                        onchange="this.form.submit()">


                                    <c:forEach var="w"
                                               items="${warehouseList}">


                                        <c:choose>


                                            <c:when test="${w.warehouseId eq warehouse.warehouseId}">

                                                <option value="${w.warehouseId}"
                                                        selected>

                                                    ${w.warehouseCode}
                                                    -
                                                    ${w.warehouseName}

                                                </option>

                                            </c:when>


                                            <c:otherwise>

                                                <option value="${w.warehouseId}">

                                                    ${w.warehouseCode}
                                                    -
                                                    ${w.warehouseName}

                                                </option>

                                            </c:otherwise>


                                        </c:choose>


                                    </c:forEach>


                                </select>


                            </form>


                        </div>


                    </c:if>



                    <%-- OPERATOR: WAREHOUSE CỐ ĐỊNH --%>

                    <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR'}">


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


                    </c:if>


                </header>



                <%-- ===================================== --%>
                <%-- CURRENT WAREHOUSE --%>
                <%-- ===================================== --%>

                <c:if test="${warehouse ne null}">

                    <div class="batch-current-warehouse">

                        <span>
                            Current Warehouse
                        </span>

                        <strong>

                            ${warehouse.warehouseCode}
                            -
                            ${warehouse.warehouseName}

                        </strong>

                        <small>
                            ${warehouse.location}
                        </small>

                    </div>

                </c:if>



                <%-- ===================================== --%>
                <%-- MESSAGE --%>
                <%-- ===================================== --%>

                <c:if test="${not empty sessionScope.message}">

                    <div class="alert alert-success">

                        ${sessionScope.message}

                    </div>

                    <c:remove var="message"
                              scope="session"/>

                </c:if>



                <%-- ===================================== --%>
                <%-- ERROR --%>
                <%-- ===================================== --%>

                <c:if test="${not empty error}">

                    <div class="alert alert-error">

                        ${error}

                    </div>

                </c:if>



                <%-- ===================================== --%>
                <%-- START NEW BATCH --%>
                <%-- ===================================== --%>

                <c:if test="${warehouse ne null}">


                    <section class="dashboard-section">


                        <div class="section-header">

                            <div>

                                <h2>
                                    Start New Batch
                                </h2>

                                <p>
                                    Multiple drying batches can run
                                    in the same warehouse.
                                </p>

                            </div>

                        </div>



                        <form action="${pageContext.request.contextPath}/batch"
                              method="post"
                              class="batch-form">


                            <input type="hidden"
                                   name="action"
                                   value="start">


                            <%-- Manager cần warehouseId.
                                 Operator gửi cũng không sao. --%>

                            <input type="hidden"
                                   name="warehouseId"
                                   value="${warehouse.warehouseId}">


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


                </c:if>



                <%-- ===================================== --%>
                <%-- ACTIVE BATCHES --%>
                <%-- ===================================== --%>

                <section class="dashboard-section">


                    <div class="section-header">

                        <div>

                            <h2>
                                Active Batches
                            </h2>

                            <p>
                                All batches currently drying
                                in this warehouse.
                            </p>

                        </div>

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


                                <c:set var="activeCount"
                                       value="0"/>


                                <c:forEach var="batch"
                                           items="${activeBatches}">


                                    <c:if test="${batch.status eq 'DRYING'}">


                                        <c:set var="activeCount"
                                               value="${activeCount + 1}"/>


                                        <tr>


                                            <td>

                                                <strong>
                                                    ${batch.batchId}
                                                </strong>

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


                                                <%-- MANAGER:
                                                     Complete được batch trong warehouse quản lý --%>

                                                <c:if test="${sessionScope.LOGIN_USER.role eq 'MANAGER'}">


                                                    <form action="${pageContext.request.contextPath}/batch"
                                                          method="post">


                                                        <input type="hidden"
                                                               name="action"
                                                               value="complete">


                                                        <input type="hidden"
                                                               name="batchId"
                                                               value="${batch.batchId}">


                                                        <input type="hidden"
                                                               name="warehouseId"
                                                               value="${warehouse.warehouseId}">


                                                        <button type="submit"
                                                                class="table-action-button">

                                                            Complete

                                                        </button>


                                                    </form>


                                                </c:if>



                                                <%-- OPERATOR:
                                                     chỉ Complete batch của chính mình --%>

                                                <c:if test="${sessionScope.LOGIN_USER.role eq 'OPERATOR'
                                                              and batch.operatorId eq sessionScope.LOGIN_USER.userId}">


                                                      <form action="${pageContext.request.contextPath}/batch"
                                                            method="post">


                                                          <input type="hidden"
                                                                 name="action"
                                                                 value="complete">


                                                          <input type="hidden"
                                                                 name="batchId"
                                                                 value="${batch.batchId}">


                                                          <input type="hidden"
                                                                 name="warehouseId"
                                                                 value="${warehouse.warehouseId}">


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



                                <c:if test="${activeCount eq 0}">


                                    <tr>

                                        <td colspan="7"
                                            class="empty-table">

                                            No active drying batches.

                                        </td>

                                    </tr>


                                </c:if>


                            </tbody>


                        </table>


                    </div>


                </section>



                <%-- ===================================== --%>
                <%-- ALL BATCHES --%>
                <%-- ===================================== --%>

                <section class="dashboard-section">


                    <div class="section-header">

                        <div>

                            <h2>
                                All Batches
                            </h2>

                            <p>
                                All drying and completed batches
                                in this warehouse.
                            </p>

                        </div>

                    </div>

                    <%-- ===================================== --%>
                    <%-- SEARCH / FILTER / SORT --%>
                    <%-- ===================================== --%>

                    <form action="${pageContext.request.contextPath}/batch"
                          method="get"
                          class="batch-filter-form">


                        <%-- GIỮ WAREHOUSE ĐANG CHỌN --%>

                        <input type="hidden"
                               name="warehouseId"
                               value="${warehouse.warehouseId}">


                        <%-- SEARCH --%>

                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Search batch, product, operator...">


                        <%-- FILTER STATUS --%>

                        <select name="status">

                            <option value="">
                                All Status
                            </option>

                            <option value="DRYING"
                                    ${selectedStatus eq 'DRYING'
                                      ? 'selected' : ''}>
                                DRYING
                            </option>

                            <option value="COMPLETED"
                                    ${selectedStatus eq 'COMPLETED'
                                      ? 'selected' : ''}>
                                COMPLETED
                            </option>

                        </select>


                        <%-- SORT BY --%>

                        <select name="sortBy">

                            <option value="startTime"
                                    ${sortBy eq 'startTime'
                                      ? 'selected' : ''}>
                                Start Time
                            </option>

                            <option value="endTime"
                                    ${sortBy eq 'endTime'
                                      ? 'selected' : ''}>
                                End Time
                            </option>

                            <option value="productName"
                                    ${sortBy eq 'productName'
                                      ? 'selected' : ''}>
                                Product Name
                            </option>

                            <option value="weight"
                                    ${sortBy eq 'weight'
                                      ? 'selected' : ''}>
                                Weight
                            </option>

                            <option value="status"
                                    ${sortBy eq 'status'
                                      ? 'selected' : ''}>
                                Status
                            </option>

                        </select>


                        <%-- ASC / DESC --%>

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


                        <a href="${pageContext.request.contextPath}/batch?warehouseId=${warehouse.warehouseId}"
                           class="filter-reset">
                            Reset
                        </a>

                    </form>

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

                                                    <strong>
                                                        ${batch.batchId}
                                                    </strong>

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
                    <%-- ===================================== --%>
                    <%-- PAGINATION --%>
                    <%-- ===================================== --%>

                    <c:if test="${totalPages > 1}">

                        <div class="pagination">


                            <%-- PREVIOUS --%>

                            <c:if test="${currentPage > 1}">

                                <c:url var="prevUrl"
                                       value="/batch">

                                    <c:param name="warehouseId"
                                             value="${warehouse.warehouseId}"/>

                                    <c:param name="keyword"
                                             value="${keyword}"/>

                                    <c:param name="status"
                                             value="${selectedStatus}"/>

                                    <c:param name="sortBy"
                                             value="${sortBy}"/>

                                    <c:param name="sortOrder"
                                             value="${sortOrder}"/>

                                    <c:param name="page"
                                             value="${currentPage - 1}"/>

                                </c:url>

                                <a href="${prevUrl}">
                                    Previous
                                </a>

                            </c:if>


                            <%-- PAGE NUMBER --%>

                            <c:forEach begin="1"
                                       end="${totalPages}"
                                       var="i">

                                <c:url var="pageUrl"
                                       value="/batch">

                                    <c:param name="warehouseId"
                                             value="${warehouse.warehouseId}"/>

                                    <c:param name="keyword"
                                             value="${keyword}"/>

                                    <c:param name="status"
                                             value="${selectedStatus}"/>

                                    <c:param name="sortBy"
                                             value="${sortBy}"/>

                                    <c:param name="sortOrder"
                                             value="${sortOrder}"/>

                                    <c:param name="page"
                                             value="${i}"/>

                                </c:url>


                                <a href="${pageUrl}"
                                   class="${i eq currentPage
                                            ? 'active'
                                            : ''}">

                                    ${i}

                                </a>

                            </c:forEach>


                            <%-- NEXT --%>

                            <c:if test="${currentPage < totalPages}">

                                <c:url var="nextUrl"
                                       value="/batch">

                                    <c:param name="warehouseId"
                                             value="${warehouse.warehouseId}"/>

                                    <c:param name="keyword"
                                             value="${keyword}"/>

                                    <c:param name="status"
                                             value="${selectedStatus}"/>

                                    <c:param name="sortBy"
                                             value="${sortBy}"/>

                                    <c:param name="sortOrder"
                                             value="${sortOrder}"/>

                                    <c:param name="page"
                                             value="${currentPage + 1}"/>

                                </c:url>


                                <a href="${nextUrl}">
                                    Next
                                </a>

                            </c:if>

                        </div>

                    </c:if>

                </section>


            </main>


        </div>


    </body>

</html>