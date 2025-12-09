(use-modules (hoot ffi)
             (ice-9 match)
             ((day01 part1) #:prefix day01:part1:))

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

(define day01-input "\
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
")
(define day01-part1-output "none")
(define day01-part2-output "none")

(define (get-template)
  `(div
    (@ id "app")
    (h1 "AOC")
    (h2 "Day 01")
    (h3 "Part 1")
    (h4 "Input")
    (div
     (textarea
      (@ change ,(λ (event)
                   (let* ((el (event:target event))
                          (new-value (element:value el)))
                     (set! day01-input new-value))))
      ,day01-input))
    (div
     (button
      (@ click ,(λ (event)
                  (set! day01-part1-output (object->string (day01:part1:solve day01-input)))
                  (render)))
      "Submit"))
    (h4 "Output (part 1)")
    (code ,day01-part1-output)
    (h4 "Output (part 2)")
    (code ,day01-part2-output)
    ))

(define (render)
  (console:log "render")
  (let ((old (document:get-element-by-id "app")))
    (unless (external-null? old)
      (element:remove! old)))
  (element:append-child! (document:body) (shtml->dom (get-template))))

(render)
