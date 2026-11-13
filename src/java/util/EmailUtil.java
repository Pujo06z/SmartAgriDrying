/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/*
 * EmailUtil.java
 * Utility for sending emails via Gmail SMTP
 */
package util;

import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.mail.*;
import javax.mail.internet.*;



/**
 * Utility class to send notification emails via Gmail SMTP.
 * Uses App Password instead of regular password.
 *
 * Instructions to create an App Password:
 * 1. Go to https://myaccount.google.com/security
 * 2. Enable "2-Step Verification"
 * 3. Go to "App passwords" -> Create a new app password
 * 4. Copy the 16-character password and paste it into SMTP_PASSWORD
 *
 * @author SmartAgriDrying
 */
public class EmailUtil {

    // =========================================
    // GMAIL SMTP CONFIGURATION - CHANGE HERE
    // =========================================

    /**
     * Gmail address used for sending notifications.
     * (This email must have 2-Step Verification enabled and an App Password created)
     */
    private static final String DEFAULT_SMTP_USERNAME
            = "vothienphuc190806@gmail.com";

    /**
     * 16-character App Password from Google Account.
     * NOT the standard Gmail login password.
     */
    private static final String DEFAULT_SMTP_PASSWORD
            = "yuew qqkm fidp zqmr";

    /**
     * Recipient email address for notifications (admin email).
     */
    private static final String DEFAULT_RECIPIENT_EMAIL
            = "vothienphuc190806@gmail.com";

    /**
     * Display name of the sender.
     */
    private static final String SENDER_NAME
            = "SmartAgriDrying System";

    // =========================================
    // SMTP SETTINGS
    // =========================================
    private static final String SMTP_HOST
            = "smtp.gmail.com";

    private static final int SMTP_PORT
            = 465;

    /**
     * Shared thread pool for sending emails asynchronously.
     */
    private static final ExecutorService EMAIL_EXECUTOR
            = Executors.newFixedThreadPool(2, r -> {
                Thread t = new Thread(r, "EmailSender-Thread");
                t.setDaemon(true);
                return t;
            });

    /**
     * Retrieves SMTP Username from System Property, Environment Variable, or default value.
     */
    public static String getSmtpUsername() {
        String sys = System.getProperty("smartagri.smtp.user");
        if (sys != null && !sys.trim().isEmpty()) {
            return sys.trim();
        }
        String env = System.getenv("SMARTAGRI_SMTP_USER");
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        return DEFAULT_SMTP_USERNAME;
    }

    /**
     * Retrieves SMTP Password from System Property, Environment Variable, or default value.
     */
    public static String getSmtpPassword() {
        String sys = System.getProperty("smartagri.smtp.password");
        if (sys != null && !sys.trim().isEmpty()) {
            return sys.trim();
        }
        String env = System.getenv("SMARTAGRI_SMTP_PASSWORD");
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        return DEFAULT_SMTP_PASSWORD;
    }

    /**
     * Retrieves default recipient email from System Property, Environment Variable, or default value.
     */
    public static String getDefaultRecipient() {
        String sys = System.getProperty("smartagri.recipient.email");
        if (sys != null && !sys.trim().isEmpty()) {
            return sys.trim();
        }
        String env = System.getenv("SMARTAGRI_RECIPIENT_EMAIL");
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        return DEFAULT_RECIPIENT_EMAIL;
    }

    /**
     * Checks if actual Gmail SMTP settings have been configured.
     */
    public static boolean isConfigured() {
        String user = getSmtpUsername();
        String pass = getSmtpPassword();
        return user != null
                && !user.trim().isEmpty()
                && !user.contains("your-email")
                && pass != null
                && !pass.trim().isEmpty()
                && !pass.contains("xxxx");
    }

