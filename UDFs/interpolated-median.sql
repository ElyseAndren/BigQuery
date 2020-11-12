CREATE OR REPLACE FUNCTION `prj.udf.intrpl_med`
  (bkts ARRAY<INT64>, mid ARRAY<INT64>, wid ARRAY<INT64>) 
  RETURNS INT64 
  LANGUAGE js AS
"""
/*  Interpolated Median Calculation Macro

      Used to calculate the median value from categorical ordinal attributes 
      ( HH_INCOME_LT10K, HH_INCOME_11KTO20K, ..., etc.).

      The interpolated median provides another measure of center which takes into account the percentage of
      the data that is strictly below versus strictly above the median. The interpolated median gives a measure 
      within the upper bound and lower bound of the median, in the direction that the data is more heavily weighted.

    MORE INFORMATION HERE: https://en.wikipedia.org/wiki/Median#Interpolated_median

      FORMULA:
            Interpolated Median = m + ( (w/2)*( (k-i) / j ) )

              m = middle value of bucket (assumption that bucket values are uniformly distributed)
              w = width of bucket
              k = number of values above the median bucket
              i = number of values below the median bucket
              j = number of values within the median bucket

    INSTRUCTIONS :
      1) Array of bucketed columns in order
      2) Array of mid values of each bucket in order
      3) Array of each bucket width in order
  */

var bkt_sum = bkts.map(Number).reduce((a, b) => a + b, 0);
  
for (var i = 0; i < bkts.length; i++) {

  var pre = bkts.slice(0,i).map(Number).reduce((a, b) => a + b, 0);
  var curr = bkts.slice(i,i+1).map(Number).reduce((a, b) => a + b, 0);
  var post = bkts.slice(i+1).map(Number).reduce((a, b) => a + b, 0);
  
  if 
    ( 
      (( bkt_sum / 2 ) > pre)
      && (( bkt_sum / 2 ) <= ( pre + curr))
      
    ) {
    // Interpolated Median = m + ( (w/2)*( (k-i) / j ) )
    return ( parseInt(mid[i]) + ( ( wid[i] / 2 ) * ( ( post - pre ) / curr ) ) )
  }

}
""";
