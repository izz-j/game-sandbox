(in-package #:game-sandbox)

(defun pack-assets ()
  (box.packer:make-atlas-from-directory
 "~/common-lisp/packer/assets/"
 :out-file "~/common-lisp/packer/spritesheet.png"
 :width 1024
 :height 1024
 :normalize nil
 :padding 25))

(defparameter *x* 0)
(defparameter *y* 0)

;;make hitbox with initial position values
(defparameter *object1*
  (make-hitbox 455 12 592 192))

(defparameter *object2*
  (make-hitbox 455 12  592 192))

(defparameter *current-key* nil)

(glfw:def-key-callback event (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close))
;;  (setf *current-key* nil)
  (when (and (eq key :left) (or (eq action :press) (eq action :repeat)))
    (progn
      (setf *current-key* "left")
      (setf *x* (- *x* 10))))
  (when (and (eq key :right) (or (eq action :press) (eq action :repeat)))
    (progn
      (setf *current-key* "right")
      (setf *x* (+ *x* 10))))
  (when (and (eq key :up) (or (eq action :press) (eq action :repeat)))
    (progn
      (setf *current-key* "up")
      (setf *y* (- *y* 10))))
  (when (and (eq key :down) (or (eq action :press) (eq action :repeat)))
    (setf *y* (+ *y* 10))))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))
      
(defun draw-test1 ()
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
    (let* ((path "spritesheet.png")
	   (e1 (make-entity 455 12 592 192))
	   (e2 (make-entity 455 12 592 192)))
      (set-hitbox (make-hitbox (get-x0 e1) (get-y0 e1) (get-x1 e1)
			       (get-y1 e1)) e1)
      (set-hitbox (make-hitbox (get-x0 e2) (get-y0 e2) (get-x1 e2)
			       (get-y1 e2)) e2)
      (mariko:load-texture path)
	(glfw:set-window-size-callback 'update-viewport)
	(glfw:set-key-callback 'event)
	(mariko:set-viewport 1600 900)
	(gl:clear-color 0 0 0 0)
	(loop until (glfw:window-should-close-p)
	   do (gl:clear :color-buffer)
	   ;; do (draw-line 455 592 12 12)
	   do (draw-test1)
	   do (check-collide (get-hitbox e1) (get-hitbox e2) *current-key*)
	   ;;constant must be added. cannot
	   ;;add getters because it will continuously increase/decrease
	   do  (update-positionf (get-hitbox e1)
				 (+ 455 *x*)
				 (+ 12 *y*)
				 (+ 592 *x*)
				 (+ 192 *y*))
	   do (glfw:poll-events)
	   do (glfw:swap-buffers)))))
