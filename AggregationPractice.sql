----------- AGGREGATION LAB --------------------
/*
-1. List out the customer name(Customers), order number(ORDERDETAIlS), and the order date(ORDER) for all orders where to
total of the order is greater than 90% of the largest order.
The order total is the sum of the quantity ordered * the price each for all the order details within a given order.
Remember that when you perform a group by you can only select out aggregate
function values, or columns that were in the group by.
Also remember that adding a column like customer name to a group by that
already has order number will not change the result since for each customer
there are several orders.
Returns 3 rows.
 */

SELECT customerName, o.orderNumber, orderDate,
        sum(QUANTITYORDERED*PRICEEACH) "ordertotal"
    FROM customers INNER JOIN orders o using (customerNumber)
        INNER JOIN orderdetails using(orderNumber)
        INNER JOIN ORDERS using (orderDate)
    GROUP BY customerName, o.orderNumber, orderDate HAVING SUM(QUANTITYORDERED*PRICEEACH) > 160000
    ORDER BY customerName, o.orderNumber, orderDate;


--2. For each office, report out the office code, city, state, country of
-- each of the customers who’s sales representative works in that office.
-- Only report city, state, and country for a given customer if there are more than one customer
-- in that city, state, and  country served by a sales representative from that office.
-- Be careful of the null states in your group by.
-- Order by the office code, the city, sate, and country of the customers.
-- Returns 12 rows.

SELECT o.officecode, c.city, COALESCE(c.state, 'N/A') AS state, c.country
    FROM offices o INNER JOIN employees e USING (officecode)
    INNER JOIN customers c ON e.employeenumber = c.salesrepemployeenumber
    GROUP BY o.officecode, c.city, c.state, c.country HAVING COUNT(salesrepemployeenumber) > 1
    ORDER BY o.officecode , c.city, c.state, c.country;

SELECT o.officeCode, c.city, c.state, c.country
    FROM offices o INNER JOIN employees e using (officeCode)
    INNER JOIN customers c using (salesRepEmployeeNumber)
GROUP BY o.officeCode, c.city, c.state, c.country
ORDER BY o.officeCode, c.city, c.state, c.country;


--3. For each product line, report out the total number of units of that product line that were ordered by month and year.
-- You cannot group by a function, but you can create an inline query that has the month number and year number of the order date.
-- Only report out those month/years for a given product line that have 1100 units ordered that month within that year.
-- Returns 23 rows.

/*
 WASN'T ABLE TO FIGURE OUT 3
 */



--4. For all the orders that were placed the same day as our very first order, list the order number, order date, the customer name,
-- and the number of days between the order date and the shipped date.  Derby does not provide a SQL function for date arithmetic per se.
-- But it does provide a function interface.  The SQL: select … {fn timestampdiff(SQL_TSI_DAY, <date expression 1>, <date expression 2>)} …
-- will return the number of days between the dates represented by date expression 1 and date expression 2.
-- Returns 1 row, but do not assume that in your code.


SELECT o.ordernumber, o.orderdate, c.customername, {fn timestampdiff(SQL_TSI_DAY, o.orderdate, o.shippeddate)} AS NumberOfDays
FROM orders o INNER JOIN customers c USING (customernumber)
    WHERE orderdate = ( SELECT MIN(orderdate) FROM orders o


);




--5. Marketing wants to find the hottest selling items overall.
-- For each product that has sold more than 1050 units overall across all orders, list the product name, the product code,
-- and the total number of units of that product every ordered.  List them in order of the total number of units sold, in descending order.
-- Returns 11 rows.

SELECT p.productName, p.productcode, SUM(quantityordered) AS total
FROM products p INNER JOIN orderdetails USING (productcode)
GROUP BY p.productName, p.productcode HAVING SUM(quantityordered) > 1050
ORDER BY total desc;


