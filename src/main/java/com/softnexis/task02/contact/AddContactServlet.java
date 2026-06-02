package com.softnexis.task02.contact;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class AddContactServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        new ContactServlet().doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));

        Map<String, String> errors = validate(name, email, phone);

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("formName", name);
            req.setAttribute("formEmail", email);
            req.setAttribute("formPhone", phone);
            req.getRequestDispatcher("/contact-form.jsp").forward(req, resp);
            return;
        }

        try {
            HttpSession session = req.getSession(true);
            List<Contact> contacts = getContactList(session);
            contacts.add(new Contact(UUID.randomUUID().toString(), name, email, phone));
            session.setAttribute("flashMessage", "Contact added successfully.");
            resp.sendRedirect(req.getContextPath() + "/contacts");
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An unexpected server error occurred. Please try again.");
            req.setAttribute("formName", name);
            req.setAttribute("formEmail", email);
            req.setAttribute("formPhone", phone);
            req.getRequestDispatcher("/contact-form.jsp").forward(req, resp);
        }
    }

    private Map<String, String> validate(String name, String email, String phone) {
        Map<String, String> errors = new HashMap<>();
        if (name == null || name.isEmpty() || name.length() < 2 || name.length() > 50) {
            errors.put("name", "Please enter valid name");
        }
        if (email == null || email.isEmpty() || !email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            errors.put("email", "Invalid email address");
        }
        if (phone != null && !phone.isEmpty() && !phone.matches("^[0-9]{10}$")) {
            errors.put("phone", "Use 10-digit format");
        }
        return errors;
    }

    private List<Contact> getContactList(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Contact> contacts = (List<Contact>) session.getAttribute("contacts");
        if (contacts == null) {
            contacts = new ArrayList<>();
            session.setAttribute("contacts", contacts);
        }
        return contacts;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
