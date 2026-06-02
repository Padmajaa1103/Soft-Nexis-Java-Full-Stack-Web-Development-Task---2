<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add Contact</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css" />
</head>
<body>
<div class="page-shell">
    <header class="page-header">
        <div>
            <h1>New Contact</h1>
            <p>Fill in the contact details and submit to add it to the list.</p>
        </div>
        <a class="button secondary" href="${pageContext.request.contextPath}/contacts">Back to contacts</a>
    </header>

    <c:if test="${not empty errorMessage}">
        <div class="alert error">${errorMessage}</div>
    </c:if>

    <form id="contact-form" class="form-card" method="post" action="${pageContext.request.contextPath}/contacts" novalidate>
        <div class="form-row">
            <label for="name">Name *</label>
            <input id="name" name="name" type="text" value="${fn:escapeXml(formName)}" aria-describedby="name-error" />
            <c:if test="${not empty errors.name}">
                <span id="name-error" class="field-error">${errors.name}</span>
            </c:if>
        </div>

        <div class="form-row">
            <label for="email">Email *</label>
            <input id="email" name="email" type="email" value="${fn:escapeXml(formEmail)}" aria-describedby="email-error" />
            <c:if test="${not empty errors.email}">
                <span id="email-error" class="field-error">${errors.email}</span>
            </c:if>
        </div>

        <div class="form-row">
            <label for="phone">Phone</label>
            <input id="phone" name="phone" type="tel" value="${fn:escapeXml(formPhone)}" aria-describedby="phone-error" />
            <c:if test="${not empty errors.phone}">
                <span id="phone-error" class="field-error">${errors.phone}</span>
            </c:if>
            <small class="field-help">Optional. Enter a 10-digit number without separators.</small>
        </div>

        <div class="form-actions">
            <button id="submit-button" class="button primary" type="submit">Save Contact</button>
            <div id="spinner" class="spinner hidden" aria-hidden="true"></div>
        </div>
    </form>
</div>
<script>
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const form = document.getElementById('contact-form');
    const spinner = document.getElementById('spinner');
    const submitButton = document.getElementById('submit-button');

    const rules = {
        name: value => value.trim().length >= 2 && value.trim().length <= 50,
        email: value => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/.test(value.trim()),
        phone: value => value.trim() === '' || /^[0-9]{10}$/.test(value.trim())
    };

    function validateField(input, message, rule) {
        const errorElement = document.getElementById(`${input.id}-error`);
        const isValid = rule(input.value);
        if (!isValid) {
            input.classList.add('invalid');
            if (errorElement) {
                errorElement.textContent = message;
            }
        } else {
            input.classList.remove('invalid');
            if (errorElement) {
                errorElement.textContent = '';
            }
        }
        return isValid;
    }

    function onInput() {
        validateField(nameInput, 'Please enter valid name', rules.name);
        validateField(emailInput, 'Invalid email address', rules.email);
        validateField(phoneInput, 'Use 10-digit format', rules.phone);
    }

    nameInput.addEventListener('input', onInput);
    emailInput.addEventListener('input', onInput);
    phoneInput.addEventListener('input', onInput);

    form.addEventListener('submit', event => {
        const validName = validateField(nameInput, 'Please enter valid name', rules.name);
        const validEmail = validateField(emailInput, 'Invalid email address', rules.email);
        const validPhone = validateField(phoneInput, 'Use 10-digit format', rules.phone);
        if (!validName || !validEmail || !validPhone) {
            event.preventDefault();
            if (!validName) {
                nameInput.focus();
            } else if (!validEmail) {
                emailInput.focus();
            } else {
                phoneInput.focus();
            }
            return;
        }
        submitButton.disabled = true;
        spinner.classList.remove('hidden');
    });

    window.addEventListener('DOMContentLoaded', () => {
        if (document.querySelector('.field-error')) {
            if (document.getElementById('name-error')) {
                nameInput.focus();
            }
        }
    });
</script>
</body>
</html>
