SRC_DIR ?= src
TOOLS_DIR ?= tools
OUT_DIR ?= XLDLIBS

# Default languages for non-localized files
SRC_LANG ?= ENGLISH
SRC_LANG1 ?= GERMAN
SRC_LANG2 ?= ENGLISH
SRC_LANG3 ?= FRENCH

SRC_LANG_DIR := $(SRC_DIR)/_$(SRC_LANG)
SRC_LANG1_DIR := $(SRC_DIR)/_$(SRC_LANG1)
SRC_LANG2_DIR := $(SRC_DIR)/_$(SRC_LANG2)
SRC_LANG3_DIR := $(SRC_DIR)/_$(SRC_LANG3)

.PHONY: all base initial lang lang1 lang2 lang3

# xlds(basename, ext, outdir?) - identifies XLDs to create based on input parts
define xlds
$(patsubst %,$(OUT_DIR)$(3)/$(1)%.XLD,$(shell $(TOOLS_DIR)/getxlds $(2) $(SRC_LANG_DIR)/$(1)/ $(SRC_DIR)/$(1)/))
endef

# parts(basename, index, ext, lang?) - finds input parts for a single XLD file
define parts
$(shell $(TOOLS_DIR)/getparts $(2) $(3) $(SRC_LANG$(4)_DIR)/$(1)/ $(SRC_DIR)/$(1)/)
endef

# parts_ext(basename, index, ext, ext_append, lang?) - same but appends another extension
define parts_ext
$(patsubst %$(3),%$(3)$(4),$(call parts,$(1),$(2),$(3),$(5)))
endef

all: base initial lang

base: \
	$(OUT_DIR)/ITEMGFX \
	$(OUT_DIR)/ITEMLIST.DAT \
	$(OUT_DIR)/ITEMNAME.DAT \
	$(OUT_DIR)/PALETTE.000 \
	$(OUT_DIR)/SLAB \
	$(OUT_DIR)/SPELLDAT.DAT \
	$(call xlds,3DBCKGR,.IMG) \
	$(call xlds,3DFLOOR,.RAW) \
	$(call xlds,3DOBJEC,.RAW) \
	$(call xlds,3DOVERL,.RAW) \
	$(call xlds,3DWALLS,.RAW) \
	$(call xlds,AUTOGFX,.RAW) \
	$(call xlds,BLKLIST,.DAT) \
	$(call xlds,COMBACK,.RAW) \
	$(call xlds,COMGFX,.IMG) \
	$(call xlds,EVNTSET,.DAT) \
	$(call xlds,FBODPIX,.IMG) \
	$(call xlds,FONTS,.FNT) \
	$(call xlds,ICONDAT,.DAT) \
	$(call xlds,ICONGFX,.RAW) \
	$(call xlds,LABDATA,.DAT) \
	$(call xlds,MAPDATA,.DAT) \
	$(call xlds,MONGFX,.IMG) \
	$(call xlds,MONGRP,.DAT) \
	$(call xlds,MONCHAR,.CHR) \
	$(call xlds,NPCGR,.IMG) \
	$(call xlds,NPCKL,.IMG) \
	$(call xlds,PALETTE,.PAL) \
	$(call xlds,PARTGR,.IMG) \
	$(call xlds,PARTKL,.IMG) \
	$(call xlds,PICTURE,.LBM) \
	$(call xlds,SAMPLES,.PCM) \
	$(call xlds,SCRIPT,.TXT) \
	$(call xlds,SMLPORT,.RAW) \
	$(call xlds,SONGS,.XMI) \
	$(call xlds,TACTICO,.RAW) \
	$(call xlds,TRANSTB,.DAT) \
	$(call xlds,WAVELIB,.WVL)

initial: \
	$(call xlds,AUTOMAP,.DAT,/INITIAL) \
	$(call xlds,CHESTDT,.DAT,/INITIAL) \
	$(call xlds,MERCHDT,.DAT,/INITIAL) \
	$(call xlds,NPCCHAR,.CHR,/INITIAL) \
	$(call xlds,PRTCHAR,.CHR,/INITIAL)

lang: lang1 lang2 lang3

lang1: \
	$(OUT_DIR)/GERMAN/SYSTEXTS \
	$(call xlds,MAPTEXT,.TXT,/GERMAN) \
	$(call xlds,EVNTTXT,.TXT,/GERMAN) \
	$(call xlds,WORDLIS,.TXT,/GERMAN) \
	$(call xlds,FLICS,.FLC,/GERMAN)

lang2: \
	$(OUT_DIR)/ENGLISH/SYSTEXTS \
	$(call xlds,MAPTEXT,.TXT,/ENGLISH) \
	$(call xlds,EVNTTXT,.TXT,/ENGLISH) \
	$(call xlds,WORDLIS,.TXT,/ENGLISH) \
	$(call xlds,FLICS,.FLC,/ENGLISH)

lang3: \
	$(OUT_DIR)/FRENCH/SYSTEXTS \
	$(call xlds,MAPTEXT,.TXT,/FRENCH) \
	$(call xlds,EVNTTXT,.TXT,/FRENCH) \
	$(call xlds,WORDLIS,.TXT,/FRENCH) \
	$(call xlds,FLICS,.FLC,/FRENCH)


