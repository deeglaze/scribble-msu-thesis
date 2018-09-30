#lang setup/infotab
;;
;; Copyright 2018 Dionna Glaze
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;;
(define name "scribble-msu-thesis")
(define version "1.0")
(define deps '("base" "scribble-text-lib"))
(define build-deps '("scribble-lib" "racket-doc" "scribble-doc"))
(define scribblings '(("msu-thesis.scrbl" () ("MSU Thesis Scribble #lang"))))
