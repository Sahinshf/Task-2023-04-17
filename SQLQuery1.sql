CREATE DATABASE CinemaDb

USE CinemaDb

--Movie-----------------------------------------------------------------
CREATE TABLE Movies(
	movieId int primary key identity,
	filmName nvarchar(100) NOT NULL,
);

INSERT INTO Movies
VALUES ('Schindlers List'),
('Pulp Fiction'),
('Forrest Gump'),
('Fight Club'),
('3 Idiots'),
('The Pianist')

--Genre------------------------------------------------------------------
CREATE TABLE Genres (
  genreId int primary key identity,
  genreName nvarchar(100) NOT NULL
);

INSERT INTO Genres
VALUES ('Drama') , ('Romance') , ('Music') , ('Biography') , ('Comedy') , ('Crime') , ('History')


--Movies Genre------------------------------------------------------------

CREATE TABLE MoviesGenres (
  movieID int NOT NULL,
  genreID int NOT NULL,
  constraint filmGenre_pk primary key (movieID, genreID),
  foreign key (movieID) references Movies(movieId),
  foreign key (genreID) references Genres(genreId)
);

INSERT INTO MoviesGenres
VALUES (1,1) , (1,4) , (1,7) , (2,1) , (2,6) , (3,1) , (3,2) , (4,1) , (5,1) , (5,5) , (6,1) , (6,3) , (6,4)


--Actor------------------------------------------------------------------
CREATE TABLE Actors (
  actorId int primary key identity,
  fullName nvarchar(100) NOT NULL,
);

INSERT INTO Actors
VALUES ('Liam Neeson') , ('Ralph Fiennes') , ('John Travolta') ,  ('Tom Hanks') , ('Brad Pitt') , ('Edward Norton') , ('Aamin Khan') , ('Adrien Brody')


--Actor Movies------------------------------------------------------------------
CREATE TABLE MoviesActors (
  movieID int,
  actorID int,
  constraint filmActor_pk primary key (movieID, actorID),
  foreign key (movieID) references Movies(movieId),
  foreign key (actorID) references Actors(actorId)
);

INSERT INTO MoviesActors
VALUES (1,1) , (1,2) ,  (2,3) , (3,4) ,  (4,5) , (4,6) , (5,7) , (6,8) 


--Hall-----------------------------------------------------------------
CREATE TABLE Halls (
  hallId int primary key identity,
  hallName nvarchar(100),
);

INSERT INTO Halls
VALUES ('HALL 1') , ('HALL 2') , ('HALL 3') , ('HALL 4') , ('HALL 5') , ('HALL 6') , ('HALL 7')

--ShowTime-----------------------------------------------------------------
CREATE TABLE ShowTimes(
	showTimeId int primary key identity,
	movieID int foreign key references Movies(movieId) NOT NULL,
	hallID int foreign key references Halls(hallId) NOT NULL,
	startTime datetime2 NOT NULL,
	endTime datetime2 NOT NULL
);

INSERT INTO ShowTimes
VALUES ( 2 , 3 , '2022-06-23 07:30:20' , '2022-06-23 09:30:00' ),
( 5 , 1 , '2023-07-23 17:30:20' , '2023-07-23 17:30:00' ),
 ( 1 , 2 , '2023-07-23 17:30:20' , '2023-07-23 17:30:00' ),
 ( 3 , 5 , '2023-08-23 18:30:20' , '2023-08-23 18:30:00' ),
 ( 5 , 5 , '2023-07-24 19:30:20' , '2023-07-24 19:30:00' ),
 ( 4 , 7 , '2023-07-23 20:30:20' , '2023-07-23 20:30:00' ),
 ( 6 , 6 , '2022-06-23 07:30:20' , '2022-06-23 09:30:00' )


