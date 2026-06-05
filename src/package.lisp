;;;; ./src/mnas-sdl3-gui.lisp

(defpackage #:mnas-debug
  (:use #:cl)
  (:export #:project-name
           #:enable-debug    ;; enable
           #:disable-debug   ;; disable
           #:toggle-debug    ;; toggle
           #:debug-feature-p ;; debug-p
           #:when-debug      ;; with
           #:debug-log
           ))

(in-package #:mnas-debug)

(defun project-name ()
  "Return the ASDF system name."
  "mnas-debug")

