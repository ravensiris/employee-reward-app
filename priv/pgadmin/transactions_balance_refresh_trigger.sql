CREATE TRIGGER transactions_refresh_balance_trg
AFTER INSERT OR UPDATE OR DELETE
ON transactions
FOR EACH STATEMENT
EXECUTE PROCEDURE transactions_refresh_balance();