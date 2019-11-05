--Get all customers and their addresses.
select c.first_name, c.last_name, a.street, a.city, a.state, a.zip
from customers c  JOIN addresses a ON (c.id = a.customer_id)

--Get all orders and their line items (orders, quantity and product).
Select  o.id, p.description, l.quantity
FROM orders o JOIN line_items l ON (o.id=l.order_id)
JOIN products p ON (p.id = l.product_id)
ORDER BY o.id

--Which warehouses have cheetos?
SELECT w.warehouse from 
warehouse w JOIN  warehouse_product wh ON (w.id=wh.warehouse_id)
JOIN products p ON (p.id=wh.product_id)
Where p.description='cheetos'

--Which warehouses have diet pepsi?
SELECT w.warehouse from 
warehouse w JOIN  warehouse_product wh ON (w.id=wh.warehouse_id)
JOIN products p ON (p.id=wh.product_id)
Where p.description='diet pepsi'


--Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT c.id, c.first_name, COUNT(o.id) 
FROM customers c JOIN addresses a ON (c.id=a.customer_id)
JOIN orders o ON (a.id=o.address_id)
GROUP BY c.id

--How many customers do we have?
select count(customers.id) from customers

--How many products do we carry?
select count(products.id) from products

--What is the total available on-hand quantity of diet pepsi?
SELECT SUM(wh.on_hand)
FROM products p JOIN warehouse_product wh ON (p.id=wh.product_id)
WHERE p.description='diet pepsi'


Stretch

--How much was the total cost for each order?
SELECT o.id, SUM(p.unit_price*l.quantity) as total
FROM orders o JOIN line_items l ON (o.id=l.order_id)
JOIN products p ON (p.id=l.product_id)
GROUP BY o.id
order by o.id asc


--How much has each customer spent in total?
SELECT c.id, c.first_name, SUM(p.unit_price*l.quantity) AS spent
FROM customers c JOIN addresses a  ON (c.id=a.customer_id)
JOIN orders o ON (a.id = o.address_id)
JOIN line_items l ON (o.id=l.order_id)
JOIN products p ON (p.id=l.product_id)
GROUP BY c.id

--How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).

SELECT c.id, c.first_name, COALESCE(SUM(p.unit_price*l.quantity),0) AS spent
FROM customers c LEFT OUTER JOIN addresses a  ON (c.id=a.customer_id)
LEFT OUTER JOIN orders o  ON (a.id = o.address_id)
LEFT OUTER JOIN line_items l ON (o.id=l.order_id)
LEFT OUTER JOIN products p ON (p.id=l.product_id)
GROUP BY c.id
