<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Drying Batch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp"/>

<main class="main-content">

    <h1>Drying Batch</h1>

    <h2>Start Batch</h2>

    <form method="post"
          action="${pageContext.request.contextPath}/batch">

        <input type="hidden"
               name="action"
               value="start">

        <label>Batch ID</label>
        <input type="text"
               name="batchId"
               required>

        <label>Warehouse</label>

        <select name="warehouseId"
                required>

            <c:forEach var="w"
                       items="${warehouseList}">

                <option value="${w.warehouseId}">
                    ${w.name}
                </option>

            </c:forEach>

        </select>

        <button type="submit">
            Start Batch
        </button>

    </form>


    <h2>Search</h2>

    <form method="get"
          action="${pageContext.request.contextPath}/batch">

        <input type="text"
               name="search"
               value="${search}"
               placeholder="Batch ID / Warehouse">

        <select name="warehouseId">

            <option value="">
                All Warehouses
            </option>

            <c:forEach var="w"
                       items="${warehouseList}">

                <option value="${w.warehouseId}"
                    <c:if test="${selectedWarehouse == w.warehouseId}">
                        selected
                    </c:if>>
                    ${w.name}
                </option>

            </c:forEach>

        </select>

        <button type="submit">
            Search
        </button>

    </form>


    <h2>Batch List</h2>

    <table>

        <tr>
            <th>Batch ID</th>
            <th>Warehouse</th>
            <th>Status</th>
            <th>Start</th>
            <th>End</th>
            <th>Action</th>
        </tr>

        <c:forEach var="b"
                   items="${batchList}">

            <tr>

                <td>${b.batchId}</td>
                <td>${b.warehouseName}</td>
                <td>${b.status}</td>
                <td>${b.startTime}</td>
                <td>${b.endTime}</td>

                <td>

                    <c:if test="${b.status == 'DRYING'}">

                        <form method="post"
                              action="${pageContext.request.contextPath}/batch">

                            <input type="hidden"
                                   name="action"
                                   value="complete">

                            <input type="hidden"
                                   name="batchId"
                                   value="${b.batchId}">

                            <button type="submit">
                                Complete
                            </button>

                        </form>

                    </c:if>

                </td>

            </tr>

        </c:forEach>

    </table>

</main>

</body>
</html>
