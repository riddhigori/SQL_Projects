SELECT * FROM namma_yatri.trips;

#total trips
select count(distinct tripid) from namma_yatri.trip_details;

#total driver
select count(distinct driverid)total_drivers from namma_yatri.trips;

#total earnings
select sum(fare)fare from namma_yatri.trips;

#total completed trips
select count(distinct tripid)total_trips from namma_yatri.trips;

#total searches got estimated
select sum(searches_got_estimate)searches from namma_yatri.trip_details;

#total searches for quotes
select sum(searches_got_quotes)searches from namma_yatri.trip_details;

#total driver cancelled
select count(*), sum(driver_not_cancelled) searches from namma_yatri.trip_details;

#total otp entered
select sum(otp_entered) from namma_yatri.trip_details;

#total end rides
select sum(end_ride) from namma_yatri.trip_details;

#avg distance per trip
select avg(distance) from namma_yatri.trips;

#av fare per trip
select avg(fare) from namma_yatri.trips;

#distance travelled
select sum(distance) from namma_yatri.trips;

#which is the most used payment method
SELECT 
    t.faremethod, 
    p.method, 
    COUNT(DISTINCT t.tripid) AS cnt 
FROM 
    namma_yatri.trips t
JOIN 
    namma_yatri.payment p 
ON 
    t.faremethod = p.id
GROUP BY 
    t.faremethod, p.method
ORDER BY 
    cnt DESC;

#the highest payment was made through which method
SELECT 
    t.tripid,
    t.faremethod, 
    p.method, 
    t.fare
FROM 
    namma_yatri.trips t
JOIN 
    namma_yatri.payment p 
ON 
    t.faremethod = p.id
ORDER BY 
    t.fare DESC
LIMIT 3;

#WHICH 2 LOCATION HAVE MORE TRIPS

select loc_from, loc_to, count(distinct tripid) from namma_yatri.trips
group by loc_from, loc_to
order by count(distinct tripid)desc;

#TOP 5 EARNING DRIVERS
SELECT *
FROM (
    SELECT 
        driverid, 
        SUM(fare) AS total_fare, 
        DENSE_RANK() OVER (ORDER BY SUM(fare) DESC) AS rk
    FROM 
        namma_yatri.trips
    GROUP BY 
        driverid
) b
WHERE rk < 6;

#which duration has more trips
SELECT *
FROM (
    SELECT 
        duration, 
        count(distinct tripid)cnt, 
        DENSE_RANK() OVER (order by cnt desc) AS rk
    FROM 
        namma_yatri.trips
    GROUP BY 
        duration
) b
WHERE rk < 2;

select duration, count(distinct tripid)cnt from  namma_yatri.trips
group by duration 
order by cnt desc
limit 1;

#which driver customer had more orders
select driverid, custid, count(distinct tripid) cnt from namma_yatri.trips
group by driverid, custid
order by cnt desc
limit 2;

#search to estmate rate
select sum(searches_got_estimate)*100.0/sum(searches) from namma_yatri.trip_details;

#which area got highest trips in which duration
select duration, loc_from, count(distinct tripid)cnt from namma_yatri.trips
group by duration, loc_from
order by cnt desc;

#which area got highest no. of fare, cancellation,trips
select loc_from, sum(fare)fare from namma_yatri.trips
group by loc_from
order by fare desc
limit 1;

select loc_from, count(*) - sum(driver_not_cancelled)driver_cancelled from namma_yatri.trip_details
group by loc_from
order by driver_cancelled desc
limit 2;

#which duration got the hightest trips and fare
select duration, count(distinct tripid) fare from namma_yatri.trips
group by duration
order by fare desc
limit 1;


select loc_from, count(*) - sum(customer_not_cancelled)customer_cancelled from namma_yatri.trip_details
group by loc_from
order by customer_cancelled desc
limit 2;   
    









