SET LOCAL client_min_messages = error; -- to avoid implicit index messages

CREATE TABLE pri_keys (
  sequence regclass PRIMARY KEY,
  key integer NOT NULL);

CREATE OR REPLACE FUNCTION
pri_random_key() RETURNS integer
LANGUAGE sql
VOLATILE
AS $$
  SELECT trunc(random() * 2^15)::integer;
$$;

CREATE OR REPLACE FUNCTION
pri_key(_sequence regclass) RETURNS integer
LANGUAGE plpgsql
STRICT
AS $$
  DECLARE
    _key integer = key FROM pri_keys WHERE sequence = _sequence;
  BEGIN
    IF _key IS NULL THEN
      RAISE WARNING 'key not found for sequence %, generating a random one', _sequence;
      INSERT INTO pri_keys(sequence, key) VALUES (_sequence, pri_random_key()) RETURNING key INTO _key;
    END IF;
    RETURN _key;
  END
$$;

CREATE OR REPLACE FUNCTION
pri_nextval(sequence regclass) RETURNS integer
LANGUAGE sql
VOLATILE
STRICT
AS $$
  SELECT pri_scramble(pri_key($1), nextval($1));
$$;

CREATE OR REPLACE FUNCTION
pri_nextval_str(sequence regclass) RETURNS char(6)
LANGUAGE sql
VOLATILE
STRICT
AS $$
  SELECT lpad(crockford(pri_scramble(pri_key($1), nextval($1))), 6, '0');
$$;
