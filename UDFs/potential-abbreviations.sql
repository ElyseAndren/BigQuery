CREATE OR REPLACE FUNCTION 
  `prj.udf.potential_abbrs`
  (x STRING, y STRING) 
  RETURNS STRING 
  LANGUAGE js AS 
"""
// Find potential abbreviations when comparing one search to subsequent search
// e.g. ('3rd gen nest tstat','3rd generation nest thermostat') --> 'gen:generation|tstat:thermostat'

// 1) Trim strings and change all whitespace to one in length
// 2) Remove all non-alphanumeric or space characters
// 3) For each same placement token in both strings, join separated by colon
//    if first value is contained within second value and has lower length by 2+
//    and fisrt not plural or past tense of second
// 4) Grab all distinct values and join by pipe

var x2 = x.replace(/\s\s+/g, ' ').trim().replace(/[^a-zA-Z\s]/g, '');
var y2 = y.replace(/\s\s+/g, ' ').trim().replace(/[^a-zA-Z\s]/g, '');
var x2Len = x2.split(' ').length
arr = []

for ( i = 0 ; i < x2Len ; i++ ) {
  var x3 = x2.split(' ').slice(i,i+1).join('')
  var x4 = x3.replace(/(.)/g, "$1.*")
  var y3 = y2.split(' ').slice(i,i+1).join('')
  if( (new RegExp(x4)).test(y3) 
      && (x3.length+1 < y3.length) 
      && ![x3+'s',x3+'ed',x3+'d'].includes(y3)
        // To do: Find more of these exclusion cases
      ){
        arr.push( x3 + ":" + y3 )
    }
}

arr2 = Array.from(new Set(arr))
return arr2.join("|") || null

""";
