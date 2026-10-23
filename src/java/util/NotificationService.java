
package util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ConcurrentHashMap;



/**
 * Service responsible for processing email notification logic
 * for important events in the SmartAgriDrying system.
 *
 * All emails are sent asynchronously through EmailUtil
 * so that email delivery does not delay server responses.
 *
 * Supported notifications:
 * - Rain detected
 * - High temperature
 * - Low temperature
 * - Device offline
 * - Drying batch completed
 * - Roof status changed
 * - Device mode changed
 *
 * @author SmartAgriDrying
 */
public class NotificationService {

    // Thread-safe date and time formatter
    private static final DateTimeFormatter DATE_TIME_FORMATTER
            = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    // =========================================
    // COOLDOWN: Prevent repeated email alerts
    // =========================================

    /**
     * Minimum interval between two alerts of the same type
     * for the same device.
     *
     * Default: 5 minutes.
     */
    private static volatile long cooldownMs = 5 * 60 * 1000L;

    /**
     * Stores the last sent time for each alert type and device.
     *
     * Example keys:
     * RAIN_D001
     * HIGH_TEMP_D001
     * LOW_TEMP_D001
     * OFFLINE_D001
     *
     * This allows each alert type and device to have
     * an independent cooldown period.
     */
    private static final ConcurrentHashMap<String, Long> lastAlertMap
            = new ConcurrentHashMap<>();

    /**
     * Changes the cooldown duration in seconds.
     *
     * This method is useful during testing.
     *
     * @param seconds cooldown duration in seconds
     */
    public static void setCooldownSeconds(int seconds) {
        cooldownMs = seconds * 1000L;
    }

    /**
     * Clears all stored cooldown timestamps.
     *
     * This method is useful when testing alerts repeatedly.
     */
    public static void resetCooldown() {
        lastAlertMap.clear();
    }

    /**
     * Returns the current date and time in the configured format.
     *
     * @return formatted current date and time
     */
    private static String getCurrentFormattedTime() {
        return LocalDateTime.now().format(DATE_TIME_FORMATTER);
    }

    /**
     * Checks whether an alert can be sent based on its cooldown
     * and records the current send time when allowed.
     *
     * @param alertType alert type such as RAIN, HIGH_TEMP,
     *                  LOW_TEMP, or OFFLINE
     * @param deviceId  device identifier
     * @return true if the alert can be sent; false if it is
     *         still within the cooldown period
     */
    private static boolean canSendAndMark(
            String alertType,
            String deviceId) {

        String key = alertType + "_"
                + (deviceId != null ? deviceId : "GLOBAL");

        long now = System.currentTimeMillis();
        Long lastSent = lastAlertMap.get(key);

        if (lastSent != null
                && (now - lastSent) < cooldownMs) {
            return false;
        }

        lastAlertMap.put(key, now);
        return true;
    }

    // =========================================
    // ALERT: Rain detected
    // =========================================

