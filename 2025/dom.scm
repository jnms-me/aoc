(define-module (dom)
  #:use-module (hoot ffi)
  #:use-module (ice-9 match)
  #:export (console:log
            document:body
            document:create-element
            document:create-text-node
            document:get-element-by-id
            element:add-event-listener!
            element:append-child!
            element:remove!
            element:set-attribute!
            element:value
            event:target
            shtml->dom))

(define-foreign console:log "console" "log" (ref string) -> none)
(define-foreign document:body "document" "body" -> (ref null extern))
(define-foreign document:create-element "document" "createElement" (ref string) -> (ref null extern))
(define-foreign document:create-text-node "document" "createTextNode" (ref string) -> (ref null extern))
(define-foreign document:get-element-by-id "document" "getElementById" (ref string) -> (ref null extern))
(define-foreign element:add-event-listener! "element" "addEventListener" (ref null extern) (ref string) (ref null extern) -> none)
(define-foreign element:append-child! "element" "appendChild" (ref null extern) (ref null extern) -> (ref null extern))
(define-foreign element:remove! "element" "remove" (ref null extern) -> none)
(define-foreign element:set-attribute! "element" "setAttribute" (ref null extern) (ref string) (ref string) -> none)
(define-foreign element:value "element" "value" (ref null extern) -> (ref string))
(define-foreign event:target "event" "target" (ref null extern) -> (ref null extern))

(define (shtml->dom shtml)
  (match shtml
    ((? string? str)
     (document:create-text-node str))
    (((? symbol? tag) . children)
     (let ((el (document:create-element (symbol->string tag))))
       (for-each
        (λ (child)
          (match child
            (('@ (? symbol? attribute) (? string? value))
             (element:set-attribute! el (symbol->string attribute) value))
            (('@ (? symbol? event) (? procedure? handler))
             (element:add-event-listener! el (symbol->string event) (procedure->external handler)))
            (child
             (element:append-child! el (shtml->dom child)))))
        children)
       el))))
