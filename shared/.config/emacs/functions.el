;; -*- lexical-binding: t -*-

(defun df/destruct-jwt ()
"decodes the current region as a jwt and prints it instead."
(interactive)
(let* ((jwt (buffer-substring (region-beginning) (region-end)))
       (parts (s-split "\\." jwt))
       (header (base64-decode-string (nth 0 parts) t nil))
       (payload (base64-decode-string (nth 1 parts) t nil)))
  (kill-region (region-beginning) (region-end))
  (insert "\n")

  ;; Insert and pretty-print the header
  (let ((start (point)))
    (insert header)
    (json-pretty-print start (point)))

  (insert "\n.\n")

  ;; Insert and pretty-print the payload
  (let ((start (point)))
    (insert payload)
    (json-pretty-print start (point)))

  (insert "\n.\n")
  (insert (nth 2 parts))
  (insert "\n")))

(defun df/epoch-to-string (epoch)
  (interactive "insert epoch")
  (let ((date (format-time-string
               "%Y-%m-%d %H:%M:%S"
               (seconds-to-time
    			(string-to-number
    			 (buffer-substring (region-beginning) (region-end)))))))
    (delete-region (region-beginning) (region-end))
    (insert date)))

(defun df/insert-uuid ()
    "Inserts a uuid, calling the external method uuidgen"
    (interactive)
	(insert (string-trim (shell-command-to-string "uuidgen -r"))))

(defun df/copy-buffer-path-to-kill-ring ()
    "Copy the file path of a buffer to the clipboard"
    (interactive)
	(kill-new (buffer-file-name)))

(defun df/my-joiner (&optional j-del j-start j-end)
    "Join a region of lines separated by j-del and surrounded by j-start and j-end"
    (interactive "sDelimiter ',': \nsStart (': \nsEnd '): ")
    (let* ((my-text (buffer-substring (region-beginning) (region-end)))
        	 (lines (remove "" (mapcar 'string-trim (string-split my-text "\n"))))
        	 (delimiter (if (string-empty-p j-del) "','" j-del))
        	 (start (if (string-empty-p j-start) "('" j-start))
        	 (end (if (string-empty-p j-end) "')" j-end)))
      (delete-region (region-beginning) (region-end))
      (insert
       (concat start
  			 (string-join lines delimiter)
  			 end))
	  ))

(defun df/filter-private ()
  "Remove private items from recentf list"
  (interactive)
  (setq recentf-list (-filter (lambda (x) (not (s-contains? ".private" x))) recentf-list)))

(defun df/insert-current-date ()
    (interactive)
    (insert
	 (format-time-string "%Y-%m-%d")))

(defun df/list-all-fonts ()
  (interactive)
  (with-output-to-temp-buffer "*fonts*"
    (princ (string-join (font-family-list) "\n"))
    (goto-char (point-min)))
  (view-mode 1))

(defhydra df/funs (:hint nil :color blue)
  "
_h_:\tConvert an *epoch* to a date-string          _j_: Insert current date
\t\tThe epoch must be in a region for this       _l_: Join lines
\t\tto work.                                     _r_: Filter private

_k_:\tCopy buffer path to kill ring
_m_:\tOpen EMPV _d_: Destruct a JWT
_q_:\tQuit


"
  ("h" df/epoch-to-string)
  ("j" df/insert-current-date)
  ("k" df/copy-buffer-path-to-kill-ring)
  ("l" df/my-joiner)
  ("r" df/filter-private)
  ("m" empv-hydra/body)
  ("d" df/destruct-jwt)
  ("q" nil "quit"))

(keymap-global-set "C-x m" 'df/funs/body)
