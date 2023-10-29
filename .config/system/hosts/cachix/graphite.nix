{
  nix = {
    settings = {
      substituters = [
        "http://graphite:5000"
      ];
      trusted-public-keys = [
        "graphite:FnIo5szy8arpdbZ/2Y5TvXaQvGUxQ5n8ks0csr7G1aI="
      ];
    };
  };
}
