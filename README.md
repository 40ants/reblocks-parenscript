<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# reblocks-parenscript - An utility to define JavaScript dependencies for Weblocks widgets using Parenscript.

<a id="reblocks-parenscript-asdf-system-details"></a>

## REBLOCKS-PARENSCRIPT ASDF System Details

* Description: An utility to define JavaScript dependencies for Weblocks widgets using Parenscript.
* Licence: Unlicense
* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>
* Homepage: [https://40ants.com/reblocks-parenscript/][7b2b]
* Bug tracker: [https://github.com/40ants/reblocks-parenscript/issues][f0d4]
* Source control: [GIT][c5e3]
* Depends on: [alexandria][8236], [bordeaux-threads][3dbf], [parenscript][7921], [reblocks][184b]

[![](https://github-actions.40ants.com/40ants/reblocks-parenscript/matrix.svg?only=ci.run-tests)][cd34]

![](http://quickdocs.org/badge/reblocks-parenscript.svg)

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-parenscript)
```
<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

This library should be used to define JavaScript dependencies for Reblocks widgets.

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-40REBLOCKS-PARENSCRIPT-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-PARENSCRIPT

<a id="x-28-23A-28-2820-29-20BASE-CHAR-20-2E-20-22REBLOCKS-PARENSCRIPT-22-29-20PACKAGE-29"></a>

#### [package](4d02) `reblocks-parenscript`

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PARENSCRIPT-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-40REBLOCKS-PARENSCRIPT-24PARENSCRIPT-DEPENDENCY-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PARENSCRIPT-DEPENDENCY

<a id="x-28REBLOCKS-PARENSCRIPT-3APARENSCRIPT-DEPENDENCY-20CLASS-29"></a>

###### [class](cbfa) `reblocks-parenscript:parenscript-dependency` (local-dependency)

Keeps JavaScript code, created using [`make-dependency`][8c2d] macro or [`make-dependency*`][8b74] function.

**Readers**

<a id="x-28REBLOCKS-PARENSCRIPT-3AJS-CODE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-PARENSCRIPT-3APARENSCRIPT-DEPENDENCY-29-29"></a>

###### [reader](bffd) `reblocks-parenscript:js-code` (parenscript-dependency) (:js)

<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PARENSCRIPT-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-PARENSCRIPT-3AMAKE-DEPENDENCY-2A-20FUNCTION-29"></a>

##### [function](378d) `reblocks-parenscript:make-dependency*` parenscript-code

This function works similarly like [`make-dependency`][8c2d] macro but accepts
Parenscript code as a list. They are related to each other like
parenscript:ps macro and parenscript:ps* function.

Use a function version when you want to build a JavaScript code from
parts and embed some value into it.

Usually it looks like this:

```lisp
CL-USER> (let ((widget-id "foo-bar"))
           (reblocks-parenscript:make-dependency*
            `(defun show-alert ()
               (alert (+ "Hello from widget with id = " ,widget-id)))))
#<REBLOCKS-PARENSCRIPT:PARENSCRIPT-DEPENDENCY >
```
This will generate following JavaScript code:

```
CL-USER> (format t "~A~%"
                 (reblocks-parenscript:js-code *))
function showAlert() {
    __PS_MV_REG = [];
    return alert('Hello from widget with id = ' + 'foo-bar');
};
```
<a id="x-28REBLOCKS-PARENSCRIPT-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PARENSCRIPT-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-PARENSCRIPT-3AMAKE-DEPENDENCY-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](3f22) `reblocks-parenscript:make-dependency` &body parenscript-code

This macro creates an object of class [`parenscript-dependency`][1a62] transformin the `BODY`
into JavaScript Code. It interpreters whole body as a Parenscript code.

Here is a usage example.

```lisp
CL-USER> (reblocks-parenscript:make-dependency
           (defun show-alert ()
             (ps:chain console (log "Showing alert"))
             (alert "Hello from Lisp!"))

           (set-interval show-alert 3000))
#<REBLOCKS-PARENSCRIPT:PARENSCRIPT-DEPENDENCY >
```
This dependency will have this JavaScript code:

```lisp
CL-USER> (format t "~A~%"
                 (reblocks-parenscript:js-code *))
function showAlert() {
    console.log('Showing alert');
    __PS_MV_REG = [];
    return alert('Hello from Lisp!');
};
setInterval(showAlert, 3000);
```
You can use this dependency in a method of [`reblocks/dependencies:get-dependencies`][0fcf] generic-function like this:

```lisp
(defmethod reblocks/dependencies:get-dependencies ((widget example))
  (list*
   (reblocks-parenscript:make-dependency
     (defun show-alert ()
       (ps:chain console (log "Showing alert"))
       (alert "Hello from Lisp!"))

     (set-interval show-alert 3000))
   (call-next-method)))
```
<a id="x-28REBLOCKS-PARENSCRIPT-3AMAKE-JS-HANDLER-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](6de0) `reblocks-parenscript:make-js-handler` &key lisp-code js-code

Creates a Reblocks action and returns JavaScript code, which can be used as `onChange`, `onClick`, etc. handler.

* Argument `LISP-CODE` should be a list of conses:
First list item should be action's lambda list.
Other list items are wrapped into implicit progn.
* Argument `JS-CODE` also should be a list of conses:
Parenscript code, returning an object.
This object will be passed to the Lisp part of the handler
as keyword arguments.

This macro creates a code which will return a string.
The result is suitable to be used inline as value for `HTML` attributes like `onChange`, `onClick`, etc.

Handler must be build from two parts `JS` and Lisp.

JavaScript part should be written in Parenscript and return
an objects. This object will be passed to the backend as
keyword arguments for the action, defined by Lisp part of the handler.

The code from `JS-CODE` argument will be wrapped into a function which is called
immediately with implicit arguments.

Here is a real world example. This code processes updates of a text
in the `HTML` input. This way you can make a suggest or on fly value validation:

```
(:input :value url
        :name "url"
        :type "text"
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

[7b2b]: https://40ants.com/reblocks-parenscript/
[8c2d]: https://40ants.com/reblocks-parenscript/#x-28REBLOCKS-PARENSCRIPT-3AMAKE-DEPENDENCY-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[8b74]: https://40ants.com/reblocks-parenscript/#x-28REBLOCKS-PARENSCRIPT-3AMAKE-DEPENDENCY-2A-20FUNCTION-29
[1a62]: https://40ants.com/reblocks-parenscript/#x-28REBLOCKS-PARENSCRIPT-3APARENSCRIPT-DEPENDENCY-20CLASS-29
[0fcf]: https://40ants.com/reblocks/dependencies/#x-28REBLOCKS-2FDEPENDENCIES-3AGET-DEPENDENCIES-20GENERIC-FUNCTION-29
[c5e3]: https://github.com/40ants/reblocks-parenscript
[cd34]: https://github.com/40ants/reblocks-parenscript/actions
[4d02]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L1
[378d]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L111
[6de0]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L181
[cbfa]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L40
[bffd]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L41
[3f22]: https://github.com/40ants/reblocks-parenscript/blob/a1cbbbeda0ebea561df39b4660d78693e47a2fc8/src/reblocks-parenscript.lisp#L61
[f0d4]: https://github.com/40ants/reblocks-parenscript/issues
[8236]: https://quickdocs.org/alexandria
[3dbf]: https://quickdocs.org/bordeaux-threads
[7921]: https://quickdocs.org/parenscript
[184b]: https://quickdocs.org/reblocks

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
