{
  home.file.".emacs.d/init.el" = {
    text = # lisp
      ''
        (org-babel-load-file
         (expand-file-name
          "~/repos/dotfiles/home-manager/emacs-config.org"
          user-emacs-directory))
      '';
  };
}
