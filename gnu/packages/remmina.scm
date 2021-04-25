;;; GNU Guix --- Functional package management for GNU
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

(define-module (gnu packages remmina)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages spice)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages vnc)
  #:use-module (gnu packages video)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages gsasl)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages rdesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages avahi)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages crypto))



(define-public remmina
  (package
    (name "remmina")
    (version "v1.4.13")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/Remmina/Remmina.git/")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hc2r42hr34ksbxrybglw5caw0zjhwlybvb5c9s99dr761rmzr27"))))
    (build-system cmake-build-system)
    (inputs
     `(("avahi" ,avahi)
       ("shared-mime-info" ,shared-mime-info)
       ("cups",cups)
       ("gtk3" ,gtk+)
       ("gstreamer" ,gstreamer)
       ("gsasl" ,gsasl)
       ("opus" ,opus)
       ("phodav" ,phodav)
       ("spice-gtk" ,spice-gtk)
       ("spice-protocol" ,spice-protocol)
       ("gnome-keyring" ,gnome-keyring)
       ("vte" ,vte)
       ("lz4" ,lz4)
       ("freerdp" ,freerdp)
       ("usbredir" ,usbredir)
       ("libappindicator" ,libappindicator)
       ("libsecret" ,libsecret)
       ("libsodium" ,libsodium)
       ("libsoup" ,libsoup)
       ("libssh" ,libssh)
       ("libva" ,libva)
       ("libvnc" ,libvnc)
       ("libgcrypt" ,libgcrypt)
       ("libxkbfile" ,libxkbfile)))
    (native-inputs
     `(("glib" ,glib "bin")
       ("pkg-config" ,pkg-config)
       ("intltool" ,intltool)
       ("gettext" ,gettext-minimal)
       ("gobject-introspection" ,gobject-introspection)
       ("json-glib" ,json-glib)
       ("telepathy-glib" ,telepathy-glib)))
    (arguments
     `(#:tests? #f)) ;; no tests
    (home-page "https://www.freerdp.com")
    (synopsis "Use other desktops remotely, from a tiny screen or large
monitors")
    (description "Remmina is a remote desktop client for POSIX-based computer
operating systems.  It supports the Remote Desktop Protocol (RDP), VNC, NX,
XDMCP, SPICE and SSH protocols.")
    (license license:gpl2+)))
