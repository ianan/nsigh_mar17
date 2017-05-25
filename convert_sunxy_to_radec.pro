pro convert_sunxy_to_radec,x,y,ra,dec,time=time

  ; For a given solar x,y in arcsec at some time, return the RA and DEC sky position
  ; At the moemtn use empheris saved from jpl so only works for limit time ranges
  ;
  ;
  ; 19-May-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  np=n_elements(x)

  if (n_elements(time) eq 0) then time='21-Mar-2017 13:52'
  if (n_elements(x) ne n_elements(y)) then print,'X and y need to be same size!'

  atim=anytim(time)

  ephem_file='20170321_ephem.txt
  ephem = nustar_read_ephem(ephem_file)

  sun_ra = ephem.raj2000
  sun_dec = ephem.decj2000
  sun_pa = ephem.np_ang

  nustar_time = anytim(ephem.time)

  ; Interpolate onto the event times:
  ra0 = interpol(sun_ra, nustar_time, atim)
  dec0 = interpol(sun_dec, nustar_time, atim)
  p0 = interpol(sun_pa, nustar_time, atim)
  
  ; instead get from get_sun().pro
  ; not as accurate??
  ; ggs=get_sun(time0) ; ggs=get_sun(time0,/list)
  ; ra_g=ggs[6]*24.
  ; dec_g=ggs[7]

  dec0d=dec0*!dtor
  p0d=p0*!dtor

  ; CCW rotation to go from heliocentric to celestial:
  delx = x*cos(p0d) + y*sin(p0d)
  dely = -x*sin(p0d) + y*cos(p0d)

  ; convert to degrees
  delx /= 3600
  dely /= 3600

  ra = ra0 + delx / cos(dec0d)
  dec= dec0 + dely


end