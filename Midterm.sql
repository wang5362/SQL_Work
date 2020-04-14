/* Exam Midterm.sql */
/* Jackie Wang */

/* Question 1: After you successfully extract the 
needed files (see exam instructions), start Toad, 
create a new database named exam1_db (or similar), 
and make sure its active. Use the code below to 
create Customer and Orders tables. */
CREATE TABLE Customer
(CustomerID 	INTEGER,
FirstName 		VARCHAR(20)		NOT NULL,
LastName 		VARCHAR(20)		NOT NULL,
Address 		VARCHAR(50),
City 			VARCHAR(30),
State 			CHAR(2),
Zip 			CHAR(5),
Phone 			CHAR(12),
CONSTRAINT PKCustomer PRIMARY KEY (CustomerID)
);

CREATE TABLE Orders
(OrderID 		INTEGER,
CustomerID 		INTEGER 		NOT NULL,
OrderDate 		DATE 			NOT NULL,
CONSTRAINT PKOrders PRIMARY KEY (OrderID),
CONSTRAINT FKCustomer FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
)

/* Question 2: Create Product table with three columns 
(all required) of appropriate data type shown in the 
Product sheet in in Exam1_Data.xlsx Excel data file. Make 
sure to designate the primary and foreign keys (if any). */

CREATE TABLE Product 
(ProductID 		INTEGER,
ItemName 		VARCHAR(20) NOT NULL,
Price			Double,
CONSTRAINT PKProduct PRIMARY KEY (ProductID)

);



/* Question 3: Create OrderDetail table with three columns 
(all required) of appropriate data type shown in the 
OrderDetail sheet in Exam1_Data.xlsx Excel data file. Make 
sure to designate the primary and foreign keys (if any). */


CREATE TABLE OrderDetail
(OrderID 		INTEGER NOT NULL,
ProductID 		INTEGER NOT NULL,
Quantity 		INTEGER ,

CONSTRAINT PKOrderDetail PRIMARY KEY (OrderID,ProductID),

CONSTRAINT FKOrders FOREIGN KEY (OrderID) REFERENCES  Orders(OrderID),
CONSTRAINT FKProduct FOREIGN KEY (ProductID) REFERENCES Product(ProductID)

);




/* Question 4: Import the data into each of the four tables 
using the Exam1_Data.xlsx Excel data file. All the data is 
clean, so you won’t have to do any edits or modifications.
There is no code to write in this question */

-- Done !!!

/* Question 5: List customer last name, first name, city, 
state, zip and order dates for orders placed in the first 
three months of 2029 for customers in Alabama and Georgia, 
sorted by last name. You must use INNER JOIN operator style. */

SELECT Customer.FirstName AS CustFirst,  
  Customer.LastName AS CustLast, City, State, Zip, OrderDate
FROM Customer INNER JOIN Orders 
	ON Customer.CustomerID=Orders.CustomerID
WHERE OrderDate BETWEEN '2029-01-01' AND '2029-03-31'
AND (State='AL' OR State='GA')
ORDER BY CustLast



/* Question 6: List the customer last name, first name, 
address, city, state and phone for customers who live 
on a street or a drive, and who’s phone numbers begin 
with 404 or 770 area codes, sorted by last name. */


SELECT Customer.LastName AS CustLast, Customer.FirstName AS CustFirst, Address,	City, State, Phone
FROM Customer 
WHERE (Address LIKE '%St%' OR Address LIKE '%Dr.%') AND (Phone LIKE "404%" OR Phone LIKE "770%")
ORDER BY CustLast


/* Question 7: List the customer last name, first name, 
and state for customers from Florida and Georgia whose 
orders have line items with more than 100 units in 2030. 
Remove duplicate rows from the result and sort by customer 
last name. You must use INNER JOIN operator style. */

SELECT DISTINCT Customer.LastName AS CustLast, Customer.FirstName AS CustFirst, State
FROM Customer INNER JOIN Orders ON Customer.CustomerID=Orders.CustomerID
	INNER JOIN OrderDetail ON Orders.OrderID = OrderDetail.OrderID
WHERE (State='FL' OR State='GA') 
AND Quantity>100 
AND year(OrderDate) =2030 
ORDER BY CustLast


/* Question 8: List the customer last name, first name, 
and zip code, as well as order date and product name 
for customers from zip codes that begin with 30 who 
ordered deluxe combos or fresh tomatoes during the 
second half of 2029, sorted by last name. You must use 
INNER JOIN operator style. */

SELECT  Customer.LastName AS CustLast, Customer.FirstName AS CustFirst, Zip, OrderDate, ItemName
FROM  Customer INNER JOIN Orders ON Customer.CustomerID=Orders.CustomerID
	INNER JOIN OrderDetail ON Orders.OrderID = OrderDetail.OrderID
		INNER JOIN Product ON OrderDetail.ProductID=Product.ProductID
WHERE Zip LIKE '30%'
AND (ItemName ='Deluxe Combo' OR ItemName='Fresh Tomatoes')
AND (OrderDate BETWEEN '2029-07-01' AND '2029-12-31')
ORDER BY CustLast

SELECT LastName, FirstName, Zip, Orders.OrderDate, ItemName 
FROM ((Customer INNER JOIN Orders ON Customer.CustomerID = Orders.CustomerID)
	INNER JOIN Orderdetail ON Orders.OrderID = Orderdetail.OrderID)
	INNER JOIN Product ON Orderdetail.ProductID = Product.ProductID
WHERE Zip LIKE '30%' AND ItemName = 'Deluxe Combo' OR ItemName = 'Fresh Tomatoes'
	AND Orders.OrderDate BETWEEN '2029-6-1' AND '2029-12-31'
GROUP BY LastName



/* Question 9: List the customer last name, product name 
and the total order amount (sum of the product price times 
the number of units), during the first ten days of June of 
2030, sorted by last name and product name. You must use 
INNER JOIN operator style. */

SELECT  Customer.LastName AS CustLast, ItemName, SUM(Price*Quantity) AS TotalOrderAmt	
FROM  Customer INNER JOIN Orders ON Customer.CustomerID=Orders.CustomerID
	INNER JOIN OrderDetail ON Orders.OrderID = OrderDetail.OrderID
		INNER JOIN Product ON OrderDetail.ProductID=Product.ProductID
WHERE OrderDate BETWEEN '2030-06-01' AND '2030-06-10'
GROUP BY Customer.LastName,ItemName
ORDER BY Customer.LastName, ItemName






/* Question 10: List the customer last name and the 
total order amount (sum of the product price times 
the number of units), during the first half of 2030, 
sorted by the total order amount descending, but only 
for those customers that ordered more than $20,000 
worth of products. You must use INNER JOIN operator style. */

SELECT  Customer.LastName AS CustLast, SUM(Price*Quantity) AS TotalOrderAmt
FROM  Customer INNER JOIN Orders ON Customer.CustomerID=Orders.CustomerID
	INNER JOIN OrderDetail ON Orders.OrderID = OrderDetail.OrderID
		INNER JOIN Product ON OrderDetail.ProductID=Product.ProductID
WHERE OrderDate BETWEEN '2030-01-01' AND '2030-06-30'
GROUP BY Customer.LastName
HAVING TotalOrderAmt> 20000
ORDER BY TotalOrderAmt DESC 


 