# Make the libraries shipped with Renku's conda-installed R (fontconfig, freetype,
# libpng, libxml2, ...) visible to pkg-config, so that renv::restore() can compile
# packages such as systemfonts and svglite from source during the image build.
local({
  prefix <- "/layers/renku_r-conda/r"
  pc_dir <- file.path(prefix, "lib", "pkgconfig")
  if (dir.exists(pc_dir)) {
    old <- Sys.getenv("PKG_CONFIG_PATH")
    Sys.setenv(PKG_CONFIG_PATH = if (nzchar(old)) paste(pc_dir, old, sep = ":") else pc_dir)
    message(".Rprofile: PKG_CONFIG_PATH set to ", Sys.getenv("PKG_CONFIG_PATH"))
  }
})
