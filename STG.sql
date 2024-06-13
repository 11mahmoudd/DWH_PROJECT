create schema STG

create table STG.Customer
(
	customer_id  int,
	first_name   varchar(20),
	last_name    varchar(20),
	email        varchar(50),
	address      varchar(100),
	city         varchar(30),
	phone        varchar(15),
	src_update_date  datetime,
	create_timestamp	datetime
)


CREATE TABLE STG.Product
(
	product_id           int,
	product_name         varchar(50),
	supplier_name        varchar(20),
	price                decimal(10, 2),
	src_update_date      datetime,
	create_timestamp	 datetime
);


CREATE TABLE STG.Store
(
  store_id            int,
  address             varchar(100),
  city                varchar(30),
  phone             varchar(15),
  manager_first_name  varchar(20),
  manager_last_name   varchar(20),
  src_update_date     datetime,
  create_timestamp	  datetime
);

create table STG.City
(
	city_id int,
	city_name varchar(30),
	city_taxes decimal(5,2),
	src_update_date     datetime,
    create_timestamp	  datetime
)

create table STG.Inventory
(
	store_id		int ,
	product_id		int,
	stock			int,
	store_address		varchar(100),
	product_price		decimal(10,2),
	supplier_name        varchar(20),
	src_update_date		datetime,
	create_timestamp	datetime
)


create table STG.Orders
(
	order_id int ,
	customer_first_name varchar(20),
	customer_last_name varchar(20),
	customer_contact varchar(15),
	store_address varchar(100),
	shipping_address varchar(100),
	quantity_sold int,
	total_amount decimal(10,2),
	payment_method varchar(20),
	order_date date,
	src_update_date		datetime,
	create_timestamp	datetime
)


create table STG.Staff
(
	staff_id  int,
	first_name   varchar(20),
	last_name    varchar(20),
	phone        varchar(15),
	email        varchar(50),
	address      varchar(100),
	city         varchar(30),
	store_id	int,
	active bit,
	src_update_date  datetime,
	create_timestamp	datetime
)


create table STG.StaffAttendance
(
	store_id	int,
	staff_id	int,
	first_name   varchar(20),
	last_name    varchar(20),
	address      varchar(100),
	active bit,
	src_update_date     datetime,
	create_timestamp	  datetime
)

create table STG.Sales
(
	customer_id int,
	product_id int,
	store_id int,
	order_id int,
	city_id int,
	quantity_sold int,
	unit_price decimal(10,2),
	total_sales decimal(10,2),	
	taxes decimal(5,2),	
	net_sales decimal(10,2),
	order_date date,
	src_update_date   datetime,
    create_timestamp	datetime
)


CREATE TABLE STG.Conf_Table
(
  table_name		 varchar(30),
  last_extract_date	 datetime
);

INSERT INTO STG.Conf_Table VALUES
	('Customer', '1/1/2023'),
	('Product', '1/1/2023'),
	('Store', '1/1/2023'),
	('City', '1/1/2023'),
	('Orders', '1/1/2023'),
	('Staff', '1/1/2023'),
	('Inventory', '1/1/2023'),
	('Sales', '1/1/2023'),
	('StaffAttendance','1/1/2023');




select * from STG.City
select * from STG.Product
select * from STG.Orders
select * from STG.Inventory
select * from STG.Sales
select * from STG.Staff
select * from STG.Store
select * from STG.Customer
select * from STG.Conf_Table


truncate table STG.City
truncate table STG.Product
truncate table STG.Orders
truncate table STG.Inventory
truncate table STG.Sales
truncate table STG.Staff
truncate table STG.Store
truncate table STG.Customer
truncate table STG.conf_Table


SELECT  * 
FROM Orders, STG.Conf_Table
where table_name='Orders'
and LastUpdate > last_extract_date;
