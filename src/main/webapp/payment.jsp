<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.dto.*, com.dao.*, java.math.BigDecimal" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/user-login.jsp?error=Please login to make payment");
        return;
    }
    
    // Get event details
    int eventId = Integer.parseInt(request.getParameter("eventId"));
    int tickets = Integer.parseInt(request.getParameter("tickets"));
    
    EventDao eventDao = new EventDao();
    Event event = eventDao.getEventById(eventId);
    
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/EventServlet?error=Event not found");
        return;
    }
    
    // Calculate total
    BigDecimal totalAmount = event.getTicketPrice().multiply(new BigDecimal(tickets));
    boolean isFree = event.getTicketPrice() == null || event.getTicketPrice().doubleValue() == 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body {
            background: var(--bg-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .payment-container {
            background: var(--bg-card);
            border-radius: 20px;
            padding: 40px;
            max-width: 500px;
            width: 100%;
            border: 1px solid var(--border-color);
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .payment-header h1 {
            font-size: 1.75rem;
            color: var(--text-primary);
            margin-bottom: 8px;
        }
        
        .payment-header p {
            color: var(--text-muted);
        }
        
        .event-summary {
            background: var(--surface);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }
        
        .event-summary h3 {
            color: var(--text-primary);
            margin-bottom: 12px;
            font-size: 1.1rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
        }
        
        .summary-row:last-child {
            border-bottom: none;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1.1rem;
        }
        
        .payment-methods {
            margin-bottom: 24px;
        }
        
        .payment-methods h3 {
            color: var(--text-primary);
            margin-bottom: 12px;
            font-size: 1rem;
        }
        
        .payment-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .payment-option:hover {
            border-color: var(--brand-primary);
        }
        
        .payment-option.selected {
            border-color: var(--brand-primary);
            background: rgba(245, 158, 11, 0.05);
        }
        
        .payment-option input {
            display: none;
        }
        
        .payment-icon {
            font-size: 1.5rem;
        }
        
        .payment-option label {
            flex: 1;
            cursor: pointer;
            color: var(--text-primary);
        }
        
        .card-inputs {
            display: none;
            margin-top: 16px;
        }
        
        .card-inputs.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 16px;
        }
        
        .form-group label {
            display: block;
            color: var(--text-secondary);
            margin-bottom: 6px;
            font-size: 0.875rem;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background: var(--surface);
            color: var(--text-primary);
            font-size: 1rem;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--brand-primary);
        }
        
        .card-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        
        .btn-pay {
            width: 100%;
            padding: 16px;
            background: var(--gradient-brand);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(245, 158, 11, 0.3);
        }
        
        .btn-pay:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .security-note {
            text-align: center;
            margin-top: 16px;
            color: var(--text-muted);
            font-size: 0.8rem;
        }
        
        .free-event {
            text-align: center;
            padding: 20px;
            background: rgba(16, 185, 129, 0.1);
            border-radius: 12px;
            margin-bottom: 24px;
        }
        
        .free-event h3 {
            color: #10b981;
            margin-bottom: 8px;
        }
        
        .free-event p {
            color: var(--text-secondary);
        }
        
        .btn-back {
            display: inline-block;
            margin-bottom: 20px;
            color: var(--text-secondary);
            text-decoration: none;
        }
        
        .btn-back:hover {
            color: var(--brand-primary);
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <a href="<%= request.getContextPath() %>/EventServlet?action=viewEvent&id=<%= eventId %>" class="btn-back">← Back to Event</a>
        
        <div class="payment-header">
            <h1>🎫 Complete Your Booking</h1>
            <p>Secure payment for event tickets</p>
        </div>
        
        <div class="event-summary">
            <h3><%= event.getTitle() %></h3>
            <div class="summary-row">
                <span>Date</span>
                <span><%= event.getEventDate() %></span>
            </div>
            <div class="summary-row">
                <span>Venue</span>
                <span><%= event.getVenueName() %>, <%= event.getCity() %></span>
            </div>
            <div class="summary-row">
                <span>Tickets</span>
                <span><%= tickets %> x ₹<%= event.getTicketPrice() != null ? event.getTicketPrice() : 0 %></span>
            </div>
            <div class="summary-row">
                <span>Total Amount</span>
                <span>₹<%= totalAmount %></span>
            </div>
        </div>
        
        <% if (isFree) { %>
            <div class="free-event">
                <h3>🎉 Free Event!</h3>
                <p>This is a free event. No payment required.</p>
            </div>
            <form action="<%= request.getContextPath() %>/EventServlet" method="post">
                <input type="hidden" name="action" value="bookTicket">
                <input type="hidden" name="eventId" value="<%= eventId %>">
                <input type="hidden" name="numberOfTickets" value="<%= tickets %>">
                <input type="hidden" name="paymentMethod" value="free">
                <button type="submit" class="btn-pay">Confirm Booking (Free)</button>
            </form>
        <% } else { %>
            <form action="<%= request.getContextPath() %>/EventServlet" method="post" id="paymentForm">
                <input type="hidden" name="action" value="bookTicket">
                <input type="hidden" name="eventId" value="<%= eventId %>">
                <input type="hidden" name="numberOfTickets" value="<%= tickets %>">
                
                <div class="payment-methods">
                    <h3>Select Payment Method</h3>
                    
                    <div class="payment-option selected" onclick="selectPayment(this, 'card')">
                        <input type="radio" name="paymentMethod" value="card" id="payCard" checked>
                        <span class="payment-icon">💳</span>
                        <label for="payCard">Credit / Debit Card</label>
                    </div>
                    
                    <div class="payment-option" onclick="selectPayment(this, 'upi')">
                        <input type="radio" name="paymentMethod" value="upi" id="payUpi">
                        <span class="payment-icon">📱</span>
                        <label for="payUpi">UPI Payment</label>
                    </div>
                    
                    <div class="payment-option" onclick="selectPayment(this, 'netbanking')">
                        <input type="radio" name="paymentMethod" value="netbanking" id="payNetbanking">
                        <span class="payment-icon">🏦</span>
                        <label for="payNetbanking">Net Banking</label>
                    </div>
                </div>
                
                <div id="cardInputs" class="card-inputs active">
                    <div class="form-group">
                        <label>Card Number</label>
                        <input type="text" placeholder="1234 5678 9012 3456" maxlength="19">
                    </div>
                    <div class="card-row">
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <input type="text" placeholder="MM/YY" maxlength="5">
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <input type="text" placeholder="123" maxlength="3">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <input type="text" placeholder="Name on card">
                    </div>
                </div>
                
                <div id="upiInputs" class="card-inputs">
                    <div class="form-group">
                        <label>UPI ID</label>
                        <input type="text" placeholder="yourname@upi">
                    </div>
                </div>
                
                <div id="netbankingInputs" class="card-inputs">
                    <div class="form-group">
                        <label>Select Bank</label>
                        <select style="width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 8px; background: var(--surface); color: var(--text-primary);">
                            <option>State Bank of India</option>
                            <option>HDFC Bank</option>
                            <option>ICICI Bank</option>
                            <option>Axis Bank</option>
                            <option>Punjab National Bank</option>
                        </select>
                    </div>
                </div>
                
                <button type="submit" class="btn-pay">Pay ₹<%= totalAmount %></button>
                
                <p class="security-note">🔒 Your payment is secure and encrypted</p>
            </form>
        <% } %>
    </div>
    
    <script>
        function selectPayment(element, method) {
            document.querySelectorAll('.payment-option').forEach(opt => opt.classList.remove('selected'));
            element.classList.add('selected');
            
            document.getElementById('cardInputs').classList.remove('active');
            document.getElementById('upiInputs').classList.remove('active');
            document.getElementById('netbankingInputs').classList.remove('active');
            
            if (method === 'card') {
                document.getElementById('cardInputs').classList.add('active');
            } else if (method === 'upi') {
                document.getElementById('upiInputs').classList.add('active');
            } else if (method === 'netbanking') {
                document.getElementById('netbankingInputs').classList.add('active');
            }
        }
    </script>
</body>
</html>
