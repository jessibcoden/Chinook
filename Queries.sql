USE [Chinook]
GO

--1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.:

select c.FirstName + ' ' + LastName Customer , CustomerId ID, Country 
	From Customer c
	where c.Country != 'USA'

--2. Provide a query only showing the Customers from Brazil.:

select c.FirstName + ' ' + LastName Brazilians
	from Customer c
	where c.Country = 'Brazil' 

--3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.:

select c.FirstName + ' ' + LastName Brazilians, i.InvoiceId, i.InvoiceDate, i.BillingCountry
	from Customer c
	inner join Invoice i on i.CustomerId = c.CustomerId
	where c.Country = 'Brazil'

--4. Provide a query showing only the Employees who are Sales Agents.:

select e.FirstName + ' ' + e.LastName  "Sales Agents"
	from Employee e
	where e.Title like 'Sales % Agent'

--5. Provide a query showing a unique/distinct list of billing countries from the Invoice table.

select distinct BillingCountry
	from Invoice

--6. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.

select e.FirstName + ' ' + e.LastName "Sales Agent", i.InvoiceId
	from Customer c
	inner join Invoice i on c.CustomerId = i.CustomerId
	inner join Employee e on c.SupportRepId = e.EmployeeId

--7. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.

select e.FirstName + ' ' + e.LastName "Sales Agent" , c.FirstName + ' ' + c.LastName Customer, c.Country, i.InvoiceId, i.Total
	from Customer c
	inner join Invoice i on c.CustomerId = i.CustomerId
	inner join Employee e on c.SupportRepId = e.EmployeeId

--8. How many Invoices were there in 2009 and 2011?

select count (i.InvoiceDate) [2009 & 2011 Invoice Count]
	from Invoice i
	where i.InvoiceDate like '%2009%' or i.InvoiceDate like '%2011%'

--9. What are the respective total sales for each of those years?

select Inv09.Total "2009 Invoice Count", Inv11.Total "2011 Invoice Count" 
	from 
	(select count (i.InvoiceDate) Total
		from Invoice i 
		where year (i.InvoiceDate) = 2009) Inv09
	join 
	(select count (i.InvoiceDate) Total
	from Invoice i 
	where year (i.InvoiceDate) = 2011) Inv11
	on Inv09.Total = Inv11.Total

--10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.

select count (il.InvoiceId) "Total Lines"
	from InvoiceLine il
	where il.InvoiceId = 37

--11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. 

select i.InvoiceId "Invoice", count (il.InvoiceId) "Total Lines"
	from InvoiceLine il
	inner join Invoice i on il.InvoiceId = i.InvoiceId
	group by i.InvoiceId 

--12. Provide a query that includes the purchased track name with each invoice line item.

select il.*, t.Name 
	from InvoiceLine il 
	inner join Track t 
	on il.TrackId = t.TrackId
	
--13. Provide a query that includes the purchased track name AND artist name with each invoice line item.
	
select il.*, t.Name, art.Name Artist
	from InvoiceLine il 
	inner join Track t on il.TrackId = t.TrackId
	inner join Album a on t.AlbumId = a.AlbumId
	inner join Artist art on a.ArtistId = art.ArtistId

--14. Provide a query that shows the # of invoices per country. 

select count (i.BillingCountry) "Invoice Count", i.BillingCountry
	from Invoice i
	group by i.BillingCountry

--15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.:

select count (plt.PlaylistId) "Track Count", pl.Name Playlist
	from PlaylistTrack plt
	inner join Playlist pl on pl.PlaylistId = plt.PlaylistId
	group by pl.Name

--16. Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.

select t.Name Track, al.Title Album, mt.Name Media, g.Name Gnere
	from Track t
	inner join MediaType mt on t.MediaTypeId = mt.MediaTypeId
	inner join Album al on t.AlbumId = al.AlbumId
	inner join Genre g on t.GenreId = g.GenreId

--17. Provide a query that shows all Invoices but includes the # of invoice line items.

select i.InvoiceId Invoice, count (il.InvoiceLineId) "Line Item Count"
	from Invoice i
	inner join InvoiceLine il on i.InvoiceId = il.InvoiceId
	group by i.InvoiceId

--18. Provide a query that shows total sales made by each sales agent.

select e.FirstName + ' ' + e.LastName "Rep Name", sum (i.Total) "Total Sales"
	from Invoice i
	inner join Customer c on i.CustomerId = c.CustomerId
	inner join Employee e on c.SupportRepId = e.EmployeeId
	group by e.FirstName + ' ' + e.LastName

--19. Which sales agent made the most in sales in 2009?

select top(1) e.FirstName + ' ' + e.LastName Agent, sum (i.Total) TotalSales
	from Invoice i
	inner join Customer c on i.CustomerId = c.CustomerId
	inner join Employee e on c.SupportRepId = e.EmployeeId
	where year (i.InvoiceDate) = 2009
	group by e.FirstName + ' ' + e.LastName
	order by TotalSales desc
	
--20. Which sales agent made the most in sales over all?
	
select top(1) e.FirstName + ' ' + e.LastName Agent, sum (i.Total) TotalSales
	from Invoice i
	inner join Customer c on i.CustomerId = c.CustomerId
	inner join Employee e on c.SupportRepId = e.EmployeeId
	group by e.FirstName + ' ' + e.LastName
	order by TotalSales desc

--21. Provide a query that shows the count of customers assigned to each sales agent.

select e.FirstName + ' ' + e.LastName Agent, count (c.CustomerId) "Customer Count"
	from Employee e
	inner join Customer c on e.EmployeeId = c.SupportRepId
	group by e.FirstName + ' ' + e.LastName

--22. Provide a query that shows the total sales per country:

select i.BillingCountry Country, count (i.BillingCountry) "Sales Count"
	from Invoice i
	group by i.BillingCountry

--23. Which country's customers spent the most?

select TOP(1) c.Country, sum (i.Total) TotalSales
	from Invoice i
	inner join Customer c on i.CustomerId = c.CustomerId
	group by c.Country
	order by TotalSales desc

--24. Provide a query that shows the most purchased track of 2013

select TOP(1) t.Name, sum (il.TrackId * il.Quantity) "Total Sold"
	from InvoiceLine il
	inner join Track t on il.TrackId = t.TrackId
	inner join Invoice i on il.InvoiceId = i.InvoiceId
	where year (i.InvoiceDate) = 2013 
	group by t.Name
	order by "Total Sold" desc

--25. Provide a query that shows the top 5 most purchased songs:

select TOP(5) t.Name, sum (il.InvoiceLineId) "Total Sold"
	from InvoiceLine il
	inner join Track t on il.TrackId = t.TrackId
	inner join Invoice i on il.InvoiceId = i.InvoiceId
	group by t.Name
	order by "Total Sold" desc

--26. Provide a query that shows the top 3 best selling artists:

select top (3) a.Name, sum (il.UnitPrice * il.Quantity) TotalSales
	from Album al
	inner join Artist a on al.ArtistId = a.ArtistId
	inner join Track t on al.AlbumId = t.AlbumId 
	inner join InvoiceLine il on t.TrackId = il.TrackId
	group by a.Name
	order by TotalSales desc

--27. Provide a query that shows the most purchased Media Type.:

select mt.Name MediaType, count (il.Quantity) Downloads
	from Track t
	inner join MediaType mt on t.MediaTypeId = mt.MediaTypeId
	inner join InvoiceLine il on il.TrackId = t.TrackId
	group by mt.Name
	order by Downloads desc
	

	 







	

	

