%.html: %.tex
	hevea $*
	hevea $*
	latex $*.image
	latex $*.image
	./fixup-refs.sh $@

%.pdf : %.tex
	pdflatex $*
	pdflatex $*

all : hello.html hello.pdf

clean:
	rm -rf *.aux *.log hello.html hello.pdf
