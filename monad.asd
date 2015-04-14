(in-package #:cl-user)

(asdf:defsystem #:monad
  :name "monad"
  :description "A base package for defining monads."
  :long-description "This is a base for working with monads.  The focus of
working with it should be on things that cannot be expressed otherwise.  To
start, define a monad class extending MONAD and having the metaclass
MONAD-CLASS, and methods of UNIT and >>= for it."
  :author "Svante v. Erichsen <svante.v.erichsen@web.de>"
  :depends-on (#:closer-mop)
  :components ((:file "monad")))
