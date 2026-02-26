package com.controller;

import java.io.IOException;

import com.dao.OrganizerDao;
import com.dao.OrganizerDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyOrganizerOtpServlet")
public class VerifyOrganizerOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrganizerDao organizerDao = new OrganizerDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("registrationEmail");
        String type = (String) session.getAttribute("registrationType");

        try {
            // 1. Session validation (security)
            if (email == null || type == null || !type.equals("organizer")) {
                response.sendRedirect("organizer-signup.jsp?error=Session expired! Please register again.");
                return;
            }

            // 2. OTP empty check
            if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
                request.setAttribute("error", "Please enter OTP!");
                request.getRequestDispatcher("/organizer-verify.jsp").forward(request, response);
                return;
            }

            // 3. Verify OTP using DAO (MVC)
            boolean isVerified = organizerDao.verifyOtp(email, enteredOtp);

            if (isVerified) {
                // Mark success and clear session
                session.removeAttribute("registrationEmail");
                session.removeAttribute("registrationType");

                request.setAttribute("success", "Email verified successfully! You can now login.");
                request.getRequestDispatcher("/organizer-verify.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Invalid or expired OTP!");
                request.getRequestDispatcher("/organizer-verify.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "OTP verification failed! Please try again.");
            request.getRequestDispatcher("/organizer-verify.jsp").forward(request, response);
        }
    }
}