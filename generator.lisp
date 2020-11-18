;;; This program should be used interactively and with Quicklisp available.
;;; Use with LISP --load generator.lisp
;;; (in-package :generator)
;;; (create-article (with-article "TITLE" spinneret-forms))
;;; (uiop:quit)
(in-package :cl-user)
(defpackage generator
  (:use :cl))
(in-package :generator)

(ql:quickload '(spinneret local-time) :silent t)

(defun todays-date ()
  (local-time:format-timestring
   nil
   (local-time:today)
   :format
   '(:day "/" :month "/" :year)))

(defmacro with-article (title &body body)
  `(spinneret:with-html-string
     (:doctype)
     (:html
      (:head
       (:meta :name "viewport" :content "width=device-width, initial-scale=1.0")
       (:title ,(format nil "~A | momozor.github.io" title))
       (:link :rel "icon"
              :href "https://avatars3.githubusercontent.com/u/24475030?s=460&v=4"
              :type "image/x-icon")
       (:link :rel "stylesheet" :href "/style.css"))

      (:header
       (:h1 "momozor.github.io")
       (:nav
        "[ " (:a :class "nav-btn" :href "/index.html" "Home") " ]"
        "[ " (:a :class "nav-btn" :href "/about.html" "About") " ]"
        "[ " (:a :class "nav-btn" :href "/contact.html" "Contact") " ]"
        "[ " (:a :class "nav-btn" :href "/repositories.html" "Repositories") " ]"))

      (:article
       (:h1 ,title)
       (:em ,(format nil
                     "Published at: ~A"
                     (todays-date)))
       
       ,@body))))

(defun create-article (path article)
  (with-open-file (file path
                        :direction :output
                        :if-exists :supersede
                        :if-does-not-exist :create)
    (format file article)))
