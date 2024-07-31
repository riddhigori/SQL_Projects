#what is the total amt each customer spent on zomato
select a.userid, sum(b.price)ttl_amt from sales a 
inner join product b  
on a.product_id=b.product_id
group by a.userid;

 #how many days has each customer visited zomato
 select userid, count(distinct created_date)distinct_days from sales
 group by userid;

#what was the first product purchased by each customer
select * from
(select *, rank() over(partition by userid order by created_date) rk from sales)
a where rk=1;

#what is the most purchased item and how many times purchased
SELECT userid, COUNT(product_id) AS cnt 
FROM sales 
WHERE product_id = (
    SELECT product_id 
    FROM sales 
    GROUP BY product_id 
    ORDER BY COUNT(product_id) DESC 
    LIMIT 1
)
GROUP BY userid;

#which item was the most popular for customer
select * from
( select *, rank() over(partition by userid order by cnt desc) rnk from
(select userid,product_id,count(product_id)cnt from sales
group by userid, product_id) a)b
where rnk=1;

#which item was purchased first by user after they became member
select * from
(select c.*,rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid=b.userid and created_date>gold_signup_date)c)d 
where rnk=1;

#which item was purcgased before the customer became member
select * from
(select c.*,rank() over(partition by userid order by created_date desc) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid=b.userid and created_date<gold_signup_date)c)d 
where rnk=1;

#what is the total order and amt spend brfore becoming members
SELECT user_id, COUNT(created_date), SUM(price) AS ttl_amt_spent 
FROM (
    SELECT c.userid AS user_id, c.created_date, c.product_id, d.price 
    FROM (
        SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
        FROM sales a
        INNER JOIN goldusers_signup b
        ON a.userid = b.userid AND a.created_date < b.gold_signup_date
    ) c 
    INNER JOIN product d 
    ON c.product_id = d.product_id
) subquery
GROUP BY user_id;

#if buyinf each product generates a point 5rs=2 zomato points calculate total ponts collects by customer
select userid,sum(ttl_points)*2.5 ttl_money_earned from
(select e.*,amt/points ttl_points from
(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c
group by userid,product_id)d)e)f group by userid;

select product_id,sum(ttl_points) ttl_points_earned from
(select e.*,amt/points ttl_points from
(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c
group by userid,product_id)d)e)f group by product_id;

#in first one year after a customer joins gold irrespective of what the customer has purchased
#they earn 5 zomato points for each purchase . calculate which customer earned more points

select c.*,d.price*0.5 total_points from
(SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
FROM sales a
INNER JOIN goldusers_signup b
ON a.userid = b.userid 
WHERE a.created_date > b.gold_signup_date 
  AND a.created_date <= DATE_ADD(b.gold_signup_date, INTERVAL 1 YEAR))c inner join product d on c.product_id=d.product_id;

# rnk all the transcation of the customers
select *,rank() over(partition by userid order by created_date)rnk from sales;

#rnk all the transactions for each member whenever they ar a gold member
select c.*,case when gold_signup_date is null then 'na' else rank() over(partition by userid order by gold_signup_date desc)end as rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a left join
goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date)c;
