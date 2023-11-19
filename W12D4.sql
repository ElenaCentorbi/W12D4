Create table Category (
IDCat int, 
CategoryName varchar(60),
CONSTRAINT PK_Product PRIMARY KEY (IDCat)
);

insert into Category
values
(1, 'Bike'),
(2,	'Clothes'),
(3,	'Swimming'),
(4,	'Skiing');

Create table Product (
IDProd Varchar(2), 
EnglishName varchar(50), 
IDCat int, 
Size Varchar(1), 
Price int,
CONSTRAINT PK_Product PRIMARY KEY (IDProd),
CONSTRAINT FK_IDCat_Product FOREIGN KEY (IDCat)
REFERENCES Category (IDCat)
);

Insert into Product
Values
('A1', 'Kids ST100 Mountain Bike',	1,	'L', 150),
('B2', 'Synthetic Mountain Trekking Hooded Padded Jacket', 2, 'L', 70),
('C3',	'Rockrider ST540 Mountain Bike 27.5', 1,'M',	300),
('D4', 'Swimming suit', 3, 'M', 30),
('E5', 'Freeride skis', 4, 'L', 420),
('F6','Short Sleeve Cycling Jersey', 2, 'S', 50),
('G7', 'Fins', 3,'S', 20),
('H8', 'FR900 MIPS Freeride Ski Helmet', 4,	'M', 68),
('I9', 'Surface Mask', 3, 'S', 30);

Create table Sale
(SalesOrderNumber varchar(10), 
OrderDate date, 
IDState varchar(4), 
IDProd varchar(2), 
OrderQuantity int, 
UnitPrice int, 
SalesAmount int,
CONSTRAINT PK_Sale PRIMARY KEY (SalesOrderNumber),
CONSTRAINT FK_IDProd_Sale FOREIGN KEY (IDProd)
REFERENCES Product (IDProd),
CONSTRAINT FK_IDState_Sale FOREIGN KEY (IDState)
REFERENCES State (IDState)
);

Create table State (
IDState varchar(3), 
StateName varchar (20), 
IDRegion varchar (3),
CONSTRAINT PK_State PRIMARY KEY (IDState),
CONSTRAINT FK_IDRegion_Region FOREIGN KEY (IDRegion)
REFERENCES Region (IDRegion)
);


Create table Region (
IDRegion varchar (3), 
RegionName varchar (15),
CONSTRAINT PK_Region PRIMARY KEY (IDRegion)
);

insert into Sale
values
('SO123', '2022-01-01', 'I', 'C3', 1, 300, 300),
('S0345', '2023-10-10','F', 'H8', 3, 68, 204),
('SO156', '2023-05-04', 'G', 'I9',	4,	30,	120),
('SO160', '2021-02-03',	'S', 'E5', 1, 420, 420),
('SO145', '2023-04-04', 'F', 'F6',	2, 50, 100);

Insert into State
values
('I', 'Italy', 'SE'),
('F', 'Francia', 'WE'),
('G', 'Germany', 'WE'),
('S', 'Spain','SE');


Insert into Region
values
('SE', 'SouthEur'),
('WE','WestEur');


Select IDProd
From Product
Group by IDProd
Having count(*) >1;

Select IDCat
From Category
Group by IDCat
Having count(*) >1;

Select IDState
From State
Group by IDState
having count(*) > 1;


Select IDRegion
From Region
Group by IDRegion
having count(*) > 1;

Select SalesOrderNumber
From Sale
group by SalesOrderNumber
having count(*) > 1;

Select EnglishName, Sum(SaleSAmount) as fatturato, Year(OrderDate) as anno
from Sale as S
inner join Product as P
on S.IDProd = P.IDProd
group by S.IDProd, year(OrderDate);

Select ST.StateName, Sum(SalesAmount) as fatturato, Year(OrderDate) 
From State as ST
Inner join Sale as SA
on ST.IDState = SA.IDState
Group By SA.IDState, Year(OrderDate)
Order by Year(OrderDate), Sum(SalesAmount) desc;

Select IDProd, EnglishName
from product as P
where IDProd not in (Select IDProd
					 From Sale
                     Group by IDProd);
                     
Select P.IDProd, EnglishName
From product as P
left join Sale as S
On P.IDProd = S.IDProd
where S.IDProd is null;

Select CategoryName, Count(SalesOrderNumber) as Conteggio
from Sale as S
Inner join product as P
on S.IDProd = P.IDProd
inner join Category as C
on P.IDCat = C.IDCat
Group by CategoryName
Order by Count(SalesOrderNumber) desc
limit 1;

Create view Prodotti as (
Select IDProd, EnglishName, CategoryName
from product as P
inner join Category as C
on P.IDCat = C.IDCat
);

select *
from Prodotti;

Create view Regione as (
Select IDState, StateName, RegionName
from State as S
join Region as R
on S.IDRegion = R.IDRegion
);

Select *
from regione;

Select S.IDProd, Sum(OrderQuantity) as QuantitàVenduta
from Sale as S
inner join Product as P
on S.IDProd = P.IDProd
Group by S.IDProd
having Sum(OrderQuantity) >= (Select avg(orderquantity) as Media
							 from sale
                             where year(orderdate) = (Select max(year(orderdate))
													  from sale)
							);

Select IDProd,
Case when DATEDIFF(CURDATE(), OrderDate) > 180 then 'True' else 'False' end AS passati_piu_di_180_giorni

From Sale;

Select SalesOrderNumber, OrderDate, EnglishName, CategoryName, StateName, RegionName,
Case when DATEDIFF(CURDATE(), OrderDate) > 180 then 'True' else 'False' end AS 'giorni>180'
from Category as C
inner join Product as P
On C.IDCat = P.IDCat
inner join Sale as S
on P.IDProd = S.IDProd
inner join State as ST
on S.IDState = ST.IDState
inner join Region as R
on ST.IDRegion = R.IDRegion
                            
                           