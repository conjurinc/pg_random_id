-- A simple Feistel network to scramble a 32-bit unsigned integer.
-- There are seven rounds with a simple round function.
-- Because PSQL ints are signed, the data is manipulated in bigints.
-- The output is guaranteed to be 1:1 mapping, ie. no collisions.
-- Supply a unique key (table oid is a good choice) to create different sequences.

-- The code is based on http://wiki.postgresql.org/wiki/Pseudo_encrypt
CREATE OR REPLACE FUNCTION
pri_scramble(key bigint, input bigint) RETURNS bigint
LANGUAGE plpgsql
IMMUTABLE STRICT
AS $$
  DECLARE
    l1 int;
    l2 int;
    r1 int;
    r2 int;
    i int:=0;
  BEGIN
    l1:= (input >> 16) & 65535;
    r1:= input & 65535;
    key := key + 54778; -- we don't want the key to be zero
    WHILE i < 7 LOOP
      l2 := r1;
      r2 := l1 # ((r1::bigint * key + 54825) & 65535);
      l1 := l2;
      r1 := r2;
      i := i + 1;
    END LOOP;
    RETURN ((l1::bigint << 16) + r1);
  END;
$$;
