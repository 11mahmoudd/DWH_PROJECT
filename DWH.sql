create schema DWH



CREATE TABLE DWH.D_Date (
   [DateKey] [int] NOT NULL,
   [Date] [date] NOT NULL,
   [Day] [tinyint] NOT NULL,
   [DaySuffix] [char](2) NOT NULL,
   [Weekday] [tinyint] NOT NULL,
   [WeekDayName] [varchar](10) NOT NULL,
   [WeekDayName_Short] [char](3) NOT NULL,
   [WeekDayName_FirstLetter] [char](1) NOT NULL,
   [DOWInMonth] [tinyint] NOT NULL,
   [DayOfYear] [smallint] NOT NULL,
   [WeekOfMonth] [tinyint] NOT NULL,
   [WeekOfYear] [tinyint] NOT NULL,
   [Month] [tinyint] NOT NULL,
   [MonthName] [varchar](10) NOT NULL,
   [MonthName_Short] [char](3) NOT NULL,
   [MonthName_FirstLetter] [char](1) NOT NULL,
   [Quarter] [tinyint] NOT NULL,
   [QuarterName] [varchar](6) NOT NULL,
   [Year] [int] NOT NULL,
   [MMYYYY] [char](6) NOT NULL,
   [MonthYear] [char](7) NOT NULL,
   [IsWeekend] BIT NOT NULL,
   [IsHoliday] BIT NOT NULL,
   [HolidayName] VARCHAR(20) NULL,
   [SpecialDays] VARCHAR(20) NULL,
   [FinancialYear] [int] NULL,
   [FinancialQuater] [int] NULL,
   [FinancialMonth] [int] NULL,
   [FirstDateofYear] DATE NULL,
   [LastDateofYear] DATE NULL,
   [FirstDateofQuater] DATE NULL,
   [LastDateofQuater] DATE NULL,
   [FirstDateofMonth] DATE NULL,
   [LastDateofMonth] DATE NULL,
   [FirstDateofWeek] DATE NULL,
   [LastDateofWeek] DATE NULL,
   [CurrentYear] SMALLINT NULL,
   [CurrentQuater] SMALLINT NULL,
   [CurrentMonth] SMALLINT NULL,
   [CurrentWeek] SMALLINT NULL,
   [CurrentDay] SMALLINT NULL,
   PRIMARY KEY CLUSTERED ([DateKey] ASC)
);


 --(DT_I4)(REPLACE(LEFT((DT_WSTR,50)(DT_DBTIMESTAMP)order_date,10),"-",""))

 --(DT_I4)(REPLACE(LEFT((DT_WSTR,50)(DT_DBTIMESTAMP)create_timestamp,10),"-",""))


 SET NOCOUNT ON

DECLARE @CurrentDate DATE = '2010-01-01'
DECLARE @EndDate DATE = '2030-12-31'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO DWH.D_Date (
      [DateKey],
      [Date],
      [Day],
      [DaySuffix],
      [Weekday],
      [WeekDayName],
      [WeekDayName_Short],
      [WeekDayName_FirstLetter],
      [DOWInMonth],
      [DayOfYear],
      [WeekOfMonth],
      [WeekOfYear],
      [Month],
      [MonthName],
      [MonthName_Short],
      [MonthName_FirstLetter],
      [Quarter],
      [QuarterName],
      [Year],
      [MMYYYY],
      [MonthYear],
      [IsWeekend],
      [IsHoliday],
      [FirstDateofYear],
      [LastDateofYear],
      [FirstDateofQuater],
      [LastDateofQuater],
      [FirstDateofMonth],
      [LastDateofMonth],
      [FirstDateofWeek],
      [LastDateofWeek]
      )
   SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      [DaySuffix] = CASE 
         WHEN DAY(@CurrentDate) = 1
            OR DAY(@CurrentDate) = 21
            OR DAY(@CurrentDate) = 31
            THEN 'st'
         WHEN DAY(@CurrentDate) = 2
            OR DAY(@CurrentDate) = 22
            THEN 'nd'
         WHEN DAY(@CurrentDate) = 3
            OR DAY(@CurrentDate) = 23
            THEN 'rd'
         ELSE 'th'
         END,
      WEEKDAY = DATEPART(dw, @CurrentDate),
      WeekDayName = DATENAME(dw, @CurrentDate),
      WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)),
      WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1),
      [DOWInMonth] = DAY(@CurrentDate),
      [DayOfYear] = DATENAME(dy, @CurrentDate),
      [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [Month] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [Year] = YEAR(@CurrentDate),
      [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
            OR DATENAME(dw, @CurrentDate) = 'Saturday'
            THEN 1
         ELSE 0
         END,
      [IsHoliday] = 0,
      [FirstDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-01-01' AS DATE),
      [LastDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-12-31' AS DATE),
      [FirstDateofQuater] = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0),
      [LastDateofQuater] = DATEADD(dd, - 1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) + 1, 0)),
      [FirstDateofMonth] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)) + '-01' AS DATE),
      [LastDateofMonth] = EOMONTH(@CurrentDate),
      [FirstDateofWeek] = DATEADD(dd, - (DATEPART(dw, @CurrentDate) - 1), @CurrentDate),
      [LastDateofWeek] = DATEADD(dd, 7 - (DATEPART(dw, @CurrentDate)), @CurrentDate)

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END


CREATE TABLE DWH.D_Customer
(
    customer_key int identity(1,1) PRIMARY KEY,
	src_id  int,
	first_name   varchar(20) NOT NULL,
	last_name    varchar(20) NOT NULL,
	email        varchar(50) NOT NULL,
	address      varchar(100) NOT NULL,
	city         varchar(30) NOT NULL,
	phone        varchar(15) NOT NULL,
	is_last	   bit NOT NULL,
	create_timestamp	datetime,
	update_timestamp  datetime

);


