<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>${param.title}</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/nb13-style.css" rel="stylesheet"></head><body>
<aside class="side"><h5>Smart Agricultural<br>Drying System</h5>
  <a class="${param.active=='dashboard'?'on':''}" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
  <a class="${param.active=='users'?'on':''}" href="${pageContext.request.contextPath}/users">User Management</a>
  <a class="${param.active=='warehouses'?'on':''}" href="${pageContext.request.contextPath}/warehouses">Warehouse Management</a>
  <a class="${param.active=='devices'?'on':''}" href="${pageContext.request.contextPath}/devices">Device Management</a>
  <a href="${pageContext.request.contextPath}/logout">Logout</a></aside>
<main class="main">
<div class="topbar"><div><h3 class="mb-0">${param.title}</h3><small class="text-muted">${param.sub}</small></div>
  <div><span class="tag ok">ADMIN</span> ${sessionScope.LOGIN_USER.fullName}</div></div>
<c:if test="${not empty sessionScope.flash}"><div class="alert alert-warning">${sessionScope.flash}</div><c:remove var="flash" scope="session"/></c:if>
