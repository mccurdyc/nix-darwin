{
  EDITOR = "neovim";
  VISUAL = "neovim";
  TERM = "xterm-256color";
  BROWSER = "firefox";

  FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude vendor --exclude .git";
  FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
  FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";

  FASTLY_CHEF_USERNAME = "cmccurdy";
  INFRA_SKIP_VERSION_CHECK = "true";

  # commit signing on the iPad
  GPG_TTY = "$(tty)";
}
