(in-package #:game-sandbox)

(defclass hitbox ()
  ((left :writer set-left :accessor get-left :initarg :left)
   (right :writer set-right :accessor get-right :initarg :right)
   (top :writer set-top :accessor get-top :initarg :top)
   (bottom :writer set-bottom :accessor get-bottom :initarg :bottom)
   (id :writer set-id :accessor get-id :initarg :id)))
 ;; (:documentation "A hitbox class for collision checking"))

(defun make-hitbox (x0 y0 x1 y1)
  (make-instance 'hitbox 
		 :left x0
		 :top y0
		 :right x1
		 :bottom y1))

(defmethod update-positionf ((object hitbox) (x0 number) (y0 number) (x1 number) (y1 number))
  (set-left x0 object)
  (set-top y0 object)
  (set-right x1 object)
  (set-bottom y1 object))
 

;;object1 placement
;;Not perfect but pretty good collisions for side scroller beat em up
#|object1's top y must be  less than object2's bottom y to collide and
object1's right x must be greater than object2's left x to be
a top side collision|#
(defmethod top-collidep ((object hitbox) (object2 hitbox))
  (and (not (>= (get-top object) (get-bottom object2))) (not (<= (get-right object) (get-left object2)))
       (not (>= (get-left object) (get-right object2)))))

#|object1 x must be greater than object2's x to collide and
object1's y must be less than the bottom of object 2's y to be
a right  side collision |#
(defmethod right-collidep ((object hitbox) (object2 hitbox))
  (and (not (<= (get-right object) (get-left object2))) (top-collidep object object2) (not (> (get-right object) (get-right object2)))))

(defmethod left-collidep ((object hitbox) (object2 hitbox))
  (and (not (>= (get-left object)  (get-right object2))) (top-collidep object object2) (not (< (get-left object) (get-left object2)))))

   ;;(and (<= (bottom object2) (top object)) (< (center-x object) 455))))     ;Above, no collide
	;;(>= (top object2) (bottom object))    ;Below, no collide
	;;(<= (right object2) (left object))    ;Left of, no collide
;;	(>= (left object2) (right object))))) ;Right of, no collide
  
#|
;;check hitbox vs hitbox vector
(defmethod check-collisions ((object hitbox) (hitbox-vector vector))
    (loop for object-index across hitbox-vector
       do (if (collidep object object-index) (return t))))

;;note return from outer with nested loops
(defmethod check-hashtable-collisions ((object hitbox) (manager entity-manager))
  "check each entity's hitboxes and compare against 1 hitbox object"
  (loop named outer for entity being the hash-value of (get-entities manager)
     do (loop for hitbox-index across (get-hitboxes entity)
	   do (if (collidep object hitbox-index) (return-from outer t)))))

|#
