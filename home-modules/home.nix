{ inputs
, system
, ...
}:
{
  home.stateVersion = "23.05";

  # Need to run `vale sync` to install styles.
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    # gem env gemdir
    "$HOME/.local/share/gem/ruby/3.1.0/bin"
    # python -m ensurepip --default-pip
    "$HOME/.local/bin"
  ];

  # Hide "last login" message on new terminal.
  home.file.".hushlogin".text = "";

  xdg.configFile."yamllint/config".text = ''
    rules:
      document-start:
        present: true
  '';
}
