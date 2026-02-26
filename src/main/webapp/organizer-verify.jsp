<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get organizer session data
    String registrationEmail = (String) session.getAttribute("registrationEmail");
    String registrationType = (String) session.getAttribute("registrationType");

    // Security: prevent direct access without signup
    if (registrationEmail == null || !"organizer".equals(registrationType)) {
        response.sendRedirect("organizer-signup.jsp?error=Session expired! Please register again.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Account | EventHub</title>
    <link rel="stylesheet" href="css/user-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <% if (request.getAttribute("success") != null) { %>
    <script>
        setTimeout(function () {
            window.location.href = "organizer-login.jsp";
        }, 3000);
    </script>
    <% } %>
</head>

<body>

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <a href="index.jsp" class="logo">EventHub</a>
            <h2>Verify Your Account</h2>
            <p>Please enter the OTP sent to your registered email address</p>
        </div>

        <%-- Error Message --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <%-- Success Message --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>Success!</strong><br>
                    <%= request.getAttribute("success") %><br>
                    <small>Redirecting to login page in a few seconds...</small>
                </div>
            </div>
        <% } %>

        <%-- Show OTP Form only if not verified yet --%>
        <% if (request.getAttribute("success") == null) { %>
            <!-- ONLY FUNCTIONAL CHANGE: Action points to Organizer Servlet -->
            <form action="VerifyOrganizerOtpServlet" method="POST" class="auth-form">

                <div class="form-group">
                    <label for="otp">Enter Verification Code</label>
                    <div class="input-wrapper">
                        <input type="text" id="otp" name="otp" placeholder="••••••" required maxlength="6">
                        <i class="fas fa-key"></i>
                    </div>
                </div>

                <button type="submit" class="btn-auth">Verify Account</button>
            </form>

            <div class="auth-footer">
                OTP sent to: <strong><%= registrationEmail %></strong>
            </div>

            <div class="auth-footer">
                <a href="organizer-signup.jsp">← Back to Registration</a>
            </div>
        <% } %>

    </div>
</div>

</body>
</html>