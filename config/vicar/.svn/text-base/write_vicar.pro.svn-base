;=============================================================================
;+
; NAME:
;	write_vicar
;
;
; PURPOSE:
;	Writes a vicar data file.
;
;
; CATEGORY:
;	UTIL/VIC
;
;
; CALLING SEQUENCE:
;	write_vicar, filename, data, label
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	String giving the name of the file to be written.
;
;	data:		Data to be written.
;
;	label:		String giving the vicar label.  System items
;			will be added or changed as appropriate.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	silent:	If set, no messages are printed.
;
;	swap:	If set, the data array will be byte-swapped.
;
;	flip:	If set, the data array will be subjected to a rotate(data, 7),
;		i.e., if its an image, it will be flipped vertically.
;
;       bpa:    Binary Prefix Array.
;
;	bha:	Binary Header Array.
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
;	This program only writes band-sequential data with no binary header 
;	or prefixes.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	read_vicar
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1996
;	Spitale 2/2004:	fixed bug where LBLSIZE wasn't always placed at the
;                       start of the header.
;	Spitale 6/2004:	added bpa and bha output.
;
;-
;=============================================================================

;===========================================================================
; write_vicar
;
;===========================================================================
pro write_vicar, filename, data, label, status=status, $
   silent=silent, swap=swap, show=show, flip=flip, bpa=bpa, bha=bha

 status=0
 file_data=data

 if(NOT keyword_set(label)) then label=''


;----------------------determine image dimensions------------------------

 s=size(data)
 n_dim=s(0)
 n_samples=s(1)
 if(n_dim GT 1) then n_lines=s(2) else n_lines=1
 if(n_dim EQ 3) then n_bands=s(3) else n_bands=1

 if(n_dim GT 3) then $
  begin
   status='Number of dimensions must be 3 or fewer.'
   if(NOT keyword_set(silent)) then message, status
   return
  end


;----------------------determine format------------------------

 typecode=s(n_dim+1)

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

 nbb = 0
 if(keyword_set(bpa)) then nbb = n_elements(bpa) / n_lines / n_bands

 nlb = 0
 if(keyword_set(bha)) then nlb = n_elements(bha) / ((n_samples*elm_size)+nbb)

 recsize = n_samples*elm_size + nbb


;----------------------determine host------------------------

 host=gethost(status=status)
 if(keyword_set(status)) then $
  begin
   if(NOT keyword_set(silent)) then message, status
   return
  end


;--------------determine integer and real formats-------------

 bb = 1
 byteorder, bb, /htons
 if(bb EQ 1) then intfmt = 'HIGH' $
 else intfmt = 'LOW'

; if((host EQ 'VAX-VMS') OR (host EQ 'DECSTATN')) then intfmt='LOW' $
; else intfmt='HIGH'

 if(host EQ 'VAX-VMS') then realfmt='VAX' $
 else if(intfmt EQ 'LOW') then realfmt='RIEEE' $
 else realfmt='IEEE'

; if(host EQ 'VAX-VMS') then realfmt='VAX' $
; else if(host EQ 'DECSTATN') then realfmt='RIEEE' $
; else realfmt='IEEE'


;--------------set the system label items---------------

; label = ''

 vicdelpar, label, 'LBLSIZE'

 vicsetpar, label, 'BLTYPE', '', /prepend
 vicsetpar, label, 'BREALFMT', realfmt, /prepend
 vicsetpar, label, 'BINTFMT', intfmt, /prepend
 vicsetpar, label, 'BHOST', host, /prepend
 vicsetpar, label, 'REALFMT', realfmt, /prepend
 vicsetpar, label, 'INTFMT', intfmt, /prepend
 vicsetpar, label, 'HOST', host, /prepend
 vicsetpar, label, 'NLB', nlb, /prepend
 vicsetpar, label, 'NBB', nbb, /prepend
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
 vicsetpar, label, 'LBLSIZE', 100000, /prepend, pad=22
						; Make sure that LBLSIZE is the
						; first keyword.
 label_nbytes = strlen(label)
 rem = label_nbytes mod recsize

 if(rem NE 0) then $				; Align label with record
  label_nbytes = label_nbytes + recsize - rem	; boundary.

 vicsetpar, label, 'LBLSIZE', label_nbytes, pad=22

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


;-------------------write binary header----------------------

 if(keyword_set(bha)) then writeu, unit, bha


;----------take care of any necessary byte-swapping-----------

 if(keyword_set(swap)) then $
  begin
   byteorder, file_data
   if(NOT keyword_set(silent)) then print, 'Byte swapping has been performed.'
  end


;----------------flip if necessary---------------

 if(keyword_set(flip)) then file_data=rotate(file_data, 7)


;------------------write data---------------

 if(keyword_set(bpa)) then $
  begin
   for j=0, n_bands-1 do $
    for i=0, n_lines-1 do $
     begin
      writeu, unit, bpa[*,i]
      writeu, unit, file_data[*,i,j]
     end
  end $
 else writeu, unit, file_data


;------------------clean up-------------------

 close, unit
 free_lun, unit


end
;===========================================================================