--Customer-----------------------------------------------------------------
CREATE TABLE Customers(
	customerId int primary key identity,
	customerName nvarchar(100) NOT NULL,
	customerSurname nvarchar(100) NOT NULL
);
INSERT INTO Customers
VALUES ( 'Shahin' , 'Sherifzade' ),
( 'Tural' , 'Cavadzade' ),
( 'Ayxan' , 'Bayramli' ),
( 'Esref' , 'Bedelov' ),
( 'Eli' , 'Shukurlu' ),
( 'Seid' , 'Babazade' )

--Ticket-----------------------------------------------------------------
CREATE TABLE Tickets(
	ticketId int primary key identity,
	showTimeID int foreign key references ShowTimes(showTimeId) NOT NULL,
	customerID int foreign key references Customers(customerId) ,
	Hallrow int check(Hallrow > = 0) NOT NULL,
	Hallcol int check(Hallcol >= 0) NOT NULL,
	price decimal(5,2) CHECK (price >= 0) NOT NULL,
	seatStatus nvarchar(100) DEFAULT 'available' NOT NULL
);
INSERT INTO Tickets
VALUES ( 2 , 3, 5 , 5,  9.99 , 'reserved'),
( 1 , 4 , 5 , 2, 10.00, 'reserved'),
( 4 , 2 , 7 , 3, 12.33, 'reserved'),
( 5 , 1 , 3 , 6, 20.00, 'reserved'),
( 6 , 6 , 9 , 1, 5.00, 'reserved'),
( 3 , 5 , 4 , 8, 7.80, 'reserved')

INSERT INTO Tickets (showTimeID,Hallrow,Hallcol,price)
VALUES ( 1 , 12 , 3,  9.99 ),
( 5 , 14 , 6,  12.50 ),
( 3 , 9 , 9,  4.99 ),
( 6 , 6 , 8,  7.99 )

--Reserved Tickets


CREATE VIEW [RESERVED_TICKETS]
AS
SELECT c.customerName 'Name' , c.customerSurname 'Surname', m.filmName 'Movie', h.hallName 'Hall', s.startTime 'Start', s.endTime 'End' , ti.Hallcol 'Seat - Column' , ti.Hallrow 'Seat - Row' FROM ShowTimes s
INNER JOIN Halls h
ON s.hallID = h.hallId
INNER JOIN Movies m
ON s.movieID = m.movieId
INNER JOIN Tickets ti
ON s.showTimeId = ti.showTimeID
INNER JOIN Customers c
ON  c.customerId= ti.customerID

SELECT * FROM [RESERVED_TICKETS]

--Available Tickets

CREATE VIEW [AVAILABLE_TICKETS]
AS
SELECT  m.filmName 'Movie' , h.hallName 'Hall', s.startTime 'Start', s.endTime 'End' , ti.Hallcol 'Seat - Column', ti.Hallrow'Seat - Row' , ti.seatStatus 'Seat - Status' , ti.price 'Price' FROM ShowTimes s
INNER JOIN Halls h
ON s.hallID = h.hallId
INNER JOIN Movies m
ON s.movieID = m.movieId
INNER JOIN Tickets ti
ON s.showTimeId = ti.showTimeID
WHERE ti.customerID IS NULL  

SELECT * FROM [AVAILABLE_TICKETS]


--INNER JOIN Customer c
--ON  c.customerId= ti.customerID

--VALUES ('Schindlers List','Drama History Biography'),
--('Pulp Fiction','Drama Crime'),
--('Forrest Gump','Drama Romance'),
--('Fight Club','Drama'),
--('3 Idiots','Comedy Drama'),
--('The Pianist','Drama Music Biography')


--Theatre-----------------------------------------------------------------

--CREATE TABLE Theatres(
--	cinemaId int primary key identity,
--	cinemaName nvarchar(100) NOT NULL,
--);

--INSERT INTO Theatres
--VALUES ('Alamo Drafthouse in Austin' ),
--('Cineteca Matadero in Madrid'),
--('Cine-de Chef in Kathmandu')

--SELECT m.filmName , g.genreName FROM MoviesGenres ms
--join Genres g 
--ON g.genreId = ms.genreID
--join Movies m
--ON m.movieId = ms.movieID