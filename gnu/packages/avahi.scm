;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015, 2017, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020 Marius Bakke <mbakke@fastmail.com>
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

(define-module (gnu packages avahi)
  #:use-module ((guix licenses) #:select (lgpl2.1+))
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages libdaemon)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages man)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xml))

(define-public avahi
  (package
    (name "avahi")
    (version "0.8")
    (home-page "https://avahi.org")
    (source (origin
             (method url-fetch)
             (uri (string-append home-page "/download/avahi-"
                                 version ".tar.gz"))
             (sha256
              (base32
               "1npdixwxxn3s9q1f365x9n9rc5xgfz39hxf23faqvlrklgbhj0q6"))
             (patches (search-patches "avahi-localstatedir.patch"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                 ;; Fix version constraint in the avahi-libevent pkg-config file.
                 ;; This can be removed for Avahi versions > 0.8.
                 (substitute* "avahi-libevent.pc.in"
                   (("libevent-2\\.1\\.5")
                    "libevent >= 2.1.5"))
                 #t))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("--with-distro=none"
                           "--disable-static"
                           "--localstatedir=/var" ; for the DBus socket
                           "--disable-python"
                           "--disable-mono"
                           "--disable-doxygen-doc"
                           "--disable-xmltoman"
                           "--enable-tests"
                           "--disable-qt4" "--disable-qt5"
                           "--disable-gtk" "--disable-gtk3"
                           "--enable-compat-libdns_sd")))
    (inputs
     `(("dbus" ,dbus)
       ("expat" ,expat)
       ("gdbm" ,gdbm)
       ("glib" ,glib)
       ("libcap" ,libcap-2.31)       ;to enable chroot support in avahi-daemon
       ("libdaemon" ,libdaemon)
       ("libevent" ,libevent)))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("glib" ,glib "bin")
       ("pkg-config" ,pkg-config)))
    (synopsis "Implementation of mDNS/DNS-SD protocols")
    (description
     "Avahi is a system which facilitates service discovery on a local
network.  It is an implementation of the mDNS (for \"Multicast DNS\") and
DNS-SD (for \"DNS-Based Service Discovery\") protocols.")
    (license lgpl2.1+)))

(define-public avahi-full
  (package/inherit avahi
    (name "avahi-full")
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("--with-distro=none"
                           "--disable-static"
                           "--localstatedir=/var" ; for the DBus socket
                           "--disable-mono"
                           "--enable-python"
                           "--disable-doxygen-doc"
                           "--enable-xmltoman"
                           "--enable-tests"
                           "--disable-qt4" 
                           "--enable-gobject"
                           "--disable-gtk" "--enable-gtk3"
                           "--enable-compat-libdns_sd")
       #:phases
        (modify-phases %standard-phases
         (add-after 'unpack 'fix-build
          (lambda* (#:key inputs #:allow-other-keys)
           (copy-file (assoc-ref inputs "build-db")
                      "service-type-database/build-db")
           #t)))))
    (inputs
     `(("glib" ,glib)
       ("gtk3" ,gtk+)
       ("qtbase" ,qtbase)
       ; this file not include in tarball
       ; of version 0.8
       ("build-db"
        ,(origin
           (method url-fetch)
           (uri (string-append
                 "https://raw.githubusercontent.com/lathiat/avahi/v"
                  "0.8" "/service-type-database/build-db"))
           (sha256
            (base32
             "0z7dk2fr80bvyhgr5kd2vnqkri1vxmymp91l441snr64rj4divc3"))))
       ("xmltoman" ,xmltoman)
       ,@(package-inputs avahi)))
    (native-inputs
      `(("python" ,python)
       ("python-pygobject" ,python-pygobject)
       ("python-dbus" ,python-dbus)
       ,@(package-native-inputs avahi)))))

(define-public nss-mdns
  (package
    (name "nss-mdns")
    (version "0.14.1")
    (home-page "https://github.com/lathiat/nss-mdns")
    (source (origin
              (method url-fetch)
              (uri (string-append home-page "/releases/download/v" version "/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "134wdr0n9cm5ab4g6dwq76lvzqns9dcylr470i2xxjimnw0l22d2"))))
    (build-system gnu-build-system)
    (arguments
     ;; The Avahi daemon socket is expected by 'configure.ac' to be at
     ;; "$(localstatedir)/run/avahi-daemon/socket", but nowadays it lives in
     ;; /run/avahi-daemon/socket.  Remove the "$(localstatedir)" bit.
     '(#:configure-flags '("AVAHI_SOCKET=/run/avahi-daemon/socket")))
    (synopsis "Multicast DNS Name Service Switch (@dfn{NSS}) plug-in")
    (description
     "Nss-mdns is a plug-in for the GNU C Library's Name Service Switch
(@dfn{NSS}) that resolves host names via multicast DNS (@dfn{mDNS}).  It is
most often used in home and other small networks without a local name server,
to resolve host names in the @samp{.local} top-level domain.")
    (license lgpl2.1+)))
