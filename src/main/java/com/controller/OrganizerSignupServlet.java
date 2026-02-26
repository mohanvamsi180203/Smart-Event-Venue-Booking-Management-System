package com.controller;

import java.io.IOException;
import java.util.Random;

import org.mindrot.jbcrypt.BCrypt;

import com.dao.OrganizerDao;
import com.dao.OrganizerDaoImpl;
import com.dto.Organizer;
import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrganizerSignupServlet")
public class OrganizerSignupServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrganizerDao organizerDao = new OrganizerDaoImpl();
    private Random random = new Random();

    // Generate 6-digit OTP
    private String generateOtp() {
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orgName = request.getParameter("org-name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        try {

            // 1️⃣ Basic Validation
            if (orgName == null || email == null || mobile == null || password == null
                    || orgName.isEmpty() || email.isEmpty() || mobile.isEmpty() || password.isEmpty()) {

                request.setAttribute("error", "All fields are required!");
                request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
                return;
            }

            // 2️⃣ Password Match Validation
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match!");
                request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
                return;
            }

            // 3️⃣ Check Duplicate Email (VERY IMPORTANT)
            if (organizerDao.isEmailExists(email)) {
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
                return;
            }

            // 4️⃣ Hash Password (Security)
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // 5️⃣ Create DTO (Model Layer)
            Organizer organizer = new Organizer();
            organizer.setOrganizationName(orgName);
            organizer.setBusinessEmail(email);
            organizer.setMobileNumber(mobile);
            organizer.setPassword(hashedPassword);

            // 6️⃣ Save Organizer (DAO Layer)
            boolean isRegistered = organizerDao.registerOrganizer(organizer);

            if (!isRegistered) {
                request.setAttribute("error", "Registration failed! Please try again.");
                request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
                return;
            }

            // 7️⃣ Get Organizer ID from DB
            long organizerId = organizerDao.getOrganizerIdByEmail(email);

            // 8️⃣ Generate OTP
            String otp = generateOtp();

            // 9️⃣ Save OTP (DAO Layer)
            organizerDao.saveOtp(organizerId, otp);

            // 🔟 Send OTP Email (Utility Layer)
            EmailUtil.sendOTP(email, otp);

            // 1️⃣1️⃣ Store Email in Session (for verification step)
            HttpSession session = request.getSession();
            session.setAttribute("registrationEmail", email);
            session.setAttribute("registrationType", "organizer");

            // 1️⃣2️⃣ Redirect to OTP Verification Page
            response.sendRedirect(request.getContextPath() + "/organizer-verify.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong! Please try again.");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
        }
    }
}