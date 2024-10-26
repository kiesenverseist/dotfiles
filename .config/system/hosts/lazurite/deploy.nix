{...}: {
  _module.args.nixinate = {
    # host = "152.69.171.68";
    host = "lazurite";
    sshUser = "root";
    buildOn = "local"; # valid args are "local" or "remote"
    substituteOnTarget = true; # if buildOn is "local" then it will substitute on the target, "-s"
    hermetic = false;
  };
}
