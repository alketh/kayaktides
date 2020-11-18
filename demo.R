# Let's have a look at the available tide packages and infos on CRAN

# 1. https://github.com/jkennel/earthtide
# Based on Fortran ETERNA 3.4' algorithm. Code was rewritten in R. Uses Rcpp.
# Able to calculate tides based on any location. Great additional informations:

# Hartmann, T., Wenzel, H.-G., 1995. The HW95 tidal potential catalogue. Geophys.
# Res. Lett. 22, 3553–3556. (https://doi.org/10.1029/95GL03324)

# Kudryavtsev, S.M., 2004. Improved harmonic development of the Earth tide-generating
# potential. J. Geod. 77, 829–838. (https://doi.org/10.1007/s00190-003-0361-2)

# Wenzel, H.G. 1996: The nanogal software: Earth tide data processing package
# ETERNA 3.30. Bull. Inf. Marges Terrestres. 124, 9425-9439.
# (http://www.eas.slu.edu/GGP/ETERNA34/MANUAL/ETERNA33.HTM)

# The syntax is a bit obscure...

# 2. https://github.com/poissonconsulting/rtide
# Supports 637 US stations. Very nice shiny app:
# https://poissonconsulting.shinyapps.io/rtide/

library(earthtide)

et <- Earthtide$new(
  utc = as.POSIXct("2017-01-01", tz = "UTC") + 0:(24 * 7) * 3600,
  latitude = 52.3868,
  longitude = 9.7144,
  catalog = "ksm04",
  wave_groups = data.frame(start = 0.0, end = 6.0))

et$predict(method = "gravity", astro_update = 1)
et$analyze(method = "gravity", astro_update = 1)
et$lod_tide()
et$pole_tide()
et$tide()
et$print()

tide <-  Earthtide$
  new(utc = as.POSIXct("2015-01-01", tz = "UTC") + 0:(24*31) * 3600,
      latitude = 52.3868,
      longitude = 9.7144,
      wave_groups = data.frame(start = 0.0, end = 6.0))$
  predict(method = "gravity", astro_update = 1)$    # compute gravity
  lod_tide()$                                       # LOD tide column
  pole_tide()$                                      # pole tide column
  tide()                                            # return result

# Classic, non R6 interface
tms <- as.POSIXct("2015-01-01", tz = "UTC") + 0:(24*31) * 3600
grav_std <- calc_earthtide(utc = tms,
                           do_predict = TRUE,
                           method = 'gravity',
                           latitude = 52.3868,
                           longitude = 9.7144)

# Spiekeroog
tms <- as.POSIXct("2020-11-18", tz = "UTC") + 0:(24*31) * 3600
grav_std <- calc_earthtide(utc = tms,
                           do_predict = TRUE,
                           method = c('tidal_potential', 'lod_tide', 'pole_tide'),
                           latitude = 53.7492,
                           longitude = 7.6819)

# Unfortunately there is no HW/LW calculation.

# World Tides seem to be e great choice for a non budget option (including API)
