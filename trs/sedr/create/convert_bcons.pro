;=============================================================================
;+
; NAME:
;	convert_bcons
;
;
; PURPOSE:
;	Create an IDL bcons file from the original VAX indexed file.
;	The data are fixed length records of the form bcons, length
;	165 bytes.  An index containing the planet and satellite number
;	is also created.  The number is consistent with the SEDR target
;	number (sat_num*10 + planet_num).
;
; CATEGORY:
;	UTIL/SEDR/CREATE
;
;
; CALLING SEQUENCE:
;	convert_bcons
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;	The IDL bcons file has its float and double entries in XDR
;	format and its integers in Network byte order.  The conversion
;	is done by the sedr_unpack_bcons procedure.  WRITEU is used to create
;	the file instead of ASSOC since the structure is byte-padded
;	differently on different platforms.  The original file is called
;	BODYCONST.DAT, the output files are bodyconst.dat_idl data
;	file and bodyconst.dat_idx index file.
;
;
; RESTRICTIONS: 
;	This procedure is meant to be run on a VAX computer running OpenVMS
;	where the original data file was hosted.  The file is then moved
;	to another platform via FTP in binary mode.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
;	Written by:    Haemmerle, 12/1998
;	
;-
;=============================================================================
pro convert_bcons

openr, 1, 'bodyconst.dat'
record = {bcons}

openw, 2, 'bodyconst.dat_idl', 165, /none

i = long(0)

on_ioerror, eod

while 1 do $
 begin
  readu, 1, record
  if(i EQ 0) then index = record.planet_number + record.sat_number*10 $
  else index = [index, record.planet_number + record.sat_number*10]
  sedr_unpack_bcons, record, /pack
  writeu, 2, record
  i = i + 1
 end

eod:
close, 1
close, 2
print, 'Total of',i,' bcons records.'

;-----------------------------------
; Write out index
;-----------------------------------
openw, 3, 'bodyconst.dat_idx', i, /none
byteorder, index, /HTONS
writeu, 3, index
close, 3

end
