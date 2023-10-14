{isDarwin, ...}:
{
  programs.gpg = {
    enable = true;
  };
}
// (
  if isDarwin
  then {}
  else {
    services.gpg-agent = {
      enable = true;
    };
  }
)