$(TOOLS_DIR)/.empty:
	: > $@

%.TXT.SED: %.TXT
	$(TOOLS_DIR)/cmap < $< > $@
	touch -r $< $@

%.TXT.OEM: %.TXT $(SRC_LANG_DIR)/CHARMAP.TXT.SED
	$(TOOLS_DIR)/text $(SRC_LANG_DIR)/CHARMAP.TXT.SED $< > $@

%.TXT.ANSI: %.TXT $(SRC_DIR)/ANSI.TXT.SED
	$(TOOLS_DIR)/text $(SRC_DIR)/ANSI.TXT.SED $< > $@

%.CRLF: %
	$(TOOLS_DIR)/crlf $< > $@

%.TXT.LIB: %.TXT.OEM
	$(TOOLS_DIR)/texts $< > $@

%.TXT.WRD: %.TXT.OEM
	$(TOOLS_DIR)/words $< > $@


$(SRC_DIR)/MONCHAR/%.CHR.DAT: $(SRC_DIR)/MONCHAR/%.CHR $(SRC_LANG1_DIR)/MONNAME.TXT.OEM $(SRC_LANG2_DIR)/MONNAME.TXT.OEM $(SRC_LANG3_DIR)/MONNAME.TXT.OEM
	$(TOOLS_DIR)/char $* $+ > $@

$(SRC_DIR)/NPCCHAR/%.CHR.DAT: $(SRC_DIR)/NPCCHAR/%.CHR $(SRC_LANG1_DIR)/NPCNAME.TXT.OEM $(SRC_LANG2_DIR)/NPCNAME.TXT.OEM $(SRC_LANG3_DIR)/NPCNAME.TXT.OEM
	$(TOOLS_DIR)/char $* $+ > $@

$(SRC_DIR)/PRTCHAR/%.CHR.DAT: $(SRC_DIR)/PRTCHAR/%.CHR $(SRC_LANG1_DIR)/PRTNAME.TXT.OEM $(SRC_LANG2_DIR)/PRTNAME.TXT.OEM $(SRC_LANG3_DIR)/PRTNAME.TXT.OEM
	$(TOOLS_DIR)/char $* $+ > $@


$(OUT_DIR) $(OUT_DIR)/INITIAL $(OUT_DIR)/GERMAN $(OUT_DIR)/ENGLISH $(OUT_DIR)/FRENCH:
	@mkdir -p $@


$(OUT_DIR)/ITEMGFX: $(SRC_DIR)/ITEMGFX.RAW | $(OUT_DIR)
	cat $< > $@

$(OUT_DIR)/ITEMLIST.DAT: $(SRC_DIR)/ITEMLIST.DAT | $(OUT_DIR)
	cat $< > $@

$(OUT_DIR)/ITEMNAME.DAT: $(SRC_LANG1_DIR)/ITEMNAME.TXT.OEM $(SRC_LANG2_DIR)/ITEMNAME.TXT.OEM $(SRC_LANG3_DIR)/ITEMNAME.TXT.OEM | $(OUT_DIR)
	$(TOOLS_DIR)/items $+ > $@

$(OUT_DIR)/PALETTE.000: $(SRC_DIR)/PALETTE.PAL | $(OUT_DIR)
	cat $< > $@

$(OUT_DIR)/SLAB: $(SRC_DIR)/SLAB.RAW | $(OUT_DIR)
	cat $< > $@

$(OUT_DIR)/SPELLDAT.DAT: $(SRC_DIR)/SPELLDAT.DAT | $(OUT_DIR)
	cat $< > $@


$(OUT_DIR)/GERMAN/SYSTEXTS: $(SRC_LANG1_DIR)/SYSTEXTS.TXT.OEM.CRLF | $(OUT_DIR)/GERMAN
	cat $< > $@

$(OUT_DIR)/ENGLISH/SYSTEXTS: $(SRC_LANG2_DIR)/SYSTEXTS.TXT.OEM.CRLF | $(OUT_DIR)/ENGLISH
	cat $< > $@

$(OUT_DIR)/FRENCH/SYSTEXTS: $(SRC_LANG3_DIR)/SYSTEXTS.TXT.OEM.CRLF | $(OUT_DIR)/FRENCH
	cat $< > $@


.SECONDEXPANSION:

