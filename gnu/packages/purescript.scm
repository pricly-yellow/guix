;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 John Soo <jsoo1@asu.edu>
;;; Copyright © 2020 Bonface Munyoki Kilyungi <bonfacemunyoki@gmail.com>
;;; Copyright © 2021 Danila Kryukov <pricly_yellow@dismail.de>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages purescript)
  #:use-module (gnu packages)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-crypto)
  #:use-module (gnu packages haskell-web)
  #:use-module ((gnu packages python) #:select (python))
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system haskell)
  #:use-module ((guix licenses) #:prefix license:))

(define ghc-happy-1.19.9
  (package
    (inherit ghc-happy)
    (version "1.19.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://hackage.haskell.org/package/happy/happy-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "138xpxdb7x62lpmgmb6b3v3vgdqqvqn4273jaap3mjmc2gla709y"))))))

(define-public purescript-ast
  (package
    (name "purescript-ast")
    (version "0.1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://hackage/package/purescript-ast/purescript-ast-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1zwwbdkc5mb3ckc2g15b18j9vp9bksyc1nrlg73w7w0fzqwnqb4g"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-aeson" ,ghc-aeson)
       ("ghc-base-compat" ,ghc-base-compat)
       ("ghc-microlens" ,ghc-microlens)
       ("ghc-protolude" ,ghc-protolude)
       ("ghc-scientific" ,ghc-scientific)
       ("ghc-serialise" ,ghc-serialise)
       ("ghc-vector" ,ghc-vector)))
    (home-page "https://www.purescript.org/")
    (synopsis "Purescript abstract syntax tree")
    (description
     "Defines the underlying syntax of the PureScript Programming Language.")
    (license license:bsd-3)))


(define-public purescript-cst
  (package
    (name "purescript-cst")
    (version "0.1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://hackage/package/purescript-cst/purescript-cst-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1h4na5k0lz91i1f49axsgs7zqz6dqdxds5dg0g00wd4wmyd619cc"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-dlist" ,ghc-dlist)
       ("purescript-ast" ,purescript-ast)
       ("ghc-happy" ,ghc-happy-1.19.9)
       ("ghc-scientific" ,ghc-scientific)
       ("ghc-semigroups" ,ghc-semigroups)))
    (native-inputs
     `(("ghc-tasty" ,ghc-tasty)
       ("ghc-tasty-golden" ,ghc-tasty-golden)
       ("ghc-tasty-hspec" ,ghc-tasty-hspec)))
    (home-page "https://www.purescript.org/")
    (synopsis "Purescript concrete syntax tree")
    (description
     "The surface syntax of the PureScript Programming Language.")
    (license license:bsd-3)))

(define-public purescript
  (package
    (name "purescript")
    (version "0.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://hackage/package/purescript/purescript-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1bv68y91l6fyjidfp71djiv2lijn5d55j4szlg77yvsw164s6vk0"))
       (patches (search-patches "purescript-relax-dependencies.patch"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-glob" ,ghc-glob)
       ("purescript-ast" ,purescript-ast)
       ("purescript-cst" ,purescript-cst)
       ("ghc-aeson" ,ghc-aeson)
       ("ghc-aeson-better-errors" ,ghc-aeson-better-errors)
       ("ghc-aeson-pretty" ,ghc-aeson-pretty)
       ("ghc-ansi-terminal" ,ghc-ansi-terminal)
       ("ghc-base-compat" ,ghc-base-compat)
       ("ghc-blaze-html" ,ghc-blaze-html)
       ("ghc-bower-json" ,ghc-bower-json)
       ("ghc-boxes" ,ghc-boxes)
       ("ghc-cborg" ,ghc-cborg)
       ("ghc-cheapskate" ,ghc-cheapskate)
       ("ghc-clock" ,ghc-clock)
       ("ghc-cryptonite" ,ghc-cryptonite)
       ("ghc-data-ordlist" ,ghc-data-ordlist)
       ("ghc-dlist" ,ghc-dlist)
       ("ghc-edit-distance" ,ghc-edit-distance)
       ("ghc-file-embed" ,ghc-file-embed)
       ("ghc-fsnotify" ,ghc-fsnotify)
       ("ghc-happy" ,ghc-happy-1.19.9)
       ("ghc-language-javascript" ,ghc-language-javascript)
       ("ghc-lifted-async" ,ghc-lifted-async)
       ("ghc-lifted-base" ,ghc-lifted-base)
       ("ghc-memory" ,ghc-memory)
       ("ghc-microlens-platform" ,ghc-microlens-platform)
       ("ghc-monad-control" ,ghc-monad-control)
       ("ghc-monad-logger" ,ghc-monad-logger)
       ("ghc-network" ,ghc-network)
       ("ghc-parallel" ,ghc-parallel)
       ("ghc-pattern-arrows" ,ghc-pattern-arrows)
       ("ghc-protolude" ,ghc-protolude)
       ("ghc-regex-tdfa" ,ghc-regex-tdfa)
       ("ghc-safe" ,ghc-safe)
       ("ghc-scientific" ,ghc-scientific)
       ("ghc-semialign" ,ghc-semialign)
       ("ghc-semigroups" ,ghc-semigroups)
       ("ghc-serialise" ,ghc-serialise)
       ("ghc-sourcemap" ,ghc-sourcemap)
       ("ghc-split" ,ghc-split)
       ("ghc-stringsearch" ,ghc-stringsearch)
       ("ghc-syb" ,ghc-syb)
       ("ghc-these" ,ghc-these)
       ("ghc-transformers-base" ,ghc-transformers-base)
       ("ghc-transformers-compat" ,ghc-transformers-compat)
       ("ghc-unordered-containers" ,ghc-unordered-containers)
       ("ghc-utf8-string" ,ghc-utf8-string)
       ("ghc-vector" ,ghc-vector)
       ("ghc-ansi-wl-pprint" ,ghc-ansi-wl-pprint)
       ("ghc-http-types" ,ghc-http-types)
       ("ghc-network" ,ghc-network)
       ("ghc-optparse-applicative" ,ghc-optparse-applicative-0.15.1)
       ("ghc-wai" ,ghc-wai)
       ("ghc-wai-websockets" ,ghc-wai-websockets)
       ("ghc-warp" ,ghc-warp)
       ("ghc-websockets" ,ghc-websockets)))
    (native-inputs
     `(("ghc-happy" ,ghc-happy-1.19.9)
       ("ghc-hunit" ,ghc-hunit)
       ("ghc-hspec" ,ghc-hspec)
       ("hspec-discover" ,hspec-discover)
       ("ghc-tasty" ,ghc-tasty)
       ("ghc-tasty-golden" ,ghc-tasty-golden)
       ("ghc-tasty-hspec" ,ghc-tasty-hspec)))
    (arguments
     `(;; Tests require npm
       #:tests? #f
       #:haddock? #f ;; haddock crash
       #:configure-flags '("--flags=release")))
    (home-page "https://www.purescript.org/")
    (synopsis "Haskell inspired programming language compiling to JavaScript")
    (description
     "Purescript is a small strongly, statically typed programming language with
expressive types, inspired by Haskell and compiling to JavaScript.")
    (license license:bsd-3)))
