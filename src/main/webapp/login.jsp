<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EMS — Login</title>
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --primary:      #185FA5;
      --primary-dark: #0C447C;
      --accent:       #1D9E75;
      --danger:       #E24B4A;
      --bg-page:      #0f1623;
      --bg-card:      #1a2235;
      --bg-input:     rgba(255,255,255,0.05);
      --border:       rgba(255,255,255,0.08);
      --text-main:    #e8edf5;
      --text-muted:   #8a9ab5;
      --font:         'Segoe UI', system-ui, sans-serif;
    }

    body {
      font-family: var(--font);
      background: var(--bg-page);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      position: relative;
    }

    /* ── Animated background shapes ─────────────────────── */
    .bg-shapes { position: fixed; inset: 0; pointer-events: none; z-index: 0; }
    .shape {
      position: absolute;
      border-radius: 50%;
      filter: blur(80px);
      opacity: 0.18;
    }
    .shape-1 {
      width: 520px; height: 520px;
      background: #185FA5;
      top: -180px; left: -180px;
      animation: drift 9s ease-in-out infinite;
    }
    .shape-2 {
      width: 380px; height: 380px;
      background: #1D9E75;
      bottom: -120px; right: -80px;
      animation: drift 11s ease-in-out infinite reverse;
    }
    .shape-3 {
      width: 220px; height: 220px;
      background: #7F77DD;
      top: 45%; right: 28%;
      animation: drift 7s ease-in-out infinite 1.5s;
    }
    @keyframes drift {
      0%, 100% { transform: translate(0, 0) rotate(0deg); }
      33%       { transform: translate(20px, -25px) rotate(4deg); }
      66%       { transform: translate(-15px, 15px) rotate(-3deg); }
    }

    /* ── Outer wrapper ───────────────────────────────────── */
    .login-wrapper {
      position: relative; z-index: 1;
      display: flex;
      width: min(980px, 94vw);
      min-height: 520px;
      border-radius: 20px;
      overflow: hidden;
      border: 1px solid var(--border);
      box-shadow: 0 32px 80px rgba(0, 0, 0, 0.55);
      animation: fadeUp 0.5s ease both;
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Left: brand panel ───────────────────────────────── */
    .login-brand {
    flex: 1.1;
    background: linear-gradient(
        150deg,
        #1b6dbf 0%,
        #0C447C 55%,
        #081830 100%
    );

    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 3rem;
	}
    .brand-top {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 2rem;
	}
    .brand-icon {
    width: 90px;
    height: 90px;
    border-radius: 22px;
    background: rgba(255,255,255,0.12);

    display: flex;
    align-items: center;
    justify-content: center;

    color: white;
    font-size: 36px;

    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
	}
    .login-brand h1 {
    font-size: 3.2rem;
    font-weight: 700;
    line-height: 1.1;
    letter-spacing: -0.03em;
    color: white;
	}

	.login-brand h1 span {
    color: #5DCAA5;
	}
    
    .login-brand .tagline {
      color: rgba(255,255,255,0.55);
      font-size: 13.5px; line-height: 1.65;
      max-width: 240px;
    }
    .brand-features { display: flex; flex-direction: column; gap: 12px; }
    .feat {
      display: flex; align-items: center; gap: 10px;
      color: rgba(255,255,255,0.75); font-size: 13px;
    }
    .feat-dot {
      width: 28px; height: 28px; border-radius: 8px;
      background: rgba(255,255,255,0.1);
      display: flex; align-items: center; justify-content: center;
      font-size: 13px; color: #5DCAA5; flex-shrink: 0;
    }
    .brand-footer {
      font-size: 11px;
      color: rgba(255,255,255,0.25);
      margin-top: 2rem;
    }

    /* ── Right: form card ────────────────────────────────── */
    .login-card {
      flex: 1;
      background: var(--bg-card);
      padding: 3.5rem;
      display: flex;
      flex-direction: column;
      justify-content: center;
      gap: 1.6rem;
    }

    .card-header h2 {
      font-size: 1.5rem; font-weight: 700;
      color: var(--text-main); letter-spacing: -0.01em;
    }
    .card-header p {
      font-size: 13.5px; color: var(--text-muted); margin-top: 5px;
    }

    /* Error alert */
    .alert-error {
      display: flex; align-items: center; gap: 10px;
      background: rgba(226,75,74,0.1);
      border: 1px solid rgba(226,75,74,0.3);
      color: #f08585;
      padding: 10px 14px;
      border-radius: 10px;
      font-size: 13px;
    }

    /* Form */
    .login-form { display: flex; flex-direction: column; gap: 1.2rem; }

    .form-group { display: flex; flex-direction: column; gap: 7px; }
    .form-group label {
      font-size: 12.5px; font-weight: 500;
      color: var(--text-muted); letter-spacing: 0.03em;
    }

    .input-wrap { position: relative; }
    .input-icon {
      position: absolute; left: 14px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted); font-size: 14px;
      pointer-events: none;
      transition: color 0.2s;
    }
    .input-wrap input {
      width: 100%;
      background: var(--bg-input);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 13px 44px;
      color: var(--text-main);
      font-size: 14px;
      font-family: var(--font);
      outline: none;
      transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
    }
    .input-wrap input::placeholder { color: rgba(138,154,181,0.6); }
    .input-wrap input:focus {
      border-color: var(--primary);
      background: rgba(24,95,165,0.08);
      box-shadow: 0 0 0 3px rgba(24,95,165,0.15);
    }
    .input-wrap input:focus + .input-icon,
    .input-wrap:focus-within .input-icon { color: #5B9BD5; }

    .toggle-pw {
      position: absolute; right: 13px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted); cursor: pointer;
      font-size: 14px; padding: 4px;
      transition: color 0.2s;
    }
    .toggle-pw:hover { color: var(--text-main); }

    /* Submit */
    .btn-login {
      width: 100%; padding: 13px;
      background: var(--primary);
      color: #fff;
      font-size: 15px; font-weight: 600;
      font-family: var(--font);
      border: none; border-radius: 10px;
      cursor: pointer;
      display: flex; align-items: center;
      justify-content: center; gap: 8px;
      letter-spacing: 0.01em;
      transition: background 0.2s, transform 0.1s, box-shadow 0.2s;
      margin-top: 0.25rem;
    }
    .btn-login:hover {
      background: var(--primary-dark);
      box-shadow: 0 4px 20px rgba(24,95,165,0.4);
    }
    .btn-login:active { transform: scale(0.98); }

    /* Divider */
    .divider {
      display: flex; align-items: center; gap: 10px;
      color: var(--text-muted); font-size: 12px;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1;
      border-top: 1px solid var(--border);
    }

    /* Hint credentials */
    .cred-hint {
      background: rgba(255,255,255,0.03);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 10px 14px;
      display: flex; flex-direction: column; gap: 5px;
    }
    .cred-row {
      display: flex; justify-content: space-between;
      font-size: 12px;
    }
    .cred-row .cred-label { color: var(--text-muted); }
    .cred-row .cred-val {
      font-family: 'Courier New', monospace;
      color: var(--accent); font-size: 11.5px;
    }
    .cred-title {
      font-size: 11px; color: var(--text-muted);
      text-transform: uppercase; letter-spacing: 0.05em;
      margin-bottom: 2px;
    }

    /* Responsive */
    @media (max-width: 600px) {
      .login-brand { display: none; }
      .login-card  { padding: 2rem 1.5rem; border-radius: 20px; }
      .login-wrapper { border-radius: 20px; min-height: unset; }
    }
  </style>
