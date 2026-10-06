<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/includes/_top.jsp"><jsp:param name="title" value="User Management"/><jsp:param name="sub" value="Quản lý tài khoản và phân quyền"/><jsp:param name="active" value="users"/></jsp:include>
<div class="row g-3 mb-3">
  <div class="col-md-3"><div class="stat" style="background:#dcfce7">Total Users<b>${users.size()}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#d1fae5">Active<b>${activeCount}</b></div></div>
  <div class="col-md-3"><div class="stat" style="background:#fee2e2">Inactive<b>${users.size()-activeCount}</b></div></div>
</div>
<div class="box"><div class="d-flex justify-content-between mb-2"><h5>User List</h5>
  <button class="btn btn-g" data-bs-toggle="modal" data-bs-target="#addM">+ Add User</button></div>
<table class="table align-middle"><tr><th>User ID</th><th>Full Name</th><th>Role</th><th>Warehouse</th><th>Status</th><th>Action</th></tr>
<c:forEach var="u" items="${users}"><tr><td>${u.id}</td><td>${u.fullName}</td>
<td><form method="post"><input type="hidden" name="action" value="role"><input type="hidden" name="id" value="${u.id}">
  <select name="role" class="form-select form-select-sm" onchange="this.form.submit()" ${u.id==sessionScope.user.id?'disabled':''}>
  <c:forEach var="r" items="ADMIN,MANAGER,OPERATOR"><option ${u.role==r?'selected':''}>${r}</option></c:forEach></select></form></td>
<td><c:choose><c:when test="${u.role=='ADMIN'}">All Warehouses</c:when><c:otherwise>
<form method="post"><input type="hidden" name="action" value="assign"><input type="hidden" name="id" value="${u.id}">
  <select name="warehouseId" class="form-select form-select-sm" onchange="this.form.submit()"><option value="">-- Not assigned --</option>
  <c:forEach var="w" items="${warehouses}"><option value="${w.id}" ${u.warehouseId==w.id?'selected':''}>${w.id} - ${w.name}</option></c:forEach></select></form>
</c:otherwise></c:choose></td>
<td><span class="tag ${u.active?'ok':'off'}">${u.active?'Active':'Inactive'}</span></td>
<td><form method="post" class="d-inline"><input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="${u.id}">
  <button class="btn btn-sm btn-outline-secondary" ${u.id==sessionScope.user.id?'disabled':''}>${u.active?'Deactivate':'Activate'}</button></form>
  <button class="btn btn-sm btn-outline-success" onclick="editU('${u.id}','${u.fullName}')">Edit</button></td></tr></c:forEach></table></div>

<div class="modal fade" id="addM"><div class="modal-dialog"><form method="post" class="modal-content p-3">
  <input type="hidden" name="action" value="add"><h5>Add User</h5>
  <input name="fullName" class="form-control mb-2" placeholder="Full name" required>
  <input name="username" class="form-control mb-2" placeholder="Username" required>
  <input name="password" type="password" class="form-control mb-2" placeholder="Password (min 6)" required minlength="6">
  <select name="role" class="form-select mb-2"><option>MANAGER</option><option>OPERATOR</option><option>ADMIN</option></select>
  <select name="warehouseId" class="form-select mb-3"><option value="">-- Warehouse --</option>
  <c:forEach var="w" items="${warehouses}"><option value="${w.id}">${w.id} - ${w.name}</option></c:forEach></select>
  <button class="btn btn-g">Save user</button></form></div></div>
<div class="modal fade" id="editM"><div class="modal-dialog"><form method="post" class="modal-content p-3">
  <input type="hidden" name="action" value="edit"><input type="hidden" name="id" id="eid"><h5>Edit User</h5>
  <input name="fullName" id="ename" class="form-control mb-3" required><button class="btn btn-g">Save changes</button></form></div></div>
<script>function editU(i,n){document.getElementById('eid').value=i;document.getElementById('ename').value=n;
new bootstrap.Modal(document.getElementById('editM')).show();}</script>
<jsp:include page="/WEB-INF/views/includes/_bottom.jsp"/>
