(defpackage reblocks-parenscript
  (:use :cl)
  (:import-from #:reblocks/dependencies
                #:local-dependency
                #:get-url
                #:get-content-type
                #:serve)
  (:import-from #:reblocks/utils/misc
                #:md5)
  (:import-from #:parenscript
                #:chain
                #:ps
                #:ps*)

  (:export
   #:make-dependency
   #:make-dependency*
   #:make-js-handler))
(in-package reblocks-parenscript)


(defclass parenscript-dependency (local-dependency)
  ((js :type string
       :initarg :js
       :reader get-js)))


(defmethod get-url ((dependency parenscript-dependency))
  "Returns a hash-like url for this dependency because it does not have
a real filename."
  (values (format nil "/static/js/~a.js"
                  (md5 (get-js dependency)))
          :local))


(defmethod serve ((dependency parenscript-dependency))
  "Serves static dependency from the disk."
  (values (get-js dependency)
          (get-content-type dependency)))


(defmacro make-dependency (&body parenscript-code)
  `(make-instance 'parenscript-dependency
                  :type :js
                  :js (ps ,@parenscript-code)))


(defun make-dependency* (parenscript-code)
  (make-instance 'parenscript-dependency
                 :type :js
                 :js (ps* parenscript-code)))


(defun make-js-code-for-handler (js-code action-code)
  "Returns Parenscript code, ready to be translated into JavaScript.

   The code from `js-code` will be wrapped into a function which is called
   immediately with implicit arguments.

   This result is suitable to be used inline as value for HTML attributes like
   onChange, onClick, etc.

   Args:
       js-code (list of conses):
           Parenscript code, returning an object.
           This object will be passed to the Lisp part of the handler
           as keyword arguments.
       action-code (string):
           A symbol used as a placeholder for the action's id string.

   Returns:
       Sexps with Parenscript code.
"
  `(chain
    (lambda (,@(car js-code))
      (let* ((args (progn ,@(cdr js-code)))
             (args-type (typeof args)))
        (cond
          ((equal args-type
                  "object")
           (initiate-action-with-args ,action-code "" args "POST"))
          (t (chain console (error (+ "Arguments, to be passed to the action should be an object, not "
                                       args-type)))))
        parenscript:false))
    (apply this
           arguments)))


(defmacro make-js-handler (&key lisp-code js-code)
  "Creates a Reblocks action and returns JavaScript code, which can be used as onChange, onClick, etc. handler.

   Args:
       lisp-code (list-of-conses):
           First list item should be action's lambda list.
           Other list items are wrapped into implicit progn.
       js-code (list of conses):
           Parenscript code, returning an object.
           This object will be passed to the Lisp part of the handler
           as keyword arguments.

   Returns (string):
       Result is suitable to be used inline as value for HTML attributes like
       onChange, onClick, etc.

   Handler must be build from two parts JS and Lisp.

   JavaScript part should be written in Parenscript and return
   an objects. This object will be passed to the backend as
   keyword arguments for the action, defined by Lisp part of the handler.

   The code from `js-code` will be wrapped into a function which is called
   immediately with implicit arguments.

   Here is a real world example. This code processes updates of a text
   in the HTML input. This way you can make a suggest or on fly value validation:

   (:input :value url
           :name \"url\"
           :type \"text\"
           :onchange
           (reblocks-parenscript:make-js-handler
            :lisp-code ((&key url)
                        (update-url (branches widget)
                                    url))
            :js-code ((event)
                      ;; This will pass new URL value
                      ;; to the backend:
                      (parenscript:create
                       :url (@ event target value)))))
"
  (unless lisp-code
    (error "Set the lisp code."))
  (unless js-code
    (error "Set the JS code."))
  (unless (and (consp js-code)
               (consp (car js-code)))
    (error "JS code should be a list of forms"))
  
  (alexandria:with-gensyms (action-code)
    `(let* ((,action-code (reblocks/actions::function-or-action->action
                           (lambda ,(car lisp-code)
                             ,@(cdr lisp-code)))))
       (ps* (make-js-code-for-handler ',js-code
                                      ,action-code)))))
