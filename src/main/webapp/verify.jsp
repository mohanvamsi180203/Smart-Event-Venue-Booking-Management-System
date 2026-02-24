<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify Account | EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <% if (request.getAttribute("success") !=null) { %>
            <script>
                setTimeout(function () {
                    window.location.href = "user-login.jsp";
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

                <%-- Success/Error Messages from Servlet --%>
                    <% if (request.getAttribute("error") !=null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <% if (request.getAttribute("success") !=null) { %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i>
                                    <div>
                                        <strong>Success!</strong><br>
                                        <%= request.getAttribute("success") %><br>
                                            <small>Redirecting to login page in a few seconds...</small>
                                    </div>
                                </div>
                                <% } %>

                                    <% if (request.getAttribute("success")==null) { %>
                                        <form action="UserServlet" method="POST" class="auth-form">
                                            <input type="hidden" name="action" value="verifyOtp">
                                            <input type="hidden" name="email" value="<%= request.getParameter("email") !=null ? request.getParameter("email") : "" %>">

                                            <div class="form-group">
                                                <label for="otp">Enter Verification Code</label>
                                                <div class="input-wrapper">
                                                    <input type="text" id="otp" name="otp" placeholder="••••••" required
                                                        maxlength="6">
                                                    <i class="fas fa-key"></i>
                                                </div>
                                            </div>

                                            <button type="submit" class="btn-auth">Verify Account</button>
                                        </form>

                                        <div class="auth-footer">
                                            Didn't receive the code? <a href="UserServlet?action=resendOtp">Resend Code</a>
                                        </div>
                                        <% } %>
            </div>
        </div>

    </body>

    </html>
