<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Multi-Event Booking Platform</title>

<link rel="stylesheet" href="css/styles.css">
<script src="js/slider.js" defer></script>
</head>

<body>

<!-- NAVBAR -->
<header class="navbar">
    <div class="nav-left">
        <h2 class="logo">EventHub</h2>
        <span class="location">📍 Select Location</span>
    </div>

    <div class="nav-center">
        <input type="text" placeholder="Search events, venues, cities">
    </div>

    <div class="nav-right">
        <a href="#">Login</a>
        <a href="#">Sign Up</a>
        <a href="#">My Tickets</a>
    </div>
</header>

<!-- CATEGORY BAR -->
<section class="categories">
    <div class="category">🎤 Concerts</div>
    <div class="category">🏟 Sports</div>
    <div class="category">🎬 Movies</div>
    <div class="category">🎓 Workshops</div>
    <div class="category">🌳 Outdoor</div>
    <div class="category">🏢 Conferences</div>
</section>

<!-- IMAGE SLIDER -->
<section class="slider">
    <img class="slide active" src="images/conference.jpg">
    <img class="slide" src="images/concert.jpg">
    <img class="slide" src="images/turf.jpg">
</section>

</body>
</html>