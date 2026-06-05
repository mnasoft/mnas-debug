(defsystem "mnas-debug"
  :description
  "@b(Описание:) система @b(mnas-debug) "
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GPL-3.0"
  :version "0.0.1"
  ;; :depends-on ("sdl3" "sdl3-ttf")
  :serial t
  ;; :in-order-to ((test-op (test-op "mnas-debug-tests")))
  :components ((:module "src"
		:serial t
                :components ((:file "package")
                             (:file "debug")
                             ))))
