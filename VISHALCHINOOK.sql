--1.Find the artist who has contributed with the most albums. Display the artist name and the number of albums.
SELECT A.NAME, COUNT(AlbumId)AS TOTAL_ALB 
FROM Artist A
JOIN ALBUM AL ON A.ARTISTID = AL.ArtistId
GROUP BY A.NAME
ORDER BY TOTAL_ALB DESC;

--2.Display the name, email id, country of all listeners who love Jazz, Rock and Pop music.
SELECT DISTINCT C.FIRSTNAME + ' '+ C.LASTNAME AS 
NAME,C.EMAIL,C.COUNTRY FROM CUSTOMER C
JOIN Invoice I ON C.CustomerId = I.CustomerId
JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
JOIN TRACK T ON IL.TrackId = T.TrackId
JOIN Genre G ON T.GenreId  = G.GenreId
WHERE G.NAME IN ('JAZZ','ROCK','POP')

--3.Find the employee who has supported the most no of customers. Display the employee’s name and designation.
select TOP 1 e.lastname + ' ' + e.firstname as EMPLOYEENAME , COUNT(C.CUSTOMERID) AS [CUSTOMER SUPPORT COUNT] , E.TITLE FROM EMPLOYEE E
JOIN CUSTOMER C ON 
E.EMPLOYEEID =  C.SUPPORTREPID
GROUP BY E.LastName + ' ' + E.FirstName,E.TITLE
ORDER BY [CUSTOMER SUPPORT COUNT] DESC

--4.Which city corresponds to the best customers?
SELECT TOP 5 CITY, COUNT(CUSTOMERID) AS CUSTOMERCOUNT FROM CUSTOMER
GROUP BY CITY 
ORDER BY CUSTOMERCOUNT DESC

--5.The highest number of invoices belongs to which country?
SELECT TOP 1  BILLINGCOUNTRY, COUNT(INVOICEID) AS INVOICECOUNT FROM Invoice
GROUP BY BillingCountry
ORDER BY COUNT(INVOICEID) DESC

--6.Name the best customer (customer who spent the most money).
SELECT TOP 1 C.CUSTOMERID, C.FIRSTNAME + ' ' + C.LASTNAME AS CUSTOMERNAME , SUM(TOTAL) AS TOTAL_AM  FROM Customer C
JOIN Invoice I ON C.CUSTOMERID = I.CustomerId
GROUP BY C.CustomerId, C.FirstName + ' ' + C.LastName
ORDER BY SUM(TOTAL) DESC

--7.Suppose you want to host a rock concert in a city and want to know which location should host it.
SELECT I.BILLINGCITY, G.NAME AS GENRE, G.COUNT(NAME) AS ROCKTRACKSALES FROM GENRE G
JOIN TRACK T ON G.GenreId = T.GenreId
JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
JOIN Invoice I ON IL.InvoiceId = I.InvoiceId
GROUP BY G.Name, I.BillingCity
HAVING G.Name = 'ROCK'
ORDER BY ROCKTRACKSALES DESC

--8.Identify all the albums who have less than 5 tracks under them.
SELECT A.ALBUMID, COUNT(T.TRACKID) AS TRACKCOUNT  FROM Album A
JOIN Track T ON A.AlbumId = T.AlbumId
GROUP BY A.AlbumId
HAVING COUNT(T.TRACKID) <5 
ORDER BY TRACKCOUNT DESC;

--9.Display the track, album, artist and the genre for all tracks which are not purchased.
SELECT A.NAME, AL.TITLE, T.NAME , G.NAME FROM Artist A
JOIN Album AL ON  A.ArtistId = AL.ARTISTID
JOIN TRACK T ON AL.ALBUMID = T.AlbumId
JOIN GENRE G ON T.GENREID = G.GENREID
LEFT JOIN INVOICELINE IL ON T.TRACKID  =IL.TRACKID
WHERE IL.INVOICELINEID IS NULL

--10.Find artists who have performed in multiple genres. Display the artist name and the genre.
SELECT A.NAME AS ARTISTNAME ,G.NAME AS GENRENAME, COUNT(G.GenreId) AS GENRECOUNT FROM Artist A
JOIN Album AL ON A.ArtistId = AL.ArtistId
JOIN TRACK T ON AL.AlbumId = T.AlbumId
JOIN GENRE G ON T.GenreId = G.GenreId
GROUP BY A.NAME, G.NAME
HAVING COUNT(G.GENREID) >1

--11.Which is the most popular and least popular genre?
SELECT G.NAME AS GENRENAME, COUNT(G.GENREID) FROM Genre G
JOIN TRACK T ON G.GenreId = T.GenreId
JOIN InvoiceLine IL ON T.TrackId= IL.TrackId
GROUP BY G.NAME
ORDER BY COUNT(G.GENREID) DESC

