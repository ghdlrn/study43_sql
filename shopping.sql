use mydb;

-- Drop the tables if they exist
DROP TABLE IF EXISTS t_sales;
DROP TABLE IF EXISTS t_customer;
DROP TABLE IF EXISTS t_product;
DROP TABLE IF EXISTS t_region;

-- create the t_region table
CREATE TABLE t_region(
   region_code varchar(3) not null,
   region_name varchar(10) not null,
   primary key(region_code)
);

-- Create the t_customer table
CREATE TABLE t_customer (
   customer_id int not null auto_increment,
   customer_name varchar(10) not null,
   phone varchar(20) not null    unique,
   email varchar(50) not null   unique,
   address varchar(100) not null,
   regist_date datetime default now(),
   region_code varchar(3) not null,
   primary key(customer_id)
);

-- Create the t_product table
CREATE TABLE t_product(
   product_code int not null auto_increment,
   product_name  varchar(50) not null,
   price int,
   primary key(product_code)
);


-- Create the t_sales table
CREATE TABLE t_sales(
   id int not null auto_increment,
   customer_id int not null,
   product_code int not null,
   qty int not null,
   sales_date datetime default now(),
   primary key(id)
);

ALTER TABLE t_customer
ADD CONSTRAINT fk_region_code FOREIGN KEY (region_code ) REFERENCES t_region(region_code);

ALTER TABLE t_sales
ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id ) REFERENCES t_customer( customer_id),
ADD CONSTRAINT fk_product_code FOREIGN KEY (product_code ) REFERENCES t_product( product_code);


-- t_region 테이블에 데이터 추가
INSERT INTO t_region (region_code , region_name ) VALUES
('02', '서울특별시'),
('031', '경기도'),
('032', '인천광역시'),
('033', '강원특별자치도'),
('041', '충청남도'),
('042', '대전광역시'),
('043', '충청북도'),
('044', '세종특별자치시'),
('051', '부산광역시'),
('052', '울산광역시'),
('053', '대구광역시'),
('054', '경상북도'),
('055', '경상남도'),
('061', '전라남도'),
('062', '광주광역시'),
('063', '전라북도'),
('064', '제주특별자치도');

select * from t_region;


-- t_customer 테이블에 데이터 추가

INSERT INTO t_customer (customer_name , phone, email, address, region_code)
VALUES
('홍길동 ', '010 1234 5678', 'hong@example.com', ' 서울시 강남구', '02'),
('김철수 ', '010 9876 5432', 'kim@example.com', ' 경기도 수원시 ', '031'),
('이영희 ', '010 1111 2222', 'lee@example.com', ' 인천시 남구 ', '032'),
('박민지 ', '010 5555 7777', 'park@example.com', ' 강원도 춘천시 ', '033'),
('정기호 ', '010 9999 8888', 'jung@example.com', ' 대전시 중구 ', '042');


select * from t_customer;


-- t_product 테이블에 데이터 추가
INSERT INTO t_product (product_name ,price)
values
('노트북',1500000),
('스마트폰 ', 1000000),
('키보드 ', 50000),
('마우스 ', 30000),
('이어폰 ', 70000);

select * from t_product;


-- t_sales 테이블에 데이터 추가
INSERT INTO t_sales (customer_id , product_code , qty)
VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 5),
(4, 4, 3),
(5, 5, 2),
(1, 2, 3),
(3, 1, 1),
(2, 4, 2),
(4, 3, 4),
(5, 5, 1);

select * from t_sales;

-- Q1. 모든 고객의 이름과 이메일을 가져오는 질의
select customer_name, email
from t_customer;
-- Q2. 특정 지역 ex) 서울특별시 에 사는 고객의 이름과 전화번호를 가져오는 질의
select customer_name, phone
from t_customer
where region_code = '02';
-- Q3. 3번 제품의 구매수량과 구매일자를 출력하세요
select qty, sales_date
from t_sales
where product_code = 3;

-- Q4. 제품별로 구매된 총 수량과 총 가격을 계산하여 출력하세요
select product_name, sum(s.qty) as 총수량, sum(s.qty * p.price) as 총가격
from t_product p join t_sales s
on s.product_code = p.product_code
group by product_name;

-- Q5. 각 지역별로 고객 수를 계산하여 출력하세요 서울특별시 1)
--  서울특별시 1
--  경기도 1
--  left join, right join
select r.region_name, count(c.customer_id)
from t_region r join t_customer c
on r.region_code = c.region_code
group by region_name;

select r.region_name, count(c.customer_id)
from t_region r left join t_customer c
on r.region_code = c.region_code
group by region_name;

insert into t_customer (customer_name , phone, email, address, region_code)
values('조조', '010 3333 5555', 'aaa@naver.com','서울시 도봉구',  '02');
desc t_customer;

-- Q6. 특정고객(3)이 구매한 제품의 이름을 출력하시오
select p.product_name 
from t_product p join t_sales s
on p.product_code = s.product_code
where s.customer_id = 3;

-- Q7. 고객이 속한 지역별 총 구매량을 출력하세요.
select r.region_name, sum(s.qty) as count
from t_region r join t_customer c
on r.region_code = c.region_code
join t_sales s
on c.customer_id = s.customer_id
group by region_name;