CREATE TRIGGER users_change_balance_trg
AFTER INSERT OR UPDATE OR DELETE
ON users
FOR EACH STATEMENT
EXECUTE PROCEDURE transactions_refresh_balance();