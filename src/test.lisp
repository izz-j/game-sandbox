(in-package #:game-sandbox)

(defun pack-assets ()
  (box.packer:make-atlas-from-directory
 "~/common-lisp/packer/assets/"
 :out-file "~/common-lisp/packer/spritesheet.png"
 :width 1024
 :height 1024
 :normalize nil
 :padding 25))

(defparameter *sprite* "hbase")
(defparameter *x* 0)
(defparameter *y* 0)

;;make hitbox with initial position values
(defparameter *object1*
  (make-hitbox 455 12 596 192))

;;(defparameter *object2*
 ;; (make-hitbox 596 192))

;;(update-moving-position *object1* *x* *y*)

;;(set-sizef *object1* 
(defun make-zero (arg)
  (setf arg 0))

(glfw:def-key-callback event (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close))
  (when (and (eq key :left) (or (eq action :press) (eq action :repeat)))
    (progn
      (princ "collide:")
      (princ (left-collidep *object1*))
      (terpri)
      (setf *x* (- *x* 10))))
  (when (and (eq key :right) (or (eq action :press) (eq action :repeat)))
    (progn
      (princ "collide:")
      (princ (right-collidep *object1*))
      (terpri)
      (setf *x* (+ *x* 10))))
  (when (and (eq key :up) (or (eq action :press) (eq action :repeat)))
    (progn
      (princ "collide:")
      (princ (top-collidep *object1*))
      (terpri)
      (setf *y* (- *y* 10))))
  (when (and (eq key :down) (or (eq action :press) (eq action :repeat)))
    (setf *y* (+ *y* 10))))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))


(defun build-house ()
  (let ((w 1024)
	(h 1024))
    ;;for now packer does not generate correct x coordinates
    ;;easier to guess the x coordinates
     ;;tx0 tx1 normalized coordinates W H
     ;;px0 py0 px1 py1 pixel coordinates X Y W H
    (mariko:draw  455 12 592 192 w h :xshift *x* :yshift *y*)
    (mariko:draw  455 12 592 192 w h   #|:xshift -225 :yshift 241|#)))
;;    (mariko:draw 12 12 418 272 w h)
   ;; (mariko:draw 757 12 850 97 w h :xshift *x* :yshift *y*)
  ;;  (mariko:draw 930 12 1024 41 w h
;;		:xshift -650 :yshift 280)
   ;; (mariko:draw 930 12 1024 41 w h :xshift -770 :yshift 280)))


(defun basic-sprite-test ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 1600 :height 900)
    (let ((path "spritesheet.png")) 
      (mariko:load-texture path)
	(glfw:set-window-size-callback 'update-viewport)
	(glfw:set-key-callback 'event)
	(mariko:set-viewport 1600 900)
	(gl:clear-color 0 0 0 0)
;;	(princ (get-right *object1*))
	(loop until (glfw:window-should-close-p)
	   do (gl:clear :color-buffer)
	  ;; do (draw-line 455 592 12 12)
	   do (build-house)
	   ;;constant must be added. cannot
	     ;;add getters because it will continuously increase/decrease
	   do  (update-positionf *object1*
				 (+ 455 *x*)
				 (+ 12 *y*)
				 (+ 596 *x*)
				 (+ 192 *y*))
	;;   do (princ (get-right *object1*))
	  ;; do (terpri)
	   do (glfw:poll-events)
	   do (glfw:swap-buffers)))))
