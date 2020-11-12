CREATE OR REPLACE FUNCTION `udf.udf_lien_adj`
( mrtgAmt FLOAT64, mrtgDate DATE, paymentCount INT64
  , matDate DATE, endDate DATE
  , mrtgDates ARRAY<STRUCT<paymentRem INT64, interestRate FLOAT64>>
) 
RETURNS FLOAT64 
LANGUAGE js AS 
"""
// This function estimates the remaining mortgage balance
// for adjusted mortgages given a specified date.

  // Inputs: Mortgage Amount, Mortgage Date, Total # Payments, Maturity Date, specified date
  //          Array:( payment remaining #, Interest Rate)

  if (matDate <= endDate || mrtgDate > endDate) {
    bal = 0.0
  } else {
  
    function monthDiff(d1, d2) {
      var months;
      months = (d2.getFullYear() - d1.getFullYear()) * 12;
      months -= d1.getMonth();
      months += d2.getMonth();
      return months <= 0 ? 0 : months;
    } 
    
    paymts = paymentCount - monthDiff(mrtgDate, endDate);

    var bal = mrtgAmt;

    for (i = 0; i < mrtgDates.length; ++i) {

      if (mrtgDates[i].paymentRem == 0) { break; }
      
      if (mrtgDates[i].interestRate !== null) {
        intRate = (mrtgDates[i].interestRate/100)/12;
      } 

      pmt = (bal*intRate) / (1 - Math.pow(1+intRate,-mrtgDates[i].paymentRem));

      int = bal*intRate;
      bal = bal - (pmt - int);
      
      if (mrtgDates[i].paymentRem <= paymts) { break; }
    }
  } 

  return bal < 0 ? 0 : bal.toFixed(2)
""";
