package com.ems.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Utility class for sending HTML emails via Gmail SMTP.
 */
public class EmailUtil {

    // Gmail SMTP Configuration
    private static final String HOST = "smtp.gmail.com";
    private static final int PORT = 587;

    // CHANGE THESE VALUES
    private static final String FROM_EMAIL = "yourgmail@gmail.com";
    private static final String APP_PASS = "your16digitapppassword";

    /**
     * Generic email sender
     */
    public static void sendEmail(String toEmail,
                                 String subject,
                                 String htmlBody) {

        Properties props = new Properties();

        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", String.valueOf(PORT));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", HOST);

        Session session = Session.getInstance(props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(FROM_EMAIL, APP_PASS);
                    }
                });

        try {

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(FROM_EMAIL));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject(subject);

            message.setContent(
                    htmlBody,
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);

            System.out.println("Email sent successfully to: " + toEmail);

        } catch (Exception e) {

            System.err.println(
                    "Email sending failed: " + e.getMessage()
            );

            e.printStackTrace();
        }
    }

    /**
     * Welcome Email
     */
    public static void sendWelcomeEmail(
            String toEmail,
            String firstName,
            String department,
            String designation) {

        String subject =
                "Welcome to Employee Management System";

        String body =
                "<html>"
              + "<body style='font-family:Segoe UI,sans-serif;'>"

              + "<div style='max-width:600px;"
              + "margin:auto;"
              + "padding:25px;"
              + "background:#f8f9fa;"
              + "border-radius:10px;'>"

              + "<h2 style='color:#185FA5;'>"
              + "Welcome " + firstName + "!"
              + "</h2>"

              + "<p>"
              + "Your employee profile has been successfully created."
              + "</p>"

              + "<table border='0' cellpadding='8'>"

              + "<tr>"
              + "<td><b>Department:</b></td>"
              + "<td>" + department + "</td>"
              + "</tr>"

              + "<tr>"
              + "<td><b>Designation:</b></td>"
              + "<td>" + designation + "</td>"
              + "</tr>"

              + "</table>"

              + "<p>"
              + "Please contact HR for login credentials."
              + "</p>"

              + "<hr>"

              + "<small>"
              + "Employee Management System"
              + "</small>"

              + "</div>"
              + "</body>"
              + "</html>";

        sendEmail(toEmail, subject, body);
    }

    /**
     * Profile Updated Email
     */
    public static void sendUpdateEmail(
            String toEmail,
            String firstName,
            String department,
            String designation) {

        String subject =
                "Employee Profile Updated";

        String body =
                "<html>"
              + "<body style='font-family:Segoe UI,sans-serif;'>"

              + "<div style='max-width:600px;"
              + "margin:auto;"
              + "padding:25px;"
              + "background:#f8f9fa;"
              + "border-radius:10px;'>"

              + "<h2 style='color:#185FA5;'>"
              + "Hello " + firstName
              + "</h2>"

              + "<p>"
              + "Your employee profile has been updated."
              + "</p>"

              + "<table border='0' cellpadding='8'>"

              + "<tr>"
              + "<td><b>Department:</b></td>"
              + "<td>" + department + "</td>"
              + "</tr>"

              + "<tr>"
              + "<td><b>Designation:</b></td>"
              + "<td>" + designation + "</td>"
              + "</tr>"

              + "</table>"

              + "<p>"
              + "If you did not expect this change, contact HR."
              + "</p>"

              + "<hr>"

              + "<small>"
              + "Employee Management System"
              + "</small>"

              + "</div>"
              + "</body>"
              + "</html>";

        sendEmail(toEmail, subject, body);
    }

    /**
     * Test Email
     */
    public static void main(String[] args) {

        sendEmail(
                "yourgmail@gmail.com",
                "EMS Test Email",
                "<h2>Email Service Working Successfully!</h2>"
        );

        System.out.println("Test email triggered.");
    }
}