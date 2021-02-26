;; Quang-Hieu's personal Emacs configuration
;; Copyright (C) 2015-2020
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; License:
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(use-package elfeed
  :ensure t
  :bind ("C-c C-r" . elfeed)
  :config
  (setq elfeed-feeds
        '(("https://www.reddit.com/.rss?feed=b715b97328a94d3dcbddf4442e2777b95a1a6397&user=CaiCuoc")
          ("https://mangadex.org/rss/follows/8TwG7hQXrCAHM9t6DScUyqzF4mZdkPap?h=1" manga)
          ("https://www.jendrikillner.com/tags/weekly/index.xml" graphics)
          ("https://news.ycombinator.com/rss" tech)))
  (setq elfeed-search-filter "@1-week-ago +unread "))

(provide 'rss)
