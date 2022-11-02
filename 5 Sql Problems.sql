1.From the following tables write a SQL query to display those managers who have average experience for each scheme.
drop table if exists managing_body 
CREATE TABLE managing_body (manager_id int NOT NULL UNIQUE, manager_name varchar(255), running_years int);

INSERT INTO managing_body VALUES(51,'James',5);
INSERT INTO managing_body VALUES(52,'Cork',3);
INSERT INTO managing_body VALUES(53,'Paul',4);
INSERT INTO managing_body VALUES(54,'Adam',3);
INSERT INTO managing_body VALUES(55,'Hense',4);
INSERT INTO managing_body VALUES(56,'Peter',2);


drop table if exists scheme
CREATE TABLE scheme (scheme_code int NOT NULL , scheme_manager_id int NOT NULL, 
PRIMARY KEY(scheme_code,scheme_manager_id));
INSERT INTO scheme VALUES(1001,	51);
INSERT INTO scheme VALUES(1001,	53);
INSERT INTO scheme VALUES(1001,	54);
INSERT INTO scheme VALUES(1001,	56);
INSERT INTO scheme VALUES(1002,	51);
INSERT INTO scheme VALUES(1002,	55);
INSERT INTO scheme VALUES(1003,	51);
INSERT INTO scheme VALUES(1004,	52);
select * from managing_body
select * from scheme 
select distinct(a.scheme_code),avg(m.running_years) over(partition by a.scheme_code) as average_years
from managing_body m
left join scheme a
on m.manager_id = a.scheme_manager_id
order by a.scheme_code

2. From the following tables write an SQL query to find the best seller by total sales price.
Return distributor ID , If there is a tie, report them all.

CREATE TABLE item (item_code int not null unique, item_desc varchar(255), cost int);
INSERT INTO item VALUES(101,'mother board',	2700);
INSERT INTO item VALUES(102,'RAM',	800);
INSERT INTO item VALUES(103,'key board',300);
INSERT INTO item VALUES(104,'mouse',300);


CREATE TABLE sales_info (distributor_id int, item_code int, retailer_id int, date_of_sell date, quantity int, total_cost int);
INSERT INTO sales_info VALUES(5001,101,1001,'2020-02-12',3,8100);
INSERT INTO sales_info VALUES(5001,103,1002,'2020-03-15',15,4500);
INSERT INTO sales_info VALUES(5002,101,1001,'2019-06-24',2,5400);
INSERT INTO sales_info VALUES(5001,104,1003,'2019-09-11',8,2400);
INSERT INTO sales_info VALUES(5003,101,1003,'2020-10-21',5,13500);
INSERT INTO sales_info VALUES(5003,104,1002,'2020-12-27',10,3000);
INSERT INTO sales_info VALUES(5002,102,1001,'2019-05-18',12,9600);
INSERT INTO sales_info VALUES(5002,103,1004,'2020-06-17',8,2400);
INSERT INTO sales_info VALUES(5003,103,1001,'2020-04-12',3,900);
select * from sales_info
select * from item

select distinct(distributor_id ),sum(total_cost) over(partition by distributor_id ) as total_sale
from sales_info
order by total_sale desc
limit 2

3.From the above table write a SQL query to find those retailers who have bought 'key board' but not 'mouse'.
Return retailer ID.

select * from sales_info
create temporary table t1 as(select case when item_desc='key board' and item_desc !='mouse' then retailer_id end as Retailer_id
from sales_info s
left join item i
on i.item_code = s.item_code
group by s.retailer_id,i.item_desc)
create temporary table t2 as(select case when item_desc ='mouse' then retailer_id end as Retailer_id
from sales_info s
left join item i
on i.item_code = s.item_code
group by s.retailer_id,i.item_desc)
select tt.retailer_id
from t1 tt
where tt.retailer_id not in (select retailer_id from t2 where retailer_id is not NULL) 

4.From the following table write a SQL query to find the highest purchase with its corresponding item for each customer.
In case of a same quantity purchase find the item code which is smallest.
The output must be sorted by increasing of customer_id. 
Return customer ID,lowest item code and purchase quantity.

CREATE TABLE purchase (customer_id int not null, item_code int not null, purch_qty int not null);
INSERT INTO purchase VALUES (101,504,25 );
INSERT INTO purchase VALUES (101,503,50 );
INSERT INTO purchase VALUES (102,502,40 );
INSERT INTO purchase VALUES (102,503,25 );
INSERT INTO purchase VALUES (102,501,45 );
INSERT INTO purchase VALUES (103,505,30 );
INSERT INTO purchase VALUES (103,503,25 );
INSERT INTO purchase VALUES (104,505,40 );
INSERT INTO purchase VALUES (101,502,25 );
INSERT INTO purchase VALUES (102,504,40 );
INSERT INTO purchase VALUES (102,505,50 );
INSERT INTO purchase VALUES (103,502,25 );
INSERT INTO purchase VALUES (104,504,40 );
INSERT INTO purchase VALUES (103,501,35 );

select * from purchase
select b.customer_id,b.item_code,b.total_sum
from(select a.customer_id,a.item_code,a.total_sum,row_number() over(partition by a.customer_id order by  a.customer_id,a.total_sum desc) as rn
from(select customer_id,item_code,sum(purch_qty) as total_sum
from purchase
group by customer_id,item_code
order by customer_id,sum(purch_qty) desc
) as a) as b
where b.rn=1


5.From the following table write a SQL query to find all the writers who rated more than one topics on the same date, sorted in ascending order by their id.
Return writr ID.
CREATE TABLE topics (topic_id int, writer_id int, rated_by int, date_of_rating date);
INSERT INTO topics VALUES (10001,504,507,'2020-07-17');
INSERT INTO topics VALUES (10003,502,503,'2020-09-22'); 
INSERT INTO topics VALUES (10001,503,507,'2020-12-23'); 
INSERT INTO topics VALUES (10002,501,507,'2020-07-17'); 
INSERT INTO topics VALUES (10002,502,502,'2020-04-10'); 
INSERT INTO topics VALUES (10002,504,502,'2020-11-16'); 
INSERT INTO topics VALUES (10003,501,502,'2020-04-10'); 
INSERT INTO topics VALUES (10001,507,507,'2020-10-23'); 
INSERT INTO topics VALUES (10004,503,501,'2020-08-28'); 
INSERT INTO topics VALUES (10003,505,504,'2020-12-21'); 


select * from topics
select a.rated_by
from(select rated_by,date_of_rating,count(topic_id) 
from topics
group by date_of_rating,rated_by)as a
where a.count >1