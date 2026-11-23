# Build-time fix for installing 'systemfonts' (needed by svglite -> kableExtra)
# from source with renv::restore() on Renku. Has no effect outside the Renku build image.
local({
  prefix <- "/layers/renku_r-conda/r"   # R installed by Renku's r-conda buildpack
  if (!dir.exists(prefix)) return(invisible())

  # Let pkg-config find the .pc files of the libraries shipped with that R
  # (fontconfig, freetype, libpng, libxml2, ...).
  pc_dir <- file.path(prefix, "lib", "pkgconfig")
  old <- Sys.getenv("PKG_CONFIG_PATH")
  Sys.setenv(PKG_CONFIG_PATH = if (nzchar(old)) paste(pc_dir, old, sep = ":") else pc_dir)

  # systemfonts 1.0.5:
  #  - pkg-config returns empty cflags in the build image, so the freetype
  #    header directory (ft2build.h) is passed explicitly via INCLUDE_DIR/LIB_DIR;
  #  - its sources miss '#include <cstdint>', which gcc >= 13 (Renku uses gcc 16)
  #    rejects ("'uint32_t' has not been declared"), so stdint.h is force-included.
  # renv passes these configure vars to systemfonts only.
  options(configure.vars = list(
    systemfonts = sprintf('INCLUDE_DIR="%s -include stdint.h" LIB_DIR=%s',
                          file.path(prefix, "include", "freetype2"),
                          file.path(prefix, "lib"))
  ))

  message(".Rprofile: PKG_CONFIG_PATH=", Sys.getenv("PKG_CONFIG_PATH"),
          "; configure.vars set for systemfonts")
})
