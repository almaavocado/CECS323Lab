
---------- SUBQUERIES LAB 2 --------------

/*
1.What product that makes us the most money (qty*price each).
Essentially, you are looking for the total sales for each product across all orders.
Returns one row.
But do not assume that when you write your query.
*/
SELECT productName
FROM PRODUCTS
    NATURAL JOIN ORDERDETAILS
GROUP BY productName HAVING SUM(quantityOrdered*priceEach) = (
           SELECT MAX(PRODUCTTOTALS.productTotal)
           FROM (
                    SELECT productCode, sum(quantityOrdered * priceEach) AS productTotal
                    FROM ORDERDETAILS
                    GROUP BY productCode
                ) AS PRODUCTTOTALS
       );

/*
2.List the product lines and vendors for product lines which are supported by < 5 vendors.
The product vendor appears in the Products table.
The number of vendors who support a given product line is just
the count of the vendors associated with the various products within a given line.
Returns 3 rows.
*/
SELECT productLine, productVendor
    FROM PRODUCTS
    WHERE productLine = (
        SELECT productLine FROM PRODUCTS
    GROUP BY productLine
    HAVING count(productVendor) < 5);

/*
3.List the products in the product line with the greatest number of products.
Returns 38 rows.
*/
SELECT productName, productLine
    FROM PRODUCTS
    WHERE productLine = (
        SELECT productLine AS ProductsInProductLine
        FROM PRODUCTS
    GROUP BY productLine
    HAVING count(productName) = (
        SELECT MAX(ProductsInProductLine) AS ProductsInProductLine
        FROM
        (
            SELECT productLine, count(productName) AS ProductsInProductLine
            FROM PRODUCTS
            GROUP BY productLine
        ) AS ProductsInProductLine
    )
);


/*
4.Report the customer name of all customers who have ordered at least one
product with the name “Ford” in it, that “Dragon Souvenirs, Ltd.” has also ordered.
List them in reverse alphabetical order, and do not consider the case of the letters
in the customer name in the ordering.  Show each customer no more than once.
Returns 61 rows.
*/
SELECT DISTINCT CUSTOMERNAME
    FROM CUSTOMERS
        NATURAL JOIN ORDERS
        NATURAL JOIN ORDERDETAILS
        NATURAL JOIN PRODUCTS
    WHERE productname IN
        (
            SELECT DISTINCT PRODUCTNAME
            FROM CUSTOMERS
    NATURAL JOIN ORDERS
                NATURAL JOIN ORDERDETAILS
                NATURAL JOIN PRODUCTS
            WHERE CUSTOMERNAME = 'Dragon Souveniers, Ltd.' AND PRODUCTNAME LIKE '%Ford%');



/*
5.Which products have an MSRP within 5% of the average MSRP across all products?
List the Product Name, the MSRP, and the average MSRP ordered by the product MSRP.
Returns 14 rows.
 */
SELECT productname, msrp
FROM PRODUCTS
where msrp <= 1.05 * (SELECT AVG(msrp) FROM PRODUCTS) AND msrp >= 0.95*(SELECT AVG(msrp) FROM PRODUCTS);

