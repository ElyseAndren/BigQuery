CREATE OR REPLACE FUNCTION `udf.udf_lien_fxd`
  ( dt_strt DATE, dt_end DATE, lead_dt DATE, amt FLOAT64, pmt FLOAT64, rt FLOAT64)
RETURNS FLOAT64 
LANGUAGE js AS 
"""
// This function estimates the remaining mortgage balance for fixed mortgages given a specified date.

  // Inputs: Mortgage Date, specified date, mortgage amount, monthly payment, monthly interest rate.

if (dt_end <= lead_dt || lead_dt < dt_strt) {
  amt = 0.0
} else {
  
  // GENERATE ARRAY OF DATES BY MONTH BETWEEN TWO DATES
  var getDaysArray = function(start, end) {
      for(var arr=[],dt=new Date(start); dt<= end; dt.setMonth(dt.getMonth()+1)){
          arr.push(new Date(dt));
      }
      return arr;
  };

  rt = ((rt / 100) / 12);

  var daylist = getDaysArray(new Date(dt_strt),new Date( new Date(lead_dt)));

  for (i = 0; i < daylist.length; ++i) {
    amt = amt - ( pmt - (amt * rt) );
  }
}

  
return amt < 0 ? 0 : amt.toFixed(2)
""";
