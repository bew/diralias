{
  lib,
  stdenvNoCC,
  bash,
  bats,
}:

stdenvNoCC.mkDerivation {
  pname = "diralias";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ bash ];

  buildInputs = [ bash ];

  nativeCheckInputs = [ bats ];

  postPatch = ''
    patchShebangs diralias
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    bats diralias.bats
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 diralias $out/bin/diralias
    runHook postInstall
  '';

  meta = {
    description = "Manage directory aliases as filesystem symlinks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bew ];
    mainProgram = "diralias";
    platforms = lib.platforms.unix;
  };
}
