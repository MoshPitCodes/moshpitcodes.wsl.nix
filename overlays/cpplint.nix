_final: prev: {
  # cpplint's test suite fails on the current nixpkgs Python because a
  # DeprecationWarning from codecs.open() leaks into captured stderr,
  # breaking output-equality assertions. Upstream packaging bug, not
  # something we can fix here; skip checks until nixpkgs updates cpplint.
  cpplint = prev.cpplint.overridePythonAttrs (_: {
    doCheck = false;
  });
}
