CREATE DATABASE CinemaDb

USE CinemaDb

--Movie-----------------------------------------------------------------
CREATE TABLE Movie(
	movieId int primary key identity,
	filmName nvarchar(100) NOT NULL,
	filmGenre nvarchar(100) NOT NULL
);

INSERT INTO Movie
VALUES ('Schindlers List','Drama History Biography'),
('Pulp Fiction','Drama Crime'),
('Forrest Gump','Drama Romance'),
('Fight Club','Drama'),
('3 Idiots','Comedy Drama'),
('The Pianist','Drama Music Biography')


--Theatre-----------------------------------------------------------------
CREATE TABLE Theatre(
	cinemaId int primary key identity,
	cinemaName nvarchar(100) NOT NULL,
);

INSERT INTO Theatre
VALUES ('Alamo Drafthouse in Austin' ),
('Cineteca Matadero in Madrid'),
('Cine-de Chef in Kathmandu')

--ShowTime-----------------------------------------------------------------
CREATE TABLE ShowTime(
	showTimeId int primary key identity,
	movieID int foreign key references Movie(movieId) NOT NULL,
	cinemaID int foreign key references Theatre(cinemaId) NOT NULL,
	startTime datetime2 NOT NULL,
	endTime datetime2 NOT NULL
);

INSERT INTO ShowTime
VALUES ( 2 , 3 , '2022-06-23 07:30:20' , '2022-06-23 09:30:00' ),
( 5 , 1 , '2023-07-23 17:30:20' , '2023-07-23 17:30:00' ),
 ( 1 , 2 , '2023-07-23 17:30:20' , '2023-07-23 17:30:00' ),
 ( 3 , 3 , '2023-08-23 18:30:20' , '2023-08-23 18:30:00' ),
 ( 5 , 1 , '2023-07-24 19:30:20' , '2023-07-24 19:30:00' ),
 ( 4 , 2 , '2023-07-23 20:30:20' , '2023-07-23 20:30:00' ),
 ( 6 , 3 , '2022-06-23 07:30:20' , '2022-06-23 09:30:00' )


--Customer-----------------------------------------------------------------
CREATE TABLE Customer(
	customerId int primary key identity,
	customerName nvarchar(100) NOT NULL,
	customerSurname nvarchar(100) NOT NULL
);
INSERT INTO Customer
VALUES ( 'Shahin' , 'Sherifzade' ),
( 'Tural' , 'Cavadzade' ),
( 'Ayxan' , 'Bayramli' ),
( 'Esref' , 'Bedelov' ),
( 'Eli' , 'Shukurlu' ),
( 'Seid' , 'Babazade' )

--Ticket-----------------------------------------------------------------
CREATE TABLE Ticket(
	ticketId int primary key identity,
	showTimeID int foreign key references ShowTime(showTimeId) NOT NULL,
	customerID int foreign key references Customer(customerId) ,
	Hallrow int check(Hallrow > = 0) NOT NULL,
	Hallcol int check(Hallcol >= 0) NOT NULL,
	price decimal(5,2) CHECK (price >= 0) NOT NULL,
	seatStatus nvarchar(100) DEFAULT 'available' NOT NULL
);
INSERT INTO Ticket
VALUES ( 2 , 3, 5 , 5,  9.99 , 'reserved'),
( 1 , 4 , 5 , 2, 10.00, 'reserved'),
( 4 , 2 , 7 , 3, 12.33, 'reserved'),
( 5 , 1 , 3 , 6, 20.00, 'reserved'),
( 6 , 6 , 9 , 1, 5.00, 'reserved'),
( 3 , 5 , 4 , 8, 7.80, 'reserved')

INSERT INTO Ticket (showTimeID,Hallrow,Hallcol,price)
VALUES ( 1 , 12 , 3,  9.99 ),
( 5 , 14 , 6,  12.50 ),
( 3 , 9 , 9,  4.99 ),
( 6 , 6 , 8,  7.99 )

--Reserved Tickets


CREATE VIEW [RESERVED_TICKETS]
AS
SELECT c.customerName , c.customerSurname , m.filmName , m.filmGenre , t.cinemaName , s.startTime , s.endTime , ti.Hallcol , ti.Hallrow  FROM ShowTime s
INNER JOIN Theatre t
ON s.cinemaID = t.cinemaId
INNER JOIN Movie m
ON s.movieID = m.movieId
INNER JOIN Ticket ti
ON s.showTimeId = ti.showTimeID
INNER JOIN Customer c
ON  c.customerId= ti.customerID

SELECT * FROM [RESERVED_TICKETS]

--Available Tickets

CREATE VIEW [AVAILABLE_TICKETS]
AS
SELECT  m.filmName , m.filmGenre , t.cinemaName , s.startTime , s.endTime , ti.Hallcol , ti.Hallrow , ti.seatStatus  FROM ShowTime s
INNER JOIN Theatre t
ON s.cinemaID = t.cinemaId
INNER JOIN Movie m
ON s.movieID = m.movieId
INNER JOIN Ticket ti
ON s.showTimeId = ti.showTimeID
WHERE ti.customerID IS NULL  

SELECT * FROM [AVAILABLE_TICKETS]


--INNER JOIN Customer c
--ON  c.customerId= ti.customerID
