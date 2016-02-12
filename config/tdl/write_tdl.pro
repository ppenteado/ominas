;=============================================================================
;+
; NAME:
;	write_tdl
;
;
; PURPOSE:
;	Writes a tab-delimited (tdl) text data file.  This is essentially
;	a VICAR file, except that the data is written as tab-delimited
;	text, suitable for reading into excel.  The label is written
;	as the first line of the file.  You may need to use '.csv' file
;	extensio for Excel to recognize the format.  
;
;
; CATEGORY:
;	UTIL/TDL
;
;
; CALLING SEQUENCE:
;	write_tdl, filename, data, label
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	String giving the name of the file to be written.
;
;	data:		Data to be written.
;
;	label:		String giving the tdl label.  System items
;			will be added or changed as appropriate.  This is
;			essentially a VICAR label, adabpted for this purpose.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	silent:	If set, no messages are printed.
;
;
;  OUTPUT:
;	status:	If no errors occur, status will be zero, otherwise
;		it will be a string giving an error message.
;
;
; RETURN: NONE
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
;	read_tdl
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2006
;
;-
;=============================================================================

;===========================================================================
; write_tdl
;
;===========================================================================
pro write_tdl, filename, data, label, status=status, $
   silent=silent, show=show

 status=0
 file_data = data

 if(NOT keyword_set(label)) then label = ''


;----------------------determine image dimensions------------------------

 s = size(data)
 n_dim = s(0)
 n_samples = s(1)
 if(n_dim GT 1) then n_lines = s(2) else n_lines = 1
 if(n_dim EQ 3) then n_bands = s(3) else n_bands = 1

 if(n_dim GT 3) then $
  begin
   status='Number of dimensions must be 3 or fewer.'
   if(NOT keyword_set(silent)) then message, status
   return
  end


;----------------------determine format------------------------

 typecode = s(n_dim+1)

 case typecode of
  1: begin
      format='BYTE'
      elm_size=1
     end
  2: begin
      format='HALF'
      elm_size=2
     end
  3: begin
      format='FULL'
      elm_size=4
     end
  4: begin
      format='REAL'
      elm_size=4
     end
  5: begin
      format='DOUB'
      elm_size=8
     end

  else : $
	begin
	 status='Unsupported format.'
	 if(NOT keyword_set(silent)) then message, status
	 return
	end
 endcase

 recsize = n_samples*elm_size


;--------------set the system label items---------------

 vicdelpar, label, 'TDL_LBLSIZE'

 vicsetpar, label, 'BLTYPE', '', /prepend
 vicsetpar, label, 'N4', 0, /prepend
 vicsetpar, label, 'N3', n_bands, /prepend
 vicsetpar, label, 'N2', n_lines, /prepend
 vicsetpar, label, 'N1', n_samples, /prepend
 vicsetpar, label, 'NB', n_bands, /prepend
 vicsetpar, label, 'NS', n_samples, /prepend
 vicsetpar, label, 'NL', n_lines, /prepend
 vicsetpar, label, 'ORG', 'BSQ', /prepend
 vicsetpar, label, 'RECSIZE', recsize, /prepend
 vicsetpar, label, 'EOL', '', /delete, /prepend
 vicsetpar, label, 'DIM', 3, /prepend
 vicsetpar, label, 'BUFSIZ', recsize, /prepend
 vicsetpar, label, 'TYPE', '', /delete, /prepend
 vicsetpar, label, 'FORMAT', format, /prepend
 vicsetpar, label, 'TDL_LBLSIZE', 100000, /prepend, pad=22
						; Make sure that TDL_LBLSIZE is the
						; first keyword.
 label_nbytes = strlen(label)
 rem = label_nbytes mod recsize

 if(rem NE 0) then $				; Align label with record
  label_nbytes = label_nbytes + recsize - rem	; boundary.

 vicsetpar, label, 'TDL_LBLSIZE', label_nbytes, pad=22

 label = str_pad(label, label_nbytes-1)		; Pad the label out to the
						; record boundary.


;----------------open file------------------

 openw, unit, filename, /get_lun, error=error
 if(error NE 0) then $
  begin
   status=!err_string
   if(NOT keyword_set(silent)) then message, status
   return
  end


;-------------------write label----------------------

 printf, unit, label


;------------------write data---------------

 ;- - - - - - - - - - - - - - - - - - - - -
 ; construct format code
 ;- - - - - - - - - - - - - - - - - - - - -
 case format of 
  'BYTE'	:	form0 = 'I3'
  'HALF'	:	form0 = 'I6'
  'FULL'	:	form0 = 'I11'
  'REAL'	:	form0 = 'G36.28E5'
  'DOUB'	:	form0 = 'E36.28E5'
 endcase

 form = '(' + strtrim(n_samples,2) + form0 + ')'

 ;- - - - - - - - - - - - - - - - - - - - -
 ; write data, band by band
 ;- - - - - - - - - - - - - - - - - - - - -
 for i=0, n_bands-1 do $
  begin
   s = string(form=form, file_data[*,*,i])
   s = strtrim(strcompress(s),2)
   s = strep_char(s, ' ', '	')

   printf, unit, s
   printf, unit
  end


;------------------clean up-------------------

 close, unit
 free_lun, unit


end
;===========================================================================
