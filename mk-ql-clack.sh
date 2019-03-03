#!/bin/sh

PORT=$1
TO_FILE=$2

cat << QLISP > $TO_FILE
(load "/root/quicklisp/setup.lisp")
(ql:quickload :cl-fastcgi)
(ql:quickload :clack)

(defpackage example-clack
  (:use :cl
        :clack))
(in-package :example-clack)

(defvar app
  #'(lambda (env)
      ;(declare (ignore env))

      (let ((request-uri (getf env :request-uri)))
        (cond 
          ((string= "/clack/" request-uri)
             \`(200
               (:content-type "text/plain")
               ((princ-to-string ("Hello, Clack!" 
                                  ,(getf env :server-name)
                                  ,(mapcar 
                                     #'(lambda (x) \`(,x 
                                                      :stringp ,(stringp x)
                                                      :keywordp ,(keywordp x)
                                                      :symbolp ,(symbolp x))) env)
                                  )))))
          (t \`(200
               (:content-type "text/plain")
               (,(princ-to-string \`("それいがいだかんね" ,request-uri)))))))))

(defvar *handler*
  (clackup app

           :server :fcgi
           :port $PORT
           :debug t))
QLISP
