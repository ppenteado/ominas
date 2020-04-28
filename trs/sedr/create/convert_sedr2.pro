;=============================================================================
;+
; NAME:
;	convert_sedr2
;
;
; PURPOSE:
;	Create an IDL sedr2 file from the original VAX indexed file.
;	The data are fixed length records of the form sedr2, length
;	134 bytes.  An index containing the sctime is also created.
;
;
; CATEGORY:
;	UTIL/SEDR/CREATE
;
;
; CALLING SEQUENCE:
;	convert_sedr2, planet
;
;
; ARGUMENTS:
;  INPUT:
;
;	planet:		String containing the central body of the sedr2
;			file.  planet can be one of 'jupiter', 'saturn',
;			'uranus' or 'neptune'.
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
;	The IDL sedr2 file has its float and double entries in XDR
;	format and its integers in Network byte order.  The conversion
;	is done by the sedr_unpack_sedr2 procedure.  WRITEU is used to create
;	the file instead of ASSOC since the structure is byte-padded
;	differently on different platforms.  The original file is called
;	'PLANET'.SDR2, the output files are 'planet'.sdr2_idl data
;	file and 'planet'.sdr2_idx index file.
;
;
; RESTRICTIONS: 
;	This procedure is meant to be run on a VAX computer running OpenVMS
;	where the original data file was hosted. The file is then moved
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
pro convert_sedr2, planet

openr, 1, planet+'.sdr2'
record = {sedr2}

openw, 2, planet+'.sdr2_idl', 134, /none

i = long(0)

on_ioerror, eod

while 1 do $
 begin
  readu, 1, record
  sedr_unpack_sedr2, record, /pack
  if(i EQ 0) then index = record.sctime $
  else index = [index, record.sctime]
  writeu, 2, record
  i = i + 1
 end

eod:
close, 1
close, 2
print, 'Total of',i,' sedr2 records.'

;-----------------------------------------
; Write out index (use i as record length)
;-----------------------------------------
openw, 3, planet+'.sdr2_idx', i, /none
writeu, 3, index
close, 3

end
