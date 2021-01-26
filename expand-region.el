(defvar expand-region-all-things '(word symbol uuid filename url sexp list defun page))
(defvar expand-region-start-point)
(defvar expand-region-things)
(defun expand-region ()
  (interactive)
  (when (not (eq last-command this-command))
    (setq expand-region-start-point (point))
    (setq expand-region-things expand-region-all-things))
  (let ((region-start (if (use-region-p) (region-beginning) (point)))
	(region-end (if (use-region-p) (region-end) (point)))
	thing)
    (goto-char expand-region-start-point)
    (catch 'loop-things
      (while expand-region-things
	(setq thing (car expand-region-things)
	      expand-region-things (cdr expand-region-things))
	(let* ((bounds (bounds-of-thing-at-point thing))
	       (start (car bounds))
	       (end (cdr bounds)))
  	  (when (and start end ; the thing must be non-nil
	       ; and it must properly extend the current region
		     (<= start region-start) ; or it properly contains the region
		     (>= end region-end)
		     (or (< start region-start) (> end region-end)))
	    (push-mark start t t)
	    (goto-char end)
	    (throw 'loop-things thing)))))
    ; Return to starting point when list exhausted
    (when (not thing)
      (deactivate-mark)
      (setq expand-region-things expand-region-all-things))
    (message "%s" thing)))

(provide 'expand-region)
