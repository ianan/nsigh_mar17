pro write_ds9_reg,ra,dec,rad,fname,dash=dash,color=color

  ; Write a  .reg file for ds9 for a circular region at ra,dec (degs) of radius rad (arcsec0
  ; with filename fname
  ;
  ;
  ; 19-May-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(ra) eq 0) then ra=0.82674799
  if (n_elements(dec) eq 0) then dec=0.35819800
  if (n_elements(rad) eq 0) then rad=60
  if (n_elements(fname) eq 0) then fname='circ_test0.reg'
  if (n_elements(dash) eq 0) then dash=1
  if (n_elements(volor) eq 0) then color='white'
  dashsh=string(dash,format='(i1)')

  np=n_elements(ra)
  radec,ra,dec,rahr,ramin,rasec,dchr,dcmin,dcsec

  rash=strarr(np)
  dcsh=strarr(np)
  radsh=strarr(np)

  for ii=0,np-1 do begin

    if (rasec[ii] ge 10.) then begin
      rash[ii]=string(rahr[ii],format='(i3)')+':'+string(ramin[ii],format='(i3)')+':'+string(rasec[ii],format='(f6.3)')
    endif else begin
      rash[ii]=string(rahr[ii],format='(i3)')+':'+string(ramin[ii],format='(i3)')+':0'+string(rasec[ii],format='(f6.3)')
    endelse

    if (dcsec[ii] ge 10.) then begin
      dcsh[ii]=string(dchr[ii],format='(i3)')+':'+string(dcmin[ii],format='(i3)')+':'+string(dcsec[ii],format='(f6.3)')
    endif else begin
      dcsh[ii]=string(dchr[ii],format='(i3)')+':'+string(dcmin[ii],format='(i3)')+':0'+string(dcsec[ii],format='(f6.3)')
    endelse

    rash[ii]=strcompress(rash[ii],/rem)
    dcsh[ii]=strcompress(dcsh[ii],/rem)

    radsh[ii]=string(rad[ii],format='(f7.2)')+'"'

  endfor

  openw, lun, /get_lun, fname
  printf, lun, '# Region file format: DS9 version 4.1'
  printf, lun, 'global color='+color+' dashlist=8 3 width=2 font="helvetica 10 normal roman" select=1 highlite=1 dash='+dashsh+' fixed=0 edit=1 move=1 delete=1 include=1 source=1'
  printf, lun, 'fk5'
  for ii=0,np-1 do printf, lun, 'circle('+rash[ii]+','+dcsh[ii]+','+radsh[ii]+')'
  close, lun
  free_lun, lun

end