CREATE OR REPLACE FUNCTION `udf.str_within_str`(x STRING, y STRING) AS
( /*
    A function to see if string x is contained within string y
    where x can be missing some characters of y and order of characters matter

    1) Trim strings and change all whitespace to one in length
    2) Change x input to a regex 
    3) Test that x input is contained with y
      Note: You must wrap in spaces to ensure x isn't a partial word of y
      Example: oil within toilet <-- Don't want to consider these
  */
  ( SELECT
      REGEXP_CONTAINS(
        CONCAT(' ', REGEXP_REPLACE(TRIM(Y), r'[\s][\s]+', ' '), ' ')
        , CONCAT(
            ' '
            , LTRIM(RTRIM(
                REGEXP_REPLACE(
                  REGEXP_REPLACE(TRIM(X), r'[\s][\s]+', ' '), '', '.*')
              , '.*'), '.*')
            , ' ')
      )
  )
);
