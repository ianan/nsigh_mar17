pro make_nsgen_map_cor,dir=dir,obsid=obsid,tbin=tbin,fextra=fextra,eps=eps,$
  smooth=smooth,mapa=mapa,mapb=mapb,rebin=rebin,dmn=dmn,dmx=dmx,$
  sh_axy=sh_axy,sh_bxy=sh_bxy,xr=xr,yr=yr

  ; Plot a map for a specified NuSTAR obsid - assumes the obsid directory structure is the default one from heasarc
  ;
  ; dir      directory where the obsid sub-dir is
  ; obsid    nustar obsid of the observation
  ; tbin     time binning for lightcurve in seconds (def whole range)
  ; fextra   extra things in the file name, ie cl_sunpos or _chu12_N_cl (def _cl_sunpos.evt)
  ; eps      output eps file of plot? (def no) - puts it in figs subdir
  ; smooth   apply gaussian smoothing to the data (def no)
  ; rebin    rebin map to larger pixels (def no)
  ;
  ; mapa     return map for FPMA
  ; mapb     return map for FPMB
  ;
  ;
  ; NOTE assumes the input is an already sunpos corrected NuSTAR evt file
  ; NOTE that the livetime hk files are assumed to need a -1s correction
  ; NOTE that the eps output goes into cwd/figs - if it doesn't exist code will crash
  ;
  ; 18-May-2017  IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(dir) ne 1) then dir='~/data/heasarc_nustar/ns_20170321/'
  if (n_elements(obsid) ne 1) then obsid='20211004001'
  if (n_elements(tbin) ne 1) then tbin=0
  if (n_elements(fextra) ne 1) then fextra='_chu12_S_cl_sunpos'
  if (n_elements(eps) ne 1) then eps=1
  if (n_elements(smooth) ne 1) then smooth=0
  if (n_elements(rebin) ne 1) then rebin=1

  ; Number of pixels when rebinned - original is 501
  rb_npix=128

  dmn=10d^(-3.5)
  dmx=10d^(-1.5)

  ;  ; how much to shift each map by
  ;  shf_id=strmid(obsid,7,1)-1
  ;  ; for CHU3
  ;  ;  axs=[-15,-15,-15,-15]
  ;  ;  ays=[55,55,55,55]
  ;  ;  bxs=[-15,-15,-15,-15]
  ;  ;  bys=[60,60,60,60]
  ;
  ;  ; for CHU12
  ;  axs=[-40,-40,-40,-40]
  ;  ays=[0,0,0,0]
  ;  bxs=[-45,-45,-45,-45]
  ;  bys=[5,5,5,5]
  ;
  ;  axy=[axs[shf_id],ays[shf_id]]
  ;  bxy=[bxs[shf_id],bys[shf_id]]

  if (n_elements(sh_axy) eq 2) then axy=sh_axy else axy=[0,0]
  if (n_elements(sh_bxy) eq 2) then bxy=sh_bxy else bxy=[0,0]

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load in the evt files
  evta = mrdfits(dir+obsid+'/event_cl/nu'+obsid+'A06'+fextra+'.evt', 1,evtah,/silent)
  evtb = mrdfits(dir+obsid+'/event_cl/nu'+obsid+'B06'+fextra+'.evt', 1,evtbh,/silent)

  ; work out the time range and binning
  ; default nustar times from 01-Jan-2010 unlike anytim/ssw
  evta_tims=anytim(evta.time+anytim('01-Jan-2010'))
  evtb_tims=anytim(evtb.time+anytim('01-Jan-2010'))

  t1=anytim(min(evta_tims),/yoh,/trunc)
  t2=anytim(max(evta_tims),/yoh,/trunc)
  midt=anytim((anytim(t1)+anytim(t2))/2.,/yoh,/trunc)
  print,midt

  if (tbin eq 0) then begin
    tbin=anytim(t2)-anytim(t1)
    num_ntims=1
    ntims=[t1,t2]
  endif else begin
    num_ntims=ceil((max(evta_tims)-min(evta_tims))/(tbin*1.))
    ntims=strarr(2,num_ntims)
    ntims[0,*]=anytim(anytim(t1)+findgen(num_ntims)*tbin,/yoh,/trunc)
    ntims[1,*]=anytim(anytim(t1)+(1+findgen(num_ntims))*tbin,/yoh,/trunc)
    ntims[1,num_ntims-1]=t2
  endelse

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Get the livetimes
  ; needs the -1s as not correct on heasarc yet??
  hka = mrdfits(dir+obsid+'/hk/nu'+obsid+'A_fpm.hk', 1, hkahdr)
  htimea=anytim(hka.time+anytim('01-Jan-2010')-1.0)
  hlivea=hka.livetime
  hkb = mrdfits(dir+obsid+'/hk/nu'+obsid+'B_fpm.hk', 1, hkahdr)
  htimeb=anytim(hka.time+anytim('01-Jan-2010')-1.0)
  hliveb=hkb.livetime

  ; just use the time binning the evt counts were done in above
  livea=fltarr(num_ntims)
  liveb=fltarr(num_ntims)

  for tt=0,num_ntims-1 do begin
    this_tima=where(htimea ge anytim(ntims[0,tt]) and htimea lt anytim(ntims[1,tt]))
    livea[tt]=mean(hlivea[this_tima])

    this_timb=where(htimeb ge anytim(ntims[0,tt]) and htimeb lt anytim(ntims[1,tt]))
    liveb[tt]=mean(hliveb[this_timb])
  endfor

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Setup the pixel and binning sizes
  ; Get the same values if using evtah or evtbh
  ttype = where(stregex(evtah, "TTYPE", /boolean))
  xt = where(stregex(evtah[ttype], 'X', /boolean))
  xpos = (strsplit( (strsplit(evtah[ttype[max(xt)]], ' ', /extract))[0], 'E', /extract))[1]
  npix = sxpar(evtah, 'TLMAX'+xpos)
  pix_size = abs(sxpar(evtah,'TCDLT'+xpos))

  xc=0
  yc=0

  centerx = round(xc / pix_size) + npix * 0.5
  centery = round(yc / pix_size) + npix * 0.5
  im_size = 1400. / pix_size
  im_width = round(im_size * 2.)

  ; Loop over each time interval
  counter=10000
  for tt=0,num_ntims-1 do begin

    id_temp=where(evta_tims ge anytim(ntims[0,tt]) and evta_tims lt anytim(ntims[1,tt]))

    pixinds = evta[id_temp].x + evta[id_temp].y * npix
    im_hist = histogram(pixinds, min = 0, max = npix*npix-1, binsize = 1)
    im = reform(im_hist, npix, npix)
    ims= im[(centerx-im_width):(centerx+im_width-1), (centery-im_width):(centery+im_width-1)]
    npp=n_elements(ims[0,*])

    ; Just want the zoomed in region
    id0=median(where(total(ims,1) gt 0))
    id1=median(where(total(ims,2) gt 0))

    subx=[-250,250]+id1
    if (subx[0] lt 0) then subx=[0,500]
    if (subx[1] gt npp-1) then subx=[npp-1-500,npp-1]
    suby=[-250,250]+id0
    if (suby[0] lt 0) then suby=[0,500]
    if (suby[1] gt npp-1) then suby=[npp-1-500,npp-1]
    zims=ims[subx[0]:subx[1],suby[0]:suby[1]]

    pxs=pix_size
    x0=xc-npp*0.5*pxs+pxs*subx[0]
    y0=yc-npp*0.5*pxs+pxs*suby[0]

    newxc=x0+0.5*n_elements(zims[*,0])*pxs
    newyc=y0+0.5*n_elements(zims[0,*])*pxs

    ang = pb0r(t1,/arcsec,l0=l0)

    if keyword_set(smooth) then zims=gauss_smooth(zims*1.0,2)

    mapa=make_map(zims/(tbin*livea[tt]),dx=pxs,dy=pxs,xc=newxc,yc=newyc,$
      time=ntims[0,tt],dur=tbin,id='FPMA '+ntims[0,tt]+' to '+$
      anytim(ntims[1,tt],/yoh,/trunc,/time)+' ('+string(livea[tt]*100,format='(f5.2)')+'%)',$
      xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])

    if keyword_set(rebin) then mapa=rebin_map(mapa,rb_npix,rb_npix)

    ; repeat for FPMB
    id_temp=where(evtb_tims ge anytim(ntims[0,tt]) and evtb_tims lt anytim(ntims[1,tt]))

    pixinds = evtb[id_temp].x + evtb[id_temp].y * npix
    im_hist = histogram(pixinds, min = 0, max = npix*npix-1, binsize = 1)
    im = reform(im_hist, npix, npix)
    ims= im[(centerx-im_width):(centerx+im_width-1), (centery-im_width):(centery+im_width-1)]
    npp=n_elements(ims[0,*])

    ; Just want the zoomed in region
    id0=median(where(total(ims,1) gt 0))
    id1=median(where(total(ims,2) gt 0))

    subx=[-250,250]+id1
    if (subx[0] lt 0) then subx=[0,500]
    if (subx[1] gt npp-1) then subx=[npp-1-500,npp-1]
    suby=[-250,250]+id0
    if (suby[0] lt 0) then suby=[0,500]
    if (suby[1] gt npp-1) then suby=[npp-1-500,npp-1]
    zims=ims[subx[0]:subx[1],suby[0]:suby[1]]

    pxs=pix_size
    x0=xc-npp*0.5*pxs+pxs*subx[0]
    y0=yc-npp*0.5*pxs+pxs*suby[0]

    newxc=x0+0.5*n_elements(zims[*,0])*pxs
    newyc=y0+0.5*n_elements(zims[0,*])*pxs

    ang = pb0r(t1,/arcsec,l0=l0)

    if keyword_set(smooth) then zims=gauss_smooth(zims*1.0,2)

    mapb=make_map(zims/(tbin*liveb[tt]),dx=pxs,dy=pxs,xc=newxc,yc=newyc,$
      time=ntims[0,tt],dur=tbin,id='FPMB '+ntims[0,tt]+' to '+$
      anytim(ntims[1,tt],/yoh,/trunc,/time)+' ('+string(liveb[tt]*100,format='(f5.2)')+'%)',$
      xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])

    if keyword_set(rebin) then mapb=rebin_map(mapb,rb_npix,rb_npix)

    ; make a nice plot
    if keyword_set(eps) then begin
      clearplot
      if (!version.os_family eq 'Windows') then set_plot,'win' else set_plot,'x'
      device,retain=2, decomposed=0
      mydevice = !d.name
      !p.font=0
      !p.multi=[0,2,1]
      !y.style=17
      !x.style=17
      !p.charsize=2
      !p.thick=4


      if (n_elements(dmn) ne 1) then dmn=max([min(mapa.data[where(mapa.data gt 0.)]),min(mapb.data[where(mapb.data gt 0.)])]) >5e-4
      if (n_elements(dmx) ne 1) then dmx=max([mapa.data,mapb.data])
      plim=650
      if (n_elements(xr) ne 2) then xr=[-600,400];[-1,1]*plim
     if (n_elements(yr) ne 2) then  yr=[-500,500];[-1,1]*plim
      ;      yr=yr-100.

      loadct,74,/silent
      reverse_ct
      tvlct,r,g,b,/get
      r[0]=0
      g[0]=0
      b[0]=0
      r[1]=255
      g[1]=255
      b[1]=255
      r[255]=255
      g[255]=255
      b[255]=255
      tvlct,r,g,b
      fout='nsmap_'
      if keyword_set(smooth) then fout=fout+'S_'
      if keyword_set(rebin) then fout=fout+'R_'


      ; load in the AIA location of the ref regions
      restore,file='aia_dc_points.dat'
      ref_tim=midt
      xy1=rot_xy(x1s[0],y1s[0],tstart=tims[0],tend=ref_tim)
      xy2=rot_xy(x2s[0],y2s[0],tstart=tims[0],tend=ref_tim)
      xy3=rot_xy(x3s[0],y3s[0],tstart=tims[0],tend=ref_tim)


      set_plot,'ps'
      device, /encapsulated, /color, / isolatin1,/inches,bits=8, xsize=9, ysize=4.5,$
        file='figs/C'+fout+obsid+fextra+'.eps'

      plot_map,mapa,/log,dmin=dmn,dmax=dmx,$
        ;        position=[0.17,0.13,0.87,0.83],$
        title=mapa.id,xrange=xr,yrange=yr,$
        gcolor=0,bot=1,chars=0.8,xtitle='x [arcsec]',ytitle='y [arcsec]'

      oplot,xr,[0,0],lines=1
      oplot,[0,0],yr,lines=1

      ctp=0
      ;
      ;      plots,xy1[0],xy1[1],psym=6,syms=1.5,color=ctp
      ;      plots,xy2[0],xy2[1],psym=6,syms=1.5,color=ctp
      ;      plots,xy3[0],xy3[1],psym=6,syms=1.5,color=ctp

      plot_map,mapb,/log,dmin=dmn,dmax=dmx,$
        ;        position=[0.17,0.13,0.87,0.83],$
        title=mapb.id,xrange=xr,yrange=yr,$
        gcolor=0,bot=1,chars=0.8,xtitle='x [arcsec]',ytitle='y [arcsec]'

      oplot,xr,[0,0],lines=1
      oplot,[0,0],yr,lines=1

      ;      plots,xy1[0],xy1[1],psym=6,syms=1.5,color=ctp
      ;      plots,xy2[0],xy2[1],psym=6,syms=1.5,color=ctp
      ;      plots,xy3[0],xy3[1],psym=6,syms=1.5,color=ctp

      plot_map_cb_igh,alog10([dmn,dmx]),position=[0.35,0.065,0.65,0.08],color=0,chars=0.8,$
        cb_title='NuSTAR [log!D10!N count s!U-1!N]',bottom=1,format='(f4.1)',major=3

      xyouts,100,100,obsid+','+fextra,/device,chars=0.8

      device,/close
      set_plot, mydevice

      ;~~~~~~~~~~~~~~~~~~~~~~~
      ; plot with shifted map


      set_plot,'ps'
      device, /encapsulated, /color, / isolatin1,/inches,bits=8, xsize=9, ysize=4.5,$
        file='figs/CSH'+fout+obsid+fextra+'.eps'

      plot_map,shift_map(mapa,axy[0],axy[1]),/log,dmin=dmn,dmax=dmx,$
        ;        position=[0.17,0.13,0.87,0.83],$
        title=mapa.id,xrange=xr,yrange=yr,$
        gcolor=0,bot=1,chars=0.8,xtitle='x [arcsec]',ytitle='y [arcsec]'

      oplot,xr,[0,0],lines=1
      oplot,[0,0],yr,lines=1

      plots,xy1[0],xy1[1],psym=6,syms=1.5,color=ctp
      plots,xy2[0],xy2[1],psym=6,syms=1.5,color=ctp
      plots,xy3[0],xy3[1],psym=6,syms=1.5,color=ctp

      xyouts,xr[0]+50,yr[0]+50,'('+string(axy[0],format='(i3)')+','+string(axy[1],format='(i3)')+')',/data,chars=0.8


      plot_map,shift_map(mapb,bxy[0],bxy[1]),/log,dmin=dmn,dmax=dmx,$
        ;        position=[0.17,0.13,0.87,0.83],$
        title=mapb.id,xrange=xr,yrange=yr,$
        gcolor=0,bot=1,chars=0.8,xtitle='x [arcsec]',ytitle='y [arcsec]'

      oplot,xr,[0,0],lines=1
      oplot,[0,0],yr,lines=1

      plots,xy1[0],xy1[1],psym=6,syms=1.5,color=ctp
      plots,xy2[0],xy2[1],psym=6,syms=1.5,color=ctp
      plots,xy3[0],xy3[1],psym=6,syms=1.5,color=ctp

      plot_map_cb_igh,alog10([dmn,dmx]),position=[0.35,0.065,0.65,0.08],color=0,chars=0.8,$
        cb_title='NuSTAR [log!D10!N count s!U-1!N]',bottom=1,format='(f4.1)',major=3

      xyouts,xr[0]+50,yr[0]+50,'('+string(bxy[0],format='(i3)')+','+string(bxy[1],format='(i3)')+')',/data,chars=0.8

      xyouts,100,100,obsid+','+fextra,/device,chars=0.8

      device,/close
      set_plot, mydevice


    endif


  endfor

end