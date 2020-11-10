---------- SUBQUERIES LAB --------------
/*
1. List the last name, the first name, and the number of employees who report
to that employee for all employees who have the greatest number of other employees
reporting to them. Returns 2 rows.
*/

SELECT e2.lastName, e2.firstName,
       count(*) "Employees Under Them"
FROM employees e JOIN employees e2 ON e.reportsTo = e2.employeeNumber
GROUP BY e2.lastName, e2.firstName
HAVING count(*) = (
    SELECT MAX(reportsTo)
    FROM (
        SELECT count(*) reportsTo
        FROM employees e JOIN employees e2 ON e.reportsTo = e2.employeeNumber
        GROUP BY e2.lastName, e2.firstName) counts);

/*
2. List the customer name, state, and country of all the customers located in the state
and country with the largest number of customers.
Consider that not all countries have states by using the coalesce function.
Order by the customer name.  Returns 13 rows.
 */

SELECT customername, coalesce(state, 'N/A'), customers.COUNTRY
FROM CUSTOMERS
    INNER JOIN (
        SELECT naState, country, count(*) stateCount
        FROM (select coalesce(state, 'N/A') naState, country
            FROM CUSTOMERS) naCust
        GROUP BY naState, country
        HAVING count(*) = (
            SELECT MAX(stateCount)
            FROM (
                 SELECT naState, country, count(*) stateCount
                FROM    (SELECT coalesce(state, 'N/A') naState, country
                    FROM CUSTOMERS) naCust
                GROUP BY  naState, country
                     ) maxState
            )) maxStates
    ON coalesce(state, 'N/A') = naState and customers.country = maxStates.country;




/*
 3.Report the customer name, order number, order date, and the count of the # of products
 ordered for all orders that have the largest number of products ordered.
 The number or products ordered in each order is the number of product codes in the order,
 not the number of individual things.
 For instance, if a given order has three 16 oz. framing hammers and two 9’ levels, it has two products ordered.
 Returns 11 rows.
 */

SELECT c.customerName, o.orderNumber, o.orderDate,
       count(*) "products ordered"
FROM CUSTOMERS c INNER JOIN ORDERS O on c.customerNumber = O.CUSTOMERNUMBER
    INNER JOIN ORDERDETAILS using(ORDERNUMBER)
GROUP BY o.orderNumber, c.customerName, o.orderDate
HAVING count(*) >= ALL  (
         SELECT COUNT(*) ordCount
         FROM ORDERDETAILS
         GROUP BY orderNumber);



/*
 4.Now do the same query but use a view instead.
 Find some part of your query in the previous query that you had to repeat,
 put that part into a view, and then revamp the query to use the view instead of
 having that code repeated.
 */
drop view custOrders;
CREATE VIEW custOrders as
     SELECT c.*, o.ORDERDATE, o.ORDERNUMBER, o.SHIPPEDDATE, o.STATUS,
            o.REQUIREDDATE, od.PRICEEACH, od.QUANTITYORDERED, od.PRODUCTCODE
    FROM CUSTOMERS c INNER JOIN ORDERS o on
         c.CUSTOMERNUMBER = o.CUSTOMERNUMBER
        INNER JOIN orderdetails od on o.orderNumber = od.orderNumber;

/*
 5.List the customer name, and the date of their order, for any orders placed on
 the same date as an order placed by ‘Euro+ Shopping Channel’ or ‘Mini Gifts Distributors Ltd.’.
 Order by customer name and the order date.  Returns 13 rows.
 */
SELECT CUSTOMERNAME, ORDERDATE
FROM customers c INNER JOIN ORDERS using(customerNumber)
WHERE orderDate in(
    SELECT ORDERDATE
    FROM customers INNER JOIN orders using(customerNumber)
    WHERE customerName in ('Euro+ Shopping Channel', 'Mini Gifts Distributors Ltd.')
        AND c.CUSTOMERNUMBER <> customers.CUSTOMERNUMBER)
    ORDER BY customerName, orderDate;

