-- Pure Postgres SQL implementation of Base32 Crockford encoding
-- using recursive common table expressions
-- (about 10% slower than the pg/plsql variant)
CREATE OR REPLACE FUNCTION crockford(input bigint) RETURNS varchar
LANGUAGE sql
IMMUTABLE STRICT AS $$
  WITH RECURSIVE parts(part) AS (
    (SELECT $1 AS part) 
  UNION 
    (SELECT part >> 5 FROM parts WHERE part > 31))
  SELECT string_agg(
    (ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'])
    [(part & 31) + 1]
  ,'') FROM (SELECT part FROM parts ORDER BY part ASC) AS reversed;
$$;
