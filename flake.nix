{
  inputs.kubenix.url = "github:whs-dot-hk/kubenix/test";
  outputs = {
    self,
    kubenix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    packages.${system}.default =
      (kubenix.evalModules.${system} {
        module = {kubenix, ...}: {
          imports = [kubenix.modules.k8s];
          kubernetes.resources.pods.example.spec.containers.nginx = {
            image = "nginx";
            ports = [
              {
                containerPort = 80;
                #protocol = "TCP";
              }
              {
                containerPort = 80;
                protocol = "UDP";
              }
            ];
          };
        };
      })
      .config
      .kubernetes
      .result;
  };
}
