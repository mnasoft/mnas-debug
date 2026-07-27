;;;; ./src/debug.lisp

(in-package #:mnas-debug)

;; Compile-time macros / helper for debug logging.
;; `*debug-features*` may hold a list of feature designators (keywords or symbols),
;; e.g. '(:debug :widget :combo). Legacy behaviour that checked only
;; presence of `:debug` is preserved when no feature is supplied.

(defparameter *debug-features* nil
  "List of debug feature designators enabled. Each element is a symbol
or keyword used to gate debug code at macroexpansion or runtime.")

(defun undebug ()
  (setf *debug-features* nil))

(defun debug-p (&optional feature)
  "Return non-nil when FEATURE is present in `*debug-features*`.
If FEATURE is nil, check for the legacy `:debug` feature.
FEATURE may be a symbol or keyword." 
  (let ((feat (or feature :debug)))
    (member feat *debug-features* :test #'eq)))

;; Macro helpers: accept an explicit feature or fall back to legacy style.
;; Usage:
;;  (with :widget (do-stuff))  ; feature supplied
;;  (with (do-stuff))          ; legacy style, feature implied :debug
(defmacro with (feature &rest body)
  "Expand to BODY at macroexpansion time only when FEATURE is enabled.

`feature` must be a keyword designator (for example :widget). The
legacy form of calling `(with (form))` is no longer supported.
Example:
  (with :widget (format t \"widget debug~%\"))
"
  (unless (keywordp feature)
    (error "WITH macro requires a feature keyword, e.g. :widget"))
  (let ((forms body))
    (if (member feature *debug-features* :test #'eq)
        `(progn ,@forms)
        nil)))

;; %log supports optional feature as first arg when followed by a string
;; format control: (%log :widget "fmt~%" args...) or the legacy
;; (%log "fmt~%" args...)
(defmacro %log (feature &rest args)
  "Compile-time gated logging helper requiring explicit FEATURE.

Usage:
  (%log :feature \"fmt~%\" a b)

`feature` must be a keyword designator. Legacy calls without an
explicit feature are not supported.
When enabled the macro expands to a `format` call followed by
`finish-output`, otherwise to NIL."
  (unless (keywordp feature)
    (error "%LOG macro requires a feature keyword, e.g. :widget"))
  (let ((fmt (car args)) (rest (cdr args)))
    (unless (stringp fmt)
      (error "%LOG requires a format string as the second argument"))
    (if (member feature *debug-features* :test #'eq)
        `(progn (format t ,fmt ,@rest) (finish-output))
        nil)))

(defun enable (&rest features)
  "Enable one or more FEATURES (symbols/keywords) in `*debug-features*`.
If no FEATURES are provided, enable the legacy :debug feature.
Returns the new `*debug-features*` list." 
  (let ((to-enable (if (null features) (list :debug) features)))
    (dolist (f to-enable)
      (unless (member f *debug-features* :test #'eq)
        (push f *debug-features*)))
    *debug-features*))

(defun disable (&rest features)
  "Disable FEATURES from `*debug-features*`. If no FEATURES provided, remove
the legacy :debug feature. Returns the new `*debug-features*` list." 
  (let ((to-disable (if (null features) (list :debug) features)))
    (dolist (f to-disable)
      (setf *debug-features* (remove f *debug-features* :test #'eq)))
    *debug-features*))

(defun toggle (&optional feature)
  "Toggle FEATURE in `*debug-features*`. If FEATURE is nil, toggle :debug.
Returns the new `*debug-features*` list." 
  (let ((f (or feature :debug)))
    (if (member f *debug-features* :test #'eq)
        (progn (setf *debug-features*
                     (remove f *debug-features* :test #'eq))
               *debug-features*)
        (progn (push f *debug-features*) *debug-features*))))
