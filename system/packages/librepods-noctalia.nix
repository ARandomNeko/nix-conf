{
  fetchFromGitHub,
  librepods,
  qt6,
}:

# The Noctalia AirPods plugin needs status publishing and IPC verbs that are
# not available in upstream LibrePods. This fork is the backend documented by
# the plugin itself.
librepods.overrideAttrs (previousAttrs: {
  pname = "librepods-noctalia";
  version = "unstable-2026-08-26";

  src = fetchFromGitHub {
    owner = "harveywuk";
    repo = "librepods";
    rev = "4ed49df0b301ac3e6fba9c81dfbbb6726cc52201";
    hash = "sha256-Ygoqz5lnGMwZkys+Q4c4pyAUI0llvpGZ/ij5E91CkAg=";
  };

  sourceRoot = "source";

  buildInputs = previousAttrs.buildInputs ++ [ qt6.qtdeclarative ];
  cmakeFlags = (previousAttrs.cmakeFlags or [ ]) ++ [ "-DBUILD_TESTING=OFF" ];

  meta = previousAttrs.meta // {
    description = "Patched LibrePods backend for the Noctalia AirPods plugin";
    homepage = "https://github.com/harveywuk/librepods";
  };
})
