CREATE EXTENSION cube;

CREATE DOMAIN gender.gender
  AS cube CHECK (
    cube_dim( VALUE ) = 3
    -- normalize ranges between -1 - 1
    AND VALUE->1 BETWEEN -1 AND 1
    AND VALUE->2 BETWEEN -1 AND 1
    AND VALUE->3 BETWEEN -1 AND 1
);

COMMENT ON DOMAIN gender.gender IS $$ Based on the genderspectrum.org $$;

CREATE FUNCTION gender.mk_gender(
  body float,
  identity float,
  expression float
)
RETURNS gender.gender AS $$
  SELECT cube(ARRAY[body,identity,expression])::gender;
$$
LANGUAGE sql
IMMUTABLE
STRICT;

COMMENT ON FUNCTION gender.mk_gender IS $$ mk_gender(body,identity,expression) arguments normalized to `[1,1]`$$;

CREATE FUNCTION gender.body(gender g) AS $$
	SELECT cube_subset(g, ARRAY[1]);
$$
LANGUAGE sql
IMMUTABLE;

CREATE FUNCTION gender.identity(gender g) AS $$
	SELECT cube_subset(g, ARRAY[2]);
$$
LANGUAGE sql
IMMUTABLE;

CREATE FUNCTION gender.expression(gender g) AS $$
	SELECT cube_subset(g, ARRAY[3]);
$$
LANGUAGE sql
IMMUTABLE;

-- Represent legacy male() and female() as polar extreme
-- or leave the column null. 
-- this is female<male
CREATE FUNCTION gender.polar_male() RETURNS gender AS
  $$ SELECT mk_gender(-1,-1,-1)::gender; $$
  LANGUAGE sql
  IMMUTABLE;
CREATE FUNCTION gender.polar_female() RETURNS gender AS
  $$ SELECT mk_gender(1,1,1)::gender; $$
  LANGUAGE sql
  IMMUTABLE;

COMMENT ON FUNCTION gender.polar_male()   IS $$ mk_gender(-1,-1,-1) $$;
COMMENT ON FUNCTION gender.polar_female() IS $$ mk_gender( 1, 1, 1) $$;
