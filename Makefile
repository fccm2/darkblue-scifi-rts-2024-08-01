all: calls
extract: extract.mk
	$(MAKE) -f $<
extract.mk: extract.ml
	echo "all:" > $@
	ocaml $< | sed -e 's/^/\t/g' >> $@
N = 1
packatlas:
	sprpack -f atlas-$(shell date --iso)_$(N).png extracted/*.png
clean:
	$(RM) extracted/Scr*.png
	$(RM) output.png
	$(RM) extract.mk
calls:
	$(MAKE) extract
	$(MAKE) packatlas
