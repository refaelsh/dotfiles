{
  programs.git = {
    enable = true;
    aliases = {
      lg = "log --date-order --color-moved --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      st = "status";
      diff = "diff --color-moved --submodule";
      show = "show --color-moved";
      ch = "checkout";
    };
    settings = {};
    userEmail = "refaelsh@pm.me";
    userName = "refaelsh";
    extraConfig = {
      safe = {
        directory = "*";
      };
      color = {
        ui = "always";
      };
      init = {
        defaultBranch = "master";
      };
      color.branch = {
        current = "cyan bold reverse";
        local = "white";
        plain = "";
        remote = "cyan";
      };
      color.diff = {
        commit = "";
        func = "cyan";
        plain = "";
        whitespace = "magenta reverse";
        meta = "white";
        frag = "cyan bold reverse";
        old = "red";
        new = "green";
      };
      color.grep = {
        context = "";
        filename = "";
        function = "";
        linenumber = "white";
        match = "";
        selected = "";
        separator = "";
      };
      color.interactive = {
        error = "";
        header = "";
        help = "";
        prompt = "";
      };
      color.status = {
        added = "green";
        changed = "yellow";
        header = "";
        localBranch = "";
        nobranch = "";
        remoteBranch = "cyan bold";
        unmerged = "magenta bold reverse";
        untracked = "red";
        updated = "green bold";
      };
      merge = {
        ff = "no";
        tool = "kdiff3";
      };
      pull = {
        rebase = "true";
      };
    };
  };
}
