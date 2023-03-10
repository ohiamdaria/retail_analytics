-- GROUP_ID

CREATE MATERIALIZED VIEW group_id AS
  SELECT DISTINCT personal_data.customer_id,
                         sku.group_id
                    FROM personal_data INNER JOIN cards ON personal_data.customer_id = cards.customer_id
                    INNER JOIN transactions ON cards.customer_card_id = transactions.customer_card_id
                    INNER JOIN checks ON transactions.transaction_id = checks.transaction_id
                    INNER JOIN sku ON checks.sku_id = sku.sku_id
    ORDER BY 1, 2;

CREATE OR REPLACE FUNCTION refresh_mat_view()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW group_id;
    RETURN NULL;
end $$;

CREATE TRIGGER refresh_mat_view_personal_data
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON personal_data FOR EACH STATEMENT
EXECUTE PROCEDURE refresh_mat_view();

CREATE TRIGGER refresh_mat_view_transactions
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON transactions FOR EACH STATEMENT
EXECUTE PROCEDURE refresh_mat_view();

CREATE TRIGGER refresh_mat_view_checks
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON checks FOR EACH STATEMENT
EXECUTE PROCEDURE refresh_mat_view();

CREATE TRIGGER refresh_mat_view_sku
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON sku FOR EACH STATEMENT
EXECUTE PROCEDURE refresh_mat_view();

SELECT * FROM group_id;

