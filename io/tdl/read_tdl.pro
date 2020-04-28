;=============================================================================
;+
; NAME:
;	read_tdl
;
;
; PURPOSE:
;	Reads a tdl data file.  This is essentially a VICAR file, except
;	that the data are written in string form.
;
;
; CATEGORY:
;	UTIL/TDL
;
;
; CALLING SEQUENCE:
;	data = read_tdl(filename, label)
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	String giving the name of the file to be read.
;
;  OUTPUT:
;	label:		Named variable in which the tdl label will be
;			returned.
;
;
; KEYWORDS:
;  INPUT:
;	n_l:	If set, this will override the number of lines given by the 
;		'NL' field of the label.	
;
;	n_s:	If set, this will override the number of samples given by the 
;		'NS' field of the label.
;
;	n_b:	If set, this will override the number of bands given by the 
;		'NB' field of the label.
;
;	silent:	If set, no messages are printed.
;
;  OUTPUT:
;	status:	If no errors occur, status will be zero, otherwise
;		it will be a string giving an error message.
;
;
; RETURN:
;	The data array read from the file.
;
;
; RESTRICTIONS:
; 	This routine relies on the presence of the routines vigetpar 
;	and vicsetpar.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	write_tdl
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2006
;-
;=============================================================================

;===========================================================================
; rtdl_pl_suffix
;
;===========================================================================
function rtdl_pl_suffix, n
 if(n NE 1) then return, 's'
 return, ''
end
;===========================================================================



;===========================================================================
; rtdl_strip_quotes
;
;===========================================================================
function rtdl_strip_quotes, s

 t=strtrim(s,2)
 
 if(strmid(t, 0, 1) EQ "'") then t=strmid(t, 1, strlen(t)-1)
 if(strmid(t, strlen(t)-1, 1) EQ "'") then t=strmid(t, 0, strlen(t)-1)

 return, t
end
;===========================================================================



;===========================================================================
; read_tdl
;
;===========================================================================
function read_tdl, filename, label, status=status, $
   silent=silent, $
   n_l=n_l, n_s=n_s, n_b=n_b, show=show, $
   nodata=_nodata, get_nl=nl, get_ns=ns, get_nb=nb, tye=type

 nodata = keyword_set(_nodata)

 if(n_elements(n_l) NE 0) then nl=n_l
 if(n_elements(n_s) NE 0) then ns=n_s
 if(n_elements(n_b) NE 0) then nb=n_b

 status=0

 ;----------------------------------
 ; read file
 ;----------------------------------
 lines = read_txt_file(filename)

 ;----------------------------------
 ; get label
 ;----------------------------------
 label = lines[0]


;------------get data dimensions-------------

 nl_note = ''
 if(n_elements(nl) EQ 0) then $
  begin
   nl = long(vicgetpar(label, 'NL', status=status))
   if(keyword_set(status)) then $
    begin
     if(NOT keyword_set(silent)) then message, status
     close, unit
     free_lun, unit
     return, 0
    end
  end else nl_note = ' (forced)'

 ns_note = ''
 if(n_elements(ns) EQ 0) then $
  begin
   ns = long(vicgetpar(label, 'NS', status=status))
   if(keyword_set(status)) then $
    begin
     if(NOT keyword_set(silent)) then message, status
     close, unit
     free_lun, unit
     return, 0
    end
  end else ns_note = ' (forced)'

 nb_note=''
 if(n_elements(nb) EQ 0) then $
  begin
   nb = long(vicgetpar(label, 'NB', status=status))
   if(keyword_set(status)) then $
    begin
     nb = 1
     nb_note = ' (by default)'
    end
  end else nb_note = ' (forced)'



 if(NOT keyword_set(silent)) then $
  begin
   print,'NL = '+strtrim(nl,2)+' line'+rtdl_pl_suffix(nl)+nl_note
   print,'NS = '+strtrim(ns,2)+' sample'+rtdl_pl_suffix(ns)+ns_note
   print,'NB = '+strtrim(nb,2)+' band'+rtdl_pl_suffix(nb)+nb_note
  end


;-----------------get data format------------------

 format = vicgetpar(label, 'FORMAT', status=status)
 format = rtdl_strip_quotes(strupcase(format))


 ;------------------------------------------
 ; get data
 ;------------------------------------------
 data = dblarr(ns,nl*nb)

 ss = lines[1:*]
 for i=0, ns-1 do $
  begin
   if(i EQ ns-1) then s = ss $
   else s = str_nnsplit(ss, '	', rem=ss)
   data[i,*] = double(s)
  end

 data = reform(reform(data, ns,nl,nb))


;------set up arrays for the appropriate data format-------

 case format of
  'BYTE' : data = byte(data)

  'HALF' :  data = fix(data)

  'FULL' : data = long(data)

  'REAL' : data = float(data)

  'DOUB' : 

  else : $
      begin
       status='Unrecognized data format : '+format+'.'
       if(NOT keyword_set(silent)) then message, status
       return, 0
      end
 endcase

 type = size(data, /type)


 return, data
end
;===========================================================================
