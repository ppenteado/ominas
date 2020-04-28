;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	host_to_ieee
;
;
; PURPOSE:
;	Translates an IDL variable from the host machine representation 
;	into IEEE-754 representation (as used, for example, in FITS data).
;
;
; CATEGORY:
;	UTIL/FITS
;
;
; CALLING SEQUENCE:
;	host_to_ieee, data, [ IDLTYPE = IDLTYPE ]
;
;
; ARGUMENTS:
;  INPUT:
;	data:	Any IDL variable, scalar or vector.   It will be modified by
;		HOST_TO_IEEE to convert from host to IEEE representation.  Byte 
;		and string variables are returned by HOST_TO_IEEE unchanged.
;
;  OUTPUT:
;	data:	See above.
;
;
; KEYWORDS:
;  INPUT:
;	IDLTYPE:	Scalar integer (1-7) specifying the IDL datatype
;			according to the code given by the SIZE function.   
;			This keyword will usually be used when suppying a byte
;			array that needs to be interpreted as another data type
;			(e.g. FLOAT).
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; RESTRICTIONS:
;	Assumes the IDL version is since 2.2.2 when the /XDRTOF keyword 
;	became available to BYTEORDER.    There were two bad implementations
;	in BYTEORDER for double precision: (1) in IDL V3.* for DecStations
;	(!VERSION.ARCH = 'mipsel') and (2) on Dec Alpha OSF machines.
;	IEEE_TO_HOST works around these cases by swapping the byte order
;	directly.
;
;
; PROCEDURE:
;	The BYTEORDER procedure is called with the appropriate keywords
;
;
; EXAMPLE:
;	Suppose FITARR is a 2880 element byte array to be converted to a FITS
;	record and interpreted a FLOAT data.
;
;	IDL> host_to_ieee, FITARR, IDLTYPE = 4
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ieee_to_host, conv_unix_vax, conv_vax_unix
;
;
; MODIFICATION HISTORY:
;	Adapted from CONV_UNIX_VAX, W. Landsman   Hughes/STX    January, 1992
;	Fixed Case statement for Float and Double      September, 1992
;	Workaround for /DTOXDR on DecStations          January, 1993
;	Workaround for /DTOXDR on Alpha OSF            July 1994
;	Assume since Version 2.2.2, Ultrix problems persist   November 1994
;	Add support for double complex        July, 1995
;	Workaround for VAX VMS bug in BYTEORDER,/FTOXDR in V4.0   August 1995
;	Workaround for VMS bug in BYTEORDER,/FTOXDR and /DTOXDR in
;		V4.0.1 (sigh...)  W. Landsman   August 1995
;	Workaround for /FTOXDR bug in OSF V4.0.1 September 1995
;	
;-
;=============================================================================
pro host_to_ieee, data, IDLTYPE = idltype
 On_error,2 

 if N_params() EQ 0 then begin
    print,'Syntax - HOST_TO_IEEE, data, [IDLTYPE = ]
    return
 endif  

 npts = N_elements( data )
 if npts EQ 0 then $
     message,'ERROR - IDL data variable (first parameter) not defined'

 sz = size(data)
 if not keyword__set( idltype) then idltype = sz( sz(0)+1)

 if idltype EQ 6 then idltype = 4     ;Treat complex as float
 if idltype EQ 9 then idltype = 5     ;Treat double complex as double

 case idltype of

      1: return                             ;byte

      2: byteorder, data, /HTONS            ;integer

      3: byteorder, data, /HTONL            ;long

      4: begin                              ;float

         bad_vms = 0
	 little_endian = 0
	 if (!VERSION.OS EQ 'linux')  or (!VERSION.OS EQ 'Win32') or $
	    (!VERSION.OS EQ 'OSF')  or (!VERSION.OS EQ 'ultrix') then $
			little_endian = 1
         if (!VERSION.ARCH EQ 'vax') and $
	    (!VERSION.RELEASE EQ '4.0') then bad_vms = 1
         if (!VERSION.RELEASE EQ '4.0.1') then $
		if !VERSION.OS EQ 'vms' then bad_vms = 1
	 if little_endian then byteorder, data,/LSWAP else $
         if bad_vms then data = conv_vax_unix(data, target = 'sparc') $
                    else byteorder, data, /FTOXDR

         end

      5: begin                              ;double
 
     bad_ultrix =   (!VERSION.ARCH EQ 'mipsel') and $
                    strmid(!VERSION.RELEASE,0,1) EQ '3'
     bad_windows = (!VERSION.RELEASE EQ '4.0.1') and ((!VERSION.OS EQ 'ultrix')$
		  or (!VERSION.OS EQ 'linux') or (!VERSION.OS EQ 'Win32') )
     bad_osf  =     (!VERSION.ARCH EQ 'alpha') and (!VERSION.OS EQ 'OSF')
     bad_vms  =     (!VERSION.OS EQ 'vms') and (!VERSION.RELEASE EQ '4.0.1')

     if bad_ultrix or bad_osf or bad_windows then begin  ;Swap byte order directly

                    dtype = sz( sz(0) + 1)
                    if ( dtype EQ 5 ) then data = byte(data, 0, npts*8) $
                                      else npts = npts/8
                    data = reform( data, 8 , npts ,/OVER)
                    data = rotate( data, 5)
                    if ( dtype EQ 5 ) then data = double(data, 0, npts) else $
                    if ( dtype EQ 9 ) then data = dcomplex(data,0,npts)
                    if sz(0) gt 0 then data = reform( data, sz(1:sz(0)), /OVER )

      endif else if bad_vms then data = conv_vax_unix(data, target = 'sparc') $

      else  byteorder, data, /DTOXDR

      end
     
      7: return                             ;string

       8: BEGIN				    ;structure

	Ntag = N_tags( data )

	for t=0,Ntag-1 do  begin
          temp = data.(t)
          host_to_ieee, temp
          data.(t) = temp
        endfor 
       END

     else: message,'Unrecognized dataype ' + strtrim(idltype,2)

 ENDCASE

 return
 end 
