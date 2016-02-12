;=============================================================================
;+
; NAME:
;	sxdelpar
;
;
; PURPOSE:
;	Deletes keyword parameters from a FITS header.
;
;
; CATEGORY:
;	UTIL/FITS
;
;
; CALLING SEQUENCE:
;	sxdelpar, h, parname
;
;
; ARGUMENTS:
;  INPUT:
;	h:		FITS header, string array.
;
;	parname:	String or string array of keyword name(s) to delete.
;
;  OUTPUT:
;	h:		Modified header.
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; NOTES:
;   (1)  Nothing happens if the keyword to be deleted is not found (no message)
;   (2)  All appearances of a keyword in the header will be deleted
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	sxpar, sxaddpar
;
;
; MODIFICATION HISTORY:
;	version 1  D. Lindler Feb. 1987
;	Converted to new IDL  April 1990 by D. Lindler
;	
;-
;=============================================================================
pro sxdelpar,h,parname
on_error,2
;
; convert parameters to string array of upper case names of length 8 char
;
s=size(parname) & ndim=s(0) & type=s(ndim+1)
if type ne 7 then message,'Keyword name(s) must a string or string array'
num = n_elements(parname)
par = strtrim(strupcase(parname),2) 
;
s=size(h) & ndim=s(0) & type=s(ndim+1)
if (ndim ne 1) or (type ne 7) then $
	message,'FITS header (1st parameter) must be a string array'
;
nlines=s(1)		;number of lines in header array
pos=0			;position in compressed header with keywords removed
;
; loop on header lines
;
keyword = strtrim(strmid(h,0,8),2)
for i=0,nlines-1 do begin
	for j=0,num-1 do if keyword(i) eq par(j) then goto,delete ;delete it?
	h(pos)=h(i)		;keep it
	pos=pos+1		;increment number of lines kept
	if keyword(i) eq 'END' then goto,done	;end of header
delete:
end
;
;
done:
h=h(0:pos-1)			;truncate
return
end

