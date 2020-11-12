CREATE OR REPLACE FUNCTION 
  `udf.potential_abbrs` (x STRING, y STRING) AS
(
  /*  Find potential abbreviations when comparing one search to subsequent search
      e.g. ('3rd gen nest tstat','3rd generation nest thermostat') 
        --> 'gen:generation|tstat:thermostat'

      1)  Trim and uppercase strings and change all whitespace to one in length
      2)  Remove all non-alphabetic or space characters
      3)  For each same placement token in both strings, join separated by colon
            if first value is contained within second value and has lower length by 2+
            and fisrt not plural or past tense of second
      4)  Grab all distinct values and join by pipe
  
  */
  ( WITH
      SRCH01 AS
        ( SELECT
            REGEXP_REPLACE(X2, r'[^A-Z ]', '') X2
            , OFST_X 
          FROM
            UNNEST(SPLIT(TRIM(
              REGEXP_REPLACE(
                UPPER(X)
              , r'[\s][\s]+', ' ')
            ), ' ') ) X2 WITH OFFSET AS OFST_X
        )
      , SRCH02 AS
        ( SELECT
            REGEXP_REPLACE(Y2, r'[^A-Z ]', '') Y2
            , OFST_Y
          FROM
            UNNEST(SPLIT(TRIM(
              REGEXP_REPLACE(
                UPPER(Y)
              , r'[\s][\s]+', ' ')
            ), ' ') ) Y2 WITH OFFSET AS OFST_Y
        )
    SELECT
      STRING_AGG(DISTINCT CONCAT(X2, ':', Y2), '|') 
    FROM 
      SRCH01
      , SRCH02
    WHERE LENGTH(X2) > 1
      -- Same token placement
      AND OFST_X = OFST_Y
      -- is an abbreviation
      AND REGEXP_CONTAINS(Y2, REGEXP_REPLACE(X2, '', '.*'))
      -- at least two fewer characters
      AND (LENGTH(X2) + 1) < LENGTH(Y2)
      -- not plural or past tense
      AND NOT REGEXP_CONTAINS(Y2, CONCAT(r'^', X2, '(S|ED|D)$'))
  )
);
