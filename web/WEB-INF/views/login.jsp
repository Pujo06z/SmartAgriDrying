<%--
    Document   : login.jsp
    Description: Smart Agricultural Drying System - Responsive Login Page
    Note       : Preserves /login POST endpoint and username/password field names.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Agricultural Drying System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
<div class="login-page">
    <!-- Full-screen decorative image; place the image under web/images/ -->
    <div class="hero-background-layer" aria-hidden="true">
        <img class="hero-background-img"
             src="${pageContext.request.contextPath}/images/drying-background.png"
             alt="">
        <div class="hero-gradient-overlay"></div>
        <div class="leaves-foreground-overlay"></div>
    </div>

    <header class="top-navbar">
        <div class="nav-brand">
            <span class="brand-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="#2d6a4f" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 4C10 4 5 9 5 16a4 4 0 0 0 4 4c7 0 12-5 11-16Z"/><path d="M4 21c3-6 7-9 13-12"/></svg>
            </span>
            <span class="brand-name">Smart Agricultural Drying System</span>
        </div>
        <div class="nav-values" aria-label="System values">
            <span>Efficient</span><span class="divider">|</span>
            <span>Smart</span><span class="divider">|</span>
            <span>Sustainable</span>
        </div>
    </header>

    <main class="login-stage-container">
        <div class="hero-content-split">
            <section class="form-column" aria-label="Sign in">
                <div class="hero-headlines">
                    <h1>Smart Agricultural <span class="highlight-green">Drying System</span></h1>
                    <p class="hero-subtitle">IoT-based monitoring and management for agricultural drying</p>
                </div>

                <div class="login-glass-card">
                    <div class="card-header">
                        <h2>Welcome Back</h2>
                        <p>Please log in to your account</p>
                    </div>

                    <%-- Server-rendered error; escaping avoids rendering untrusted HTML. --%>
                    <%
                        Object errorObj = request.getAttribute("error");
                        if (errorObj != null) {
                            String safeError = String.valueOf(errorObj)
                                .replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("\"", "&quot;")
                                .replace("'", "&#39;");
                    %>
                    <div class="login-error" role="alert">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 7v6M12 17h.01"/></svg>
                        <span><%= safeError %></span>
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <div class="input-container">
                                <span class="input-icon-left" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21v-2a8 8 0 0 1 16 0v2"/></svg>
                                </span>
                                <input id="username" type="text" name="username"
                                       placeholder="Username" autocomplete="username" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <div class="input-container">
                                <span class="input-icon-left" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="10" width="14" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>
                                </span>
                                <input id="password" type="password" name="password"
                                       placeholder="Password" autocomplete="current-password" required>
                                <button type="button" class="password-toggle-btn" id="togglePassword"
                                        aria-label="Show password" aria-pressed="false">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                        </div>
                        <button type="submit" class="btn-login-submit">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M10 17l5-5-5-5M15 12H3M13 3h5a3 3 0 0 1 3 3v12a3 3 0 0 1-3 3h-5"/></svg>
                            Login
                        </button>
                    </form>

                    <%-- Optional: only add demo accounts here if these credentials are actually enabled. --%>
                </div>
            </section>

            <aside class="interactive-stage" aria-label="Smart drying technology">
                <div class="sensor-pin pin-temp">
                    <span class="pin-icon-wrap" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 14.5V5a2 2 0 1 1 4 0v9.5a4 4 0 1 1-4 0Z"/></svg></span>
                    <span class="pin-info"><span class="pin-title">Temperature</span><span class="pin-sub">Sensor</span></span>
                </div>
                <div class="sensor-pin pin-humidity">
                    <span class="pin-icon-wrap" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2C8 8 5 11 5 15a7 7 0 0 0 14 0c0-4-3-7-7-13Z"/></svg></span>
                    <span class="pin-info"><span class="pin-title">Humidity</span><span class="pin-sub">Sensor</span></span>
                </div>
                <div class="sensor-pin pin-vent">
                    <span class="pin-icon-wrap" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="2"/><path d="M12 10V3c4-1 7 3 4 7M14 12h7c1 4-3 7-7 4M12 14v7c-4 1-7-3-4-7M10 12H3c-1-4 3-7 7-4"/></svg></span>
                    <span class="pin-info"><span class="pin-title">Ventilation</span><span class="pin-sub">Control</span></span>
                </div>
                <div class="sensor-pin pin-warehouse">
                    <span class="pin-icon-wrap" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 10 12 3l9 7v11H3V10Z"/><path d="M9 21v-8h6v8"/></svg></span>
                    <span class="pin-info"><span class="pin-title">Warehouse</span><span class="pin-sub">Storage</span></span>
                </div>
            </aside>
        </div>
    </main>

    <footer class="bottom-features-bar">
        <div class="features-container">
            <div class="feature-card-item">
                <span class="feature-card-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 4C10 4 5 9 5 16a4 4 0 0 0 4 4c7 0 12-5 11-16Z"/><path d="M4 21c3-6 7-9 13-12"/></svg></span>
                <div class="feature-text-block"><h3>Improve Drying Efficiency</h3><p>Real-time monitoring and control</p></div>
            </div>
            <div class="feature-card-item">
                <span class="feature-card-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 20V13h4v7M10 20V9h4v11M16 20V4h4v16"/></svg></span>
                <div class="feature-text-block"><h3>Ensure Product Quality</h3><p>Stable and optimized drying process</p></div>
            </div>
            <div class="feature-card-item">
                <span class="feature-card-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 2 8 4v6c0 5-3 8-8 10-5-2-8-5-8-10V6l8-4Z"/><path d="m8 12 3 3 5-6"/></svg></span>
                <div class="feature-text-block"><h3>Support Sustainable Agriculture</h3><p>Smart technology for a better future</p></div>
            </div>
        </div>
    </footer>
</div>
<script>
    (function () {
        const password = document.getElementById('password');
        const toggle = document.getElementById('togglePassword');
        if (!password || !toggle) return;
        toggle.addEventListener('click', function () {
            const show = password.type === 'password';
            password.type = show ? 'text' : 'password';
            toggle.setAttribute('aria-pressed', String(show));
            toggle.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
        });
    })();
</script>
</body>
</html>
