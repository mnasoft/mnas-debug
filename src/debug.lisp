;;;; ./src/debug.lisp

(in-package #:mnas-debug)

;; Compile-time macros / helper for debug logging.
;; These macros expand at macro-expansion time according to the
;; presence of :debug in *debug*. To make them active for already
;; compiled files you must add :debug to *debug* and recompile the
;; affected ASDF systems (see `enable`).

(defparameter *debug* nil)

(defun debug-p ()
  "Return non-nil if `:debug` is present in `*debug*`." 
  (member :debug *debug* :test #'eq))

(defmacro with (&body body)
  "Expand to BODY at compile/macroexpansion time only when `:debug` is
present in `*debug*`. Otherwise expands to NIL.

This mirrors the behaviour of reader conditionals, but uses the
keyword `:debug` which aligns with the helpers below.
" 
  (if (member :debug *debug* :test #'eq)
      `(progn ,@body)
      nil))

(defmacro log (&rest args)
  "Compile-time gated logging helper. Expands to a `format` call when
`:debug` is present in `*debug*`, otherwise to NIL.
Usage: `(log "fmt~%" arg1 arg2)`" 
  (if (member :debug *debug* :test #'eq)
      `(progn (format t ,@args) (finish-output))
      nil))

(defun enable ()
  "Add `:debug` to `*debug*`. If SYSTEM is non-nil, recompile and
load SYSTEM via ASDF so files that use compile-time gating are rebuilt
with the new feature present.

SYSTEM may be a symbol naming the ASDF system (e.g. 'mnas-sdl3-gui)."
  (unless (member :debug *debug* :test #'eq)
    (push :debug *debug*)))

(defun disable ()
  "Remove `:debug` from `*debug*`. If SYSTEM is non-nil, recompile and
load SYSTEM via ASDF so files are rebuilt without the debug feature."
  (setf *debug* (remove :debug *debug* :test #'eq)))

(defun toggle ()
  "Toggle presence of `:debug` in `*debug*`. If SYSTEM is non-nil,
recompile/load it after toggling." 
  (if (member :debug *debug* :test #'eq)
      (disable)
      (enable)))
