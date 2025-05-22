all: calls
extract: extract.sh
	sh $<
extract.sh: extract.ml
	ocaml $< > $@
N = 1
packatlas:
	sprpack -f atlas-$(shell date --iso)_$(N).png extracted/*.png
clean:
	$(RM) extracted/Scr*.png
	$(RM) output.png
calls:
	$(MAKE) extract
	$(MAKE) packatlas
