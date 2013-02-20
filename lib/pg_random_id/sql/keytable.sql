SET LOCAL client_min_messages = error; -- to avoid implicit index messages

CREATE TABLE pri_keys (
  sequence regclass PRIMARY KEY,
  key integer NOT NULL);

CREATE OR REPLACE FUNCTION
pri_nextval(sequence regclass) RETURNS integer
LANGUAGE sql
VOLATILE
STRICT
AS $$
  SELECT pri_scramble(key, nextval($1))
    FROM pri_keys
    WHERE sequence = $1;
$$;

CREATE OR REPLACE FUNCTION
pri_nextval_str(sequence regclass) RETURNS char(6)
LANGUAGE sql
VOLATILE
STRICT
AS $$
  SELECT lpad(crockford(pri_scramble(key, nextval($1))), 6, '0')
    FROM pri_keys
    WHERE sequence = $1;
$$;
