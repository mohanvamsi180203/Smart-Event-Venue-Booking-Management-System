<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is already logged in
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Check if user has registered (session should have registrationEmail)
    String registrationEmail = (String) session.getAttribute("registrationEmail");
    if (registrationEmail == null) {
        response.sendRedirect("user-signup.jsp?error=Session expired! Please register again.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify OTP - EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <a href="index.jsp" class="logo">EventHub</a>
                    <h2>Verify Your Email</h2>
                    <p>We've sent an OTP to your email address</p>
                </div>

                <%-- Display error message if any --%>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <%-- Display success message if any --%>
                                <% String successParam = request.getParameter("success");
           if (successParam != null) { %>
                                    <div class="alert alert-success">
                                        <i class="fas fa-check-circle"></i>
                                        <%= successParam %>
                                    </div>
                                    <% } %>

                                        <%-- Display warning message if any --%>
                                            <% String warningParam = request.getParameter("warning");
           if (warningParam != null) { %>
                                                <div class="alert alert-warning">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <%= warningParam %>
                                                </div>
                                                <% } %>

                                                    <div class="email-display">
                                                        <i class="fas fa-envelope"></i>
                                                        <span>OTP sent to: <strong><%= registrationEmail %></strong></span>
                                                    </div>

                                                    <form action="UserServlet" method="post" class="auth-form">
                                                        <input type="hidden" name="action" value="verifyOtp">

                                                        <div class="form-group">
                                                            <label for="otp">Enter 6-digit OTP</label>
                                                            <div class="input-wrapper">
                                                                <input type="text" id="otp" name="otp" 
                                                                       placeholder="Enter OTP" maxlength="6"
                                                                       required autocomplete="one-time-code">
                                                                <i class="fas fa-shield-halved"></i>
                                                            </div>
                                                        </div>

                                                        <button type="submit" class="btn-auth">
                                                            Verify OTP
                                                        </button>
                                                    </form>

                                                    <form action="UserServlet" method="post" id="resendForm" style="display: none;">
                                                        <input type="hidden" name="action" value="resendOtp">
                                                    </form>

                                                    <div class="auth-footer">
                                                        Didn't receive OTP? <a href="#" onclick="document.getElementById('resendForm').submit(); return false;">Resend OTP</a>
                                                    </div>

                                                    <div class="auth-footer">
                                                        <a href="user-signup.jsp">← Back to Registration</a>
                                                    </div>
            </div>
        </div>

    </body>

</html>
