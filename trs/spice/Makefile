##############################################################################
# Makefile for MINAS NAIF/SPICE interface
#
# Notes on building the shareable object:
#
# After installing (and perhaps recompiling) cspice, you need to make a 
#  dynamic link in the cspice/lib directory with name libcspice.a pointing to
#  the appropriate library so that the linker will find it.
#
##############################################################################
include		$(MINAS_PLATFORM_DEFS)

COMPILE=	$(GCC)
LINK=		$(LDSO)

CFLAGS=		-I$(CSPICEDIR)/include/ -I$(IDL_DIR)/external/ \
		                                 $(CC_OPTIONS) $(SO_CC_OPTIONS)
#LFLAGS=		-L$(NV_SPICE) -L$(CSPICEDIR)/lib/ $(SO_LD_OPTIONS) 
LFLAGS=		-L$(MINAS_DIR)/debug/ -L$(CSPICEDIR)/lib/ $(SO_LD_OPTIONS) 

LIBS=		-lcspice $(C_LIBS)

BIN=		$(NV_SPICE)/bin/$(MINAS_PLATFORM)/

project:	spice_io.so ckcat

spice_io.so : spice_io.o
	mkdir -p $(BIN)
	$(LINK) $(LFLAGS) -o $(BIN)/spice_io.so \
		$(NV_SPICE)/spice_io.o $(LIBS) 
	rm -f $(NV_SPICE)/*.o


spice_io.o: $(NV_SPICE)/spice_io.c $(NV_SPICE)/mspice.h
	$(COMPILE) $(CFLAGS) $(DEBUG) $(ANSI) \
		-c $(NV_SPICE)/spice_io.c -o $(NV_SPICE)/spice_io.o

ckcat: $(NV_SPICE)/ckcat.c
	$(COMPILE) $(ANSI) -I$(CSPICEDIR)/include/ -L$(CSPICEDIR)/lib/ \
	-L$(MINAS_DIR)/debug/ $(NV_SPICE)/ckcat.c -o $(BIN)/ckcat $(LIBS)


##############################################################################
