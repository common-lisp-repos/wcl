;;; (C) Copyright 1990 - 2014 by Wade L. Hennessey. All rights reserved.

(defun get-decoded-time ()
  (decode-universal-time (get-universal-time)))

(defun get-internal-real-time ()
  (internal_real_time))

(defun get-internal-run-time ()
  (internal_user_run_time))

(defun get-universal-time ()
  (+ (unix_time_of_day) unix-to-universal-time-difference))

(defun print-runtime-statistics (form)
  (let ((start-gc-count (gc-call-count))
	(real-start (get-internal-real-time))
	(user-start (internal_user_run_time))
	(system-start (internal_system_run_time)))
    (multiple-value-prog1  (funcall form)
      (let ((elapsed-user (/ (- (internal_user_run_time) user-start)
			     100.0))
	    (elapsed-system (/ (- (internal_system_run_time) system-start)
			       100.0))
	    (elapsed-real (/ (- (get-internal-real-time) real-start)
			     100.0))
	    (gc-count (- (gc-call-count) start-gc-count)))
	(format t "~&User run time = ~A~%" elapsed-user)
	(format t "System run time = ~A~%" elapsed-system)
	(format t "Total run time = ~A~%" (+ elapsed-user elapsed-system))
	(format t "Elapsed real time = ~A~%" elapsed-real)
	(format t "~D Garbage Collection~P~%" gc-count gc-count)))))
    
(defun time-zone ()
  (unix_timezone))

;;; HEY! fix to use unix-to-universal-time-difference again
(defun unix->universal-time (time)
  (+ time (compute-time-diff)))

