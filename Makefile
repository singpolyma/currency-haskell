GHCFLAGS=-Wall -XNoCPP -fno-warn-name-shadowing -XHaskell98
HLINTFLAGS=-XHaskell98 -XNoCPP -i 'Use camelCase' -i 'Use String' -i 'Use string literal' -i 'Use list comprehension' --utf8 -XMultiParamTypeClasses
VERSION=0.2.0.0

.PHONY: all clean doc install

all: report.html doc dist/build/libHScurrency-$(VERSION).a dist/currency-$(VERSION).tar.gz

install: dist/build/libHScurrency-$(VERSION).a
	cabal install

report.html: Currency.hs Currency/Rates.hs
	-hlint $(HLINTFLAGS) --report Currency.hs Currency

doc: dist/doc/html/currency/index.html README

README: currency.cabal
	tail -n+$$(( `grep -n ^description: $^ | head -n1 | cut -d: -f1` + 1 )) $^ > .$@
	head -n+$$(( `grep -n ^$$ .$@ | head -n1 | cut -d: -f1` - 1 )) .$@ > $@
	-printf ',s/        //g\n,s/^.$$//g\nw\nq\n' | ed $@
	$(RM) .$@

dist/doc/html/currency/index.html: dist/setup-config Currency.hs Currency/Rates.hs
	cabal haddock --hyperlink-source

dist/setup-config: currency.cabal
	cabal configure

clean:
	find . '(' -name '*.o' -o -name '*.hi' ')' -print0 | xargs -0 $(RM)
	$(RM) report.html
	$(RM) -r dist dist-ghc

dist/build/libHScurrency-$(VERSION).a: currency.cabal dist/setup-config Currency.hs Currency/Rates.hs
	cabal build --ghc-options="$(GHCFLAGS)"

dist/currency-$(VERSION).tar.gz: currency.cabal dist/setup-config Currency.hs Currency/Rates.hs README
	cabal check
	cabal sdist
