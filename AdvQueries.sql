USE [Chinook]
GO

--1. Which	artists	did	not	make any	albums	at	all?	Include	their	names	in your	answer.

select * 
	from artist 
	where ArtistId not in (select ArtistId from Album)

--2. Which	artists	did	not	record	any	tracks	of	the	Latin	genre?

select a.Name "Non-Latin"
	from Artist a 
	inner join Album al on a.ArtistId = al.ArtistId
	inner join Track t on al.AlbumId = t.AlbumId
	right join Genre g on t.GenreId != g.GenreId
	where g.Name = 'Latin'
	group by a.Name

--3. Which	video track	has	the	longest	length?

select top (1) t.Name Title, t.Milliseconds, mt.Name
	from Track t
	inner join MediaType mt on t.MediaTypeId = mt.MediaTypeId
	where mt.Name like '%video%'
	order by t.Milliseconds desc

--4. Find the names	of customers who live in the same city	as	the	top	employee (The one not managed by anyone).

select c.FirstName + ' ' + c.LastName "Name"
	from Customer c 
	where City in (select City from Employee e where e.ReportsTo  is null)

--5. Find the managers of employees	supporting	Brazilian customers.

select e.FirstName + ' ' + e.LastName Manager
	from Employee e
	where e.EmployeeId in
	(select distinct e.ReportsTo  Manager
	from Employee e
	join Customer c on e.EmployeeId = c.SupportRepId
	where c.Country = 'Brazil') 
	 
--6. How many audio tracks in total	were bought	by	German	customers? And what	was	the	total price	paid for them?

select sum (il.Quantity) "Total Tracks", sum (il.UnitPrice * il.Quantity) "Total Price"
		from Track t
		inner join MediaType mt on t.MediaTypeId = mt.MediaTypeId
		inner join InvoiceLine il on t.TrackId = il.TrackId
		inner join Invoice i on il.InvoiceId = i.InvoiceId
		inner join Customer c on i.CustomerId = c.CustomerId
		where c.Country like '%germany%' and mt.Name like '%audio%'



		
	