--12.Identify if there are tracks more expensive than others.
SELECT NAME,UNITPRICE FROM Track
WHERE UnitPrice >(SELECT MIN(UNITPRICE) FROM Track)
ORDER BY UnitPrice DESC

--14.Find the artist who has contributed with the maximum number of songs/tracks.
SELECT TOP 1 A.NAME, COUNT(T.TRACKID) AS TRACKCOUNT FROM Artist A
JOIN ALBUM AL ON A.ArtistId = AL.ARTISTID
JOIN TRACK T ON AL.ALBUMID  = T.AlbumId
GROUP BY A.NAME
ORDER BY COUNT(TRACKID) DESC

--16.List all customers from Canada.
SELECT FIRSTNAME + ' ' + LASTNAME AS CUSTOMERSNAME FROM Customer
WHERE Country = 'CANADA'

--17.Get the names and emails of customers whose first name starts with 'A'.
SELECT FIRSTNAME, EMAIL FROM Customer
WHERE FIRSTNAME LIKE 'A%'

--18.Find all invoices where the total is more than $20.
SELECT INVOICEID, Total FROM Invoice
WHERE TOTAL >20

--19.List all customers along with the name of their support representative.
SELECT C.FIRSTNAME+ ' ' + C.LastName AS CUSTOMERNAME , E.FIRSTNAME + ' ' + E.LASTNAME AS EMPLOYEENAME FROM Customer C
JOIN Employee E ON C.SupportRepId = E.EmployeeId

--20.Get a list of tracks and the names of their artists.
SELECT T.TRACKID ,T.NAME AS TRACKNAME, A.NAME AS ARTISTNAME  FROM Artist A
JOIN Album AL ON A.ArtistId = AL.ArtistId
JOIN TRACK T ON AL.AlbumId = T.AlbumId

--21.Find the genre name for each track.
SELECT G.GENREID, G.NAME AS GENRENAME, T.NAME AS TRACKNAME FROM GENRE G
JOIN TRACK T ON G.GENREID = T.GENREID

--22.Find the total number of customers in each country.
SELECT COUNTRY,COUNT(CUSTOMERID) AS TOTAL_CUSTOMER FROM Customer C
GROUP BY Country
ORDER BY TOTAL_CUSTOMER DESC

--23.Get the top 3 countries by invoice total.
SELECT * FROM Invoice
SELECT TOP 3 BILLINGCOUNTRY,SUM(TOTAL) AS TOTALNAME  FROM Invoice 
GROUP BY BillingCountry
ORDER BY SUM(TOTAL) DESC

--24.Calculate the average track duration (in milliseconds) by genre.
SELECT G.NAME AS GENRENAME, AVG(MILLISECONDS) AS TRACKDURATION FROM GENRE G
JOIN TRACK T ON G.GenreId = T.GenreId
GROUP BY G.Name

--25.Find customers who have spent more than the average total invoice value.
SELECT C.CUSTOMERID, C.FIRSTNAME+ ' '+ C.LASTNAME AS CUSTOMERNAME, I.TOTAL FROM Customer C
JOIN Invoice I ON C.CustomerId = I.CustomerId
WHERE I.TOTAL > (SELECT AVG(TOTAL) FROM Invoice)
ORDER BY I.TOTAL DESC

--28.Find the running total of invoice amounts for each customer.
select  c.FirstName , sum(i.total) as totalamount,sum(sum(i.total)) over ( order by sum(i.total) desc) as runningtotal   from Customer c
join Invoice i on c.CustomerId = i.CustomerId
group by c.FirstName
order by totalamount desc

--29.Find the number of invoices per year.
SELECT * FROM Invoice
SELECT COUNT(INVOICEID) AS INVOICECOUNT, YEAR(INVOICEDATE) AS YEAR FROM Invoice
GROUP BY YEAR(INVOICEDATE)
ORDER BY COUNT(INVOICEID)

--30.Get the month with the highest number of invoices.
SELECT TOP 1  DATENAME(MONTH,INVOICEDATE) AS MONTH, COUNT(INVOICEID) INVOICECOUNT FROM INVOICE I
GROUP BY DATENAME(MONTH,INVOICEDATE)
ORDER BY COUNT(INVOICEID) DESC

--33.List the top-selling genre.
SELECT G.NAME,COUNT(I.INVOICELINEID) AS INVOIVE FROM GENRE G
JOIN TRACK T ON G.GenreId = T.GenreId
JOIN InvoiceLine I ON T.TrackId = I.TrackId
GROUP BY G.NAME
ORDER BY INVOIVE DESC