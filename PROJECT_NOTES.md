# Smart Event Venue Booking Management System - Technical Documentation

## 1. Project Overview

This is a **Java Web Application** for managing event venue bookings. The system allows users to register, verify their email via OTP (One-Time Password), and login to browse and book event venues.

### Key Features:
- User Registration with Email Verification
- OTP-based Email Verification
- Secure Login with Password Hashing
- Event Venue Booking Management

---

## 2. Technology Stack

| Component | Technology |
|-----------|------------|
| **Programming Language** | Java |
| **Web Framework** | Jakarta Servlet API 6.0.0 |
| **Build Tool** | Maven |
| **Server** | Jetty 11.0.20 |
| **Database** | MySQL |
| **Email** | JavaMail (Gmail SMTP) |
| **Password Security** | BCrypt |
| **Frontend** | JSP, HTML, CSS, JavaScript |

---

## 3. Project Structure

```
Smart-Event-Venue-Booking-Management-System/
├── pom.xml                          # Maven configuration
├── src/
│   ├── main/
│   │   ├── java/com/
│   │   │   ├── controller/          # Servlets (UserServlet, VerifyOtpServlet)
│   │   │   ├── dao/                 # Data Access Objects
│   │   │   ├── dto/                 # Data Transfer Objects (User, Organizer)
│   │   │   └── util/                # Utility classes (DBConnection, EmailUtil)
│   │   ├── resources/
│   │   │   └── schema.sql           # Database schema
│   │   └── webapp/
│   │       ├── index.jsp            # Home page
│   │       ├── user-login.jsp       # User login page
│   │       ├── user-signup.jsp      # User registration page
│   │       ├── verifyOtp.jsp       # OTP verification page
│   │       ├── css/                 # Stylesheets
│   │       └── WEB-INF/web.xml      # Web application configuration
│   └── test/                        # Test files
└── target/                          # Build output
```

---

## 4. Database Schema

### Database: `eventhub_db`

#### Users Table
```
sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    otp VARCHAR(6) DEFAULT NULL,
    otp_expires_at TIMESTAMP NULL DEFAULT NULL,
    is_verified TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_is_verified (is_verified)
);
```

### Key Fields:
- **id**: Primary key, auto-increment
- **name**: User's full name
- **password**: BCrypt hashed password
- **email**: Unique email address
- **otp**: 6-digit verification code
- **otp_expires_at**: OTP expiration timestamp (10 minutes)
- **is_verified**: Boolean flag for email verification status
- **created_at**: Account creation timestamp
- **updated_at**: Last update timestamp

---

## 5. Core Components

### 5.1 DBConnection.java
**Purpose**: Manages database connections

```
java
public class DBConnection {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/eventhub_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
            "root",
            "@Mahendra2428sql"
        );
    }
}
```

**Configuration**:
- Host: localhost
- Port: 3306
- Database: eventhub_db
- Username: root
- Password: @Mahendra2428sql

---

### 5.2 UserServlet.java
**Purpose**: Handles all user-related operations

**Endpoints/Actions**:
1. **register** - User registration with OTP generation
2. **verifyOtp** - Email verification using OTP
3. **resendOtp** - Resend OTP if expired
4. **login** - User authentication
5. **logout** - End user session

**Key Methods**:
- `handleRegistration()` - Validates input, checks existing email, hashes password, generates OTP, sends email
- `handleOtpVerification()` - Validates OTP against stored value and expiration time
- `handleResendOtp()` - Generates new OTP and sends via email
- `handleLogin()` - Authenticates user with BCrypt password check
- `handleLogout()` - Invalidates session
- `generateOtp()` - Generates 6-digit random OTP (100000-999999)

---

### 5.3 EmailUtil.java
**Purpose**: Sends transactional emails

**Methods**:
1. **sendOTP(String toEmail, String otp)**
   - Sends verification OTP email
   - Uses Gmail SMTP (port 587)
   - HTML formatted email with gradient design
   - OTP expires in 10 minutes

2. **sendRegistrationSuccess(String toEmail, String userName)**
   - Sends welcome email after successful verification
   - Lists features user can access

**Email Configuration**:
- SMTP Host: smtp.gmail.com
- SMTP Port: 587
- From Email: mvsv18k@gmail.com
- Authentication: Gmail App Password

---

## 6. User Registration Flow

```
┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│  User Signup    │ ──→  │  Generate OTP    │ ──→  │  Send OTP Email │
│  (user-signup)  │      │  (6-digit)       │      │  (10 min expiry)│
└─────────────────┘      └──────────────────┘      └─────────────────┘
                                                          │
                                                          ▼
┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│  Login Success  │ ←─── │  Verify OTP &    │ ←─── │  Enter OTP      │
│  (index.jsp)   │      │  Update Status   │      │  (verifyOtp.jsp)│
└─────────────────┘      └──────────────────┘      └─────────────────┘
```