$(OUT_DIR)/BLKLIST%.XLD: $$(call parts,BLKLIST,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/EVNTSET%.XLD: $$(call parts,EVNTSET,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ICONDAT%.XLD: $$(call parts,ICONDAT,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/LABDATA%.XLD: $$(call parts,LABDATA,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/MAPDATA%.XLD: $$(call parts,MAPDATA,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/MONGRP%.XLD: $$(call parts,MONGRP,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/TRANSTB%.XLD: $$(call parts,TRANSTB,$$*,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/3DFLOOR%.XLD: $$(call parts,3DFLOOR,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/3DOBJEC%.XLD: $$(call parts,3DOBJEC,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/3DOVERL%.XLD: $$(call parts,3DOVERL,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/3DWALLS%.XLD: $$(call parts,3DWALLS,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/AUTOGFX%.XLD: $$(call parts,AUTOGFX,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/COMBACK%.XLD: $$(call parts,COMBACK,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ICONGFX%.XLD: $$(call parts,ICONGFX,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/SMLPORT%.XLD: $$(call parts,SMLPORT,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/TACTICO%.XLD: $$(call parts,TACTICO,$$*,.RAW) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/3DBCKGR%.XLD: $$(call parts,3DBCKGR,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/COMGFX%.XLD: $$(call parts,COMGFX,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FBODPIX%.XLD: $$(call parts,FBODPIX,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/MONGFX%.XLD: $$(call parts,MONGFX,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/NPCGR%.XLD: $$(call parts,NPCGR,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/NPCKL%.XLD: $$(call parts,NPCKL,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/PARTGR%.XLD: $$(call parts,PARTGR,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/PARTKL%.XLD: $$(call parts,PARTKL,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/PARTKL%.XLD: $$(call parts,PARTKL,$$*,.IMG) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FONTS%.XLD: $$(call parts,FONTS,$$*,.FNT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/PICTURE%.XLD: $$(call parts,PICTURE,$$*,.LBM) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/PALETTE%.XLD: $$(call parts,PALETTE,$$*,.PAL) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/SAMPLES%.XLD: $$(call parts,SAMPLES,$$*,.PCM) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/SONGS%.XLD: $$(call parts,SONGS,$$*,.XMI) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/WAVELIB%.XLD: $$(call parts,WAVELIB,$$*,.WVL) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/SCRIPT%.XLD: $$(call parts_ext,SCRIPT,$$*,.TXT,.ANSI.CRLF) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/MONCHAR%.XLD: $$(call parts_ext,MONCHAR,$$*,.CHR,.DAT) | $(OUT_DIR)
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/INITIAL/AUTOMAP%.XLD: $$(call parts,AUTOMAP,$$*,.DAT) | $(OUT_DIR)/INITIAL
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/INITIAL/CHESTDT%.XLD: $$(call parts,CHESTDT,$$*,.DAT) | $(OUT_DIR)/INITIAL
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/INITIAL/MERCHDT%.XLD: $$(call parts,MERCHDT,$$*,.DAT) | $(OUT_DIR)/INITIAL
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/INITIAL/NPCCHAR%.XLD: $$(call parts_ext,NPCCHAR,$$*,.CHR,.DAT) | $(OUT_DIR)/INITIAL
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/INITIAL/PRTCHAR%.XLD: $$(call parts_ext,PRTCHAR,$$*,.CHR,.DAT) | $(OUT_DIR)/INITIAL
	$(TOOLS_DIR)/xld $+ > $@


$(OUT_DIR)/GERMAN/MAPTEXT%.XLD: $$(call parts_ext,MAPTEXT,$$*,.TXT,.LIB,1) | $(OUT_DIR)/GERMAN
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ENGLISH/MAPTEXT%.XLD: $$(call parts_ext,MAPTEXT,$$*,.TXT,.LIB,2) | $(OUT_DIR)/ENGLISH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FRENCH/MAPTEXT%.XLD: $$(call parts_ext,MAPTEXT,$$*,.TXT,.LIB,3) | $(OUT_DIR)/FRENCH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/GERMAN/EVNTTXT%.XLD: $$(call parts_ext,EVNTTXT,$$*,.TXT,.LIB,1) | $(OUT_DIR)/GERMAN
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ENGLISH/EVNTTXT%.XLD: $$(call parts_ext,EVNTTXT,$$*,.TXT,.LIB,2) | $(OUT_DIR)/ENGLISH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FRENCH/EVNTTXT%.XLD: $$(call parts_ext,EVNTTXT,$$*,.TXT,.LIB,3) | $(OUT_DIR)/FRENCH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/GERMAN/WORDLIS%.XLD: $$(call parts_ext,WORDLIS,$$*,.TXT,.WRD,1) | $(OUT_DIR)/GERMAN
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ENGLISH/WORDLIS%.XLD: $$(call parts_ext,WORDLIS,$$*,.TXT,.WRD,2) | $(OUT_DIR)/ENGLISH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FRENCH/WORDLIS%.XLD: $$(call parts_ext,WORDLIS,$$*,.TXT,.WRD,3) | $(OUT_DIR)/FRENCH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/GERMAN/FLICS%.XLD: $$(call parts,FLICS,$$*,.FLC,1) | $(OUT_DIR)/GERMAN
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/ENGLISH/FLICS%.XLD: $$(call parts,FLICS,$$*,.FLC,2) | $(OUT_DIR)/ENGLISH
	$(TOOLS_DIR)/xld $+ > $@

$(OUT_DIR)/FRENCH/FLICS%.XLD: $$(call parts,FLICS,$$*,.FLC,3) | $(OUT_DIR)/FRENCH
	$(TOOLS_DIR)/xld $+ > $@
