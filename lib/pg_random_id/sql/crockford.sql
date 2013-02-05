-- Postgres pl/pgSQL implementation of Base32 Crockford encoding
-- (see http://www.crockford.com/wrmg/base32.html )

CREATE OR REPLACE FUNCTION crockford(input bigint) RETURNS varchar
LANGUAGE plpgsql
IMMUTABLE STRICT AS $$
  DECLARE
    charmap CONSTANT char[] = ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'];
    result varchar = '';
  BEGIN
    IF (input < 0) THEN
      RAISE EXCEPTION numeric_value_out_of_range USING
        MESSAGE = 'crockford(): bad input value --> ' || input,
        HINT = 'Input needs to be nonnegative.';
    END IF;
    LOOP
      result := charmap[(input & 31) + 1] || result;
      input := input >> 5;
      EXIT WHEN input = 0;
    END LOOP;
    RETURN result;
  END;
$$;
