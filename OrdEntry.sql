/* JackieWang_ MySQL3_OrdEntry.sql */

-- Problem_01: List the customer number, customer name (first and last), the sum of the quantity of products ordered, 
-- and the total order amount (sum of the product price times the quantity) for orders placed in January 2030. 
-- Only include products in which the product name contains the string Ink Jet or Laser. Only include the customers 
-- who have ordered more than two Ink Jet or Laser products in January 2030.

SELECT Customer.CustNo, CustFirstName, CustLastName, sum(Qty) AS SumofQty, sum(ProdPrice*Qty) AS TotalOrderAmt
FROM Customer, OrderTbl, OrderLine,Product
WHERE Customer.CustNo=OrderTbl.CustNo AND OrderTbl.OrdNo=OrderLine.OrdNo AND OrderLine.ProdNo=Product.ProdNo
AND OrdDate LIKE '2030-01-%'
AND (ProdName LIKE '%Ink Jet%' OR  ProdName LIKE '%Laser%') 
GROUP BY Customer.CustNo
HAVING SUM(QTY)> 2

-- Problem_02: List the product number, product name, sum of the quantity of products ordered, and total order amount 
-- (sum of the product price times the quantity) for orders placed in January 2030. Only include products that have 
-- more than five products ordered in January 2030. Sort the result in descending order of the total amount.

SELECT OrderLine.ProdNo, ProdName, sum(Qty) AS SumofQty, sum(ProdPrice*Qty) AS TotalOrderAmt
FROM  OrderLine,Product,OrderTbl
WHERE OrderTbl.OrdNo=OrderLine.OrdNo AND OrderLine.ProdNo=Product.ProdNo  
AND OrdDate LIKE '2030-01-%'
GROUP BY OrderLine.ProdNo
HAVING SumofQty> 5
ORDER BY TotalOrderAmt DESC 

-- Problem_03: List the order number, the order date, the customer number, the customer name (first and last), 
-- the customer state, and the shipping state (OrdState) in which the customer state differs from shipping state.

SELECT OrdNo, OrdDate, Customer.CustNo,CustFirstName, CustLastName,CustState,OrdState
FROM Customer, OrderTbl
WHERE Customer.CustNo = OrderTbl.CustNo 
AND CustState != OrdState



-- Problem_04: List the employee number, the employee name (first and last), the commission rate, 
-- the supervising employee name (first and last), and the commission rate of the supervisor.

  
SELECT Reg.EmpNo, Reg.EmpFirstName, Reg.EmpLastName, Reg.EmpCommRate,
		 Sup.EmpFirstName AS SupFirstName ,Sup.EmpLastName AS SupLastName , Sup.EmpCommRate AS SupCommRate
FROM Employee Reg, Employee Sup
WHERE Reg.SupEmpNo= Sup.EmpNo




-- Problem_05: List the employee number, the employee name (first and last), and total amount of commissions on orders 
-- taken in January 2030. The amount of a commission is the sum of the dollar amount of products ordered times the 
-- commission rate of the employee.

SELECT Employee.EmpNo, EmpFirstName, EmpLastName, Sum(ProdPrice*Qty*EmpCommRate) AS TotalAmtOfComm
FROM Employee,OrderTbl,OrderLine,Product
WHERE Employee.EmpNo= OrderTbl.EmpNo AND OrderTbl.OrdNo=OrderLine.OrdNo AND OrderLine.ProdNo=Product.ProdNo
AND OrdDate LIKE '2030-01-%'
GROUP BY Employee.EmpNo

-- Problem_06: Using join operator style, list the product name and the price of all products 
-- ordered by Beth Taylor in January 2030. Remove duplicate rows from the result.

SELECT DISTINCT ProdName, ProdPrice
FROM ((Customer INNER JOIN  OrderTbl ON Customer.CustNo=OrderTbl.CustNo)
INNER JOIN OrderLine ON OrderTbl.OrdNo=OrderLine.OrdNo)
INNER JOIN Product ON OrderLine.ProdNo=Product.ProdNo
WHERE CustFirstName = 'Beth' AND CustLastName = 'Taylor'
AND OrdDate LIKE '2030-01-%'

