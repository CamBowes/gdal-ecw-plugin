# Makefile for building a standalone GDAL-plugin for ECW support
# Modified to use existing library files

ECWDIR ?= /usr

ECW_INCLUDE = -I$(ECWDIR)/local/include/NCSECW
ECW_LIBRARY = $(ECWDIR)/local/lib/libNCSEcw.so

CXXFLAGS = -g -O2 -fPIC -Wall $(USER_DEFS)
ECW_FLAGS = -DHAVE_ECW_BUILDNUMBER_H -DLINUX -DX86 -DPOSIX -DHAVE_COMPRESS -DECW_COMPRESS_RW_SDK_VERSION
OBJ = ecwdataset.o ecwcreatecopy.o jp2userbox.o ecwasyncreader.o
GDAL_INCLUDE = $(shell gdal-config --cflags | sed 's/-I//g')
AUTOLOAD_DIR = $(shell gdal-config --prefix)/lib/gdalplugins

CPPFLAGS := -DFRMT_ecw -I $(GDAL_INCLUDE) $(ECW_FLAGS) $(ECW_INCLUDE) $(EXTRA_CFLAGS)
PLUGIN_SO = gdal_ECW_JP2ECW.so

default: plugin

clean:
	rm -f *.o $(O_OBJ) *.so
	
install-obj: $(O_OBJ:.o=.$(OBJ_EXT))

install: default
	install -d $(AUTOLOAD_DIR)
	cp $(PLUGIN_SO) $(AUTOLOAD_DIR)

$(OBJ) $(O_OBJ): gdal_ecw.h

plugin: $(PLUGIN_SO)

$(PLUGIN_SO): $(OBJ)
	g++ -shared -o $(PLUGIN_SO) $(LNK_FLAGS) $(OBJ) $(ECW_LIBRARY) -lgdal
