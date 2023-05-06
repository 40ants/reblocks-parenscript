(uiop:define-package #:reblocks-parenscript
  (:use :cl)
  (:nicknames #:reblocks-parenscript/reblocks-parenscript)
  (:import-from #:reblocks/dependencies
                #:local-dependency
                #:get-url
                #:get-content-type
                #:serve)
  (:import-from #:reblocks/utils/misc
                #:md5)
  (:import-from #:alexandria)
  (:import-from #:parenscript
                #:chain)
  (:import-from #:bordeaux-threads
                #:with-lock-held
                #:make-lock)

  (:export #:make-dependency
           #:make-dependency*
           #:make-js-handler
           #:js-code
           #:parenscript-dependency))
(in-package #:reblocks-parenscript)


(defvar *js-compiler-lock*
  (make-lock "JS Compiler Lock"))


(defun ps* (&rest parenscript-code)
  (with-lock-held (*js-compiler-lock*)
    (apply #'parenscript:ps* parenscript-code)))


(defmacro ps (&body body)
  `(with-lock-held (*js-compiler-lock*)
     (parenscript:ps ,@body)))


(defclass parenscript-dependency (local-dependency)
  ((js :type string
       :initarg :js
       :reader js-code))
  (:documentation "Keeps JavaScript code, created using MAKE-DEPENDENCY macro or MAKE-DEPENDENCY* function."))


(defmethod get-url ((dependency parenscript-dependency))
  "Returns a hash-like url for this dependency because it does not have
a real filename."
  (values (format nil "/static/js/~a.js"
                  (md5 (js-code dependency)))
          :local))


(defmethod serve ((dependency parenscript-dependency))
  "Serves static dependency from the disk."
  (values (js-code dependency)
          (get-content-type dependency)))


(defmacro make-dependency (&body parenscript-code)
  "
This macro creates an object of class PARENSCRIPT-DEPENDENCY transformin the BODY
into JavaScript Code. It interpreters whole body as a Parenscript code.

Here is a usage example.

```lisp
CL-USER> (reblocks-parenscript:make-dependency
           (defun show-alert ()
             (ps:chain console (log \"Showing alert\"))
             (alert \"Hello from Lisp!\"))

           (set-interval show-alert 3000))
#<REBLOCKS-PARENSCRIPT:PARENSCRIPT-DEPENDENCY >
```

This dependency will have this JavaScript code:

```lisp
CL-USER> (format t \"~A~%\"
                 (reblocks-parenscript:js-code *))
function showAlert() {
    console.log('Showing alert');
    __PS_MV_REG = [];
    return alert('Hello from Lisp!');
};
setInterval(showAlert, 3000);
```

You can use this dependency in a method of REBLOCKS/DEPENDENCIES:GET-DEPENDENCIES generic-function like this:

```lisp
(defmethod reblocks/dependencies:get-dependencies ((widget example))
  (list*
   (reblocks-parenscript:make-dependency
     (defun show-alert ()
       (ps:chain console (log \"Showing alert\"))
       (alert \"Hello from Lisp!\"))

     (set-interval show-alert 3000))
   (call-next-method)))
```

"
  `(make-instance 'parenscript-dependency
                  :type :js
                  :js (ps ,@parenscript-code)))


(defun make-dependency* (parenscript-code)
  "This function works similarly like MAKE-DEPENDENCY macro but accepts
   Parenscript code as a list. They are related to each other like
   parenscript:ps macro and parenscript:ps* function.

   Use a function version when you want to build a JavaScript code from
   parts and embed some value into it.

   Usually it looks like this:

   ```lisp
   CL-USER> (let ((widget-id \"foo-bar\"))
              (reblocks-parenscript:make-dependency*
               `(defun show-alert ()
                  (alert (+ \"Hello from widget with id = \" ,widget-id)))))
   #<REBLOCKS-PARENSCRIPT:PARENSCRIPT-DEPENDENCY >
   ```

   This will generate following JavaScript code:

   ```
   CL-USER> (format t \"~A~%\"
                    (reblocks-parenscript:js-code *))
   function showAlert() {
       __PS_MV_REG = [];
       return alert('Hello from widget with id = ' + 'foo-bar');
   };
   ```
"
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
           (initiate-action ,action-code (parenscript:create :method "POST"
                                                             :args args)))
          (t (chain console (error (+ "Arguments, to be passed to the action should be an object, not "
                                       args-type)))))
        parenscript:false))
    (apply this
           arguments)))


(defmacro make-js-handler (&key lisp-code js-code)
  "Creates a Reblocks action and returns JavaScript code, which can be used as `onChange`, `onClick`, etc. handler.

   - Argument LISP-CODE should be a list of conses:

       First list item should be action's lambda list.
       Other list items are wrapped into implicit progn.

   - Argument JS-CODE also should be a list of conses:

       Parenscript code, returning an object.
       This object will be passed to the Lisp part of the handler
       as keyword arguments.

   This macro creates a code which will return a string.
   The result is suitable to be used inline as value for HTML attributes like `onChange`, `onClick`, etc.

   Handler must be build from two parts JS and Lisp.

   JavaScript part should be written in Parenscript and return
   an objects. This object will be passed to the backend as
   keyword arguments for the action, defined by Lisp part of the handler.

   The code from JS-CODE argument will be wrapped into a function which is called
   immediately with implicit arguments.

   Here is a real world example. This code processes updates of a text
   in the HTML input. This way you can make a suggest or on fly value validation:

   ```
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
   ```
"
  (unless lisp-code
    (error "Set the lisp code."))
  (unless js-code
    (error "Set the JS code."))
  (unless (and (consp js-code)
               (consp (car js-code)))
    (error "JS code should be a list of forms"))
  
  (alexandria:with-gensyms (action-code)
    `(let* ((,action-code (reblocks/actions:make-action
                           (lambda ,(car lisp-code)
                             ,@(cdr lisp-code)))))
       (ps* (make-js-code-for-handler ',js-code
                                      ,action-code)))))
