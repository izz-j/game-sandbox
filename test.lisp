(defun main ()
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

(defun make-zero (arg)
  (setf arg 0))

(glfw:def-key-callback event (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close))
  (when (and (eq key :left) (or (eq action :press) (eq action :repeat)))
    (setf *x* (- *x* 10)))
  (when (and (eq key :right) (or (eq action :press) (eq action :repeat)))
    (setf *x* (+ *x* 10)))
  (when (and (eq key :up) (or (eq action :press) (eq action :repeat)))
    (setf *y* (- *y* 10)))
  (when (and (eq key :down) (or (eq action :press) (eq action :repeat)))
    (setf *y* (+ *y* 10))))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))

(defun draw (px0 py0 px1 py1 spritesheet-width spritesheet-height &key (xshift 0) (yshift 0))
  "gets pixel coordinates converts them into tex coordinates and draws them. It is recommended to leave some space between objects on a spritesheet for this function to accurately draw the specified object" 
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (let* ((tx0 (/ px0 spritesheet-width))
	 (tx1 (/ px1 spritesheet-width))
	 (ty0 (/ py0 spritesheet-height))
	 (ty1 (/ py1 spritesheet-height)))
    (gl:with-primitive :quads
      (gl:tex-coord tx0 ty0)
      (gl:vertex (+ px0 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty0)
      (gl:vertex  (+ px1 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty1)
      (gl:vertex (+ px1 xshift) (+ py1 yshift) 0)
      (gl:tex-coord  tx0 ty1)
      (gl:vertex (+ px0 xshift) (+ py1 yshift)  0)))
  (gl:flush))

(defun draw2 (w h px0 py0 px1 py1 &key (xshift 0) (yshift 0))
  "gets pixel coordinates converts them into tex coordinates and draws them. It is recommended to leave some space between objects on a spritesheet for this function to accurately draw the specified object" 
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (let* ((tx0 (/ px0 w))
	 (tx1 (/ px1 w))
	 (ty0 (/ py0 h))
	 (ty1 (/ py1 h)))
    (gl:with-primitive :quads
      (gl:tex-coord tx0 ty0)
      (gl:vertex (+ px0 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty0)
      (gl:vertex  (+ px1 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty1)
      (gl:vertex (+ px1 xshift) (+ py1 yshift) 0)
      (gl:tex-coord  tx0 ty1)
      (gl:vertex (+ px0 xshift) (+ py1 yshift)  0)))
  (gl:flush))

(defun pixel-coord-list (path num-of-columns num-of-rows
			  sprite-row sprite-column)
  (let* ((imw (mariko:get-image-width path))
	 (imh (mariko:get-image-height path))
	 (tw (/ imw num-of-columns))
	 (th (/ imh num-of-rows))
	 (px0 (* sprite-row tw))
	 (py0 (* sprite-column th))
	 (px1 (+ px0 tw))
	 (py1 (+ py0 th)))
    (list px0 py0 px1 py1)))

(defun display-sprite (path num-of-columns num-of-rows sprite-row sprite-column &key (xshift 0) (yshift 0))
  (let ((pixel-list (mariko:pixel-coord-list path num-of-columns num-of-rows sprite-row sprite-column)))
;;    (princ (cadddr pixel-list))
    (draw (car pixel-list) (cadr pixel-list) (caddr pixel-list) (cadddr pixel-list)
			   (mariko:get-image-width path)
			   (mariko:get-image-height path)
			   :xshift xshift :yshift yshift)))

;;3rd row counts as 2nd row
(defun build-house ()
  (let ((w 1024)
	(h 1024))
  (draw2 w h 455 12 600 192 :xshift -360 :yshift 241)
  (draw2 w h 455 12 600 192 :xshift -225 :yshift 241)
  ;;(draw2 (/ 600 1024) (/ 12 1024) (/ 750 1024) (/ 111 1024) 600 12  750 111
  ;;	 :xshift *x* :yshift *y*)
   (draw2 w h 12 12 418 272)
   (draw2 w h 757 12 850 97 :xshift *x* :yshift *y*)
   (draw2 w h 930 12 1024 41
	  :xshift -650 :yshift 280)
  (draw2 w h 930 12 1024 41 :xshift -770 :yshift 280)))
  

(defun basic-sprite-test ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 1600 :height 900)
    (let ((path "spritesheet.png")) 
      (mariko:load-texture path)
	(glfw:set-window-size-callback 'update-viewport)
	(glfw:set-key-callback 'event)
	(mariko:set-viewport 1600 900)
	(gl:clear-color 0 0 0 0)
;;	(display-sprite path 3 1 2 0)
	(loop until (glfw:window-should-close-p)
	   ;; do (gl:clear)
	   do (gl:clear :color-buffer)
	 ;;  do (setq *sprite* (read))
	   do (build-house)
;;	   do (display-sprite path 2 3 1 0 :xshift -400 :yshift 200)
;;	   do (display-sprite path 2 3 1 0 :xshift -530 :yshift 200)
;;	   do (display-sprite path 2 3 0 0)
	   ;;	   do (display-sprite path 2 3 1 1 :yshift -300 :xshift -550)

	   ;;tx0 tx1 normalized coordinates W H
	   ;;px1 py1 pixel coordinates W H
	  ;; do (draw2 0 0 .40820313 .265625 0 0 418 272)
	;;   do (draw2 (/ 12 1024) (/ 12 1024) (/ 418 1024) (/ 272 1024) 12 12 418 272)
	     
	  ;; do (draw2 (/ 455 1024) (/ 12 1024) (/ 600 1024) (/ 192 1024) 455 12 600 192 :xshift *x* :yshift *y*)
	   ;; do (draw2 (/ 600 1024) (/ 12 1024) (/ 750 1024) (/ 111 1024) 600 12  750 111)  
	   do (glfw:poll-events)
	   do (glfw:swap-buffers)))))
