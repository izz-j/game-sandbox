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

;;; Getters
#|(defmethod half-width ((object hitbox))  
  (* (width object) .5))

(defmethod half-height ((object hitbox)) 
  (* (height object) .5))

(defmethod top ((object hitbox)) 
  (- (center-y object) (half-height object)))

(defmethod right ((object hitbox)) 
  (+ (center-x object) (half-width object)))

(defmethod bottom ((object hitbox)) 
  (+ (center-y object) (half-height object)))

;;(defmethod left ((object hitbox) x) 
 ;; (setf (width object) x))

(defmethod location ((object hitbox))
  (values (center-x object) (center-y object)))

(defmethod size ((object hitbox))
  (values (width object) (height object)))

;;; Setters
(defmethod set-sizef ((object hitbox) (width number) (height number))
  (setf (width object) width)
  (setf (height object) height))

(defmethod set-positionf ((object hitbox) (x number)  (y number))
  (setf (center-x object) x)
  (setf (center-y object) y))
|#
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
