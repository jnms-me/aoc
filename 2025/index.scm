(use-modules ((day01 part1) #:prefix day01:part1:)
             ((day01 part2) #:prefix day01:part2:)
             (dom)
             (hoot ffi))

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
    (h3 "Input")
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
                  (set! day01-part2-output (object->string (day01:part2:solve day01-input)))
                  (render)))
      "Submit"))
    (h3 "Output (part 1)")
    (code ,day01-part1-output)
    (h3 "Output (part 2)")
    (code ,day01-part2-output)))

(define (render)
  (console:log "render")
  (let ((old (document:get-element-by-id "app")))
    (unless (external-null? old)
      (element:remove! old)))
  (element:append-child! (document:body) (shtml->dom (get-template))))

(render)
