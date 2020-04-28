;=============================================================================
;+
; NAME:
;	mkhdr
;
;
; PURPOSE:
;	Make a minimal primary FITS image header or a minimal FITS IMAGE
;	extension header.
;
;
; CATEGORY:
;	UTIL/FITS
;
;
; CALLING SEQUENCE:
;	mkhdr, header
;	mkhdr, header, im, [ /IMAGE, /EXTEND ]
;	mkhdr, header, type, naxisx, [/IMAGE, /EXTEND ]    	
;	
;
; ARGUMENTS:
;  INPUT:
;	im:	If im is a vector or array then the header will be made
;		appropiate to the size and type of im.  im does not have
;		to be the actual data; it can be a dummy array of the same
;		type and size as the data.    Set im = '' to create a dummy
;		header with NAXIS = 0. 
;
;	type:	If more than 2 parameters are supplied, then the second
;		parameter is intepreted as an integer giving the IDL datatype
;		e.g. 1 - LOGICAL*1, 2 - INTEGER*2, 4 - REAL*4, 3 - INTEGER*4.
;
;	naxisx:	Vector giving the size of each dimension (naxis1, naxis2, 
;		etc.).
;
;  OUTPUT:
;	header:	Image header, (string array) with required keywords
;		BITPIX, NAXIS, NAXIS1, ... Further keywords can be added
;		to the header with SXADDPAR.
;
; KEYWORDS:
;  INPUT:
;	image:	If set, then a minimal header for a FITS IMAGE extension
;		is created.    An IMAGE extension header is identical to
;		a primary FITS header except the first keyword is 
;		'XTENSION' = 'IMAGE' instead of 'SIMPLE  ' = 'T'.
;
;	extend:	If set, then the keyword EXTEND is inserted into the file,
;		with the value of "T" (true).
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; RESTRICTIONS:
;	(1)  MKHDR should not be used to make an STSDAS header or a FITS
;		ASCII or Binary Table header.   Instead use
;
;		SXHMAKE - to create a minimal STSDAS header
;		FXHMAKE - to create a minimal FITS binary table header
;		FTCREATE - to create a minimal FITS ASCII table header
;
;	(2)  Any data already in the header before calling MKHDR
;		will be destroyed.
;
;
; EXAMPLE:
;	Create a minimal FITS header, HDR, for a 30 x 40 x 50 INTEGER*2 array
;
;	      IDL> MKHDR, HDR, 2, [30,40,50]
;
;	Alternatively, if the array already exists as an IDL variable, ARRAY,
;
;	       IDL> MKHDR, HDR, ARRAY
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	sxaddpar, sxdelpar, sxpar
;
;
; MODIFICATION HISTORY:
;    Written November, 1988               W. Landsman
;    May, 1990, Adapted for IDL Version 2.0, J. Isensee
;	
;-
;=============================================================================
pro mkhdr, header, im, naxisx, IMAGE = image, EXTEND = extend
 On_error,2

 npar = N_params()
 if npar LT 1 then begin
   print,'Syntax:  mkhdr, header, [ im, /IMAGE, /EXTEND ]'
   print,'    or   mkhdr, header, [ type, naxisx, /IMAGE, EXTEND ]
   print,'   header - output FITS image header to be created
   return
 endif

 if (npar eq 1) then begin               ;Prompt for keyword values
    read,'Enter number of dimensions (NAXIS): ',naxis
    s = lonarr(naxis+2)
    s(0) = naxis
    if ( naxis GT 0 ) then begin       ;Make sure not a dummy header
    for i = 1,naxis do begin       ;Get dimension of each axis
      keyword = 'NAXIS' + strtrim(i,2)
      read,'Enter size of dimension '+ strtrim(i,2) + ' ('+keyword+'): ',nx
      s(i) = nx                            
    endfor
  endif

  print,'Allowed datatypes are (1) INTEGER*1, (2) INTEGER*2, (4) REAL*4,'
  print,'                     (3) INTEGER*4 or (6) COMPLEX*8'
  read,'Enter datatype: ',stype
  s(s(0) + 1) = stype

 endif else $
     if ( npar EQ 2 ) then s = size(im) $  ;Image array supplied
          else  s = [ N_elements(naxisx),naxisx, im ] ;Keyword values supplied

 stype = s(s(0)+1)		;Type of data    
	case stype of
	1:	bitpix = 8  
	2:	bitpix = 16  
	3:	bitpix = 32  
	4:	bitpix = -32 
	5:	bitpix = -64 
	6:	bitpix = 64  
        7:      bitpix = 8
	else:   message,'Illegal Image Datatype'
	endcase

 header = strarr(s(0) + 7) + string(' ',format='(a80)')      ;Create empty array
 header(0) = 'END' + string(replicate(32b,77))

 if keyword__set( IMAGE) then $
    sxaddpar, header, 'XTENSION', 'IMAGE   ',' IMAGE extension' $
 else $
    sxaddpar, header, 'SIMPLE', 'T',' Written by IDL:  '+ systime()

 sxaddpar, header, 'BITPIX', bitpix
 sxaddpar, header, 'NAXIS', S(0)	;# of dimensions

 if ( s(0) GT 0 ) then begin
   for i = 1, s(0) do sxaddpar,header,'NAXIS' + strtrim(i,2),s(i)
 endif

 if keyword__set( IMAGE) then begin
     sxaddpar, header, 'PCOUNT', 0, ' NO GROUP PARAMETERS'
     sxaddpar, header, 'GCOUNT', 1, ' ONE TABLE'
 endif else begin
     Get_date, dte                       ;Get current date as DD/MM/YY
     sxaddpar, header, 'DATE', dte,' Creation date (DD/MM/YY) of FITS header'
     if keyword__set( EXTEND) or (s(0) EQ 0) then $
          sxaddpar, header, 'EXTEND', 'T', ' FILE MAY CONTAIN EXTENSIONS'
 endelse

 header = header(0:s(0)+7)

 end
