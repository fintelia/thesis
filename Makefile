LATEXRUN := ./bin/latexrun --bibtex-args=-min-crossrefs=100
PANDOC   := pandoc

# phony targets

all: main

clean:
	rm -rf latex.out version.tex fig/*.svg fig/*.pdf \
	*.aux *.log *.blg *.bbl *.ent *.out *.gz *fls *.fdb_latexmk proposal.pdf

.PHONY: all clean

# main targets

.PHONY: checkversion
checkversion: version.sh
	@sh $< version.tex

# This is a hack so that the paper will be regenerated any time the version
# changes, but not regenerated otherwise.
#
# Inlining the call to version.sh in the build process for paper.pdf is not
# enough, because the dependencies will look up to date even if the version
# changes (e.g. as a result of a git commit), so a `make` will not cause the
# paper to be rebuilt. Similarly, depending on a version.tex that's marked as
# .PHONY and generated with a call to version.sh is not ideal, because that
# will cause the paper to be rebuilt every time `make` is called.
#
# Instead, we add a level of indirection: the main makefile target is main,
# which has as prerequisites checkversion and paper.pdf. The checkversion
# prerequisite updates version.tex only if the version has changed, and
# paper.pdf depends on version.tex, so the paper is rebuilt only when the
# version is actually changed.
.NOTPARALLEL: main
.PHONY: main
main: checkversion proposal.pdf

proposal.pdf: proposal.tex $(wildcard *.tex)
	$(LATEXRUN) -W no-all $<

thesis.pdf: thesis.tex $(wildcard *.tex)
	$(LATEXRUN) -W no-all $<

