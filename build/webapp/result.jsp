<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String name      = (String) request.getAttribute("name");
    String studentId = (String) request.getAttribute("studentId");
    String program   = (String) request.getAttribute("program");
    String email      = (String) request.getAttribute("email");
    String hobbies   = (String) request.getAttribute("hobbies");
    String intro      = (String) request.getAttribute("intro");

    String initials = "";
    if (name != null && name.trim().length() > 0) {
        String[] parts = name.trim().split("\\s+");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
        initials = initials.toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= name %> - Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=3">
</head>
<body>
    <div class="profile-layout">
        <div class="profile-sidebar">
            <div class="avatar-large"><%= initials %></div>
            <h1><%= name %></h1>
            <p class="program-tag"><%= program %></p>
            <div class="contact-links">
                <a href="mailto:<%= email %>"><i class="fa-solid fa-envelope"></i> <%= email %></a>
            </div>
            <a href="index.html" class="nav-link"><i class="fa-solid fa-arrow-left"></i> Edit Profile</a>
        </div>
        <div class="profile-main">
            <div class="content-section">
                <h2>About</h2>
                <p class="bio-text"><%= intro == null ? "" : intro.replace("\n", "<br>") %></p>
            </div>
            <div class="details-grid">
                <div class="detail-card">
                    <span class="detail-label">Student ID</span>
                    <span class="detail-value"><%= studentId %></span>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Hobbies</span>
                    <span class="detail-value"><%= hobbies %></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
