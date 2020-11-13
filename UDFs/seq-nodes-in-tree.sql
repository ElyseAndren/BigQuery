CREATE FUNCTION `udf.seq_nodes_in_tree`(x STRING, y STRING) AS 
(
  ( WITH 
      t01 AS
        ( SELECT VAR, OFFSET
          FROM UNNEST(SPLIT(x, y)) VAR WITH OFFSET
        )
      , t02 AS
        ( SELECT 
            a.VAR
            , REGEXP_REPLACE(
                -- not allowing me to split by y
                STRING_AGG(B.VAR, '_-123-_' ORDER BY B.OFFSET)
              , '_-123-_', y) PATHS 
          FROM t01 A, t01 B 
          WHERE A.OFFSET >= B.OFFSET
          GROUP BY 1
        )
    SELECT ARRAY_AGG(PATHS) PATHS
    FROM t02
  )       
);
