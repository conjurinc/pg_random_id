-- A simple Feistel network to scramble a 30-bit unsigned integer.
-- There are seven rounds with a simple round function.
-- The output is guaranteed to be 1:1 mapping, ie. no collisions.
-- Supply a unique key (table oid is a good choice) to create different sequences.
-- 30-bit length makes it possible to use ints instead of bigints
-- and convenient to base32-encode the value.

-- The code is based on http://wiki.postgresql.org/wiki/Pseudo_encrypt
CREATE OR REPLACE FUNCTION
pri_scramble(key bigint, input bigint) RETURNS int
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
    IF (input < 0) OR (input > 1073741823) THEN
      RAISE EXCEPTION numeric_value_out_of_range USING
        MESSAGE = 'pri_scramble(): bad input value --> ' || input,
        HINT = 'Input needs to be a 30-bit nonnegative integer.';
    END IF;
    l1:= (input >> 15) & 32767;
    r1:= input & 32767;
    key := key + 15228; -- we don't want the key to be zero
    WHILE i < 7 LOOP
      l2 := r1;
      r2 := l1 # ((r1::bigint * key + 3506) & 32767);
      l1 := l2;
      r1 := r2;
      i := i + 1;
    END LOOP;
    RETURN ((l1 << 15) + r1);
  END;
$$;
