{ pkgs, inputs, ... }:
{
  # xdg.configFile."emacs/init.el".source = ./init.el;
  # home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/init.el" = {
    text = # lisp
      ''
        (org-babel-load-file
         (expand-file-name
          "./emacs-config.org"
          user-emacs-directory))
      '';
  };
}
