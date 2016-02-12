;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	get_date
;
;
; PURPOSE:
;	Return the current date in DD/MM/YY or MM/DD/YY format.
;
;
; CATEGORY:
;	UTIL/FITS
;
;
; CALLING SEQUENCE:
;	get_date, dte
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT:
;	dte:	An eight character scalar string specifying the current day 
;		(0-31), current month (1-12), and last two digits of the 
;		current year
;
; KEYWORDS:
;  INPUT:
;	mdy:	If set, output will be as MM/DD/YY instead of DD/MM/YY.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Date as either DD/MM/YY or MM/DD/YY.
;
;
; EXAMPLE:
;	Add the current date to the DATE keyword in a FITS header,h
;     
;	IDL> GET_DATE,dte
;	IDL> sxaddpar, h, 'DATE', dte
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
;	Written      W. Landsman          March 1991
;	Added option to output date as mm/dd/yy - Spitale; June 1998
;	
;-
;=============================================================================
pro get_date,dte, mdy=mdy
 On_error,2

 if N_params() LT 1 then begin
     print,'Syntax - Get_date, dte'
     print,'  dte - 8 character output string giving current date'
     return
 endif

 mn = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct', $
       'Nov','Dec']

 st = !STIME
 day = strmid(st,0,2)
 month = strmid(st,3,3)
 month = where(mn EQ month) + 1
 yr = strmid(st,9,2)

 if(keyword__set(mdy)) then $
    dte = string(month,f='(i2.2)') + '/' + string(day,f='(I2.2)') + '/' + yr $
 else dte =  string(day,f='(I2.2)') + '/' + string(month,f='(i2.2)') + '/' + yr
 
 return
 end
