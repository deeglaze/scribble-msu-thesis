#lang scheme/base
(require scribble/doclang
         scribble/core
         scribble/base
         scribble/latex-prefix
         withesis
         racket/list
         "../private/defaults.rkt"
         (for-syntax scheme/base))
(provide (except-out (all-from-out scribble/doclang) #%module-begin)
         (all-from-out withesis)
         (all-from-out scribble/base)
         (rename-out [module-begin #%module-begin]))

(define-syntax (module-begin stx)
  (syntax-case stx ()
    [(_ id . body)
     (let ([10pt? #f]
           [11pt? #f]
           [12pt? #f]
           [twoside? #f]
           [margincheck? #f]
           [msthesis? #f])
       (let loop ([stuff #'body])
         (syntax-case* stuff (10pt 11pt 12pt twoside margincheck msthesis) (lambda (a b) (eq? (syntax-e a) (syntax-e b)))
           [(ws . body)
            ;; Skip intraline whitespace to find options:
            (and (string? (syntax-e #'ws))
                 (regexp-match? #rx"^ *$" (syntax-e #'ws)))
            (loop #'body)]
           [(10pt . body)
            (set! 10pt? "10pt")
            (loop #'body)]
           [(11pt . body)
            (set! 11pt? "11pt")
            (loop #'body)]
           [(12pt . body)
            (set! 12pt? "12pt")
            (loop #'body)]
           [(twoside . body)
            (set! twoside? "twoside")
            (loop #'body)]
           [(margincheck . body)
            (set! margincheck? "margincheck")
            (loop #'body)]
           [(msthesis . body)
            (set! msthesis? "msthesis")
            (loop #'body)]
           [body
            (begin
             ;; Default to 10pt font.
             (unless (or 10pt? 11pt? 12pt?)
               (set! 10pt? #t))
             (unless (= 1 (+ (if 10pt? 1 0) (if 11pt? 1 0) (if 12pt? 1 0))
               (raise-syntax-error #f "Must specify at most one of 10pt, 11pt, and 12pt" stx))
            #`(#%module-begin id (post-process #,10pt? #,11pt? #,12pt? #,twoside? #,margincheck? #,msthesis?) () . body))])))]))

(define ((post-process . opts) doc)
  (let ([options
         (if (ormap values opts)
             (format "[~a]" (apply string-append (add-between (filter values opts) ", ")))
             "")])
    (add-withesis-styles 
     (add-defaults doc
                   (string->bytes/utf-8
                    (format "\\documentclass~a{withesis}\n~a~a"
                            options
                            unicode-encoding-packages))
                   (scribble-file "scribble-withesis/style.tex")
                   (list (scribble-file "scribble-withesis/withesis.cls"))
                   #f))))

(define (add-withesis-styles doc)
  ;; Ensure that "withesis.tex" is used, since "style.tex"
  ;; re-defines commands.
  (struct-copy part doc [to-collect
                         (cons (terms)
                               (part-to-collect doc))]))
