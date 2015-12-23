;;; helm-matsuya.el --- Matsuya generator with helm interface -*- lexical-binding: t; -*-

;; Copyright (C) 2015 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-helm-matsuya
;; Version: 0.01
;; Package-Requires: ((helm "1.7.7") (migemo "0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; matsuya generator command with helm interface

;;; Code:

(require 'helm)
(require 'helm-net)
(require 'cl-lib)

(defgroup helm-matsuya nil
  "matsuya generator command with helm interface"
  :group 'helm)

(defcustom helm-matsuya-limit 10
  "Limit of menu"
  :group 'helm-matsuya)

(defun helm-matsuya--candidates ()
  (cl-loop repeat helm-matsuya-limit
           collect
           (with-temp-buffer
             (process-file "matsuya" nil t nil)
             (forward-line -1)
             (buffer-substring-no-properties (point-min) (line-end-position)))))

(defvar helm-matsuya--source
  (helm-build-sync-source "Menu"
    :candidates #'helm-matsuya--candidates
    :volatile t
    :migemo t
    :action (helm-make-actions
             "Open Browser" #'helm-google-suggest-action
             "Insert" #'insert)))

;;;###autoload
(defun helm-matsuya ()
  (interactive)
  (helm-migemo-mode +1)
  (helm :sources '(helm-matsuya--source) :buffer "*helm matsuya*"))

(provide 'helm-matsuya)

;;; helm-matsuya.el ends here
