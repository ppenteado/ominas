function ARBINPDS2, fname, label, objindex, SILENT=silent
;-----------------------------------------------------------------------------
; NAME:
;    ARBINPDS2 (array - binary - pds 2)
;
; PURPOSE:
;    Read a PDS binary array with axes greater than 2, into IDL array.
;
; CALLING SEQUENCE:
;    Result = ARBINPDS2(fname, label, objindex, /SILENT)
; 
; INPUTS:
;    fname: a scalar string containing the name of the PDS file to be read.
;    label: string array containing the "header" from the PDS file.
;    objindex: an integer specifying the starting index in the label for the
;              current array object to be processed.
;
; OPTIONAL INPUT:
;    SILENT: the silent keyword suppresses any messages produced by this
;            routine to the terminal.
; 
; OUTPUTS:
;    Result: PDS array constructed from designated input.
;
; EXAMPLE:
;    To read a Keck 6D fits file with a PDS label file. The array object
;    in the label starts at index 53:
;    IDL> label = headpds ('focus0037.lbl')
;    IDL> result = ARBINPDS2('focus0037.lbl', label, 53)
;    
;    The output is :
;    IDL> help, result
;       RESULT          LONG      Array[128, 128, 2, 1, 2]
;
; WARNINGS:
;    This version of ARBINPDS is to be used only on MSB architectures, under
;    IDL version 5.3.
;
; PROCEDURES USED:
;    Functions: GET_VIABLE, GET_INDEX, PDSPAR, CLEAN, REMOVE, POINTPDS,
;               and STR2NUM.
;
; MODIFICATION HISTORY:
;    Written by Puneet Khetarpal [March 16, 2004]
;
;    For a complete list of modifications, please see changelog.txt file.
;-----------------------------------------------------------------------------

   ; error protection---:
   ON_ERROR, 2
   ON_IOERROR, SIGNAL

   ; check for correct number of inputs---:
   if (n_params() LT 3) then begin 
      print, "Syntax: result = ARBINPDS2(filename, label, objindex [,/SILENT])"
      return, -1
   endif

   if (keyword_set(SILENT)) then silent = 1 else silent = 0
   
   ; obtain all array objects from the label---:
   objects = OBJPDS (label, 'ARRAY')
   objpos = where(objindex EQ objects.index)
   if (objpos[0] NE -1) then begin
      objarray = objects.array[objpos[0]]
   endif else begin
      print, "Error: Invalid objindex specified."
      return, -1
   endelse

   ; now obtain end_object index for the current object---:
   end_object_index = GET_INDEX(label, objindex)
   
   ; obtain global ARRAY keyword parameters---:
   ; first obtain interchange format keyword---:
   interform = PDSPAR (label, 'INTERCHANGE_FORMAT',INDEX=interformindex)
   if (!ERR EQ -1) then begin
      print, "Error: missing required INTERCHANGE_FORMAT keyword."
      return, -1
   endif else begin
      interpos = where (interformindex GT objindex AND interformindex LT $
                        end_object_index)
      interform = interform[interpos[0]]
      interform = interform[0]
      interform = CLEAN(interform, /SPACE)
      interform = REMOVE(interform, '"')
      if (interform EQ "ASCII") then begin
         print, "Error: this is a binary ARRAY file; try ARASCPDS."
         return, -1
      endif
   endelse

   ; now obtain required ARRAY keywords---:
   glob_axes = PDSPAR(label,'AXES',COUNT=glob_axes_count,INDEX=glob_axes_index)
   if (!ERR EQ -1) then begin
      print, "Error: missing required AXES keyword."
      return, -1
   endif

   glob_axis_items = PDSPAR(label,'AXIS_ITEMS',COUNT=glob_axis_items_count, $
                            INDEX=glob_axis_items_index)
   if (!ERR EQ -1) then begin
      print, "Error: missing required AXIS_ITEMS keyword."
      return, -1
   endif

   glob_name = PDSPAR(label,'NAME',COUNT=glob_name_count,INDEX=glob_name_index)
   if (!ERR EQ -1) then begin
      print, "Error: missing required NAME keyword."
      return, -1
   endif

   ; now obtain optional ARRAY keywords---:
   glob_start_byte = PDSPAR(label,'START_BYTE',COUNT=glob_start_byte_count, $
                           INDEX=glob_start_byte_index)
   
   glob_data_type = PDSPAR(label,'DATA_TYPE',COUNT=glob_data_type_count, $
                           INDEX=glob_data_type_index)
   if (!ERR EQ -1) then begin
      print, "Error: missing required DATA_TYPE keyword."
      return, -1
   endif

   glob_bytes = PDSPAR(label,'BYTES',COUNT=glob_bytes_count, $
                       INDEX=glob_bytes_index)
   if (!ERR EQ -1) then begin
      print, "Error: missing required BYTES keyword."
      return, -1
   endif

   offflag = 1
   glob_offset = PDSPAR(label,'OFFSET',COUNT=glob_offset_count, $
                        INDEX=glob_offset_index)
   if (!ERR EQ -1) then begin
      offflag = 0
      !ERR = 0
   endif

   scalflag = 1
   glob_scal = PDSPAR(label,'SCALING_FACTOR',COUNT=glob_scal_count, $
                      INDEX=glob_scal_index)
   if (!ERR EQ -1) then begin
      scalflag = 0
      !ERR = 0
   endif

   ; get the ELEMENT objects---:
   element_object = OBJPDS(label, 'ELEMENT')
   elem_index = element_object.index

   ; get viable element index---:
   viable_elem_pos = where (elem_index GT objindex AND elem_index LT $
                            end_object_index)
   if (viable_elem_pos[0] EQ -1) then begin
      print, "Error: no ELEMENT object found for given array."
      return, -1
   endif else if (n_elements(viable_elem_pos) GT 1) then begin
      print, "Error: more than 1 ELEMENT object found for 6-D image."
      return, -1
   endif else begin
      elem_index = elem_index[viable_elem_pos[0]]
      elem_end_index = GET_INDEX(label, elem_index)
   endelse

   ; obtain viable keyword values for the current ELEMENT object---:
   ; obtain start_byte---:
   start_byte_pos = where (glob_start_byte_index GT elem_index AND $
                           glob_start_byte_index LT elem_end_index)
   if (start_byte_pos[0] EQ -1) then begin
      start_byte = 0
   endif else begin
      start_byte = CLEAN(glob_start_byte[start_byte_pos[0]],/SPACE)
      start_byte = STR2NUM(start_byte)
   endelse

   ; obtain data_type---:
   data_type_pos = where (glob_data_type_index GT elem_index AND $
                          glob_data_type_index LT elem_end_index)
   if (data_type_pos[0] EQ -1) then begin
      print, "Error: ELEMENT object missing required DATA_TYPE keyword."
      return, -1
   endif else begin
      data_type = glob_data_type[data_type_pos[0]]
      data_type = REMOVE(data_type, '"')
   endelse

   ; obtain bytes_pos---:
   bytes_pos = where (glob_bytes_index GT elem_index AND $
                      glob_bytes_index LT elem_end_index)
   if (bytes_pos[0] EQ -1) then begin
      print, "Error: ELEMENT object missing required BYTES keyword."
      return, -1
   endif else begin
      bytes = CLEAN(glob_bytes[bytes_pos[0]],/SPACE)
      bytes = fix(STR2NUM(bytes))
   endelse

   ; obtain offset---:
   if (offflag EQ 1) then begin
      offset_pos = where (glob_offset_index GT elem_index AND $
                          glob_offset_index LT elem_end_index)
      if (offset_pos[0] NE -1) then begin
         offset = CLEAN(glob_offset[offset_pos[0]],/SPACE)
         offset = fix(STR2NUM(offset))
      endif else begin
         offset = 0
      endelse
   endif else begin
      offset = 0
   endelse

   ; obtain scaling factor---:
   if (scalflag EQ 1) then begin
      scal_pos = where (glob_scal_index GT elem_index AND $
                        glob_scal_index LT elem_end_index)
      if (scal_pos[0] NE -1) then begin
         scal = CLEAN(glob_scal[scal_pos[0]],/SPACE)
         scal = float(STR2NUM(scal))
      endif else begin
         scal = 1
      endelse
   endif else begin
      scal = 1
   endelse

   ; get axes and axis-items---:
   axespos = where (glob_axes_index GT objindex AND $
                    glob_axes_index LT end_object_index)
   axes = CLEAN(glob_axes[axespos[0]],/SPACE)
   axes = fix(STR2NUM(axes))
   
   axisitemspos = where (glob_axis_items_index GT objindex AND $
                         glob_axis_items_index LT end_object_index)
   axisitems = glob_axis_items[axisitemspos[0]]

   ; store axis items---:
   if (!VERSION.RELEASE GT 5.2) then begin
       tempitems = strsplit(axisitems, ',', /EXTRACT)
   endif else begin
       tempitems = str_sep(axisitems, ',')     ; obsolete in IDL v. > 5.2
   endelse
   param = ['"',',','(',')']
   axis_items = make_array(axes,/INTEGER,VALUE=0)
   for i = 0, n_elements(tempitems)-1 do begin
      axis_items[i] = REMOVE(tempitems[i],param)
   endfor

   bits = bytes * 8

   ; obtain IDL_TYPE---:
   case bits of 
         8:   IDL_type = 1          ; Byte
        16:   IDL_type = 2          ; Integer*2
        32:   IDL_type = 3          ; Integer*4
       -32:   IDL_type = 4          ; Real*4
       -64:   IDL_type = 5          ; Real*8
      else:   message,'ERROR - Illegal value of bits'
   endcase     

   ; get file pointer information---:
   pointer = POINTPDS(label, fname, 'ARRAY')
   fname = pointer.datafile
   skip = pointer.skip      

   if (silent EQ 0) then begin
      print, "Now reading array"
   endif

   ; make array---:
   data = make_array(DIM=axis_items, TYPE=IDL_type, /NOZERO)
   openr, unit, fname, /GET_LUN
   point_lun, unit, skip
   readu, unit, data
   close, unit
   free_lun, unit

   return, data

   SIGNAL:
      ON_IOERROR, NULL
      print, 'ERROR reading file'
      return, -1
end



