;;; text-align.el --- スペースを削除してカラムを揃える

;; Copyright (C) 2005  Free Software Foundation, Inc.

;; Author: akicho8 <akicho8@gmail.com>
;; Keywords:

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;;   (require 'text-align)
;;   (global-set-key "\C-xr<" 'text-align-ljust)
;;   (global-set-key "\C-xr>" 'text-align-rjust)
;;
;;; Code:

(defun text-align-delete-space-region (start end direction)
  (save-excursion
    (let ((lines (count-lines start end))
          (column (progn (goto-char start) (current-column)))
          (line 0))
      (untabify start end)
      (while (< line lines)
        (if (eq direction 'right)
            (progn
              (delete-region
               (point) (progn (skip-chars-forward " ") (point))))
          (let* ((to (point))
                 (from (progn (skip-chars-backward " ") (point)))
                 (space (buffer-substring from to)))
            (delete-region from to)
            (beginning-of-line)
            (insert space)))
        (forward-line)
        (move-to-column column)
        (insert (make-string (- column (current-column)) ? ))
        (setq line (1+ line))))))

(defun text-align-ljust (start end)
  "右側のスペースを削除
1  |  4    1  |4
 2 | 5  =>  2 |5
  3|6        3|6"
  (interactive "*r")
  (text-align-delete-space-region start end 'right))

(defun text-align-rjust (start end)
  "左側のスペースを削除
1  |  4    1|  4
 2 | 5  => 2| 5
  3|6      3|6"
  (interactive "*r")
  (text-align-delete-space-region start end 'left))

(provide 'text-align)
;;; text-align.el ends here
