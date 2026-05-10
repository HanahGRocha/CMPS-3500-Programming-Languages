;;;; ================================================================
;;;; CMPS 3500 – Common Lisp Tutorial with Interactive Test Menu
;;;; ================================================================
;;;; course:CSUB - CMPS 3500
;;;; assign:Lab 07
;;;; date: 11/28/25
;;;; name: Hanah Rocha
;;;; Purpose:
;;;;   Demonstrate recursion, tail recursion, list manipulation, and
;;;;   higher-order functions in Common Lisp. Includes an interactive
;;;;   menu for testing functions.
;;;; Usage:
;;;;   sbcl --load lists_menu_final.lisp --eval '(menu)' --quit
;;;; ================================================================

(in-package :cl-user)

;;; unique-words

(defun whitespace-char-p (ch)
  "Return T if CH is a whitespace character (space, tab, newline, etc.)."
  (or (char= ch #\Space)
      (char= ch #\Tab)
      (char= ch #\Newline)
      (char= ch #\Return)))

(defun unique-words (infile outfile)
  "Read INFILE, collect unique words (case-insensitive),
  and write them (one per line) to OUTFILE."
  (let ((table (make-hash-table :test 'equal)))
    ;; Build hash table of lowercase words
    (with-open-file (in infile :direction :input)
      (labels ((consume-word (stream buffer)
                             (let ((ch (read-char stream nil nil)))
                               (cond
                                 ;; End of file
                                 ((null ch)
                                  (when (> (length buffer) 0)
                                    (setf (gethash buffer table) t)))
                                 ;; Hit whitespace
                                 ((whitespace-char-p ch)
                                  (when (> (length buffer) 0)
                                    (setf (gethash buffer table) t))
                                  (consume-word stream ""))
                                 ;; Normal character
                                 (t
                                   (consume-word stream
                                                 (concatenate 'string
                                                              buffer
                                                              (string (char-downcase ch)))))))))
        (consume-word in "")))
    ;; Write unique words to OUTFILE
    (with-open-file (out outfile
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (maphash (lambda (word value)
                 (declare (ignore value))
                 (format out "~a~%" word))
               table))))

;;; reverse-list

(defun reverse-list (list1)
  "Recursively reverse LIST1 without using built-in REVERSE."
  (labels ((rev-helper (l acc)
                       (if (null l)
                         acc
                         (rev-helper (cdr l) (cons (car l) acc)))))
    (rev-helper list1 nil)))

;;; power-two (recursive, logarithmic time)

(defun power-two (n)
  "Return 2^N using recursive exponentiation by squaring.
  Assumes N is a nonnegative integer."
  (cond
    ((= n 0) 1)
    ((evenp n)
     (let ((half (power-two (floor n 2))))
       (* half half)))
    (t
      (* 2 (power-two (1- n))))))

;;; power-set (recursive)

(defun power-set (list1)
  "Return the powerset of LIST1 (treated as a set).
  The ordering of subsets is not important, but this implementation
  matches the sample run ordering."
  (if (null list1)
    (list nil)  ; powerset of empty set = (NIL)
    (let* ((sub (power-set (cdr list1)))
           (with-first (mapcar (lambda (subset)
                                 (cons (car list1) subset))
                               sub)))
      (append sub with-first))))

;;; intercalate

(defun intercalate (list1 list2)
  "Interleave LIST1 and LIST2:
  (intercalate '(1 2) '(3 4)) => (1 3 2 4)
  If lengths differ, return the error message string exactly
  as shown in the sample run."
  (if (/= (length list1) (length list2))
    "Lists must have the same length, please try again!"
    (labels ((helper (l1 l2)
                     (if (null l1)
                       nil
                       (cons (car l1)
                             (cons (car l2)
                                   (helper (cdr l1) (cdr l2)))))))
      (helper list1 list2))))

;;; Menu + test functions

(defun print-main-menu ()
  (format t "~%---------------------------------------------~%")
  (format t "  CMPS 3500 — LISP Tutorial Test Menu~%")
  (format t "  lab07.lisp~%")
  (format t "---------------------------------------------~%~%")
  (format t "Pick an option:~%")
  (format t "  1) Test unique-words~%")
  (format t "  2) Test Recursive reverse~%")
  (format t "  3) Test Recursive Power of 2~%")
  (format t "  4) Test Recursive Power of a Set~%")
  (format t "  5) Test intercalate:~%")
  (format t "  6) Quit~%")
  (format t "Your choice: ")
  (finish-output))

;;; Test options

(defun test-unique-words ()
  (format t "~%~%Test unique-words:~%")
  (format t "-----------------------~%")
  (format t "(unique-words \"infile.data\" \"outfile.data\")~%~%")
  (unique-words "infile.data" "outfile.data")
  (format t "output file has been generated! please check it out~%"))

(defun test-reverse-list ()
  (format t "~%~%Test Recursive Reverse:~%")
  (format t "-----------------------~%")
  (format t "(print (reverse-list '(1))):~%~%")
  (print (reverse-list '(1)))
  (format t "~%~%(print (reverse-list '(1 2 3))):~%~%")
  (print (reverse-list '(1 2 3)))
  (format t "~%~%((print (reverse-list '(1 (2 4 6) 3))):~%~%")
  (print (reverse-list '(1 (2 4 6) 3)))
  (format t "~%"))

(defun test-power-two ()
  (format t "~%~%Test Recursive Power of 2:~%")
  (format t "--------------------------~%")
  (format t "(print (power-two 0))):~%~%")
  (print (power-two 0))
  (format t "~%~%(print (power-two 5))):~%~%")
  (print (power-two 5))
  (format t "~%~%(print (power-two 20))):~%~%")
  (print (power-two 20))
  (format t "~%"))

(defun test-power-set ()
  (format t "~%~%Test Recursive Power of a Set:~%")
  (format t "------------------------------~%")
  (format t "(print (power-set '(1))):~%~%")
  (print (power-set '(1)))
  (format t "~%~%(print (power-set '(1 2 3))):~%~%")
  (print (power-set '(1 2 3)))
  (format t "~%~%(print (power-set '(1 2 3 (4)))):~%~%")
  (print (power-set '(1 2 3 (4))))
  (format t "~%"))

(defun test-intercalate ()
  (format t "~%~%Test intercalate:~%")
  (format t "----------------~%")
  (format t "(print (intercalate '(1) '(3))):~%~%")
  (print (intercalate '(1) '(3)))
  (format t "~%~%(print (intercalate '(1 2) '(3 4))):~%~%")
  (print (intercalate '(1 2) '(3 4)))
  (format t "~%~%(print (intercalate '(1 3 5) '(2 4 6))):~%~%")
  (print (intercalate '(1 3 5) '(2 4 6)))
  (format t "~%~%(print (intercalate '(1 3 5) '(2))):~%~%")
  (print (intercalate '(1 3 5) '(2)))
  (format t "~%"))

;;; Main menu loop

(defun menu ()
  "Main interactive test menu for lab07."
  (loop
    (print-main-menu)
    (let ((choice (read)))
      (case choice
        (1 (test-unique-words))
        (2 (test-reverse-list))
        (3 (test-power-two))
        (4 (test-power-set))
        (5 (test-intercalate))
        (6 (format t "Goodbye!~%")
         (return))
        (t (format t "Invalid choice, please try again.~%"))))))

;;;; ================================================================
;;;; END OF FILE
;;;; ================================================================
