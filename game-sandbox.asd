;;;; game-sandbox.asd

(asdf:defsystem #:game-sandbox
  :description "An experimental 2d game testing space, primarily to test the graphics lib Mariko and editing features"
  :author "Iseman Johnson <johnsoni1440@gmail.com>"
  :license  ""
  :version ""
  :serial t
  :depends-on (#:mariko #:cl-glfw3 #:gamebox-sprite-packer)
  :pathname "src"
  :components ((:file "package")
	       (:file "entity")
	       (:file "collisions")
               (:file "test")))
