{
  # systemd.services.numlock = {
  #   description = "Enable NumLock at startup";
  #   wantedBy = [ "multi-user.target" ]; 
  #   serviceConfig = {
  #     TTYPath = "/dev/tty1";
  #     StandardInput = "tty";
  #     StandardOutput = "tty";
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = "${pkgs.kbd}/bin/setleds -D +num";  
  #   };
  # };
}
