;=============================================================================
;+-+
; NAME:
;	write_fits
;
;
; PURPOSE:
;	Writes an an IDL array into a disk FITS file.
;
;
; CATEGORY:
;	UTIL/FITS
;
;
; CALLING SEQUENCE:
;	writefits, filename, data [,header]
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	String containing the name of the file to be written.
;
;	data:		Image array to be written to FITS file.
;
;	header:		String array containing the header for the FITS file.
;			If variable HEADER is not given, the program will
;			generate a minimal FITS header.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	NaNvalue:	Value in the data array to be set to the IEEE NaN
;			condition.  This is the FITS representation of undefined
; 			values.
;
;	silent:		If set, suppress superfluous printed output.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; RESTRICTIONS:
;       (1) It recommended that BSCALE and BZERO not be used (or set equal
;           to 1. and 0) with REAL*4 or REAL*8 data.
;       (2) WRITEFITS will remove any group parameters from the FITS header.
;	(3) Does not handle groups or extensions.
;
;
; EXAMPLE:
;       Write a randomn 50 x 50 array as a FITS file creating a minimal header.
;
;       IDL> im = randomn(seed, 50, 50)        ;Create array
;       IDL> writefits, 'test', im             ;Write to a FITS file "test"
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	read_fits
;
;
; MODIFICATION HISTORY:
;	WRITTEN, Jim Wofford, January, 29 1989
;       MODIFIED, Wayne Landsman, added BITPIX = -32,-64 support for UNIX
;       Fixed Unix bug when writing FITS header, 13-Feb-92
;       Use new BYTEODER keywords 22-Feb-92
;	J.Spitale Jan 1998; changed name from 'writefits' to 'write_fits'
;	Spitale, 3/2002 -- add silent keyword
;	
;-
;=============================================================================
pro write_fits, filename, data, header, NaNvalue = NaNvalue, silent=silent
    On_error, 2

  if N_params() LT 2 then message, $
         'Syntax: WRITEFITS, filename, data,[ header, NaNvalue = ]
;
; Get information about data
;                             
  siz = size( data )      
  naxis = siz(0)                    ;Number of dimensions
  nax = siz( 1:naxis )              ;Vector of dimensions
  lim = siz( naxis+2 )              ;Total number of data points
  type = siz(naxis + 1)             ;Data type

        if N_elements(header) LT 2 then mkhdr, header, data $
        else $         
              check_FITS, data, header, /UPDATE, /FITS

  hdr = header
  sxdelpar, hdr, [ 'GCOUNT', 'GROUPS', 'PCOUNT', 'PSIZE' ]
  sxaddpar, hdr, 'SIMPLE', 'T', ' Written by IDL:  ' + !STIME
  
; For floating or double precision test for NaN values to write

  NaNtest = keyword__set(NaNvalue) and ( (type EQ 4) or (type EQ 5) )
  if NaNtest then NaNpts = where( data EQ NaNvalue, N_NaN)
      
;
; If necessary, byte-swap the data.    Do not destroy the original data
;
        vax = !VERSION.ARCH EQ "vax"
        Little_endian = ( !VERSION.ARCH EQ "mipsel" ) or $ 
                        ( !VERSION.ARCH EQ '386i') or  $
                        ( !VERSION.ARCH EQ '386' )
        
        if VAX or Little_endian then begin
             newdata = data
             host_to_ieee, newdata
        endif

; Write the NaN values, if necessary

      if NaNtest then begin
     if (N_NaN GT 0) then begin
         if type EQ 4 then data(NaNpts) = $
             float( [ 127b, 255b, 255b, 255b ], 0, 1 ) $
    else if type EQ 8 then data(NaNpts) = $
             double( [ 127b, replicate( 255b,7)], 0 ,1)
      endif
endif
;
; Open file and write header information
;
       	openw, unit, filename, /NONE, /BLOCK, /GET_LUN, 2880
;
; Determine if an END line occurs, and add one if necessary

       endline = where( strmid(hdr,0,8) EQ 'END     ', Nend)
     if Nend EQ 0 then begin

 if(NOT silent) then $
  message,'WARNING - An END statement has been appended to the FITS header',/INF
     hdr = [hdr, 'END' + string(replicate(32b,77))]
     endline = N_elements(hdr) - 1 

   endif
   nmax = endline(0) + 1

; Convert to byte and force into 80 character lines

       bhdr = replicate(32b, 80l*nmax)
       for n = 0l, endline(0) do bhdr(80*n) = byte( hdr(n) )
       npad = 80l*nmax mod 2880
       writeu, unit, bhdr
       if npad GT 0 then writeu, unit,  bytarr(2880 - npad)
;
; Write data
;
        bitpix = sxpar( hdr, 'BITPIX' )
        nbytes = N_elements( data) * (abs(bitpix) / 8 )
        npad = nbytes mod 2880

        if VAX or LITTLE_ENDIAN then $

          writeu, unit, newdata  $

       else writeu, unit, data 

        if npad GT 0 then writeu, unit, bytarr( 2880 - npad)

	free_lun, unit  

return
end