</head>
<body>

  <!-- Animated background -->
  <div class="bg-shapes" aria-hidden="true">
    <div class="shape shape-1"></div>
    <div class="shape shape-2"></div>
    <div class="shape shape-3"></div>
  </div>

  <div class="login-wrapper">

    <!-- ── Left: branding ─────────────────────────────────── -->
    <div class="login-brand">
      <div class="brand-top">
        <div class="brand-icon">
          <i class="fas fa-building" aria-hidden="true"></i>
        </div>
        <div>
          <h1>EMS Portal</h1>
          <p class="tagline">
            Employee Management System
          </p>
        </div>
        
      </div>
      
    </div>

    <!-- ── Right: login form ──────────────────────────────── -->
    <div class="login-card">

      <div class="card-header">
        <h2>Welcome back</h2>
        <p>Sign in to continue to your dashboard</p>
      </div>

      <%-- Show error message if login failed --%>
      <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
      %>
        <div class="alert-error" role="alert">
          <i class="fas fa-exclamation-circle" aria-hidden="true"></i>
          <%= error %>
        </div>
      <% } %>

      <form action="<%= request.getContextPath() %>/login"
            method="post" class="login-form" autocomplete="off" novalidate>

        <!-- Username -->
        <div class="form-group">
          <label for="username">Username</label>
          <div class="input-wrap">
            <input
              type="text"
              id="username"
              name="username"
              placeholder="Enter your username"
              value="<%=
                request.getParameter("username") != null
                  ? request.getParameter("username") : ""
              %>"
              required
              autofocus
            >
            <i class="fas fa-user input-icon" aria-hidden="true"></i>
          </div>
        </div>

        <!-- Password -->
        <div class="form-group">
          <label for="password">Password</label>
          <div class="input-wrap">
            <input
              type="password"
              id="password"
              name="password"
              placeholder="Enter your password"
              required
            >
            <i class="fas fa-lock input-icon" aria-hidden="true"></i>
            <span class="toggle-pw"
                  onclick="togglePassword()"
                  title="Show / hide password"
                  aria-label="Toggle password visibility">
              <i class="fas fa-eye" id="pw-icon" aria-hidden="true"></i>
            </span>
          </div>
        </div>

        <!-- Submit -->
        <button type="submit" class="btn-login">
          Sign In &nbsp;<i class="fas fa-arrow-right" aria-hidden="true"></i>
        </button>

      </form>

     

    </div>
  </div>

  <script>
    function togglePassword() {
      const input = document.getElementById('password');
      const icon  = document.getElementById('pw-icon');
      const show  = input.type === 'password';
      input.type      = show ? 'text'      : 'password';
      icon.className  = show ? 'fas fa-eye-slash' : 'fas fa-eye';
    }

    // Auto-fill username on credential hint click
    document.querySelectorAll('.cred-row').forEach(row => {
      row.style.cursor = 'pointer';
      row.addEventListener('click', () => {
        const val = row.querySelector('.cred-val').textContent.trim().split(' / ');
        document.getElementById('username').value = val[0];
        document.getElementById('password').value = val[1];
      });
    });
  </script>

</body>
</html>