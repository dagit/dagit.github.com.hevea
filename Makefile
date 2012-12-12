%.html: %.tex
	hevea $*
	hevea $*
	latex $*.image
	latex $*.image
	./fixup-refs.sh $@
	pdflatex $*
	pdflatex $*

