-- find GROUP_ID

WITH sku_info AS (SELECT DISTINCT personal_data.customer_id,
                         checks.sku_id,
                         sku.group_id
                    FROM personal_data INNER JOIN cards ON personal_data.customer_id = cards.customer_id
                    INNER JOIN transactions ON cards.customer_card_id = transactions.customer_card_id
                    INNER JOIN checks ON transactions.transaction_id = checks.transaction_id
                    INNER JOIN sku ON checks.sku_id = sku.sku_id)



SELECT DISTINCT customer_id,
                group_id
FROM sku_info
ORDER BY 1, 2;

--

select * from periods