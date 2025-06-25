{
  home.file.".emacs.d/init.el" = {
    text = # lisp
      ''
        (org-babel-load-file
         ; (expand-file-name
          "~/repos/dotfiles/home-manager/emacs-config.org"
      ; user-emacs-directory)
      )
      '';
  };
  home.file.".emacs.d/early-init.el" = {
    text = # lisp
      ''
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . 0) default-frame-alist)
        (push '(vertical-scroll-bars) default-frame-alist)
      '';
  };
}
