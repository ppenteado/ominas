;=============================================================================
;+
; NAME:
;	dat_lookup_transforms
;
;
; PURPOSE:
;	Looks up the names of the data input and output functions in
;	the I/O table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_lookup_transforms, instrument, input_transforms, output_transforms
;
;
; ARGUMENTS:
;  INPUT:
;	instrument:	Instrument string from dat_detect_instrument.
;
;  OUTPUT:
;	input_transforms:	Array giving the names of the input transform 
;				functions.
;
;	output_transforms:	Array giving the names of the output transform 
;				functions.
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro dat_lookup_transforms, instrument, $
       input_transforms, output_transforms, $
        tab_transforms=tab_transforms
@nv_block.common
@core.include


 marker='-'
 input_transforms = ''
 output_transforms = ''

 ;=====================================================
 ; read the transforms table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.trf_table_p)) then $
   dat_read_config, 'NV_TRANSFORMS', stat=stat, /con, $
              nv_state.trf_table_p, nv_state.transforms_filenames_p
 if(stat NE 0) then $
   nv_message, /con, $
     'No transforms table.', $
       exp=['The transforms table specifies the names of programs to transform', $
            'data values as they are read or written.  OMINAS should work fine', $
            'without this table, but some data sources may have problems.']


 table = *nv_state.trf_table_p
 if(NOT keyword_set(table)) then return


 ;==============================================================
 ; lookup the instrument string
 ;==============================================================
 input_transform = ''
 output_transform = ''

 instruments = table[*,0]
 w0 = (where(instruments EQ instrument))[0]


 ;================================================================
 ; extract all given transforms 
 ;================================================================
 if(w0 NE -1) then $
  begin
   w1 = w0
   wn = where(instruments[w0:*] NE marker)
   wc = where(instruments[w0:*] EQ marker)
   if(wc[0] NE -1) then $
    begin
     if(n_elements(wn) GT 1) then w1 = w0 + wn[1]-1 $
     else w1 = w0 + n_elements(wc)
    end

   input_transforms = table[w0:w1,1]
   output_transforms = table[w0:w1,2]
  end $
 else return
 

 ;================================
 ; filter out any place markers
 ;================================
 w = where(input_transforms NE marker)
 if(w[0] EQ -1) then input_transforms = '' $
 else input_transforms = input_transforms[w]

 w = where(output_transforms NE marker)
 if(w[0] EQ -1) then output_transforms = '' $
 else output_transforms = output_transforms[w]


end
;===========================================================================
