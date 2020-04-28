;=============================================================================
;+
; NAME:
;	convert_sedrupd
;
;
; PURPOSE:
;	Create an IDL sedrupd file from the original VAX indexed file.
;	The data are fixed length records of the form sedrupd, length
;	84 bytes.  An index containing the sctime is also created.
;
;
; CATEGORY:
;	UTIL/SEDR/CREATE
;
;
; CALLING SEQUENCE:
;	convert_sedrupd, planet
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
;	The IDL sedrupd file has its float and double entries in XDR
;	format and its integers in Network byte order.  The conversion
;	is done by the sedr_unpack_sedrupd procedure.  WRITEU is used to create
;	the file instead of ASSOC since the structure is byte-padded
;	differently on different platforms.  The original file is called
;	'PLANET'.SDRU, the output files are 'planet'.sdru_idl data
;	file and 'planet'.sdru_idx index file.
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
pro convert_sedrupd, planet

openr, 1, planet+'.sdru'
record = {sedrupd}

openw, 2, planet+'.sdru_idl', 84, /none

i = long(0)

on_ioerror, eod

while 1 do $
 begin
  readu, 1, record
  sedr_unpack_sedrupd, record, /pack
  if(i EQ 0) then index = record.sctime $
  else index = [index, record.sctime]
  writeu, 2, record
  i = i + 1
 end

eod:
close, 1
close, 2
print, 'Total of',i,' sedrupd records.'

;-----------------------------------
; Write out index
;-----------------------------------
openw, 3, planet+'.sdru_idx', i, /none
writeu, 3, index
close, 3

end
