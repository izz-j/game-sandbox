(in-package #:game-sandbox)

(defclass entity ()
  ;;position on sprite sheet coordinates
  ((x0 :writer set-x0 :accessor get-x0 :initarg :x0)
   (y0 :writer set-y0 :accessor get-y0 :initarg :y0)
   (x1 :writer set-x1 :accessor get-x1 :initarg :x1)
   (y1 :writer set-y1 :accessor get-y1 :initarg :y1)
   ;;c-stays constant
   (coord-listc :initarg :coord-listc)
   ;;path to spritesheet
   (path :initarg :path)
  ;;hitbox
  (hitbox :writer set-hitbox :accessor get-hitbox :initarg :hitbox))
  (:documentation "entity object class"))

(defun make-entity (x0 y0 x1 y1)
  "makes entity, hitbox is either t or nil"
  (make-instance 'entity :x0 x0 :y0 y0 :x1 x1 :y1 y1
		 :coord-listc (list x0 y0 x1 y1)))