create table DWH.D_City
(
	city_key int identity(1,1) PRIMARY KEY,
	src_id int  NOT NULL,
	city_name varchar(30)  NOT NULL,
	city_taxes decimal(5,2)  NOT NULL,
    create_timestamp	  datetime
);	


CREATE TABLE DWH.D_Product
(
	product_key			 int identity(1,1) PRIMARY KEY,
	src_id				 int  NOT NULL,
	product_name         varchar(50) NOT NULL,
	supplier_name        varchar(20) NOT NULL,
	price                decimal(10, 2) NOT NULL,
	is_last				 bit NOT NULL,
	update_timestamp     datetime,
	create_timestamp	 datetime
);

CREATE TABLE DWH.D_Store
(
	store_key			int identity(1,1) PRIMARY KEY,
	src_id              int NOT NULL,
	address             varchar(100) NOT NULL,
	city                varchar(30) NOT NULL,
	phone               varchar(15) NOT NULL,
	manager_first_name  varchar(20) NOT NULL,
	manager_last_name   varchar(20) NOT NULL,
	is_last bit NOT NULL,
	update_timestamp     datetime,
	create_timestamp	  datetime
);


create table DWH.D_Staff
(
	staff_key int identity(1,1) PRIMARY KEY,
	src_id  int,
	first_name   varchar(20) NOT NULL,
	last_name    varchar(20) NOT NULL,
	phone        varchar(15) NOT NULL,
	email        varchar(50) NOT NULL,
	address      varchar(100) NOT NULL,
	city         varchar(30) NOT NULL,
	store_id	int  NOT NULL,
	active bit NOT NULL,
	is_last bit NOT NULL,
	update_timestamp datetime,
	create_timestamp	datetime
)


create  table DWH.D_Orders
(
	order_key  int identity(1,1) PRIMARY KEY,
	src_id int  NOT NULL,
	customer_id int NOT NULL,
	store_id int NOT NULL,
	product_id int NOT NULL,
	customer_first_name varchar(20) NOT NULL,
	customer_last_name varchar(20) NOT NULL,
	customer_contact varchar(15) NOT NULL,
	store_address varchar(100) NOT NULL,
	shipping_address varchar(100) NOT NULL,
	quantity_sold int NOT NULL,
	unit_price decimal(10,2) NOT NULL,
	total_amount decimal(10,2) NOT NULL,
	payment_method varchar(20) NOT NULL,
	order_date date NOT NULL,
	is_last bit NOT NULL,
	update_timestamp		datetime,
	create_timestamp	datetime
)


create table DWH.F_Inventory
(
	inventory_key		int IDENTITY(1,1) PRIMARY KEY,
	date_key			int REFERENCES DWH.D_Date(DateKey) NOT NULL,
	store_key			int REFERENCES DWH.D_Store(store_key) NOT NULL,
	product_key			int REFERENCES DWH.D_Product(product_key) NOT NULL,
	stock				int NOT NULL,
	store_address		varchar(100) NOT NULL,
	product_price		decimal(10,2) NOT NULL,
	supplier_name        varchar(20) NOT NULL,
	create_timestamp	datetime
);


create table DWH.F_Staff_Attendance
(
	staff_fact_key int IDENTITY(1,1) PRIMARY KEY ,
	date_key int REFERENCES DWH.D_Date(DateKey) NOT NULL,
	staff_key int  REFERENCES DWH.D_Staff(staff_key) NOT NULL,
	store_key int  REFERENCES DWH.D_Store(store_key) NOT NULL,
	first_name   varchar(20) NOT NULL,
	last_name    varchar(20) NOT NULL,
	store_address	varchar(100) NOT NULL,
	active bit NOT NULL,
	create_timestamp	datetime
)

create table DWH.F_Sales
(
	sales_key		 int IDENTITY(1,1) PRIMARY KEY,
	date_key		 int REFERENCES DWH.D_Date(DateKey) NOT NULL,
    customer_key	 int REFERENCES DWH.D_Customer(customer_key) NOT NULL,
	product_key		 int REFERENCES DWH.D_Product(product_key) NOT NULL,
	store_key		 int REFERENCES DWH.D_Store(store_key) NOT NULL,
	order_key		 int REFERENCES DWH.D_Orders(order_key) NOT NULL,
	city_key		 int REFERENCES DWH.D_City(city_key) NOT NULL,
	quantity_sold int NOT NULL,
	unit_price decimal(10,2) NOT NULL,
	total_sales decimal(10,2) NOT NULL,
	taxes decimal(5,2) NOT NULL,
	net_sales decimal(10,2) NOT NULL,
    create_timestamp	datetime
)




select * from DWH.D_Staff
select * from DWH.D_Store
select * from DWH.D_Customer
select * from DWH.D_City
select * from DWH.D_Product
select * from DWH.D_Orders

select * from DWH.F_Staff_Attendance
select * from DWH.F_Inventory
select * from DWH.F_Sales


drop table DWH.F_Sales
drop table DWH.F_Inventory
drop  table DWH.F_Staff_Attendance

truncate table DWH.D_City
truncate table DWH.D_Product
truncate table DWH.D_Orders
truncate table DWH.D_Staff
truncate table DWH.D_Store
truncate table DWH.D_Customer

truncate table DWH.F_Staff_Attendance
truncate table DWH.F_Inventory
truncate table DWH.F_Sales



drop table DWH.D_City
drop table DWH.D_Product
drop table DWH.D_Orders
drop table DWH.D_Staff
drop table DWH.D_Store
drop table DWH.D_Customer