    /**
     * Sends email synchronously (blocks until completed) to the default recipient.
     *
     * @param subject  Email subject
     * @param htmlBody Email body content (HTML)
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendEmail(
            String subject,
            String htmlBody) {

        return sendEmail(
                getDefaultRecipient(),
                subject,
                htmlBody
        );
    }

    /**
     * Sends email synchronously to a specific address.
     *
     * @param toEmail  Recipient email address
     * @param subject  Email subject
     * @param htmlBody Email body content (HTML)
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendEmail(
            String toEmail,
            String subject,
            String htmlBody) {

        String username = getSmtpUsername();
        String password = getSmtpPassword();

        // If real App Password is not set -> Log simulation mode without throwing exception
        if (!isConfigured()) {
            System.out.println(
                    "[EmailUtil] [SIMULATION] Email triggered, but real SMTP is not configured."
            );
            System.out.println(
                    "[EmailUtil] [SIMULATION] To: " + toEmail
                    + " | Subject: " + subject
            );
            System.out.println(
                    "[EmailUtil] -> Please enter Gmail and a 16-character App Password in EmailUtil.java to send real emails."
            );
            return true;
        }

        try {
            Properties props = new Properties();

            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            // =====================================
            // OPTIMIZE DELIVERY SPEED (FAST DELIVERY)
            // =====================================
            // Send packet immediately without buffering (disable Nagle's algorithm)
            props.put("mail.smtp.tcpnodelay", "true");
            // Bypass login mechanism negotiation, login directly with LOGIN mechanism to save time
            props.put("mail.smtp.auth.mechanisms", "LOGIN PLAIN");
            props.put("mail.smtp.socketFactory.port", String.valueOf(SMTP_PORT));
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
            props.put("mail.smtp.sendpartial", "true");

            // Timeout settings (ms)
            props.put("mail.smtp.connectiontimeout", "5000");
            props.put("mail.smtp.timeout", "5000");
            props.put("mail.smtp.writetimeout", "5000");

            // =====================================
            // Create authenticated session
            // =====================================
            Session session = Session.getInstance(
                    props,
                    new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            }
            );

            // =====================================
            // Compose message
            // =====================================
            Message message = new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(
                            username,
                            SENDER_NAME,
                            "UTF-8"
                    )
            );

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject(subject);

            message.setContent(
                    htmlBody,
                    "text/html; charset=UTF-8"
            );

            // =====================================
            // Send & Measure Execution Time
            // =====================================
            long startTime = System.currentTimeMillis();
            Transport.send(message);
            long elapsed = System.currentTimeMillis() - startTime;

            System.out.println(
                    "[EmailUtil] Email sent OK in "
                    + elapsed + " ms (" + String.format("%.2f", elapsed / 1000.0) + "s) to: "
                    + toEmail
                    + " | Subject: "
                    + subject
            );

            return true;

        } catch (Exception e) {
            System.err.println(
                    "[EmailUtil] FAILED to send email to " + toEmail + ": "
                    + e.getMessage()
            );
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Sends email ASYNCHRONOUSLY (non-blocking).
     * Email will be sent in a separate Thread pool without slowing down ESP32 or user requests.
     *
     * @param subject  Email subject
     * @param htmlBody Email body content (HTML)
     */
    public static void sendEmailAsync(
            String subject,
            String htmlBody) {

        sendEmailAsync(
                getDefaultRecipient(),
                subject,
                htmlBody
        );
    }

    /**
     * Sends email ASYNCHRONOUSLY to a specific address.
     *
     * @param toEmail  Recipient email address
     * @param subject  Email subject
     * @param htmlBody Email body content (HTML)
     */
    public static void sendEmailAsync(
            String toEmail,
            String subject,
            String htmlBody) {

        EMAIL_EXECUTOR.submit(() -> {
            sendEmail(toEmail, subject, htmlBody);
        });
    }

//    /**
//     * Main method used for quick console testing.
//     */
//    public static void main(String[] args) {
//        System.out.println("=== EMAIL UTIL AND NOTIFICATION SERVICE TEST ===");
//        System.out.println("Real Gmail configuration status: " + (isConfigured() ? "CONFIGURED" : "NOT CONFIGURED (USING SIMULATION MODE)"));
//        System.out.println("Sender Email: " + getSmtpUsername());
//        System.out.println("Recipient Email: " + getDefaultRecipient());
//
//        System.out.println("\n--- TEST 1: Send direct email ---");
//        sendEmail("Test Email Title", "<h3>Test email content</h3><p>The system is operating normally.</p>");
//
//        System.out.println("\n--- TEST 2: Send alert via NotificationService ---");
//        NotificationService.alertRainDetected("DEV001", 28.5, 95.0, "CLOSED");
//
//        System.out.println("\n--- TEST 3: Check cooldown (immediate recall) ---");
//        NotificationService.alertRainDetected("DEV001", 29.0, 96.0, "CLOSED");
//
//        System.out.println("\n--- TEST 4: Different device DEV002 (unaffected by DEV001 cooldown) ---");
//        NotificationService.alertRainDetected("DEV002", 27.0, 92.0, "OPEN");
//
//        System.out.println("\n=== TEST COMPLETED ===");
//    }
}