    /**
     * Sends an alert when rain is detected.
     *
     * @param deviceId    device identifier
     * @param temperature current temperature
     * @param humidity    current humidity
     * @param roofStatus  current roof status
     */
    public static void alertRainDetected(
            String deviceId,
            double temperature,
            double humidity,
            String roofStatus) {

        if (!canSendAndMark("RAIN", deviceId)) {
            return;
        }

        String subject
                = "⚠️ [SmartAgriDrying] ALERT: Rain Detected - "
                + deviceId;

        String body = buildAlertEmail(
                "RAIN DETECTED",
                "#e74c3c",
                "🌧️",
                deviceId,
                new String[][]{
                    {"Temperature", temperature + " °C"},
                    {"Humidity", humidity + " %"},
                    {"Roof Status", roofStatus},
                    {"Time", getCurrentFormattedTime()}
                },
                "Rain has been detected. Please check the roof "
                + "status and the active drying batches immediately."
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // ALERT: High temperature
    // =========================================

    /**
     * Sends an alert when temperature reaches or exceeds 40°C.
     *
     * @param deviceId    device identifier
     * @param temperature current temperature
     * @param humidity    current humidity
     */
    public static void alertHighTemperature(
            String deviceId,
            double temperature,
            double humidity) {

        if (!canSendAndMark("HIGH_TEMP", deviceId)) {
            return;
        }

        String subject
                = "🔥 [SmartAgriDrying] ALERT: High Temperature ("
                + temperature + "°C) - "
                + deviceId;

        String body = buildAlertEmail(
                "HIGH TEMPERATURE",
                "#e67e22",
                "🔥",
                deviceId,
                new String[][]{
                    {"Temperature", temperature + " °C"},
                    {"Humidity", humidity + " %"},
                    {"Warning Threshold", ">= 40 °C"},
                    {"Time", getCurrentFormattedTime()}
                },
                "The temperature has exceeded the configured "
                + "safety threshold. Please check the drying "
                + "environment to prevent product quality issues."
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // ALERT: Low temperature
    // =========================================

    /**
     * Sends an alert when temperature reaches or falls below 15°C.
     *
     * @param deviceId    device identifier
     * @param temperature current temperature
     * @param humidity    current humidity
     */
    public static void alertLowTemperature(
            String deviceId,
            double temperature,
            double humidity) {

        if (!canSendAndMark("LOW_TEMP", deviceId)) {
            return;
        }

        String subject
                = "❄️ [SmartAgriDrying] ALERT: Low Temperature ("
                + temperature + "°C) - "
                + deviceId;

        String body = buildAlertEmail(
                "LOW TEMPERATURE",
                "#3498db",
                "❄️",
                deviceId,
                new String[][]{
                    {"Temperature", temperature + " °C"},
                    {"Humidity", humidity + " %"},
                    {"Warning Threshold", "<= 15 °C"},
                    {"Time", getCurrentFormattedTime()}
                },
                "The temperature is below the configured threshold. "
                + "This condition may reduce drying efficiency."
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // ALERT: Device offline
    // =========================================

    /**
     * Sends an alert when an IoT device is detected as offline.
     *
     * This method must be called by server-side offline detection
     * logic because an offline ESP32-CAM cannot send its own
     * disconnection notification.
     *
     * @param deviceId      device identifier
     * @param warehouseName warehouse name
     */
    public static void alertDeviceOffline(
            String deviceId,
            String warehouseName) {

        if (!canSendAndMark("OFFLINE", deviceId)) {
            return;
        }

        String subject
                = "📡 [SmartAgriDrying] ALERT: Device Offline - "
                + deviceId;

        String body = buildAlertEmail(
                "DEVICE OFFLINE",
                "#95a5a6",
                "📡",
                deviceId,
                new String[][]{
                    {
                        "Warehouse",
                        warehouseName != null
                                ? warehouseName
                                : "N/A"
                    },
                    {"Device Status", "OFFLINE"},
                    {"Detected At", getCurrentFormattedTime()}
                },
                "The IoT device has stopped communicating with "
                + "the server. Please check the device power supply "
                + "and Wi-Fi connection."
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // NOTIFICATION: Drying batch completed
    // =========================================

    /**
     * Sends a notification when a drying batch is completed.
     *
     * @param batchId       drying batch identifier
     * @param productName   product name
     * @param weightKg      product weight in kilograms
     * @param warehouseName warehouse name
     * @param operatorName  operator who completed the batch
     */
    public static void notifyBatchCompleted(
            String batchId,
            String productName,
            double weightKg,
            String warehouseName,
            String operatorName) {

        String subject
                = "✅ [SmartAgriDrying] Drying Batch Completed - "
                + (productName != null
                        ? productName
                        : batchId);

        String body = buildNotificationEmail(
                "DRYING BATCH COMPLETED",
                "#27ae60",
                "✅",
                new String[][]{
                    {
                        "Batch ID",
                        batchId != null
                                ? batchId
                                : "N/A"
                    },
                    {
                        "Product",
                        productName != null
                                ? productName
                                : "N/A"
                    },
                    {"Weight", weightKg + " kg"},
                    {
                        "Warehouse",
                        warehouseName != null
                                ? warehouseName
                                : "N/A"
                    },
                    {
                        "Operator",
                        operatorName != null
                                ? operatorName
                                : "System"
                    },
                    {
                        "Completed At",
                        getCurrentFormattedTime()
                    }
                }
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // NOTIFICATION: Roof status changed
    // =========================================

    /**
     * Sends a notification when the roof status changes.
     *
     * @param deviceId  device identifier
     * @param newStatus new roof status (OPEN/CLOSED)
     * @param source    command source (AUTO/MANUAL/WEB)
     * @param actorName user who performed the action, if available
     */
    public static void notifyRoofChanged(
            String deviceId,
            String newStatus,
            String source,
            String actorName) {

        String emoji
                = "OPEN".equals(newStatus)
                        ? "☀️"
                        : "🏠";

        String statusText
                = "OPEN".equals(newStatus)
                        ? "OPEN"
                        : "CLOSED";

        String subject
                = emoji
                + " [SmartAgriDrying] Roof "
                + statusText
                + " - "
                + deviceId;

        String body = buildNotificationEmail(
                "ROOF STATUS CHANGED",
                "#8e44ad",
                emoji,
                new String[][]{
                    {"Device", deviceId},
                    {"Roof Status", statusText},
                    {
                        "Command Source",
                        source != null
                                ? source
                                : "N/A"
                    },
                    {
                        "Performed By",
                        actorName != null
                                ? actorName
                                : "Automatic System"
                    },
                    {"Time", getCurrentFormattedTime()}
                }
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // NOTIFICATION: Device mode changed
    // =========================================

    /**
     * Sends a notification when the operating mode changes
     * between AUTO and MANUAL.
     *
     * @param deviceId  device identifier
     * @param newMode   new operating mode
     * @param actorName user who performed the action
     */
    public static void notifyModeChanged(
            String deviceId,
            String newMode,
            String actorName) {

        String subject
                = "⚙️ [SmartAgriDrying] Operating Mode Changed: "
                + newMode
                + " - "
                + deviceId;

        String body = buildNotificationEmail(
                "OPERATING MODE CHANGED",
                "#2980b9",
                "⚙️",
                new String[][]{
                    {"Device", deviceId},
                    {"New Mode", newMode},
                    {
                        "Performed By",
                        actorName != null
                                ? actorName
                                : "N/A"
                    },
                    {"Time", getCurrentFormattedTime()}
                }
        );

        EmailUtil.sendEmailAsync(subject, body);
    }

    // =========================================
    // TEMPLATE: Alert email
    // =========================================

    /**
     * Builds an HTML email for warning and alert messages.
     *
     * @param title          alert title
     * @param accentColor    header accent color
     * @param emoji          alert icon
     * @param deviceId       device identifier
     * @param details        alert details
     * @param recommendation recommended action
     * @return generated HTML email content
     */
    private static String buildAlertEmail(
            String title,
            String accentColor,
            String emoji,
            String deviceId,
            String[][] details,
            String recommendation) {

        StringBuilder sb = new StringBuilder();

        sb.append("<!DOCTYPE html>");
        sb.append(
                "<html><head><meta charset='UTF-8'></head>"
        );

        sb.append(
                "<body style='margin:0;padding:0;"
                + "font-family:Arial,sans-serif;"
                + "background-color:#f4f4f4;'>"
        );

        // Main container
        sb.append(
                "<div style='max-width:600px;"
                + "margin:20px auto;"
                + "background:#ffffff;"
                + "border-radius:12px;"
                + "overflow:hidden;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.1);'>"
        );

        // Header
        sb.append(
                "<div style='background:"
        );

        sb.append(accentColor);

        sb.append(
                ";padding:24px;text-align:center;'>"
        );

        sb.append(
                "<h1 style='color:#ffffff;"
                + "margin:0;font-size:22px;'>"
        );

        sb.append(emoji)
                .append(" ")
                .append(title);

        sb.append("</h1>");

        sb.append(
                "<p style='color:rgba(255,255,255,0.9);"
                + "margin:8px 0 0;"
                + "font-size:14px;'>"
                + "SmartAgriDrying - Agricultural Drying "
                + "Monitoring System"
                + "</p>"
        );

        sb.append("</div>");

        // Email body
        sb.append(
                "<div style='padding:24px;'>"
        );

        // Device information
        if (deviceId != null) {
            sb.append(
                    "<p style='margin-top:0;"
                    + "font-size:14px;color:#555;'>"
                    + "<strong>Device:</strong> "
            );

            sb.append(deviceId);

            sb.append("</p>");
        }

        // Details table
        sb.append(
                "<table style='width:100%;"
                + "border-collapse:collapse;"
                + "margin-bottom:20px;'>"
        );

        for (String[] row : details) {

            sb.append("<tr>");

            sb.append(
                    "<td style='padding:10px 12px;"
                    + "border-bottom:1px solid #eee;"
                    + "font-weight:bold;"
                    + "color:#555;"
                    + "width:40%;'>"
            );

            sb.append(row[0]);

            sb.append("</td>");

            sb.append(
                    "<td style='padding:10px 12px;"
                    + "border-bottom:1px solid #eee;"
                    + "color:#333;'>"
            );

            sb.append(row[1]);

            sb.append("</td>");

            sb.append("</tr>");
        }

        sb.append("</table>");

        // Recommendation box
        if (recommendation != null
                && !recommendation.isEmpty()) {

            sb.append(
                    "<div style='background:#fff3cd;"
                    + "border-left:4px solid #ffc107;"
                    + "padding:12px 16px;"
                    + "border-radius:4px;"
                    + "margin-top:16px;'>"
            );

            sb.append(
                    "<strong>💡 Recommendation:</strong><br>"
            );

            sb.append(recommendation);

            sb.append("</div>");
        }

        sb.append("</div>");

        // Footer
        sb.append(
                "<div style='background:#f8f9fa;"
                + "padding:16px;"
                + "text-align:center;"
                + "font-size:12px;"
                + "color:#888;'>"
                + "This is an automated email from "
                + "SmartAgriDrying System.<br>"
                + "Please do not reply to this email."
                + "</div>"
        );

        sb.append("</div>");
        sb.append("</body></html>");

        return sb.toString();
    }

    // =========================================
    // TEMPLATE: General notification email
    // =========================================

    /**
     * Builds an HTML email for general system notifications.
     *
     * @param title       notification title
     * @param accentColor header accent color
     * @param emoji       notification icon
     * @param details     notification details
     * @return generated HTML email content
     */
    private static String buildNotificationEmail(
            String title,
            String accentColor,
            String emoji,
            String[][] details) {

        StringBuilder sb = new StringBuilder();

        sb.append("<!DOCTYPE html>");

        sb.append(
                "<html><head><meta charset='UTF-8'></head>"
        );

        sb.append(
                "<body style='margin:0;padding:0;"
                + "font-family:Arial,sans-serif;"
                + "background-color:#f4f4f4;'>"
        );

        // Main container
        sb.append(
                "<div style='max-width:600px;"
                + "margin:20px auto;"
                + "background:#ffffff;"
                + "border-radius:12px;"
                + "overflow:hidden;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.1);'>"
        );

        // Header
        sb.append(
                "<div style='background:"
        );

        sb.append(accentColor);

        sb.append(
                ";padding:24px;text-align:center;'>"
        );

        sb.append(
                "<h1 style='color:#ffffff;"
                + "margin:0;font-size:22px;'>"
        );

        sb.append(emoji)
                .append(" ")
                .append(title);

        sb.append("</h1>");

        sb.append(
                "<p style='color:rgba(255,255,255,0.9);"
                + "margin:8px 0 0;"
                + "font-size:14px;'>"
                + "SmartAgriDrying - System Notification"
                + "</p>"
        );

        sb.append("</div>");

        // Email body
        sb.append(
                "<div style='padding:24px;'>"
        );

        // Details table
        sb.append(
                "<table style='width:100%;"
                + "border-collapse:collapse;'>"
        );

        for (String[] row : details) {

            sb.append("<tr>");

            sb.append(
                    "<td style='padding:10px 12px;"
                    + "border-bottom:1px solid #eee;"
                    + "font-weight:bold;"
                    + "color:#555;"
                    + "width:40%;'>"
            );

            sb.append(row[0]);

            sb.append("</td>");

            sb.append(
                    "<td style='padding:10px 12px;"
                    + "border-bottom:1px solid #eee;"
                    + "color:#333;'>"
            );

            sb.append(row[1]);

            sb.append("</td>");

            sb.append("</tr>");
        }

        sb.append("</table>");
        sb.append("</div>");

        // Footer
        sb.append(
                "<div style='background:#f8f9fa;"
                + "padding:16px;"
                + "text-align:center;"
                + "font-size:12px;"
                + "color:#888;'>"
                + "This is an automated email from "
                + "SmartAgriDrying System.<br>"
                + "Please do not reply to this email."
                + "</div>"
        );

        sb.append("</div>");
        sb.append("</body></html>");

        return sb.toString();
    }
}
