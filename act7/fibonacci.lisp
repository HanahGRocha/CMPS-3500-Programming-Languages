#!/usr/bin/env -S sbcl --script
;;;; ----------------------------------------------------------
;;;; fibonacci.lisp — SBCL script with packages and CLI args
;;;; ----------------------------------------------------------

;;;; 1) Package
(defpackage :fibonacci
  (:use :cl)
  (:export :main :fib :fib-iter))

(in-package :fibonacci)

;;;; 2) Implementations

(defun fib (n)
  "Naive recursive Fibonacci. Returns F_n."
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(defun fib-iter (n)
  "Iterative Fibonacci. Returns F_n in O(n)."
  (let ((a 0) (b 1))
    (dotimes (i n a)
      (psetf a b
             b (+ a b)))))

;;;; 3) Main entry point

(defun main (&optional (n 10))
  (format t "Fibonacci(~D) = ~D~%" n (fib-iter n)))

;;;; 4) Read CLI args and run
#+sbcl
(let* ((args sb-ext:*posix-argv*)      ; args[0] is the script path
       (n (handler-case
               (if (> (length args) 1)
                   (parse-integer (second args))
                   10)
             (error ()                 ; handle non-integer input
               10))))
  (main n))
