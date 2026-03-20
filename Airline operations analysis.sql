-- ====================
-- 1. BASIC KPI
-- ====================

-- Total Flights, Passengers & Revenue
SELECT 
    COUNT(DISTINCT f.flight_id) AS total_flights,
    SUM(b.passenger_count) AS total_passengers,
    SUM(b.passenger_count * b.ticket_price) AS total_revenue
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id;

--Average Delay(mins)
SELECT 
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes
FROM flights
WHERE cancelled = 0;

--Cancellation Rate %
SELECT 
    ROUND(SUM(cancelled) * 100.0 / COUNT(*),2) AS cancellation_rate
FROM flights;

-- ====================
-- 2. ANALYSIS
-- ====================

--Revenue by Airline
SELECT a.airline_name, SUM(b.passenger_count * b.ticket_price) AS revenue
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY a.airline_name
ORDER BY revenue DESC;

--Average Delay(mins) by Airport
SELECT source_airport, ROUND(AVG(delay_minutes),2) AS avg_delay
FROM flights
GROUP BY source_airport
ORDER BY avg_delay DESC;

--Top Routes by Revenue
SELECT f.source_airport, f.destination_airport, SUM(b.passenger_count * b.ticket_price) AS revenue
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY f.source_airport, f.destination_airport
ORDER BY revenue DESC
LIMIT 5;

--Passenger Trend by date
SELECT DATE(departure_time) AS flight_date, SUM(b.passenger_count) AS total_passengers
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY flight_date
ORDER BY flight_date;

--Delay Impact on Revenue
SELECT 
     CASE 
        WHEN delay_minutes = 0 THEN 'On-Time'
        WHEN delay_minutes BETWEEN 1 AND 30 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END AS delay_category, 
	SUM(b.passenger_count * b.ticket_price) AS revenue
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY delay_category
ORDER BY revenue DESC;

--Most Efficient Airlines by Low Delay & High Revenue
SELECT 
    a.airline_name,
    ROUND(AVG(f.delay_minutes),2) AS avg_delay,
    SUM(b.passenger_count * b.ticket_price) AS revenue
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY a.airline_name
ORDER BY avg_delay ASC, revenue DESC
LIMIT 3;

--Cancellation Impact
SELECT cancelled, COUNT(*) AS total_flights, SUM(b.passenger_count) AS passengers_affected
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY cancelled;

-- ====================
-- Final View
-- ====================
CREATE VIEW airline_analysis_view AS
SELECT 
    f.flight_id,
    a.airline_name,
    f.source_airport,
    f.destination_airport,
    DATE(f.departure_time) AS flight_date,
    f.delay_minutes,
    f.cancelled,
    b.passenger_count,
    b.ticket_price,
    (b.passenger_count * b.ticket_price) AS revenue
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN bookings b ON f.flight_id = b.flight_id;


SELECT * FROM airline_analysis_view;





