<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/user-style.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-dark);
            padding: 40px 20px;
        }
        
        .auth-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 440px;
            box-shadow: var(--shadow-lg);
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .auth-header .logo {
            font-family: 'Outfit', sans-serif;
            font-size: 28px;
            font-weight: 800;
            background: var(--gradient-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: block;
            margin-bottom: 8px;
        }
        
        .auth-header h2 {
            font-size: 24px;
            color: var(--text-primary);
            margin-bottom: 8px;
        }
        
        .auth-header p {
            font-size: 14px;
            color: var(--text-secondary);
        }
        
        .auth-toggle {
            display: flex;
            background: var(--surface);
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 24px;
        }
        
        .auth-toggle a {
            flex: 1;
            text-align: center;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            background: transparent;
        }
        
        .auth-toggle a.active {
            background: var(--brand-primary);
            color: #0b0f19;
        }
        
        .auth-toggle a:hover:not(.active) {
            color: var(--text-primary);
        }
        
        .login-form {
            display: none;
        }
        
        .login-form.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-wrapper input {
            width: 100%;
            padding: 14px 14px 14px 44px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            background: var(--surface);
            color: var(--text-primary);
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .input-wrapper input:focus {
            outline: none;
            border-color: var(--brand-primary);
            background: var(--bg-card);
        }
        
        .input-wrapper input::placeholder {
            color: var(--text-muted);
        }
        
        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 16px;
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 14px;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            cursor: pointer;
        }
        
        .remember-me input {
            width: 16px;
            height: 16px;
            accent-color: var(--brand-primary);
        }
        
        .forgot-password {
            color: var(--brand-primary);
            text-decoration: none;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .btn-auth {
            width: 100%;
            padding: 14px;
            background: var(--gradient-brand);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(245, 158, 11, 0.3);
        }
        
        .auth-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: var(--text-secondary);
        }
        
        .auth-footer a {
            color: var(--brand-primary);
            text-decoration: none;
            font-weight: 500;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link a:hover {
            color: var(--brand-primary);
        }
    </style>
</head>

<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <a href="<%= request.getContextPath() %>/index.jsp" class="logo">EventHub</a>
                <h2>Welcome Back</h2>
                <p>Enter your credentials to access your account</p>
            </div>

            <div class="auth-toggle">
                <a href="#" class="active" onclick="switchTab('user')">User</a>
                <a href="#" onclick="switchTab('organizer')">Organizer</a>
                <a href="#" onclick="switchTab('admin')">Admin</a>
            </div>

            <%-- Success/Error Messages from Servlet --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% String success = request.getParameter("success");
               if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= success %>
                </div>
            <% } %>

            <!-- User Login Form -->
            <form action="<%= request.getContextPath() %>/UserServlet" method="POST" class="login-form active" id="user-form">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label for="user-email">Email Address</label>
                    <div class="input-wrapper">
                        <input type="email" id="user-email" name="email" placeholder="name@company.com" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="user-password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="user-password" name="password" placeholder="Enter your password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="forgot-password">Forgot password?</a>
                </div>

                <button type="submit" class="btn-auth">Sign In as User</button>
            </form>

            <!-- Organizer Login Form -->
            <form action="<%= request.getContextPath() %>/UserServlet" method="POST" class="login-form" id="organizer-form">
                <input type="hidden" name="action" value="organizerLogin">
                <div class="form-group">
                    <label for="org-email">Email Address</label>
                    <div class="input-wrapper">
                        <input type="email" id="org-email" name="email" placeholder="organizer@company.com" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="org-password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="org-password" name="password" placeholder="Enter your password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <button type="submit" class="btn-auth">Sign In as Organizer</button>
                
                <div class="auth-footer" style="margin-top: 16px;">
                    New organizer? <a href="<%= request.getContextPath() %>/organizer-signup.jsp">Register here</a>
                </div>
            </form>

            <!-- Admin Login Form -->
            <form action="<%= request.getContextPath() %>/UserServlet" method="POST" class="login-form" id="admin-form">
                <input type="hidden" name="action" value="adminLogin">
                <div class="form-group">
                    <label for="admin-username">Username</label>
                    <div class="input-wrapper">
                        <input type="text" id="admin-username" name="username" placeholder="Enter admin username" required>
                        <i class="fas fa-user"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="admin-password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="admin-password" name="password" placeholder="Enter your password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <button type="submit" class="btn-auth">Sign In as Admin</button>
            </form>

            <div class="auth-footer">
                Don't have an account? <a href="<%= request.getContextPath() %>/user-signup.jsp">Create Account</a>
            </div>
            
            <div class="back-link">
                <a href="<%= request.getContextPath() %>/index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tab) {
            event.preventDefault();
            
            // Update tab buttons
            const tabs = document.querySelectorAll('.auth-toggle a');
            tabs.forEach(t => t.classList.remove('active'));
            event.target.classList.add('active');
            
            // Update forms
            const forms = document.querySelectorAll('.login-form');
            forms.forEach(f => f.classList.remove('active'));
            
            document.getElementById(tab + '-form').classList.add('active');
        }
    </script>

</body>

</html>
