<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css" />
</head>
<body>
<div class="page-shell">
    <header class="page-header">
        <div>
            <h1>Contacts</h1>
            <p>Manage visitor submissions and keep your contact list up to date.</p>
        </div>
        <a class="button primary" href="${pageContext.request.contextPath}/contacts/add">Add New Contact</a>
    </header>

    <c:if test="${not empty successMessage}">
        <div class="alert success">${successMessage}</div>
    </c:if>

    <div class="toolbar">
        <input id="search" type="search" placeholder="Search contacts..." aria-label="Search contacts" />
    </div>

    <c:if test="${empty contacts}">
        <div class="empty-state">
            <strong>No contacts yet.</strong>
            <p>Use the button above to add your first contact.</p>
        </div>
    </c:if>

    <c:if test="${not empty contacts}">
        <div class="table-wrap">
            <table class="responsive-table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                </tr>
                </thead>
                <tbody id="contact-body">
                <c:forEach items="${contacts}" var="contact" varStatus="status">
                    <tr class="contact-row" data-index="${status.index}">
                        <td><c:out value="${contact.name}"/></td>
                        <td><c:out value="${contact.email}"/></td>
                        <td><c:out value="${contact.phone}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div id="pagination" class="pagination"></div>
    </c:if>
</div>
<script>
    const rows = Array.from(document.querySelectorAll('.contact-row'));
    const pageSize = 5;
    const pagination = document.getElementById('pagination');
    const searchInput = document.getElementById('search');

    function renderPage(page) {
        const term = searchInput.value.trim().toLowerCase();
        const filtered = rows.filter(row => {
            const text = row.textContent.toLowerCase();
            return text.includes(term);
        });
        const pageCount = Math.max(1, Math.ceil(filtered.length / pageSize));
        const safePage = Math.min(Math.max(page, 1), pageCount);

        rows.forEach(row => row.classList.add('hidden'));
        filtered.slice((safePage - 1) * pageSize, safePage * pageSize).forEach(row => row.classList.remove('hidden'));

        pagination.innerHTML = '';
        if (pageCount <= 1) {
            return;
        }

        for (let i = 1; i <= pageCount; i++) {
            const button = document.createElement('button');
            button.type = 'button';
            button.textContent = i;
            button.className = i === safePage ? 'page active' : 'page';
            button.addEventListener('click', () => renderPage(i));
            pagination.appendChild(button);
        }
    }

    searchInput.addEventListener('input', () => renderPage(1));
    renderPage(1);
</script>
</body>
</html>
