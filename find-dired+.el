;;; find-dired+.el --- Extensions to `find-dired.el'.
;;
;; Filename: find-dired+.el
;; Description: Extensions to `find-dired.el'.
;; Author: Roland McGrath <roland@gnu.ai.mit.edu>,
;;      Sebastian Kremer <sk@thp.uni-koeln.de>,
;;      Drew Adams
;; Maintainer: Drew Adams
;; Copyright (C) 1996-2015, Drew Adams, all rights reserved.
;; Created: Wed Jan 10 14:31:50 1996
;; Version: 0
;; Package-Requires: (("find-dired-" "0"))
;; Last-Updated: Sun Jul 26 09:50:06 2015 (-0700)
;;           By: dradams
;;     Update #: 731
;; URL: http://www.emacswiki.org/find-dired+.el
;; Doc URL: http://emacswiki.org/LocateFilesAnywhere
;; Keywords: internal, unix, tools, matching, local
;; Compatibility: GNU Emacs 20.x
;;
;; Features that might be required by this library:
;;
;;   `apropos', `apropos+', `autofit-frame', `avoid', `bookmark',
;;   `bookmark+', `bookmark+-1', `bookmark+-bmu', `bookmark+-key',
;;   `bookmark+-lit', `cmds-menu', `dired', `dired+', `dired-aux',
;;   `dired-x', `easymenu', `ffap', `find-dired', `find-dired-',
;;   `fit-frame', `frame-fns', `help+20', `highlight', `image-dired',
;;   `image-file', `info', `info+20', `menu-bar', `menu-bar+',
;;   `misc-cmds', `misc-fns', `naked', `pp', `pp+', `second-sel',
;;   `strings', `subr-21', `thingatpt', `thingatpt+', `unaccent',
;;   `w32-browser', `w32browser-dlgopen', `wid-edit', `wid-edit+',
;;   `widget'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    Extensions to `find-dired.el'.
;;
;;  See also the companion file `find-dired-.el'.
;;        `find-dired-.el' should be loaded before `find-dired.el'.
;;        `find-dired+.el' should be loaded after `find-dired.el'.
;;
;;  A `find' submenu has been added to Dired's menu bar, and most of
;;  the Emacs `find-*' commands have undergone slight improvements.
;;
;;
;;  New user options (variables) defined here:
;;
;;    `find-dired-default-fn', `find-dired-hook'.
;;
;;  Other new variable defined here: `menu-bar-run-find-menu'.
;;
;;
;;  ***** NOTE: The following functions defined in `find-dired.el'
;;              have been REDEFINED HERE:
;;
;;  `find-dired' - 1. Interactive spec uses `read-from-minibuffer',
;;                    `read-file-name', `dired-regexp-history' and
;;                    `find-dired-default-fn'.
;;                 2. Runs `find-dired-hook' at end.
;;                 3. Uses `find-dired-default-fn' for default input.
;;                 4. Buffer named after dir (not named "*Find*").
;;  `find-dired-filter' - Removes lines that just list a file.
;;  `find-dired-sentinel' - 1. Highlights file lines.
;;                          2. Puts `find' in mode-line.
;;  `find-grep-dired' - Interactive spec uses `read-from-minibuffer',
;;                      `read-file-name', `dired-regexp-history' and
;;                      `find-dired-default-fn'.
;;  `find-name-dired' - Interactive spec uses `read-from-minibuffer',
;;                      `read-file-name', `dired-regexp-history' and
;;                      `find-dired-default-fn'.
;;
;;
;;  ***** NOTE: The following variable defined in `find-dired.el'
;;              has been REDEFINED HERE:
;;
;;  `find-ls-option'   - Uses `dired-listing-switches' for Windows.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;; 2015/07/26 dadams
;;     find-dired: Update to more recent vanilla code.
;;      Added: find-args (for older Emacs versions).  Use read-string with INITIAL-INPUT.
;;      Offer to kill running old proc.  Save find-args.  Use shell-quote-argument.
;;      Use find-program, find-exec-terminator, if defined.  Use shell-command and
;;      dired-insert-set-properties instead of start-process-shell-command.
;; 2015/07/25 dadams
;;     find-dired-filter:
;;       Update wrt recent Emacs:
;;         Use with-current-buffer, not set-buffer. Removed extra save-excursion after widen.
;;         Added the code to pad number of links and file size.
;;       Use delete-region, not kill-line, to protect kill-ring.
;;       Escape the . in the regexp.
;; 2015/07/24 dadams
;;     find-ls-option: Updated wrt vanilla Emacs.
;;     find-dired: Set buffer read-only.
;;     find-dired-filter, find-dired-sentinel: Bind inhibit-read-only to t.
;;     Thx to Tino Calancha.
;; 2015/07/17 dadams
;;     find-name-dired: Use find-name-arg and read-directory-name, if available.
;;                      Use shell-quote-argument.
;; 2012/08/21 dadams
;;     Call tap-put-thing-at-point-props after load thingatpt+.el.
;; 2012/08/18 dadams
;;     Invoke tap-define-aliases-wo-prefix if thingatpt+.el is loaded.
;; 2011/08/30 dadams
;;     find-dired-default-fn:
;;       devar -> defcustom.
;;       symbol-name-nearest-point -> region-or-non-nil-symbol-name-nearest-point.
;;     find(-name|-grep)-dired: Use functionp as test, not just non-nil.
;; 2011/01/04 dadams
;;     Removed autoloads for defvar, defconst, and non-interactive functions.
;; 2010/03/24 dadams
;;     find-grep-dired:
;;       Added missing DEFAULT arg for read-from-minibuffer.
;;       Thx to Sascha Friedmann.
;;     find(-name)-dired: Use nil as INITIAL-CONTENTS arg to read-from-minibuffer.
;; 2006/03/20 dadams
;;     menu-bar-dired-subdir-menu -> diredp-menu-bar-subdir-menu.
;; 2000/09/27 dadams
;;     Updated for Emacs 20.7.
;; 2000/09/18 dadams
;;     1. find-dired: a) Use dired-simple-subdir-alist & find-ls-option anew
;;                       (instead of dired's default switches).
;;                    b) Updated to Emacs20 version: define-key added.
;;     2. Added: find-ls-option - redefined to treat Windows too.
;; 1999/04/06 dadams
;;     1. Protected symbol-name-nearest-point with fboundp.
;;     2. find-dired, find-name-dired, find-grep-dired: No default regexp
;;        if grep-default-regexp-fn is nil.
;; 1999/03/31 dadams
;;     Updated for Emacs version 19.34.
;;     1. Updated using version 19.34 find-dired.el. (find-dired, find-name-dired,
;;        find-grep-dired, find-dired-filter, find-dired-sentinel)
;;     2. Added: find-grep-options (added irix).
;;     3. Renamed: find-dired-history -> find-args-history.
;;     4. find-dired: pop-to-buffer -> switch-to-buffer.
;; 1996/04/18 dadams
;;     Menu is added to Dir (Subdir) menu, not This (Immediate) menu.
;; 1996/03/20 dadams
;;     1. Added find-dired-default-fn.
;;     2. find-dired, find-name-dired, find-grep-dired:
;;           symbol-name-nearest-point -> find-dired-default-fn.
;; 1996/01/25 dadams
;;     find-dired-sentinel:
;;       1. Use (my) dired-insert-set-properties.
;;       2. Highlight whole file lines.
;; 1996/01/11 dadams
;;     find-dired-filter: Corrected removal of extra lines just listing a file,
;;       and deletion of "./" prefix.
;; 1996/01/11 dadams
;;     1. Added redefinition of dired-revert.
;;     2. Buffer used has same root name as the dir (no longer "*Find*").
;;     3. Added " `find'" to mode-line-process.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(and (< emacs-major-version 20) (eval-when-compile (require 'cl))) ;; when, unless
(require 'find-dired-) ;; for new defvars from `find-dired.el'
(require 'find-dired)

(require 'dired+ nil t) ;; (no error if not found):
                        ;; dired-insert-set-properties,
                        ;; diredp-menu-bar-subdir-menu
 ;; Note: `dired+.el' does a (require 'dired): dired-mode-map

(when (and (require 'thingatpt+ nil t);; (no error if not found)
           (fboundp 'tap-put-thing-at-point-props)) ; >= 2012-08-21
  (tap-define-aliases-wo-prefix)
  (tap-put-thing-at-point-props))
 ;; region-or-non-nil-symbol-name-nearest-point

;; Quiet the byte-compiler.
(defvar find-ls-subdir-switches)        ; Emacs 22+
(defvar find-name-arg)                  ; Emacs 22+
(defvar find-program)                   ; Emacs 22+
(defvar find-exec-terminator)           ; Emacs 22+

;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar find-args nil                   ; Define it for older Emacs versions.
  "Last arguments given to `find' by `\\[find-dired]'.")

(defvar find-dired-hook nil
  "*Hook to be run at the end of each `find-dired' execution.")

(defcustom find-dired-default-fn (if (fboundp 'region-or-non-nil-symbol-name-nearest-point)
                                     (lambda () (region-or-non-nil-symbol-name-nearest-point t))
                                   'word-at-point)
  "*Function of 0 args called to provide default input for \\[find-dired],
\\[find-name-dired], and  \\[find-grep-dired].

Some reasonable choices: `word-nearest-point',
`region-or-non-nil-symbol-name-nearest-point',
`non-nil-symbol-name-nearest-point', `sexp-nearest-point'.

If this is nil, then no default input is provided."
  :type '(choice
          (const :tag "No default for `find-dired'" nil)
          (function :tag "Function of zero args to provide default for `find-dired'"))
  :group 'find-dired)


;; REPLACES ORIGINAL in `find-dired.el':
;;
;; Use `dired-listing-switches' for Windows.
;;
;; Note: `defconst' is necessary here because this is preloaded by Emacs.
;;       It is not sufficient to do a defvar before loading `find-dired.el'.
;;       Otherwise, this could be just a `defvar' in `find-dired-.el'.
(defconst find-ls-option
    (cond ((eq system-type 'windows-nt) (cons "-ls" dired-listing-switches))
          ((and (fboundp 'process-file)  (boundp 'find-program)  (boundp 'null-device) ;Emacs22+
                (eq 0 (condition-case nil
                          (process-file find-program nil nil nil null-device "-ls")
                        (error nil))))
           (cons "-ls" (if (eq system-type 'berkeley-unix) "-gilsb" "-dilsb")))
          (t (cons (format "-exec ls -ld {} %s" (if (boundp 'find-exec-terminator)
                                                    find-exec-terminator
                                                  "\\;"))
                   "-ld")))
  "*Description of the option to `find' to produce an `ls -l'-type listing.
This is a cons of two strings (FIND-OPTION . LS-SWITCHES).
FIND-OPTION is the option (or options) for `find' needed to produce
 the desired output.
LS-SWITCHES is a list of `ls' switches that tell Dired how to parse
 the output.")


;; REPLACES ORIGINAL in `find-dired.el':
;; 1. Interactive spec uses `find-dired-default-fn'.
;; 2. Runs `find-dired-hook' at end.
;; 3. Buffer used has same root name as the dir (not "*Find*").
;;;###autoload
(defun find-dired (dir args)
  "Run `find' and put its output in a buffer in Dired Mode.
Then run `find-dired-hook' and `dired-after-readin-hook'.
The `find' command run (after changing into DIR) is essentially:

    find . \\( ARGS \\) -ls"
  (interactive
   (let ((default  (and (functionp find-dired-default-fn) (funcall find-dired-default-fn))))
     (list (funcall (if (fboundp 'read-directory-name) 'read-directory-name 'read-file-name)
                    "Run `find' in directory: " nil "" t)
           (read-string "Run `find' (with args): " find-args '(find-args-history . 1) default))))
  (let ((dired-buffers  dired-buffers))
    ;; Expand DIR ("" means default-directory), and make sure it has a
    ;; trailing slash.
    (setq dir  (abbreviate-file-name (file-name-as-directory (expand-file-name dir))))
    (unless (file-directory-p dir) (error "Command `find-dired' needs a directory: `%s'" dir))
    (switch-to-buffer (create-file-buffer (directory-file-name dir)))
    ;; See if there is still a `find' running, and offer to kill it first, if so.
    (let ((find-proc  (get-buffer-process (current-buffer))))
      (when find-proc
	(if (or (not (eq (process-status find-proc) 'run))
		(yes-or-no-p "A `find' process is running; kill it? "))
	    (condition-case nil
		(progn (interrupt-process find-proc) (sit-for 1)
                       (delete-process find-proc))
	      (error nil))
	  (error "Cannot have two processes in `%s' at once" (buffer-name)))))
    (widen)
    (kill-all-local-variables)
    (setq buffer-read-only  nil)
    (erase-buffer)
    (setq default-directory  dir
          find-args          args       ; Save for next interactive call.
          args               (concat (if (boundp 'find-program) find-program "find") " . "
                                     (if (string= args "")
                                         ""
                                       (concat (shell-quote-argument "(") " " args
                                               (shell-quote-argument ")") " "))
                                     (if (string-match "\\`\\(.*\\) {} \\(\\\\;\\|+\\)\\'"
                                                       (car find-ls-option))
                                         (format "%s %s %s"
                                                 (match-string 1 (car find-ls-option))
                                                 (shell-quote-argument "{}")
                                                 (if (boundp 'find-exec-terminator)
                                                     find-exec-terminator
                                                   "\\;"))
                                       (car find-ls-option))))
    (shell-command (concat args "&") (current-buffer)) ; Start `find' process.
    ;; The next statement will bomb in classic Dired (no optional arg allowed)
    (dired-mode dir (cdr find-ls-option))
    (let ((map  (make-sparse-keymap)))
      (set-keymap-parent map (current-local-map))
      (define-key map "\C-c\C-k" 'kill-find)
      (use-local-map map))
    (when (boundp 'dired-sort-inhibit) (set (make-local-variable 'dired-sort-inhibit) t))
    (set (make-local-variable 'revert-buffer-function)
	 `(lambda (ignore-auto noconfirm) (find-dired ,dir ,find-args)))
    ;; Set subdir-alist so that Tree Dired will work:
    (if (fboundp 'dired-simple-subdir-alist)
        ;; Works even with nested Dired format (dired-nstd.el,v 1.15 and later)
        (dired-simple-subdir-alist)
      ;; We have an ancient tree Dired (or classic Dired, where this does no harm)
      (set (make-local-variable 'dired-subdir-alist)
           (list (cons default-directory (point-min-marker)))))
    (when (boundp 'find-ls-subdir-switches)
      (set (make-local-variable 'dired-subdir-switches) find-ls-subdir-switches))
    (setq buffer-read-only  nil)
    ;; Subdir headerline must come first because first marker in `subdir-alist' points there.
    (insert "  " dir ":\n")
    ;; Make second line a "find" line by analogy to the "total" or "wildcard" line.
    (let ((opoint  (point)))
      (insert "  " args "\n")
      (dired-insert-set-properties opoint (point)))
    (setq buffer-read-only t)
    (let ((proc  (get-buffer-process (current-buffer))))
      (set-process-filter proc (function find-dired-filter))
      (set-process-sentinel proc (function find-dired-sentinel))
      ;; Initialize the process marker; it is used by the filter.
      (move-marker (process-mark proc) (point) (current-buffer)))
    (setq mode-line-process  '(": %s `find'"))
    (run-hooks 'find-dired-hook 'dired-after-readin-hook)))


;; REPLACES ORIGINAL in `find-dired.el':
;; Interactive spec uses `read-from-minibuffer', `read-directory-name',
;; `dired-regexp-history' and `find-dired-default-fn'.
;;;###autoload
(defun find-name-dired (dir pattern)
  "Search directory DIR recursively for files matching globbing PATTERN,
and run `dired' on those files.  PATTERN may use shell wildcards, and
it need not be quoted.  It is not an Emacs regexp.
By default, the command run (after changing into DIR) is this:

  find . -name 'PATTERN' -ls

See `find-name-arg' to customize the `find' file-name pattern arg."
  (interactive
   (let ((default  (and (functionp find-dired-default-fn) (funcall find-dired-default-fn))))
     (list (if (fboundp 'read-directory-name) ; Emacs 22+
               (read-directory-name "Find-name (directory): " nil nil t)
             (read-file-name "Find-name (directory): " nil "" t))
           (read-from-minibuffer "Find-name (filename wildcard): " nil
                                 nil nil 'dired-regexp-history default t))))
  (find-dired dir (concat (if (boundp 'find-name-arg) find-name-arg "-name")
                          " "
                          (shell-quote-argument pattern))))


;; REPLACES ORIGINAL in `find-dired.el':
;; Interactive spec uses `read-from-minibuffer', `read-file-name',
;; `dired-regexp-history' and `find-dired-default-fn'.
;;;###autoload
(defun find-grep-dired (dir regexp)
  "Find files in DIR containing a regexp REGEXP.
The output is in a Dired buffer.
The `find' command run (after changing into DIR) is:

    find . -exec grep -s REGEXP {} \\\; -ls

Thus REGEXP can also contain additional grep options."
  (interactive
   (let ((default  (and (functionp find-dired-default-fn) (funcall find-dired-default-fn))))
     (list (read-file-name "Find-grep (directory): " nil "" t)
           (read-from-minibuffer "Find-grep (grep regexp): " nil
                                 nil nil 'dired-regexp-history default t))))
  ;; find -exec doesn't allow shell i/o redirections in the command,
  ;; or we could use `grep -l >/dev/null'
  ;; We use -type f, not ! -type d, to avoid getting screwed
  ;; by FIFOs and devices.  I'm not sure what's best to do
  ;; about symlinks, so as far as I know this is not wrong.
  (find-dired dir (concat "-type f -exec grep " find-grep-options " " regexp " {} \\\; ")))


;; REPLACES ORIGINAL in `find-dired.el':
;; Removes lines that just list a file.
(defun find-dired-filter (proc string)
  "Filter for \\[find-dired] processes.
PROC is the process.
STRING is the string to insert."
  (let ((buf                (process-buffer proc))
        (inhibit-read-only  t))
    (if (buffer-name buf)
        (with-current-buffer buf
          (save-excursion
            (save-restriction
              (widen)
              (let ((buffer-read-only  nil)
                    (beg               (point-max))
                    (l-opt             (and (consp find-ls-option)
                                            (string-match "l" (cdr find-ls-option))))
                    (ls-regexp         (concat "^ +[^ \t\r\n]+\\( +[^ \t\r\n]+\\) +"
                                               "[^ \t\r\n]+ +[^ \t\r\n]+\\( +[0-9]+\\)")))
                (goto-char beg)
                (insert string)
                (goto-char beg)
                (unless (looking-at "^") (forward-line 1))
                (while (looking-at "^")
                  (insert "  ")
                  (forward-line 1))
                (goto-char (- beg 3))   ; No error if < 0.
                (save-excursion         ; Remove lines just listing the file.
                  (while (re-search-forward "^  \\./" nil t)
                    (delete-region (line-beginning-position) (line-end-position))
                    (when (eq (following-char) ?\n) (delete-char 1))))
                ;; Convert ` ./FILE' to ` FILE'.  This would lose if current chunk of output
                ;; starts or ends within the ` ./', so back up a bit.
                (while (search-forward " ./" nil t) (delete-region (point) (- (point) 2)))
		;; Pad the number of links and file size.  This is a quick and dirty way of
                ;; getting the columns to line up of the time, but it's not foolproof.
		(when l-opt
		  (goto-char beg)
		  (goto-char (line-beginning-position))
		  (while (re-search-forward ls-regexp nil t)
		    (replace-match (format "%4s" (match-string 1)) nil nil nil 1)
		    (replace-match (format "%9s" (match-string 2)) nil nil nil 2)
		    (forward-line 1)))
                ;; Find the complete lines in the unprocessed output, and add text props to it.
                (goto-char (point-max))
                (when (search-backward "\n" (process-mark proc) t)
                  (dired-insert-set-properties (process-mark proc) (1+ (point)))
                  (move-marker (process-mark proc) (1+ (point))))))))
      (delete-process proc))))          ; The buffer was killed.


;; REPLACES ORIGINAL in `find-dired.el':
;; 1. Highlights file lines.
;; 2. Puts `find' in mode-line.
(defun find-dired-sentinel (proc state)
  "Sentinel for \\[find-dired] processes.
PROC is the process.
STATE is the state of process PROC."
  (let ((buf                (process-buffer proc))
        (inhibit-read-only  t))
    (if (buffer-name buf)
        (save-excursion
          (set-buffer buf)
          (let ((buffer-read-only  nil))
            (save-excursion
              (goto-char (point-max))
              (insert "\nfind " state)  ; STATE is, e.g., "finished".
              (forward-char -1)         ; Back up before \n at end of STATE.
              (insert " at " (substring (current-time-string) 0 19))
              (forward-char 1)
              (setq mode-line-process  (concat ": " (symbol-name (process-status proc))
                                               " `find'"))
              ;; Since the buffer and mode line will show that the
              ;; process is dead, we can delete it now.  Otherwise it
              ;; will stay around until M-x list-processes.
              (delete-process proc)
              ;; Highlight lines of file names for mouse selection.
              (dired-insert-set-properties (point-min) (point-max))
              (force-mode-line-update)))
          (message "find-dired `%s' done." (buffer-name))))))


;; Menu bar, `find' menu.
(defvar menu-bar-run-find-menu (make-sparse-keymap "Unix `find'"))
(defalias 'menu-bar-run-find-menu (symbol-value 'menu-bar-run-find-menu))
(define-key menu-bar-run-find-menu [find-dired]
  '("`find' <anything>..." . find-dired))
(define-key menu-bar-run-find-menu [find-name-dired]
  '("Find Files Named..." . find-name-dired))
(define-key menu-bar-run-find-menu [find-grep-dired]
  '("Find Files Containing..." . find-grep-dired))
;; Add it to Dired's "Search" menu.
(when (boundp 'menu-bar-search-menu)
  (define-key dired-mode-map [menu-bar search separator-find]
    '("--"))
  (define-key dired-mode-map [menu-bar search find]
    '("Run `find' Command" . menu-bar-run-find-menu)))
;; Add it to Dired's "Dir" menu (called "Subdir" in `dired.el').
(when (boundp 'diredp-menu-bar-subdir-menu) ; Defined in `dired+.el'.
  (define-key-after diredp-menu-bar-subdir-menu [find]
    '("Run `find' Command" . menu-bar-run-find-menu) 'up))

;;;;;;;;;;;;;;;;;;;;;;;

(provide 'find-dired+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find-dired+.el ends here
