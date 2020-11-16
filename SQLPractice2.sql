/*
1. For each product, report out the product name, the product code, the month, year, and
number of units of that product that was ordered in that month and year. Order by the product name,
month, and year. This will be the sum of the quantity ordered of that product across all orders within a
given month and year. Only show the products which received orders for 130 or more in the given month and year.
Order by the product name, month of the order, Returns 15 rows.
 */


SELECT p.productName, p.productCode, MONTH(orderDate) AS MONTH, YEAR(orderDate) AS yearOF, SUM(OD.quantityOrdered) AS total
       FROM PRODUCTS p
INNER JOIN ORDERDETAILS OD on p.productCode = OD.PRODUCTCODE
INNER JOIN orders o on OD.orderNumber =  o.orderNumber
GROUP BY p.productName, p.productCode, MONTH(orderDate), YEAR(orderDate)
HAVING SUM(OD.quantityOrdered) >= 130;


/*
The problem with the answer to the above query is that the month number is not too descriptive.
Sadly, all these large orders are in November, which must be the Christmas rush, so it is not as
good an example as I would like but bear with me.  We would like to dress the report up a little by
quoting month names instead.  Not finding a ready function built into Derby to do that, we decide
to build a little table of our own for the purpose:

drop table months;

CREATE TABLE months(
    number          INTEGER     NOT NULL,
    name            VARCHAR(9)  NOT NULL,
    abbreviation    VARCHAR(3)  NOT NULL,
    CONSTRAINT      months_pk   PRIMARY KEY (number),
    CONSTRAINT      months_uk01 UNIQUE      (name),
    CONSTRAINT      months_uk02 UNIQUE      (abbreviation)
);

INSERT INTO months (number, name, abbreviation)
VALUES  (1, 'January',  'Jan'),
        (2, 'February', 'Feb'),
        (3, 'March',    'Mar'),
        (4, 'April',    'Apr'),
        (5, 'May',      'May'),
        (6, 'June',     'Jun'),
        (7, 'July',     'Jul'),
        (8, 'August',   'Aug'),
        (9, 'September','Sep'),
        (10,'October',  'Oct'),
        (11,'November', 'Nov'),
         (12, 'December',    'Dec');

Now, alter your report in the above problem to use the months table to
allow you to output a month name rather than the month number.
Hint, in a select clause, you can do a (<arbitrary select statement>)
and treat the output from that inner select as though it is a single column value
(assuming of course that the select statement returns exactly one value).
 */

SELECT p.productName, p.productCode, m.name, YEAR(orderDate) AS yearOF, SUM(OD.quantityOrdered) AS total
       FROM PRODUCTS p
INNER JOIN ORDERDETAILS OD on p.productCode = OD.PRODUCTCODE
INNER JOIN orders o on OD.orderNumber =  o.orderNumber
INNER JOIN months m on m.number = MONTH(orderDate)
GROUP BY p.productName, p.productCode, m.name, YEAR(orderDate)
HAVING SUM(OD.quantityOrdered) >= 130;

--SELECT p.productName, p.productCode, (SELECT name from months WHERE number = month(orderDate)), YEAR(orderDate) AS yearOF, SUM(OD.quantityOrdered) AS total


/*
3. Report out the name of the customer and the grand total cost for all their
orders added together but only for those customers whose grand total is as large
as the largest grand total of all customers.  Do this using the max function.
Order by the customer name.  Returns 1 row.
 */

SELECT customerName, SUM(quantityOrdered*priceEach) as grandtotal
FROM customers
INNER JOIN orders o on customers.customerNumber = o.customerNumber
INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
GROUP BY customerName
HAVING SUM(quantityOrdered*priceEach) = (
           SELECT MAX(orderTotal)
           FROM (
                    SELECT customerName, sum(quantityOrdered * priceEach) AS orderTotal
                    FROM customers
                    INNER JOIN orders o on customers.customerNumber = o.customerNumber
                    INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
                    GROUP BY customerName
                ) AS orderTotal
       );



/*
4. Now do the same query, but instead of the MAX function, use the NOT EXISTS operator.
 */

SELECT DISTINCT *
FROM (SELECT customerName, SUM(quantityOrdered*priceEach) total
        FROM customers
        INNER JOIN orders o on customers.customerNumber = o.customerNumber
        INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
    GROUP BY customerName) maximum
WHERE NOT EXISTS(
        SELECT customerName
        FROM customers
            INNER JOIN orders o on customers.customerNumber = o.customerNumber
            INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
        WHERE maximum.total < total);

/*
5. Now do the same query, using >= ALL.
 */


SELECT *
FROM (
SELECT customerName, SUM(quantityOrdered*priceEach) as grandtotal
FROM customers
INNER JOIN orders o on customers.customerNumber = o.customerNumber
INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
GROUP BY customerName) total
WHERE grandtotal >= ALL (
    SELECT sum(quantityOrdered * priceEach) AS orderTotal
    FROM customers
             INNER JOIN orders o on customers.customerNumber = o.customerNumber
             INNER JOIN orderdetails o2 on o.orderNumber = o2.orderNumber
    GROUP BY customerName
        );


/*
6. List the pairs of customers who have a sales representative with the same first name but a different last name.
Report out the first customer name, the first name of their sales rep, the last name of their sales rep,
the first name of the other customer's sales rep, and the other customer's name.
List each pair of customers only once.  Order the output by the first customer name, then the second customer name.
Returns 36 rows.  Do this by joining the output from two subqueries.
 */

SELECT  *
FROM
     (SELECT lastName, firstName
        FROM customers c1
            INNER JOIN employees e on c1.salesRepEmployeeNumber = e.employeeNumber ) c1
    INNER JOIN
        (SELECT lastName, firstName
        FROM customers
        INNER JOIN employees e2 on customers.salesRepEmployeeNumber = e2.employeeNumber) c2
USING (firstname)
WHERE c1.lastName <> c2.lastName;