-- Problem_07: For Colorado customers, compute the number of orders placed in January 2030 in which the orders contain 
-- products made by Connex. The result should include the customer number, last name, and the number of orders placed 
-- in January 2030.

SELECT Customer.CustNo, CustLastName,COUNT(OrderLine.OrdNo) AS 'Num Of Order'
FROM Customer, OrderTbl, OrderLine,Product
WHERE Customer.CustNo=OrderTbl.CustNo 
AND OrderTbl.OrdNo=OrderLine.OrdNo 
AND OrderLine.ProdNo=Product.ProdNo
AND CustState='CO' 
AND OrdDate LIKE '2030-01-%'
AND ProdMfg='Connex'
GROUP BY Customer.CustNo


-- Problem_08: For each employee with a commission rate of less than 0.04, compute the number of orders taken in January 2030. 
-- The result should include the employee number, employee last name, and number of orders taken.


SELECT OrderTbl.EmpNo, EmpLastName, COUNT(OrdNo) AS NumOfOrder
FROM OrderTbl, Employee
WHERE OrderTbl.EmpNo= Employee.EmpNo
AND EmpCommRate <0.04 
AND OrdDate LIKE '2030-01-%'
GROUP BY OrderTbl.EmpNo

-- Problem_09: For each employee with commission rate greater than 0.03, compute the total commission earned from orders 
-- taken in January 2030. The total commission earned is the total order amount times the commission rate. The result should 
-- include the employee number, employee last name, and the total commission earned.

SELECT OrderTbl.EmpNo, EmpLastName, SUM(Qty*prodprice* EmpCommRate) AS TotalCommEarned
FROM OrderTbl, Employee,Orderline,Product
WHERE OrderTbl.EmpNo= Employee.EmpNo
AND OrderTbl.OrdNo=Orderline.OrdNo
And OrderLine.ProdNo=Product.ProdNo
AND EmpCommRate > 0.03
AND OrdDate LIKE '2030-01-%'
GROUP BY OrderTbl.EmpNo


-- Problem_10: Insert yourself as a new row in the Customer table, and your roommate or 
-- best friend as a new row in the Employee table.

INSERT INTO Customer(CustNo, CustFirstName, CustLastName, CustCity, CustState,
  CustZip, CustBal)
VALUES('C0000000', 'Jackie', 'Wang', 'Minneapolis', 'MN', '55444-0000', 999.99);


INSERT INTO Employee(EmpNo, EmpFirstName, EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail)
Values ('E1111111','Josh', 'Westphalm', '(612) 000-0000','22222222',0.99, 'joshNoEmailGiven@gmail.com');


-- Problem_11: Insert a new OrderTbl row with you as the customer, your roommate/best friend as the employee, 
-- and your choice of values for the other columns of the OrderTbl table. Insert two rows in OrderLine table 
-- corresponding to the new OrderTbl row.
-- SET FOREIGN_KEY_CHECKS=0


INSERT INTO OrderTbl(OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip)
VALUES('O3333333','2018-02-14','C0000000','E1111111','Jackie Wang','111 NoturningBack St.','Minneapolis','MN',55444-0000);

INSERT INTO OrderLine(OrdNo,ProdNo,Qty)
VALUES ('O3333333', 'P4444444',100);

INSERT INTO OrderLine(OrdNo,ProdNo,Qty)
VALUES ('O3333333', 'P5555555',100);


-- Problem_12: Delete your order placed in problem 11. What happened to corresponding order lines?
-- Delete yourself and your roommate/best friend from the appropriate tables.
-- SET FOREIGN_KEY_CHECKS=0

DELETE FROM OrderTbl
WHERE OrdNo ='O3333333';

DELETE FROM Customer
WHERE CustNo='C0000000';

DELETE FROM Employee
WHERE EmpNo='E1111111';


##EXPLANATION##
-- The two corresponding orderlines still exist in the ORDERLINE Table becasue we didn't set ON DELETE CASCADE,
-- but there is no corresponding ORDER ,CUSTOMER, EMPLOYEE.