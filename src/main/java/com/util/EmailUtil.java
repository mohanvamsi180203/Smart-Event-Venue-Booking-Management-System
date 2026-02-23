package com.util;

import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Email Utility class for sending OTP emails
 * Uses Jakarta Mail API to send verification emails
 */
public class EmailUtil {
    
    // Email configuration - Update these with your SMTP server details
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USERNAME = "mvsv18k@gmail.com";  // Replace with your email
    private static final String SMTP_PASSWORD = "bypzugpwkpuvszqt";    // Replace with your app password
    
    /**
     * Send OTP email to user
     * @param recipientEmail User's email address
     * @param otp One-time password to send
     * @param userName User's name
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendOtpEmail(String recipientEmail, int otp, String userName) {
        // Set up mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        
        // Create session with authentication
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
        
        try {
            // Create message
            MimeMessage message = new MimeMessage(session);
            
            // Set sender
            message.setFrom(new InternetAddress(SMTP_USERNAME, "EventHub"));
            
            // Set recipient
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            
            // Set subject
            message.setSubject("EventHub - Email Verification OTP");
            
            // Set email content (HTML)
            String htmlContent = 
                "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }" +
                ".container { max-width: 500px; margin: 0 auto; background: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                ".header { text-align: center; margin-bottom: 20px; }" +
                ".logo { font-size: 28px; font-weight: bold; color: #4CAF50; }" +
                ".content { text-align: center; }" +
                ".otp-box { display: inline-block; background: #4CAF50; color: white; padding: 15px 30px; font-size: 32px; font-weight: bold; border-radius: 5px; margin: 20px 0; letter-spacing: 5px; }" +
                ".footer { text-align: center; margin-top: 20px; font-size: 12px; color: #888; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<div class='logo'>EventHub</div>" +
                "</div>" +
                "<div class='content'>" +
                "<h2>Hello " + userName + ",</h2>" +
                "<p>Thank you for registering with EventHub!</p>" +
                "<p>Your One-Time Password (OTP) for email verification is:</p>" +
                "<div class='otp-box'>" + otp + "</div>" +
                "<p>This OTP is valid for 10 minutes.</p>" +
                "<p>If you didn't request this, please ignore this email.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>&copy; 2026 EventHub. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
            
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            // Send message
            Transport.send(message);
            
            System.out.println("OTP email sent successfully to: " + recipientEmail);
            return true;
            
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            System.err.println("Failed to send OTP email to: " + recipientEmail);
            return false;
        }
    }

    /**
     * Send welcome email after verification
     * @param recipientEmail User's email address
     * @param userName User's name
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendWelcomeEmail(String recipientEmail, String userName) {
        // Set up mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        
        // Create session with authentication
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
        
        try {
            // Create message
            MimeMessage message = new MimeMessage(session);
            
            // Set sender
            message.setFrom(new InternetAddress(SMTP_USERNAME, "EventHub"));
            
            // Set recipient
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            
            // Set subject
            message.setSubject("Welcome to EventHub - Email Verified Successfully!");
            
            // Set email content (HTML)
            String htmlContent = 
                "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }" +
                ".container { max-width: 500px; margin: 0 auto; background: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                ".header { text-align: center; margin-bottom: 20px; }" +
                ".logo { font-size: 28px; font-weight: bold; color: #4CAF50; }" +
                ".content { text-align: center; }" +
                ".success-icon { font-size: 50px; color: #4CAF50; }" +
                ".footer { text-align: center; margin-top: 20px; font-size: 12px; color: #888; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<div class='logo'>EventHub</div>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='success-icon'>&#10004;</div>" +
                "<h2>Welcome " + userName + "!</h2>" +
                "<p>Your email has been verified successfully.</p>" +
                "<p>You can now explore and book amazing events and venues!</p>" +
                "<p>Start your journey with EventHub today.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>&copy; 2026 EventHub. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
            
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            // Send message
            Transport.send(message);
            
            System.out.println("Welcome email sent successfully to: " + recipientEmail);
            return true;
            
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            System.err.println("Failed to send welcome email to: " + recipientEmail);
            return false;
        }
    }
}
