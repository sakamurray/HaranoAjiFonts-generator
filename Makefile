all: output_otfs

.PHONY: all output_otfs clean


CMAP = UniJIS2004-UTF32-H

ORIGINAL_FAMILY_SANS = SourceHanSans
ORIGINAL_FAMILY_SERIF = SourceHanSerif
OUTPUT_FAMILY_SANS = HaranoAjiGothic
OUTPUT_FAMILY_SERIF = HaranoAjiMincho

WEIGHT_SANS = ExtraLight Light Normal Regular Medium Bold Heavy
WEIGHT_SERIF = ExtraLight Light Regular Medium SemiBold Bold Heavy
#WEIGHT_SANS = Regular
#WEIGHT_SERIF  = Medium

ORIGINAL_FONTS = $(addprefix $(ORIGINAL_FAMILY_SANS)-,$(WEIGHT_SANS)) \
	$(addprefix $(ORIGINAL_FAMILY_SERIF)-,$(WEIGHT_SERIF))

OUTPUT_FONTS = $(addprefix $(OUTPUT_FAMILY_SANS)-,$(WEIGHT_SANS)) \
	$(addprefix $(OUTPUT_FAMILY_SERIF)-,$(WEIGHT_SERIF))

BUILD_OTFS = $(addprefix build/,$(addsuffix /output.otf,$(ORIGINAL_FONTS)))
OUTPUT_OTFS = $(addsuffix .otf,$(OUTPUT_FONTS))


output_otfs: $(OUTPUT_OTFS)


ttx/%.ttx: download/%.otf
	mkdir -p ttx
	$(MAKE) -C ttx $*.ttx

bin/make_conv_table:
	$(MAKE) -C src
	$(MAKE) -C src install

build/%/output.otf: ttx/%.ttx bin/make_conv_table
	mkdir -p build/$*
	./make_font.sh $* $(CMAP)


HaranoAjiGothic-%.otf: build/SourceHanSansJP-%/output.otf
	cp $< $@
HaranoAjiMincho-%.otf: build/SourceHanSerifJP-%/output.otf
	cp $< $@


.SECONDARY: ttx/%.ttx build/%/output.otf
.PRECIOUS: ttx/%.ttx build/%/output.otf


clean:
	$(RM) *~
	$(MAKE) -C src clean
	$(MAKE) -C ttx clean
