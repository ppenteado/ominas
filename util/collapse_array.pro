;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	collapse_array
;
;
; PURPOSE:
;	Collapses an array (n,m) to an array (n,l), where l is the maximum
;	number of nonzero elements in a row.  Rows with fewer nonzero elements
;	are padded with zeroes.
;
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	
;	The input array:
;
;		1 0 0 1 0 1 0 
;		0 0 0 1 0 0 0 
;		0 0 0 0 0 0 0 
;		1 1 0 0 1 0 0 
;
;	would produce the output array:
;
;		1 1 1
;		1 0 0
;		0 0 0
;		1 1 1
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function collapse_array, array

 s = size(array)
 n = s[1]
 m = s[2]

 ;------------------------------------------------------------
 ; count number of nonzero elements in each row
 ;------------------------------------------------------------
 w = where(array NE 0)
 if(w[0] EQ -1) then return, array

 ix = long(w/n)
 h = histogram(ix, bin=1, min=0l, max=long(m-1))
 mx = max(h)

 ;---------------------------------------------------------------------------
 ; create a marker array in which each row has the same number of 
 ; nonzero elements
 ;---------------------------------------------------------------------------
 x = intarr(n,m)
 x[w] = 1
 xx = intarr(n+mx,m)
 xx[0:n-1,*] = x

 for i=0, mx-1 do $
  begin
   w = where(h LE i)
   if(w[0] NE -1) then xx[n+i,w] = 1
  end


 ;---------------------------------------------------------------------------
 ; use the marker array to subscript the original array into the 
 ; collapsed array
 ;---------------------------------------------------------------------------
 x = dblarr(n+mx,m)
 x[0:n-1,*] = array 
 w = where(xx NE 0)

 result = dblarr(mx,m)
 result[*] = x[w]


 return, result
end
;=============================================================================
