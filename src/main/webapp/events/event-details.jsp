<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.dto.*" %>
<%
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/EventServlet?error=Event not found");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= event.getTitle() %> | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/user-style.css">
    <style>
        /* ====== PREMIUM EVENT DETAILS STYLES ====== */
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: #0a0a0f;
            color: #e5e5e5;
            min-height: 100vh;
        }
        
        /* Hero Section */
        .hero-section {
            position: relative;
            width: 100%;
            height: 420px;
            overflow: hidden;
        }
        
        .hero-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
        }
        
        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(10, 10, 15, 0.4) 0%, rgba(10, 10, 15, 0.7) 50%, rgba(10, 10, 15, 0.95) 100%);
        }
        
        .hero-content {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
            right: 0;
        }
        
        .event-category-badge {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-radius: 20px;
            margin-bottom: 16px;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 16px;
            text-shadow: 0 2px 20px rgba(0, 0, 0, 0.5);
        }
        
        .hero-metadata {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.85);
        }
        
        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px;
        }
        
        .content-wrapper {
            display: flex;
            flex-direction: column;
            gap: 32px;
            align-items: stretch;
        }
        
        /* Left Column */
        .event-details-left {
            display: flex;
            flex-direction: column;
            gap: 24px;
            width: 100%;
        }
        
        /* Info Cards */
        .info-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.06), rgba(255,255,255,0.02));
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 24px;
        }
        
        .info-card h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #a1a1aa;
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .event-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }
        
        .event-info-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }
        
        .info-icon {
            font-size: 1.3rem;
        }
        
        .event-info-item label {
            display: block;
            font-size: 0.75rem;
            color: #71717a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }
        
        .event-info-item p {
            font-size: 0.95rem;
            color: #e5e5e5;
            font-weight: 500;
        }
        
        .event-description p {
            font-size: 0.95rem;
            line-height: 1.7;
            color: #a1a1aa;
        }
        
        /* ====== THEATER SEAT LAYOUT - CINEMA STYLE ====== */
        .seat-selection-container {
            background: linear-gradient(180deg, #1a1a24 0%, #12121a 100%);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        }
        
        .seat-selection-header {
            text-align: center;
            margin-bottom: 24px;
        }
        
        .seat-selection-header h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 4px;
            text-transform: none;
        }
        
        .seat-selection-header p {
            color: #71717a;
            font-size: 0.85rem;
        }
        
        /* Screen - Curved Theater Style */
        .screen-container {
            position: relative;
            margin: 0 auto 36px;
            width: 75%;
        }
        
        .screen-curve {
            height: 40px;
            background: linear-gradient(180deg, rgba(99, 102, 241, 0.4) 0%, rgba(99, 102, 241, 0.15) 50%, transparent 100%);
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
            border: 2px solid rgba(99, 102, 241, 0.3);
            border-bottom: none;
            position: relative;
        }
        
        .screen-label {
            position: absolute;
            bottom: 8px;
            left: 50%;
            transform: translateX(-50%);
            color: #71717a;
            font-size: 11px;
            letter-spacing: 4px;
            text-transform: uppercase;
        }
        
        /* Seat Legend */
        .seat-legend {
            display: flex;
            justify-content: center;
            gap: 28px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: #a1a1aa;
        }
        
        .legend-seat {
            width: 24px;
            height: 24px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            font-weight: 600;
        }
        
        .legend-seat.available {
            background: rgba(34, 197, 94, 0.15);
            border: 1.5px solid #22c55e;
            color: #22c55e;
        }
        
        .legend-seat.selected {
            background: #6366f1;
            border-color: #6366f1;
            color: #fff;
        }
        
        .legend-seat.booked {
            background: rgba(239, 68, 68, 0.15);
            border: 1.5px solid #ef4444;
            color: #ef4444;
        }
        
        .legend-seat.locked {
            background: rgba(245, 158, 11, 0.15);
            border: 1.5px solid #f59e0b;
            color: #f59e0b;
        }
        
        /* Seat Grid - Theater Layout */
        .seat-map-container {
            max-height: 320px;
            overflow-y: auto;
            overflow-x: auto;
            padding: 8px;
        }
        
        .seat-map-container::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        
        .seat-map-container::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 3px;
        }
        
        .seat-map-container::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.4);
            border-radius: 3px;
        }
        
        .seat-map {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            min-width: fit-content;
            padding: 0 20px;
        }
        
        .seat-row {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .row-label {
            width: 22px;
            font-weight: 600;
            color: #52525b;
            font-size: 11px;
            text-align: center;
            flex-shrink: 0;
        }
        
        /* Individual Seat */
        .seat {
            width: 28px;
            height: 28px;
            border-radius: 5px;
            border: 1.5px solid #22c55e;
            background: rgba(34, 197, 94, 0.1);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            font-weight: 600;
            color: #22c55e;
            transition: all 0.15s ease;
            flex-shrink: 0;
        }
        
        .seat:hover:not(.booked):not(.locked) {
            transform: scale(1.15);
            border-color: #818cf8;
            background: rgba(99, 102, 241, 0.25);
            box-shadow: 0 0 12px rgba(99, 102, 241, 0.4);
        }
        
        .seat.selected {
            background: #6366f1;
            border-color: #6366f1;
            color: #fff;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.5);
        }
        
        .seat.booked {
            background: rgba(239, 68, 68, 0.12);
            border-color: #ef4444;
            color: #ef4444;
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        .seat.locked {
            background: rgba(245, 158, 11, 0.12);
            border-color: #f59e0b;
            color: #f59e0b;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        /* No Seats */
        .no-seats-message {
            text-align: center;
            padding: 40px;
            color: #71717a;
        }
        
        .no-seats-message span {
            font-size: 2.5rem;
            display: block;
            margin-bottom: 12px;
        }
        
        /* Debug Info */
        .debug-info {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 8px;
            padding: 12px;
            margin: 12px 0;
            font-size: 12px;
            color: #f59e0b;
            display: none;
        }
        
        /* Right Column - Ticket Summary */
        .ticket-summary-card {
            position: sticky;
            top: 90px;
            background: linear-gradient(180deg, #1a1a24 0%, #14141c 100%);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 16px 48px rgba(0, 0, 0, 0.5);
        }
        
        .ticket-summary-header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            margin-bottom: 20px;
        }
        
        .ticket-price {
            font-size: 2.2rem;
            font-weight: 700;
            color: #ffffff;
        }
        
        .ticket-price span {
            font-size: 0.9rem;
            color: #71717a;
            font-weight: 400;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
        
        .summary-row span:first-child {
            color: #a1a1aa;
        }
        
        .summary-row span:last-child {
            color: #e5e5e5;
            font-weight: 500;
        }
        
        .selected-seats-list {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin: 8px 0;
            min-height: 24px;
        }
        
        .selected-seat-tag {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            padding: 4px 10px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .summary-divider {
            height: 1px;
            background: rgba(255, 255, 255, 0.06);
            margin: 12px 0;
        }
        
        .summary-row.total span:last-child {
            color: #818cf8;
            font-weight: 700;
        }
        
        .btn-proceed-booking {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 16px;
            transition: all 0.2s ease;
        }
        
        .btn-proceed-booking:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }
        
        .btn-proceed-booking:disabled {
            background: #3f3f46;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .login-prompt {
            text-align: center;
            padding: 20px;
        }
        
        .login-prompt p {
            color: #a1a1aa;
            margin-bottom: 14px;
        }
        
        .btn-login {
            display: inline-block;
            padding: 12px 28px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
        }
        
        .btn-back {
            display: block;
            text-align: center;
            color: #71717a;
            text-decoration: none;
            margin-top: 14px;
            font-size: 0.85rem;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
            .ticket-summary-card {
                position: relative;
                top: 0;
                order: -1;
            }
        }
        
        @media (max-width: 640px) {
            .hero-section {
                height: 320px;
            }
            .hero-title {
                font-size: 1.8rem;
            }
            .event-info-grid {
                grid-template-columns: 1fr;
            }
            .seat-legend {
                gap: 16px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-background" style="background-image: url('<%= event.getPosterUrl() != null ? event.getPosterUrl() : request.getContextPath() + "/images/concert.jpg" %>');"></div>
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <span class="event-category-badge"><%= event.getCategoryName() %></span>
            <h1 class="hero-title"><%= event.getTitle() %></h1>
            <div class="hero-metadata">
                <span>📍 <%= event.getLocation() %>, <%= event.getCity() %></span>
                <span>📅 <%= event.getEventDate() %></span>
                <span>⏰ <%= event.getEventTime() %></span>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="main-container">
        <div class="content-wrapper">
            <!-- Left Column -->
            <div class="event-details-left">
                <!-- Event Info -->
                <div class="info-card">
                    <h3>Event Details</h3>
                    <div class="event-info-grid">
                        <div class="event-info-item">
                            <span class="info-icon">🏢</span>
                            <div>
                                <label>Venue</label>
                                <p><%= event.getVenueName() %></p>
                            </div>
                        </div>
                        <div class="event-info-item">
                            <span class="info-icon">👤</span>
                            <div>
                                <label>Organizer</label>
                                <p><%= event.getOrganizerName() %></p>
                            </div>
                        </div>
                        <div class="event-info-item">
                            <span class="info-icon">🎫</span>
                            <div>
                                <label>Available</label>
                                <p><%= event.getAvailableSeats() %> / <%= event.getTotalSeats() %> seats</p>
                            </div>
                        </div>
                        <div class="event-info-item">
                            <span class="info-icon">📍</span>
                            <div>
                                <label>Location</label>
                                <p><%= event.getLocation() %></p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- About -->
                <div class="info-card event-description">
                    <h3>About This Event</h3>
                    <p><%= event.getDescription() != null ? event.getDescription() : "No description available for this event." %></p>
                </div>
                
                <!-- Seat Selection -->
                <div class="seat-selection-container">
                    <div class="seat-selection-header">
                        <h3>🎫 Select Your Seats</h3>
                        <p>Click on available seats to select</p>
                    </div>
                    
                    <!-- Cinema Style Screen -->
                    <div class="screen-container">
                        <div class="screen-curve">
                            <span class="screen-label">Screen</span>
                        </div>
                    </div>
                    
                    <!-- Legend -->
                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-seat available">A</div>
                            <span>Available</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat selected">A</div>
                            <span>Selected</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat booked">A</div>
                            <span>Booked</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat locked">A</div>
                            <span>Locked</span>
                        </div>
                    </div>
                    
                    <!-- Debug Info -->
                    <div id="debugInfo" class="debug-info"></div>
                    
                    <!-- Seat Grid -->
                    <div class="seat-map-container">
                        <div id="seatGrid" class="seat-map">
                            <div class="no-seats-message">
                                <span>🎭</span>
                                <p>Loading seats...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Right Column - Ticket Summary -->
            <div class="ticket-summary-card">
                <div class="ticket-summary-header">
                    <div class="ticket-price">
                        <% if (event.getTicketPrice() != null && event.getTicketPrice().doubleValue() > 0) { %>
                            ₹<%= event.getTicketPrice().intValue() %>
                            <span>/ ticket</span>
                        <% } else { %>
                            FREE
                            <span>/ entry</span>
                        <% } %>
                    </div>
                </div>
                
                <% if (userId != null) { %>
                <div class="ticket-summary-content">
                    <div class="summary-row">
                        <span>Price per ticket</span>
                        <span>₹<%= event.getTicketPrice() != null ? event.getTicketPrice().intValue() : 0 %></span>
                    </div>
                    <div class="summary-row">
                        <span>Selected Seats</span>
                        <span id="seatCount">0</span>
                    </div>
                    <div class="selected-seats-list" id="selectedSeatsList"></div>
                    <div class="summary-divider"></div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span id="totalAmount">₹0</span>
                    </div>
                    <button type="button" class="btn-proceed-booking" id="proceedBtn" onclick="bookSeats()" disabled>
                        Proceed to Payment
                    </button>
                </div>
                <% } else { %>
                <div class="login-prompt">
                    <p>Please login to select seats and book tickets</p>
                    <a href="<%= request.getContextPath() %>/user-login.jsp?redirect=EventServlet?action=viewEvent&id=<%= event.getId() %>" class="btn-login">Login to Book</a>
                </div>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/EventServlet" class="btn-back">← Back to Events</a>
            </div>
        </div>
    </main>

    <jsp:include page="../footer.jsp" />
    
    <script>
        var eventId = <%= event.getId() %>;
        var pricePerTicket = <%= event.getTicketPrice() != null ? event.getTicketPrice().doubleValue() : 0 %>;
        var selectedSeats = [];
        
        document.addEventListener('DOMContentLoaded', function() {
            loadSeats();
        });
        
        function showDebug(message) {
            var debug = document.getElementById('debugInfo');
            debug.style.display = 'block';
            debug.innerHTML += message + '<br>';
        }
        
        function loadSeats() {
            showDebug('Loading seats for event: ' + eventId);
            
            var formData = new FormData();
            formData.append('action', 'getSeats');
            formData.append('eventId', eventId);
            
            fetch('<%= request.getContextPath() %>/BookingServlet', {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                showDebug('Response status: ' + response.status);
                return response.text();
            })
            .then(function(text) {
                showDebug('Raw response: ' + text.substring(0, 200));
                
                try {
                    var data = JSON.parse(text);
                    if (data.seats && data.seats.length > 0) {
                        showDebug('Found ' + data.seats.length + ' seats');
                        renderSeats(data.seats);
                    } else {
                        showDebug('No seats found in response');
                        document.getElementById('seatGrid').innerHTML = 
                            '<div class="no-seats-message">' +
                            '<span>🎭</span>' +
                            '<p>No seats available for this event yet.</p>' +
                            '<p style="font-size:11px;margin-top:8px;">Please contact organizer to add seats.</p>' +
                            '</div>';
                    }
                } catch(e) {
                    showDebug('JSON parse error: ' + e.message);
                    document.getElementById('seatGrid').innerHTML = 
                        '<div class="no-seats-message">' +
                        '<span>❌</span>' +
                        '<p>Error loading seats: ' + e.message + '</p>' +
                        '</div>';
                }
            })
            .catch(function(error) {
                showDebug('Fetch error: ' + error.message);
                document.getElementById('seatGrid').innerHTML = 
                    '<div class="no-seats-message">' +
                    '<span>❌</span>' +
                    '<p>Error: ' + error.message + '</p>' +
                    '</div>';
            });
        }
        
        function renderSeats(seats) {
            var seatGrid = document.getElementById('seatGrid');
            seatGrid.innerHTML = '';
            
            // Group by row
            var rows = {};
            seats.forEach(function(seat) {
                var row = seat.rowLabel;
                if (!rows[row]) rows[row] = [];
                rows[row].push(seat);
            });
            
            // Sort rows
            var sortedRows = Object.keys(rows).sort();
            
            if (sortedRows.length === 0) {
                seatGrid.innerHTML = '<div class="no-seats-message"><span>🎭</span><p>No seats configured</p></div>';
                return;
            }
            
            // Find max columns
            var maxCols = 0;
            Object.values(rows).forEach(function(rowSeats) {
                if (rowSeats.length > maxCols) maxCols = rowSeats.length;
            });
            
            // Column numbers
            var colNumRow = document.createElement('div');
            colNumRow.className = 'seat-row';
            colNumRow.innerHTML = '<div class="row-label"></div>';
            for (var c = 1; c <= maxCols; c++) {
                var colNum = document.createElement('div');
                colNum.className = 'seat';
                colNum.style.visibility = 'hidden';
                colNum.textContent = c;
                colNumRow.appendChild(colNum);
            }
            seatGrid.appendChild(colNumRow);
            
            // Each row
            sortedRows.forEach(function(rowLabel) {
                var rowSeats = rows[rowLabel].sort(function(a, b) {
                    return a.seatColumn - b.seatColumn;
                });
                
                var rowDiv = document.createElement('div');
                rowDiv.className = 'seat-row';
                
                var labelSpan = document.createElement('div');
                labelSpan.className = 'row-label';
                labelSpan.textContent = rowLabel;
                rowDiv.appendChild(labelSpan);
                
                rowSeats.forEach(function(seat) {
                    var seatDiv = document.createElement('div');
                    seatDiv.className = 'seat';
                    
                    if (seat.status === 'BOOKED') {
                        seatDiv.classList.add('booked');
                        seatDiv.title = 'Seat ' + seat.seatNumber + ' booked';
                    } else if (seat.status === 'LOCKED') {
                        seatDiv.classList.add('locked');
                        seatDiv.title = 'Seat ' + seat.seatNumber + ' locked';
                    } else {
                        seatDiv.onclick = function() { toggleSeat(seat); };
                        seatDiv.title = 'Click seat ' + seat.seatNumber;
                    }
                    
                    seatDiv.textContent = seat.seatColumn;
                    seatDiv.dataset.seatNumber = seat.seatNumber;
                    rowDiv.appendChild(seatDiv);
                });
                
                seatGrid.appendChild(rowDiv);
            });
        }
        
        function toggleSeat(seat) {
            var seatIndex = selectedSeats.indexOf(seat.seatNumber);
            var seatElement = document.querySelector('[data-seat-number="' + seat.seatNumber + '"]');
            
            if (seatIndex > -1) {
                selectedSeats.splice(seatIndex, 1);
                seatElement.classList.remove('selected');
                unlockSeats([seat.seatNumber]);
            } else {
                selectedSeats.push(seat.seatNumber);
                seatElement.classList.add('selected');
                lockSeats([seat.seatNumber]);
            }
            
            updateBookingSummary();
        }
        
        function lockSeats(seats) {
            var formData = new FormData();
            formData.append('action', 'lockSeats');
            formData.append('eventId', eventId);
            formData.append('seats', seats.join(','));
            
            fetch('<%= request.getContextPath() %>/BookingServlet', {
                method: 'POST',
                body: formData
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (!data.success) {
                    alert(data.message || 'Failed to lock seat');
                    var idx = selectedSeats.indexOf(seats[0]);
                    if (idx > -1) {
                        selectedSeats.splice(idx, 1);
                        var el = document.querySelector('[data-seat-number="' + seats[0] + '"]');
                        if (el) el.classList.remove('selected');
                    }
                }
            })
            .catch(function(err) { console.error('Lock error:', err); });
        }
        
        function unlockSeats(seats) {
            var formData = new FormData();
            formData.append('action', 'unlockSeats');
            formData.append('eventId', eventId);
            formData.append('seats', seats.join(','));
            
            fetch('<%= request.getContextPath() %>/BookingServlet', {
                method: 'POST',
                body: formData
            })
            .then(function(response) { return response.json(); })
            .catch(function(err) { console.error('Unlock error:', err); });
        }
        
        function updateBookingSummary() {
            var seatCount = document.getElementById('seatCount');
            var totalAmount = document.getElementById('totalAmount');
            var selectedList = document.getElementById('selectedSeatsList');
            var proceedBtn = document.getElementById('proceedBtn');
            
            seatCount.textContent = selectedSeats.length;
            totalAmount.textContent = '₹' + (selectedSeats.length * pricePerTicket);
            
            if (selectedSeats.length > 0) {
                proceedBtn.disabled = false;
                var tagsHtml = '';
                selectedSeats.forEach(function(seat) {
                    tagsHtml += '<span class="selected-seat-tag">' + seat + '</span>';
                });
                selectedList.innerHTML = tagsHtml;
            } else {
                proceedBtn.disabled = true;
                selectedList.innerHTML = '';
            }
        }
        
        function bookSeats() {
            if (selectedSeats.length === 0) {
                alert('Please select at least one seat');
                return;
            }
            
            var formData = new FormData();
            formData.append('action', 'bookSeats');
            formData.append('eventId', eventId);
            formData.append('seats', selectedSeats.join(','));
            
            var proceedBtn = document.getElementById('proceedBtn');
            proceedBtn.disabled = true;
            proceedBtn.textContent = 'Processing...';
            
            fetch('<%= request.getContextPath() %>/BookingServlet', {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    return response.json();
                }
            })
            .then(function(data) {
                if (data && !data.success) {
                    alert(data.message || 'Booking failed');
                    proceedBtn.disabled = false;
                    proceedBtn.textContent = 'Proceed to Payment';
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                alert('Booking failed');
                proceedBtn.disabled = false;
                proceedBtn.textContent = 'Proceed to Payment';
            });
        }
    </script>
</body>
</html>
