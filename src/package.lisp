;;;; ./src/mnas-sdl3-gui.lisp

(defpackage #:mnas-debug
  (:use #:cl)
  (:export #:project-name ;;
           #:enable       ;; enable-debug
           #:disable      ;; disable-debug
           #:toggle       ;; toggle-debug
           #:debug-p      ;; debug-feature-p
           #:with         ;; when-debug
           #:%log         ;; debug-log
           ))

(in-package #:mnas-debug)

(defun project-name ()
  "Return the ASDF system name."
  "mnas-debug")