### Step-by-Step Flow:

1. **User Registration**:
   - User fills form (name, email, password, confirm password)
   - Client-side validation (password match, minimum length)
   - Server checks if email already exists
   - Password hashed using BCrypt
   - User record created with is_verified=false
   - 6-digit OTP generated and stored with 10-minute expiry
   - OTP sent to user's email
   - Redirect to verifyOtp.jsp

2. **OTP Verification**:
   - User enters 6-digit OTP
   - System validates:
     - OTP matches stored value
     - Current time < otp_expires_at
   - On success: is_verified=true, OTP cleared, success email sent
   - On failure: Error message, option to resend OTP

3. **Login**:
   - User enters email and password
   - System checks email exists and is_verified=true
   - Password validated using BCrypt
   - On success: Create session, redirect to index.jsp
   - On failure: Error message

---

## 7. Security Features

| Feature | Implementation |
|---------|---------------|
| **Password Hashing** | BCrypt with salt |
| **SQL Injection Prevention** | PreparedStatement with parameterized queries |
| **Session Management** | HttpSession with proper invalidation |
| **Email Validation** | Server-side validation |
| **OTP Expiry** | 10-minute time limit |
| **Input Validation** | Server-side checks for all inputs |

---

## 8. Dependencies (Maven)

```
xml
<!-- Jakarta Servlet API -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.0.0</version>
</dependency>

<!-- MySQL Connector -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- JavaMail -->
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>jakarta.mail</artifactId>
    <version>2.0.1</version>
</dependency>

<!-- BCrypt -->
<dependency>
    <groupId>org.mindrot</groupId>
    <artifactId>jbcrypt</artifactId>
    <version>0.4</version>
</dependency>
```

---

## 9. Running the Application

### Prerequisites:
1. Java JDK 11 or higher
2. Maven
3. MySQL Server (running on localhost:3306)
4. MySQL database `eventhub_db` created (run schema.sql)

### Commands:

```
bash
# Build the project
mvn clean package

# Run the application
mvn jetty:run
```

### Access URLs:
- Home: http://localhost:8080/
- User Login: http://localhost:8080/user-login.jsp
- User Signup: http://localhost:8080/user-signup.jsp
- OTP Verification: http://localhost:8080/verifyOtp.jsp

---

## 10. Key Code Patterns

### BCrypt Password Hashing:
```
java
// Hashing password during registration
String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

// Verifying password during login
if (BCrypt.checkpw(password, hashedPassword)) {
    // Password matches
}
```

### PreparedStatement Usage:
```
java
// Prevents SQL injection
String sql = "SELECT * FROM users WHERE email = ? AND is_verified = true";
PreparedStatement ps = con.prepareStatement(sql);
ps.setString(1, email);
ResultSet rs = ps.executeQuery();
```

### Session Management:
```
java
// Set session attributes
HttpSession session = request.getSession();
session.setAttribute("userId", rs.getInt("id"));
session.setAttribute("userName", rs.getString("name"));

// Invalidate session on logout
session.invalidate();
```

---

## 11. Potential Improvements

1. **Email Service**: Use a more robust email service (SendGrid, AWS SES)
2. **Database**: Add connection pooling (HikariCP)
3. **Validation**: Add more robust input validation
4. **Error Handling**: Implement global exception handling
5. **Logging**: Add proper logging framework (Log4j, SLF4J)
6. **Security**: Add CSRF protection, rate limiting
7. **Testing**: Add unit and integration tests

---

## 12. Troubleshooting

### Common Issues:

1. **Database Connection Failed**
   - Check MySQL is running
   - Verify credentials in DBConnection.java
   - Ensure database exists

2. **Email Not Sent**
   - Check Gmail app password is correct
   - Enable "Less secure app access" or use App Password
   - Check firewall blocking SMTP port 587

3. **OTP Expired**
   - OTP validity is 10 minutes
   - Use "Resend OTP" option

4. **Server Port Conflict**
   - Default port is 8080
   - Modify port in pom.xml if needed

---

## 13. Summary

This is a complete **User Registration and Email Verification System** built with:
- **Jakarta EE** for web components
- **MySQL** for data persistence
- **BCrypt** for secure password storage
- **JavaMail** for transactional emails
- **Maven** for build management
- **Jetty** as embedded server

The system demonstrates secure user authentication with email verification using time-limited OTPs.
