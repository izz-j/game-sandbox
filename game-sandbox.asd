;;;; skirmish.asd

(asdf:defsystem #:game-sandbox
  :description "An experimental 2d game in progress primarily to test the graphics lib Mariko and editing features"
  :author "Iseman Johnson <johnsoni1440@gmail.com>"
  :license ""
  :depends-on (#:mariko #:cl-glfw3 #:gamebox-sprite-packer)
  :serial t
  :components ((:file "package")
               (:file "test")))

;;note order matters when listing component
;;make sure mainfile is last
