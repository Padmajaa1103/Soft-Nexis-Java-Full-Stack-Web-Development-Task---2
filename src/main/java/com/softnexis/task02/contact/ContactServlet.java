package com.softnexis.task02.contact;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ContactServlet extends HttpServlet {
    private static final String CONTACT_LIST_VIEW = "/contact-list.jsp";
    private static final String CONTACT_FORM_VIEW = "/contact-form.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            List<Contact> contacts = getContactList(session);

            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.isEmpty() || "/".equals(pathInfo)) {
                String flash = (String) session.getAttribute("flashMessage");
                if (flash != null) {
                    req.setAttribute("successMessage", flash);
                    session.removeAttribute("flashMessage");
                }
                req.setAttribute("contacts", contacts);
                req.getRequestDispatcher(CONTACT_LIST_VIEW).forward(req, resp);
                return;
            }

            if ("/add".equals(pathInfo)) {
                req.setAttribute("formName", req.getParameter("name"));
                req.setAttribute("formEmail", req.getParameter("email"));
                req.setAttribute("formPhone", req.getParameter("phone"));
                req.getRequestDispatcher(CONTACT_FORM_VIEW).forward(req, resp);
                return;
            }

            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        } catch (NullPointerException error) {
            req.setAttribute("errorMessage", "Your session has expired or an unexpected error occurred.");
            req.getRequestDispatcher(CONTACT_LIST_VIEW).forward(req, resp);
        }
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
}
