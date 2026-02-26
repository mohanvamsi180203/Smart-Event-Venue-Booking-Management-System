<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description"
            content="EventHub - Your premier multi-event booking platform. Discover and book concerts, sports, conferences, and more at premium venues.">
        <title>EventHub | Discover & Book Amazing Events</title>

        <link rel="stylesheet" href="css/styles.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>

    <body>

        <header class="navbar" id="navbar">
            <div class="nav-left">
                <h1 class="logo">EventHub</h1>
                <span class="location" id="location-select">📍 Select Location</span>
            </div>

            <div class="nav-center">
                <span class="search-icon">🔍</span>
                <input type="text" id="search-input" placeholder="Search events, venues, cities..." autocomplete="off">
            </div>

            <div class="nav-right">
                <a href="#" class="btn-outline" id="nav-tickets">🎫 My Tickets</a>
                <%
                    // Check if user is logged in
                    Integer loggedInUserId = (Integer) session.getAttribute("userId");
                    String loggedInUserName = (String) session.getAttribute("userName");
                    
                    if (loggedInUserId != null) {
                %>
                    <!-- User is logged in - show profile dropdown -->
                    <div class="user-profile-dropdown">
                        <button class="profile-btn" id="nav-profile" onclick="toggleDropdown()">
                            <span class="profile-avatar-small">👤</span>
                            <span class="profile-name-small"><%= loggedInUserName %></span>
                            <span class="dropdown-arrow">▼</span>
                        </button>
                        <div class="dropdown-menu" id="dropdown-menu">
                            <a href="<%= request.getContextPath() %>/ProfileServlet" class="dropdown-item">
                                <span>👤</span> My Profile
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>🎫</span> My Tickets
                            </a>
                            <a href="#" class="dropdown-item">
                                <span>⚙️</span> Settings
                            </a>
                            <div class="dropdown-divider"></div>
                            <a href="<%= request.getContextPath() %>/ProfileServlet?action=logout" class="dropdown-item logout">
                                <span>🚪</span> Logout
                            </a>
                        </div>
                    </div>
                <%
                    } else {
                %>
                    <!-- User is not logged in - show login and signup buttons -->
                    <a href="user-login.jsp" id="nav-login">Login</a>
                    <a href="user-signup.jsp" class="btn-primary" id="nav-signup">Sign Up</a>
                <%
                    }
                %>
            </div>
        </header>

       
        <section class="hero" id="hero">
            <div class="hero-slider">
                <img class="slide active" src="images/concert.jpg" alt="Live Concert Event">
                <img class="slide" src="images/conference.jpg" alt="Professional Conference">
                <img class="slide" src="images/turf.jpg" alt="Sports Turf Venue">
            </div>
            <div class="hero-overlay"></div>

            <div class="hero-content">
                <div class="hero-badge">
                    <span class="pulse-dot"></span>
                    Live Events Near You
                </div>

                <h2 class="hero-title">
                    Discover <span class="gradient-text">Extraordinary</span> Events & Venues
                </h2>

                <p class="hero-description">
                    Find and book the perfect venue for concerts, conferences, sports, and celebrations.
                    One platform, unlimited possibilities.
                </p>

                <div class="hero-actions">
                    <a href="#featured-events" class="btn btn-hero-primary" id="btn-explore">
                        🚀 Explore Events
                    </a>
                    <a href="#how-it-works" class="btn btn-hero-secondary" id="btn-how">
                        ▶ How It Works
                    </a>
                </div>

                <div class="hero-stats">
                    <div class="hero-stat">
                        <div class="stat-number" id="stat-events">500+</div>
                        <div class="stat-label">Live Events</div>
                    </div>
                    <div class="hero-stat">
                        <div class="stat-number" id="stat-venues">200+</div>
                        <div class="stat-label">Premium Venues</div>
                    </div>
                    <div class="hero-stat">
                        <div class="stat-number" id="stat-users">50K+</div>
                        <div class="stat-label">Happy Users</div>
                    </div>
                </div>
            </div>

           
            <div class="slider-dots" id="slider-dots">
                <span class="slider-dot active" data-index="0"></span>
                <span class="slider-dot" data-index="1"></span>
                <span class="slider-dot" data-index="2"></span>
            </div>

            <!-- Scroll Indicator -->
            <div class="scroll-indicator">
                <div class="scroll-mouse"></div>
                <span>Scroll</span>
            </div>
        </section>

       
        <section class="categories" id="categories">
            <div class="category reveal" id="cat-concerts">
                <span class="cat-icon">🎪</span>
                <span class="cat-label">Events</span>
            </div>
            <div class="category reveal" id="cat-concerts">
                <span class="cat-icon">🎤</span>
                <span class="cat-label">Concerts</span>
            </div>
            <div class="category reveal reveal-delay-1" id="cat-sports">
                <span class="cat-icon">🏟️</span>
                <span class="cat-label">Sports</span>
            </div>
            <div class="category reveal reveal-delay-2" id="cat-movies">
                <span class="cat-icon">🎬</span>
                <span class="cat-label">Movies</span>
            </div>
            <div class="category reveal reveal-delay-3" id="cat-workshops">
                <span class="cat-icon">🎓</span>
                <span class="cat-label">Workshops</span>
            </div>
            <div class="category reveal reveal-delay-4" id="cat-conferences">
                <span class="cat-icon">🏢</span>
                <span class="cat-label">Conferences</span>
            </div>
        </section>

       
        <section class="featured-events" id="featured-events">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-badge">🔥 Trending Now</span>
                    <h2 class="section-title">Featured Events</h2>
                    <p class="section-subtitle">
                        Handpicked experiences curated just for you. Grab your tickets before they sell out!
                    </p>
                </div>

                <div class="events-grid">
                    <!-- Event Card 1 -->
                    <div class="event-card reveal" id="event-1">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=600&q=80"
                                alt="Live Music Concert">
                            <div class="event-date">
                                <span class="date-day">15</span>
                                <span class="date-month">Mar</span>
                            </div>
                            <span class="event-tag">Trending</span>
                        </div>
                        <div class="event-card-body">
                            <h3>Sonic Waves Live Concert</h3>
                            <div class="event-meta">
                                <span>📍 Grand Arena, Mumbai</span>
                                <span>🕐 7:00 PM - 11:00 PM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">₹1,499 <small>onwards</small></span>
                                <button class="btn-book" id="book-event-1">Book Now →</button>
                            </div>
                        </div>
                    </div>

                    
                    <div class="event-card reveal reveal-delay-1" id="event-2">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=600&q=80"
                                alt="Tech Conference">
                            <div class="event-date">
                                <span class="date-day">22</span>
                                <span class="date-month">Mar</span>
                            </div>
                            <span class="event-tag">Featured</span>
                        </div>
                        <div class="event-card-body">
                            <h3>TechSummit 2026</h3>
                            <div class="event-meta">
                                <span>📍 Convention Center, Bengaluru</span>
                                <span>🕐 9:00 AM - 6:00 PM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">₹2,999 <small>onwards</small></span>
                                <button class="btn-book" id="book-event-2">Book Now →</button>
                            </div>
                        </div>
                    </div>

                  
                    <div class="event-card reveal reveal-delay-2" id="event-3">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1431540015160-0bd15f3b58af?w=600&q=80"
                                alt="Sports Championship">
                            <div class="event-date">
                                <span class="date-day">01</span>
                                <span class="date-month">Apr</span>
                            </div>
                            <span class="event-tag">Hot 🔥</span>
                        </div>
                        <div class="event-card-body">
                            <h3>National Cricket Championship</h3>
                            <div class="event-meta">
                                <span>📍 Sports Complex, Hyderabad</span>
                                <span>🕐 2:00 PM - 9:00 PM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">₹799 <small>onwards</small></span>
                                <button class="btn-book" id="book-event-3">Book Now →</button>
                            </div>
                        </div>
                    </div>

                    
                    <div class="event-card reveal" id="event-4">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600&q=80"
                                alt="Festival Night">
                            <div class="event-date">
                                <span class="date-day">10</span>
                                <span class="date-month">Apr</span>
                            </div>
                            <span class="event-tag">New</span>
                        </div>
                        <div class="event-card-body">
                            <h3>Midnight Festival of Lights</h3>
                            <div class="event-meta">
                                <span>📍 Lake Gardens, Delhi</span>
                                <span>🕐 8:00 PM - 2:00 AM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">₹599 <small>onwards</small></span>
                                <button class="btn-book" id="book-event-4">Book Now →</button>
                            </div>
                        </div>
                    </div>

                   
                    <div class="event-card reveal reveal-delay-1" id="event-5">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=600&q=80"
                                alt="Comedy Night">
                            <div class="event-date">
                                <span class="date-day">18</span>
                                <span class="date-month">Apr</span>
                            </div>
                            <span class="event-tag">Limited</span>
                        </div>
                        <div class="event-card-body">
                            <h3>Stand-Up Comedy Night</h3>
                            <div class="event-meta">
                                <span>📍 Laugh Factory, Pune</span>
                                <span>🕐 8:30 PM - 10:30 PM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">₹499 <small>onwards</small></span>
                                <button class="btn-book" id="book-event-5">Book Now →</button>
                            </div>
                        </div>
                    </div>

                 
                    <div class="event-card reveal reveal-delay-2" id="event-6">
                        <div class="event-card-image">
                            <img src="https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=600&q=80"
                                alt="Wedding Gala">
                            <div class="event-date">
                                <span class="date-day">25</span>
                                <span class="date-month">Apr</span>
                            </div>
                            <span class="event-tag">Premium</span>
                        </div>
                        <div class="event-card-body">
                            <h3>Grand Wedding Expo 2026</h3>
                            <div class="event-meta">
                                <span>📍 Palace Grounds, Chennai</span>
                                <span>🕐 10:00 AM - 8:00 PM</span>
                            </div>
                            <div class="event-card-footer">
                                <span class="event-price">Free <small>entry</small></span>
                                <button class="btn-book" id="book-event-6">Register →</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

     
        <section class="how-it-works" id="how-it-works">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-badge">✨ Simple & Easy</span>
                    <h2 class="section-title">How It Works</h2>
                    <p class="section-subtitle">
                        Book your next unforgettable experience in just four simple steps.
                    </p>
                </div>

                <div class="steps-grid">
                    <div class="step-card reveal" id="step-1">
                        <div class="step-icon">
                            🔍
                            <span class="step-number">1</span>
                        </div>
                        <h3>Discover Events</h3>
                        <p>Browse hundreds of events and venues near you with our smart search.</p>
                    </div>
                    <div class="step-card reveal reveal-delay-1" id="step-2">
                        <div class="step-icon">
                            📅
                            <span class="step-number">2</span>
                        </div>
                        <h3>Pick Your Date</h3>
                        <p>Choose a date and time that works best for your schedule.</p>
                    </div>
                    <div class="step-card reveal reveal-delay-2" id="step-3">
                        <div class="step-icon">
                            💳
                            <span class="step-number">3</span>
                        </div>
                        <h3>Secure Booking</h3>
                        <p>Complete your booking with our safe and instant payment system.</p>
                    </div>
                    <div class="step-card reveal reveal-delay-3" id="step-4">
                        <div class="step-icon">
                            🎉
                            <span class="step-number">4</span>
                        </div>
                        <h3>Enjoy the Event</h3>
                        <p>Show your e-ticket, walk in, and create unforgettable memories!</p>
                    </div>
                </div>
            </div>
        </section>

      
        <section class="venues-section" id="venues">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-badge">🏛️ Top Picks</span>
                    <h2 class="section-title">Premium Venues</h2>
                    <p class="section-subtitle">
                        Explore our handpicked collection of world-class venues for every occasion.
                    </p>
                </div>

                <div class="venues-grid">
                    <div class="venue-card reveal" id="venue-1">
                        <img src="images/concert.jpg" alt="Grand Concert Arena">
                        <div class="venue-card-overlay">
                            <h3>Grand Concert Arena</h3>
                            <div class="venue-info">
                                <span>📍 Mumbai</span>
                                <span>👥 10,000 capacity</span>
                                <span>⭐ 4.9</span>
                            </div>
                            <button class="venue-explore-btn" id="explore-venue-1">Explore Venue →</button>
                        </div>
                    </div>

                    <div class="venue-card reveal reveal-delay-1" id="venue-2">
                        <img src="images/conference.jpg" alt="Elite Conference Center">
                        <div class="venue-card-overlay">
                            <h3>Elite Conference Center</h3>
                            <div class="venue-info">
                                <span>📍 Bengaluru</span>
                                <span>👥 2,500 capacity</span>
                                <span>⭐ 4.8</span>
                            </div>
                            <button class="venue-explore-btn" id="explore-venue-2">Explore Venue →</button>
                        </div>
                    </div>

                    <div class="venue-card reveal" id="venue-3">
                        <img src="images/turf.jpg" alt="Premium Sports Complex">
                        <div class="venue-card-overlay">
                            <h3>Premium Sports Complex</h3>
                            <div class="venue-info">
                                <span>📍 Hyderabad</span>
                                <span>👥 5,000 capacity</span>
                                <span>⭐ 4.7</span>
                            </div>
                            <button class="venue-explore-btn" id="explore-venue-3">Explore Venue →</button>
                        </div>
                    </div>

                    <div class="venue-card reveal reveal-delay-1" id="venue-4">
                        <img src="https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800&q=80"
                            alt="Luxury Banquet Hall">
                        <div class="venue-card-overlay">
                            <h3>Luxury Banquet Hall</h3>
                            <div class="venue-info">
                                <span>📍 Delhi</span>
                                <span>👥 1,200 capacity</span>
                                <span>⭐ 4.9</span>
                            </div>
                            <button class="venue-explore-btn" id="explore-venue-4">Explore Venue →</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

       
        <section class="testimonials" id="testimonials">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-badge">💬 Reviews</span>
                    <h2 class="section-title">What People Say</h2>
                    <p class="section-subtitle">
                        Don't just take our word for it — hear from our community of event enthusiasts.
                    </p>
                </div>

                <div class="testimonials-grid">
                    <div class="testimonial-card reveal" id="testimonial-1">
                        <div class="testimonial-stars">★★★★★</div>
                        <p>"EventHub made booking our corporate conference seamless. The venue search was intuitive and
                            the support team was incredibly responsive."</p>
                        <div class="testimonial-author">
                            <div class="testimonial-avatar">R</div>
                            <div class="testimonial-author-info">
                                <h4>Rahul Sharma</h4>
                                <span>Event Manager, TCS</span>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card reveal reveal-delay-1" id="testimonial-2">
                        <div class="testimonial-stars">★★★★★</div>
                        <p>"I found the perfect venue for my wedding through EventHub. The filters and reviews helped me
                            make a confident decision. Absolutely loved it!"</p>
                        <div class="testimonial-author">
                            <div class="testimonial-avatar">P</div>
                            <div class="testimonial-author-info">
                                <h4>Priya Patel</h4>
                                <span>Happy Customer</span>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card reveal reveal-delay-2" id="testimonial-3">
                        <div class="testimonial-stars">★★★★★</div>
                        <p>"Booked tickets for a concert in under 2 minutes! The interface is clean, fast, and the
                            experience was butter smooth. Highly recommend."</p>
                        <div class="testimonial-author">
                            <div class="testimonial-avatar">A</div>
                            <div class="testimonial-author-info">
                                <h4>Arjun Reddy</h4>
                                <span>Music Enthusiast</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

      
        <section class="cta-section" id="cta">
            <div class="container">
                <div class="cta-box reveal">
                    <h2>Never Miss an Event Again</h2>
                    <p>Subscribe to get early access to tickets, exclusive discounts, and curated event recommendations.
                    </p>
                    <form class="cta-form" id="newsletter-form" onsubmit="return false;">
                        <input type="email" id="newsletter-email" placeholder="Enter your email address" required>
                        <button type="submit" id="newsletter-submit">Subscribe →</button>
                    </form>
                </div>
            </div>
        </section>

       
        <footer class="footer" id="footer">
            <div class="container">
                <div class="footer-grid">
                    <div class="footer-brand">
                        <h2 class="logo">EventHub</h2>
                        <p>Your premier destination for discovering, booking, and managing events and venues across
                            India.</p>
                        <div class="footer-socials">
                            <a href="#" id="social-fb" aria-label="Facebook">📘</a>
                            <a href="#" id="social-tw" aria-label="Twitter">🐦</a>
                            <a href="#" id="social-ig" aria-label="Instagram">📸</a>
                            <a href="#" id="social-li" aria-label="LinkedIn">💼</a>
                        </div>
                    </div>

                    <div class="footer-column">
                        <h4>Explore</h4>
                        <ul>
                            <li><a href="#featured-events">Featured Events</a></li>
                            <li><a href="#venues">Venues</a></li>
                            <li><a href="#categories">Categories</a></li>
                            <li><a href="#">Cities</a></li>
                        </ul>
                    </div>

                    <div class="footer-column">
                        <h4>Company</h4>
                        <ul>
                            <li><a href="#">About Us</a></li>
                            <li><a href="#">Careers</a></li>
                            <li><a href="#">Blog</a></li>
                            <li><a href="#">Contact</a></li>
                        </ul>
                    </div>

                    <div class="footer-column">
                        <h4>Support</h4>
                        <ul>
                            <li><a href="#">Help Center</a></li>
                            <li><a href="#">FAQs</a></li>
                            <li><a href="#">Refund Policy</a></li>
                            <li><a href="#">Terms of Service</a></li>
                        </ul>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2026 EventHub. All rights reserved. Built with ❤️</p>
                    <div class="footer-bottom-links">
                        <a href="#">Privacy Policy</a>
                        <a href="#">Terms & Conditions</a>
                        <a href="#">Cookies</a>
                    </div>
                </div>
            </div>
        </footer>


        <script src="js/slider.js" defer></script>
        <script>
            // Toggle dropdown menu
            function toggleDropdown() {
                var dropdown = document.getElementById('dropdown-menu');
                var btn = document.getElementById('nav-profile');
                dropdown.classList.toggle('show');
                btn.classList.toggle('active');
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                var dropdown = document.getElementById('dropdown-menu');
                var btn = document.getElementById('nav-profile');
                if (dropdown && btn) {
                    if (!dropdown.contains(event.target) && !btn.contains(event.target)) {
                        dropdown.classList.remove('show');
                        btn.classList.remove('active');
                    }
                }
            });
        </script>

    </body>

    </html>