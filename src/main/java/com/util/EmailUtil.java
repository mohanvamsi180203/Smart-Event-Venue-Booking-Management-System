package com.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    public static void sendOTP(String toEmail, String otp) throws Exception {

        final String fromEmail = "event.hub.webapp1@gmail.com";
        final String password = "xsdy xovs soxq ggpi"; // Gmail App Password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, password);
                    }
                });
 
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(toEmail));
        message.setSubject("Email Verification OTP - EventHub");

        // Create HTML email content
        String htmlContent = 
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; padding: 20px; }" +
            ".container { max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); overflow: hidden; }" +
            ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; }" +
            ".header h1 { margin: 0; font-size: 24px; }" +
            ".content { padding: 30px; text-align: center; }" +
            ".otp-box { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; font-size: 36px; font-weight: bold; padding: 15px 30px; border-radius: 8px; letter-spacing: 8px; margin: 20px 0; }" +
            ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px; }" +
            ".warning { color: #dc3545; font-size: 12px; margin-top: 15px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>EventHub</h1>" +
            "<p>Email Verification</p>" +
            "</div>" +
            "<div class='content'>" +
            "<h2>Verify Your Email Address</h2>" +
            "<p>Thank you for registering with EventHub. Please use the following OTP to verify your email address:</p>" +
            "<div class='otp-box'>" + otp + "</div>" +
            "<p>This OTP will expire in 10 minutes.</p>" +
            "<p class='warning'>If you didn't request this verification, please ignore this email.</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2024 EventHub. All rights reserved.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";

        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
    
    public static void sendRegistrationSuccess(String toEmail, String userName) throws Exception {

        final String fromEmail = "event.hub.webapp1@gmail.com";
        final String password = "xsdy xovs soxq ggpi"; // Gmail App Password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, password);
                    }
                });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(toEmail));
        message.setSubject("Registration Successful - Welcome to EventHub!");

        // Create HTML email content for registration success
        String htmlContent = 
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; padding: 20px; }" +
            ".container { max-width: 500px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); overflow: hidden; }" +
            ".header { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 30px; text-align: center; }" +
            ".header h1 { margin: 0; font-size: 24px; }" +
            ".content { padding: 30px; text-align: center; }" +
            ".icon { font-size: 60px; margin-bottom: 20px; }" +
            ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<div class='container'>" +
            "<div class='header'>" +
            "<h1>Registration Successful!</h1>" +
            "</div>" +
            "<div class='content'>" +
            "<div class='icon'>✅</div>" +
            "<h2>Welcome to EventHub, " + userName + "!</h2>" +
            "<p>Your account has been successfully verified.</p>" +
            "<p>You can now:</p>" +
            "<ul style='text-align: left; display: inline-block;'>" +
            "<li>Browse event venues</li>" +
            "<li>Book venues for your events</li>" +
            "<li>Manage your bookings</li>" +
            "<li>And much more!</li>" +
            "</ul>" +
            "<p style='margin-top: 20px;'>Start exploring events by logging into your account.</p>" +
            "<p style='color: #666; font-size: 12px; margin-top: 20px;'>If you have any questions, feel free to contact our support team.</p>" +
            "</div>" +
            "<div class='footer'>" +
            "<p>&copy; 2024 EventHub. All rights reserved.</p>" +
            "<p>This is an automated message. Please do not reply to this email.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";

        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
