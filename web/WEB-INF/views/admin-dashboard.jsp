<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp"/>

<main class="main-content">

    <h1>Admin Dashboard</h1>

    <div class="cards">

        <div class="card">
            <h3>Total Users</h3>
            <p id="totalUsers">
                ${totalUsers}
            </p>
        </div>

        <div class="card">
            <h3>Active Warehouses</h3>
            <p id="activeWarehouses">
                ${activeWarehouses}
            </p>
        </div>

        <div class="card">
            <h3>Online Devices</h3>
            <p id="onlineDevices">
                ${onlineDevices}
            </p>
        </div>

        <div class="card">
            <h3>Active Batches</h3>
            <p id="activeBatches">
                ${activeBatches}
            </p>
        </div>

    </div>


    <h2>Warehouse Status</h2>

    <table>

        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Location</th>
            <th>Status</th>
            <th>Manager</th>
            <th>Devices</th>
            <th>Online</th>
            <th>Active Batches</th>
        </tr>

        <c:forEach var="w"
                   items="${warehouseList}">

            <tr>

                <td>${w.warehouseId}</td>
                <td>${w.name}</td>
                <td>${w.location}</td>
                <td>${w.status}</td>
                <td>${w.managerName}</td>
                <td>${w.deviceCount}</td>
                <td>${w.onlineDeviceCount}</td>
                <td>${w.activeBatchCount}</td>

            </tr>

        </c:forEach>

    </table>

</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>


</body>
</html>
