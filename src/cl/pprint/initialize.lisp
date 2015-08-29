;;; Copyright 1989,1990 by the Massachusetts Institute of Technology,
;;; Cambridge, Massachusetts.

(in-package "XP")

(setq *IPD* (make-pprint-dispatch))

(set-pprint-dispatch+ '(satisfies function-call-p) #'fn-call '(-5) *IPD*)
(set-pprint-dispatch+ 'cons #'pprint-fill '(-10) *IPD*)
(set-pprint-dispatch+ '(cons (member defstruct)) #'block-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member block)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member case)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member catch)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member ccase)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member compiler-let)) #'let-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member cond)) #'cond-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member ctypecase)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member defconstant)) #'defun-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member define-setf-method)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member defmacro)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member define-modify-macro)) #'dmm-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member defparameter)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member defsetf)) #'defsetf-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member define-setf-method)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member lisp:defstruct)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member deftype)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member defun)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member defvar)) #'defun-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member do)) #'do-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member do*)) #'do-print '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member do-all-symbols)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member do-external-symbols)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member do-symbols)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member dolist)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member dotimes)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member ecase)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member etypecase)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member eval-when)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member flet)) #'flet-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member function)) #'function-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member labels)) #'flet-print '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member lambda)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member let)) #'let-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member let*)) #'let-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member locally)) #'block-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member loop)) #'pretty-loop '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member macrolet)) #'flet-print '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member multiple-value-bind)) #'mvb-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member multiple-value-setq)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member prog)) #'prog-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member prog*)) #'prog-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member progv)) #'defun-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member psetf)) #'setq-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member psetq)) #'setq-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member quote)) #'quote-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member return-from)) #'block-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member setf)) #'setq-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member setq)) #'setq-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member tagbody)) #'tagbody-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member throw)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member typecase)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member unless)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member unwind-protect)) #'up-print '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member when)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member with-input-from-string)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member with-open-file)) #'block-like '(0) *IPD*)
(set-pprint-dispatch+ '(cons (member with-open-stream)) #'block-like '(0) *IPD*) 
(set-pprint-dispatch+ '(cons (member with-output-to-string)) #'block-like '(0) *IPD*) 

(set-pprint-dispatch+ '(cons (member lisp::backquote))
		      #'backquote-print '(0) *IPD*)

(set-pprint-dispatch+ `(cons (member ,lisp::*comma*))
		      #'comma-print '(0) *IPD*)

(set-pprint-dispatch+ `(cons (member ,lisp::*comma-atsign*))
		      #'comma-atsign-print '(0) *IPD*)

(set-pprint-dispatch+ `(cons (member ,lisp::*comma-dot*))
		      #'comma-dot-print '(0) *IPD*)

(defun pprint-dispatch-print (xp table)
  (declare (ignore level))
  (let ((stuff (copy-list (others table))))
    (maphash #'(lambda (key val) (declare (ignore key))
		       (push val stuff))
	     (conses-with-cars table))
    (maphash #'(lambda (key val) (declare (ignore key))
		       (push val stuff))
	     (structures table))
    (setq stuff (sort stuff #'priority-> :key #'(lambda (x) (car (full-spec x)))))
    (pprint-logical-block (xp stuff :prefix "#<" :suffix ">")
			  (format xp (formatter "pprint dispatch table containing ~A entries: ")
				  (length stuff))
			  (loop (pprint-exit-if-list-exhausted)
				(let ((entry (pprint-pop)))
				  (format xp (formatter "~{~_P=~4D ~W~} F=~W ")
					  (full-spec entry) (fn entry)))))))

(setf (get 'pprint-dispatch 'structure-printer) #'pprint-dispatch-print)

(set-pprint-dispatch+ 'pprint-dispatch #'pprint-dispatch-print '(0) *IPD*) 

;;; Symbolics only stuff used to be here

					;so only happens first time is loaded.
(when (eq *print-pprint-dispatch* T)
  (setq *print-pprint-dispatch* (copy-pprint-dispatch nil)))

