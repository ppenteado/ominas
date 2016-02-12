##############################################################################
# Makefile for MINAS VGR CDROM interface
#
##############################################################################
include		$(MINAS_PLATFORM_DEFS)

COMPILE=	$(GCC)
LINK=		$(LDSO)

CFLAGS=		-I$(IDL_DIR)/external/ $(CC_OPTIONS) $(SO_CC_OPTIONS)
LFLAGS=		-L$(NV_VGR_CD) $(SO_LD_OPTIONS) 
#LFLAGS=		-L$(MINAS_DIR)/debug/ $(SO_LD_OPTIONS) 

LIBS=		$(C_LIBS)

BIN=		$(NV_VGR_CD)/bin/$(MINAS_PLATFORM)/

project:	vgr_cd_input.so 

vgr_cd_input.so : vgr_cd_input.o $(NV_VGR_CD)/decomp.o
	mkdir -p $(BIN)
	$(LINK) $(LFLAGS) -o $(BIN)/vgr_cd_input.so \
		$(NV_VGR_CD)/vgr_cd_input.o $(NV_VGR_CD)/decomp.o $(LIBS) 
	rm -f $(NV_VGR_CD)/*.o

vgr_cd_input.o: $(NV_VGR_CD)/vgr_cd_input.c
	$(COMPILE) $(CFLAGS) $(DEBUG) $(ANSI) \
		-c $(NV_VGR_CD)/vgr_cd_input.c -o $(NV_VGR_CD)/vgr_cd_input.o

decomp.o: $(NV_VGR_CD)/decomp.c
	$(COMPILE) $(ANSI) \
		-c $(NV_VGR_CD)/decomp.c -o $(NV_VGR_CD)/decomp.o



##############################################################################