;;; SPICE code with dst fix 
(eval-when (compile)
  (defmacro dst-check-start-of-month-ge (day hour weekday daybound)
    (let ((d (gensym))
	  (h (gensym))
	  (w (gensym))
	  (db (gensym)))
      `(let ((,d ,day)
	     (,h ,hour)
	     (,w ,weekday)
	     (,db ,daybound))
	 (declare (fixnum ,d ,h ,w ,db))
	 (cond ((< ,d ,db) NIL)
	       ((> (the fixnum (- ,d ,w)) ,db) T)
	       ((and (eq ,w 6) (> ,h 0)) T)
	       (T NIL)))))
  
  (defmacro dst-check-end-of-month-ge (day hour weekday daybound)
    (let ((d (gensym))
	  (h (gensym))
	  (w (gensym))
	  (db (gensym)))
      `(let ((,d ,day)
	     (,h ,hour)
	     (,w ,weekday)
	     (,db ,daybound))
	 (declare (fixnum ,d ,h ,w ,db))
	 (cond ((< (the fixnum (+ ,d 6)) ,db) NIL)
	       ((> (the fixnum  (- (the fixnum (+ ,d 6)) ,w)) ,db) T)
	       ((and (eq ,w 6) (> ,h 0)) T)
	       (T NIL)))))

  (defmacro not-leap-year (year)
    (let ((sym (gensym)))
      `(let ((,sym ,year))
	(cond ((eq (mod ,sym 4) 0)
	       (and (eq (mod ,sym 100) 0)
		    (not (eq (mod ,sym 400) 0))))
	      (T T))))))
 
(defun dst-check (day hour weekday)
  (and (dst-check-start-of-month-ge day hour weekday april-1)
       (not (dst-check-end-of-month-ge day hour weekday october-31))))

(defun decode-universal-time (universal-time &optional (time-zone (time-zone)))
  (declare (fixnum time-zone))
  (multiple-value-bind (weeks secs)
		       (truncate (+ universal-time seconds-offset)
				 seconds-in-week)
    (let ((weeks (+ weeks weeks-offset))
	  (second nil)
	  (minute nil)
	  (hour nil)
	  (date nil)
	  (month nil)
	  (year nil)
	  (day nil)
	  (daylight nil)
	  (timezone (* time-zone 60)))
      (declare (fixnum timezone))
      (multiple-value-bind (t1 seconds) (truncate secs 60)
	(setq second seconds)
	(setq t1 (- t1 timezone))
	(let* ((tday (if (< t1 0)
			 (1- (truncate (1+ t1) minutes-per-day))
			 (truncate t1 minutes-per-day))))
	  (multiple-value-setq (hour minute)
	    (truncate (- t1 (* tday minutes-per-day)) 60))
	  (let* ((t2 (1- (* (+ (* weeks 7) tday november-17-1858) 4)))
		 (tcent (truncate t2 quarter-days-per-century)))
	    (setq t2 (mod t2 quarter-days-per-century))
	    (setq t2 (+ (- t2 (mod t2 4)) 3))
	    (setq year (+ (* tcent 100) (truncate t2 quarter-days-per-year)))
	    (let ((days-since-mar0 (1+ (truncate (mod t2 quarter-days-per-year)
						 4))))
	      (setq day (mod (+ tday weekday-november-17-1858) 7))
	      ;(unless time-zone ; This seems wrong - wade)
	      (progn
		(if (setq daylight (dst-check days-since-mar0 hour day))
		    (cond ((eq hour 23)
			   (setq hour 0)
			   (setq day (mod (1+ day) 7))
			   (setq days-since-mar0 (1+ days-since-mar0))
			   (if (>= days-since-mar0 366)
			       (if (or (> days-since-mar0 366)
				       (not-leap-year (1+ year)))
				   (setq days-since-mar0 368))))
			  (t (setq hour (1+ hour))))))
	      (let ((t3 (+ (* days-since-mar0 5) 456)))
		(cond ((>= t3 1989)
		       (setq t3 (- t3 1836))
		       (setq year (1+ year))))
		(multiple-value-setq (month t3) (truncate t3 153))
		(setq date (1+ (truncate t3 5))))))))
      (values second minute hour date month year day
	      daylight (truncate timezone 60)))))

(defun make-universal-time (weeks msec)
  (+ (* (- weeks weeks-offset) seconds-in-week)
     (- (truncate msec 1000) seconds-offset)))

(defun encode-universal-time (second minute hour date month year
				     &optional (time-zone (time-zone)))
  (let* ((year (if (< year 100)
		   (multiple-value-bind (sec min hour day month now-year)
		       (get-decoded-time)
		     (declare (ignore sec min hour day month))
		     (do ((y (+ year (* 100 (1- (truncate now-year 100))))
			     (+ y 100)))
			 ((<= (abs (- y now-year)) 50) y)))
		   year))
	 (zone (* time-zone 60))
	 (tmonth (- month 3)))
    (cond ((< tmonth 0)
	   (setq tmonth (+ tmonth 12))
	   (setq year (1- year))))
    (let ((days-since-mar0 (+ (truncate (+ (* tmonth 153) 2) 5) date)))
      (multiple-value-bind (tcent tyear) (truncate year 100)
	(let* ((tday (- (+ (truncate (* tcent quarter-days-per-century) 4)
			   (truncate (* tyear quarter-days-per-year) 4)
			   days-since-mar0)
			november-17-1858))
	       (daylight (dst-check days-since-mar0 (1- hour)
				    (mod (+ tday weekday-november-17-1858) 7)))
	       (tminutes (+ (* hour 60) minute zone)))
	  (if daylight (setq tminutes (- tminutes 60)))
	  (do ((i tminutes (+ i minutes-per-day)))
	      ((>= i 0) (setq tminutes i))
	    (declare (fixnum i))
	    (decf tday 1))
	  (do ((i tminutes (- i minutes-per-day)))
	      ((< i minutes-per-day) (setq tminutes i))
	    (declare (fixnum i))
	    (incf tday 1))
	  (multiple-value-bind (weeks dpart) (truncate tday 7)
	    (make-universal-time weeks (* (+ (* (+ (* dpart minutes-per-day)
						   tminutes) 60)
					     second) 1000))))))))
