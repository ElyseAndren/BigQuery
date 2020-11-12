CREATE OR REPLACE FUNCTION 
`udf.seq_substr_in_str`(s STRING) AS 
(
-- Create list of all sequential substrings within a string
-- e.g. '9v ryobi drill' --> '9v|9v ryobi|9v ryobi drill|ryobi|ryobi drill|drill'

-- 1) Trim string and change all whitespace to one in length
-- 2) Remove pipes (need for our delimiter)
-- 3) Loop through each token in string
-- 4) Grab all sequential slices of string from token to end of string
  ( WITH c00 AS
      ( SELECT 
        REGEXP_REPLACE(
            REGEXP_REPLACE(TRIM(s), r'[\s][\s]+', ' ')
            , r'\|', '') s2
      )
      , c01 AS
        ( SELECT s2, VAR, OFFSET
          FROM c00, UNNEST(SPLIT(s2, " ") ) VAR WITH OFFSET
        )
      , c02 AS
        ( SELECT 
            A.s2
            , A.OFFSET OS1
            , B.OFFSET OS2
            , STRING_AGG( AGG, ' ') s3
          FROM 
            c01 A
            , c01 B 
            , UNNEST(SPLIT(A.s2,' ')) AGG WITH OFFSET
          WHERE A.OFFSET <= B.OFFSET
            AND OFFSET BETWEEN A.OFFSET AND B.OFFSET
          GROUP BY 1,2,3
          ORDER BY 1,2,3
        )
    SELECT
      STRING_AGG(DISTINCT s3, '|' ORDER BY s3)
    FROM c02
  )
);
