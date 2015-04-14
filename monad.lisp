(in-package #:cl-user)

(defpackage #:monad
  (:use #:closer-common-lisp)
  (:export #:monad-class
           #:monad
           #:unit
           #:>>=
           #:>=>
           #:fmap
           #:join))

(in-package #:monad)

(defclass monad-class (standard-class) ())

(defmethod validate-superclass ((class monad-class)
                                (super standard-class))
  t)

(defclass monad () ()
  (:metaclass monad-class))

(defgeneric unit (class value)
  (:documentation "Returns an instance of the monadic class CLASS with the given
VALUE.  Also known as RETURN."))

(defgeneric >>= (m function)
  (:documentation "Applies FUNCTION to the value wrapped in the monadic class
instance M.  FUNCTION must return a new instance of the same monadic class.
Also known as BIND."))

(defgeneric >=> (class function &rest more-functions)
  (:documentation "The Kleisli operator.  Composes FUNCTION with MORE-FUNCTIONS.
Each function given must take a value of the wrapped type returned by the
preceding, and return a monadic CLASS instance.  The final composed function
takes whatever the first function takes and returns a monadic CLASS instance
with a wrapped type like the last function."))

(defmethod >=> ((class symbol) (function function) &rest more-functions)
  "A convenience wrapper for implicitly invoking FIND-CLASS."
  (apply #'>=> (find-class class) function more-functions))

(defmethod >=> ((class monad-class) (function function) &rest more-functions)
  "A generic implementation based on >>=."
  (if more-functions
      (lambda (a)
        (>>= (funcall function a)
             (apply #'>=> class more-functions)))
      function))

(defgeneric fmap (function m)
  (:documentation "Applies FUNCTION to the value wrapped by the monadic class
instance M, returning a new monadic class instance wrapping the return value of
FUNCTION."))

(defmethod fmap ((function function) (m monad))
  "A generic implementation based on >>= and UNIT."
  (>>= m (lambda (a)
           (funcall function (unit (class-of m) a)))))

(defgeneric join (class mma)
  (:documentation "Flattens the wrapping into monadic class instances."))

(defmethod join ((class symbol) mma)
  (join (find-class class) mma))

(defmethod join ((class monad-class) mma)
  "A generic implementation based on >>= and IDENTITY."
  (>>= mma #'identity))

;; TODO: do-notation
