;;; shoot-in-the-foot-mode
;;;
;;; Warn user of using a shoot-yourself-in-the-foot technique like macro by
;;; playing the gun-cocking sound on dangerous symbol input.

(defconst shoot-in-the-foot-sounds
  (file-name-as-directory
   (expand-file-name
    "sounds"
    (if load-file-name
        (file-name-directory load-file-name)
      default-directory)))
  "Path to the directory with sounds.")

(defmacro shoot-in-the-foot-play (file)
  "Play sound file.
If the platform is known, run its built-in shell tool, otherwise
use Emacs' own `play-sound-file' function."
  `(concat
    ,(cond
      ((string-equal system-type "gnu/linux")
       `(call-process "aplay" nil 0 nil ,file))
      ((string-equal system-type "darwin")
       `(call-process "afplay" nil 0 nil ,file))
      (t
       `(make-thread (lambda () (play-sound-file ,file)))))))

(defun shoot-in-the-foot-warn ()
  "Produce shotgun reloading sound."
  (shoot-in-the-foot-play (concat shoot-in-the-foot-sounds "reload_00.wav")))

(defcustom shoot-in-the-foot-dangerous-symbols (list 'defmacro 'macrolet)
  "List of symbols that trigger warning."
  :type 'list)

(defun shoot-in-the-foot-dispatch ()
  "Dispatch warning on symbol at point.
If symbol at point is in dangerous list, call warning function."
  (when (member (symbol-at-point) shoot-in-the-foot-dangerous-symbols)
    (shoot-in-the-foot-warn)))

(defun shoot-in-the-foot-after-hook ()
  "After-hook to add/remove dispatch function.
Add/remove dispatch function from post-self-insert-hook list when
mode is enabled/disabled."
  (if shoot-in-the-foot-mode
      (add-hook 'post-self-insert-hook 'shoot-in-the-foot-dispatch)
    (remove-hook 'post-self-insert-hook 'shoot-in-the-foot-dispatch)))

(define-minor-mode shoot-in-the-foot-mode
  "Warn if the user tries to shoot himself in the foot."
  :lighter " SYitF"
  :after-hook (shoot-in-the-foot-after-hook))

(provide 'shoot-in-the-foot)
