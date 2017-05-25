pro make_nsgen_ltc,dir=dir,obsid=obsid,tbin=tbin,fextra=fextra,eps=eps

  ; Plot a summary lightcurve showing the counts, livetime, livetime correct counts and CHUs for
  ; a specified obsid - assumes the obsid directory structure is the default one from heasarc
  ;
  ; dir      directory where the obsid sub-dir is
  ; obsid    nustar obsid of the observation
  ; tbin     time binning for lightcurve in seconds (def 300s)
  ; fextra   extra things in the file name, ie cl_sunpos or _chu12_N_cl (def _cl.evt)
  ; eps      output eps file of plot? (def no) - puts it in figs subdir
  ;
  ;
  ; NOTE that the livetime hk files are assumed to need a -1s correction
  ; NOTE that the eps output goes into cwd/figs - if it doesn't exist code will crash
  ;
  ; 17-May-2017  IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(dir) ne 1) then dir='~/data/heasarc_nustar/ns_20170321/'
  if (n_elements(obsid) ne 1) then obsid='20211001001'
  if (n_elements(tbin) ne 1) then tbin=60
  if (n_elements(fextra) ne 1) then fextra='_cl';'_chu3_S_cl'
  if (n_elements(eps) ne 1) then eps=1

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load in the evt files
  evta = mrdfits(dir+obsid+'/event_cl/nu'+obsid+'A06'+fextra+'.evt', 1,evtah,/silent)
  evtb = mrdfits(dir+obsid+'/event_cl/nu'+obsid+'B06'+fextra+'.evt', 1,evtbh,/silent)

  deadca=(strsplit(evtah[where(stregex(evtah, "DEADC   =", /boolean))],' ',/extract))[2]
  deadcb=(strsplit(evtbh[where(stregex(evtbh, "DEADC   =", /boolean))],' ',/extract))[2]

  ; work out the time range and binning
  ; default nustar times from 01-Jan-2010 unlike anytim/ssw
  evta_tims=anytim(evta.time+anytim('01-Jan-2010'))
  evtb_tims=anytim(evtb.time+anytim('01-Jan-2010'))

  t1=anytim(min(evta_tims),/yoh,/trunc)
  t2=anytim(max(evta_tims),/yoh,/trunc)

  num_ntims=ceil((max(evta_tims)-min(evta_tims))/(tbin*1.))
  ntims=strarr(2,num_ntims)
  ntims[0,*]=anytim(anytim(t1)+findgen(num_ntims)*tbin,/yoh,/trunc)
  ntims[1,*]=anytim(anytim(t1)+(1+findgen(num_ntims))*tbin,/yoh,/trunc)
  ntims[1,num_ntims-1]=t2

  midt=anytim(get_edges(anytim(ntims),/mean),/yoh,/trunc)

  countsa=fltarr(num_ntims)
  countsb=fltarr(num_ntims)

  for tt=0,num_ntims-1 do begin
    this_tima=where(evta_tims ge anytim(ntims[0,tt]) and evta_tims lt anytim(ntims[1,tt]),nida)
    countsa[tt]=nida

    this_timb=where(evtb_tims ge anytim(ntims[0,tt]) and evtb_tims lt anytim(ntims[1,tt]),nidb)
    countsb[tt]=nidb
  endfor

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

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load in the CHU info
  for chunum= 1, 3 do begin
    chu = mrdfits(dir+obsid+'/hk/nu'+obsid+'_chu123.fits', chunum)
    maxres = 20 ;; [arcsec] maximum solution residual
    qind=1 ; From KKM code...
    if chunum eq 1 then begin
      chumask = (chu.valid EQ 1 AND $          ;; Valid solution from CHU
        chu.residual LT maxres AND $  ;; CHU solution has low residuals
        chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
        chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
    endif else begin
      chumask += (chu.valid EQ 1 AND $            ;; Valid solution from CHU
        chu.residual LT maxres AND $    ;; CHU solution has low residuals
        chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
        chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
    endelse
  endfor
  chutime=anytim(chu.time+anytim('01-Jan-2010'),/yoh)
  ; Set up the y labelling
  ;; mask = 1, chu1 only
  ;; mask = 4, chu2 only
  ;; mask = 9, chu3 only
  ;; mask = 5, chu12
  ;; mask = 10 chu13
  ;; mask = 13 chu23
  ;; mask = 14 chu123

  ; Change the KKM mask setup into something a bit easier to plot
  ; Make deafult value out of range of real values
  newmask=intarr(n_elements(chumask))-5
  id1=where(chumask eq 1,nid1)
  if (nid1 gt 0) then newmask[id1]=1
  id2=where(chumask eq 4,nid2)
  if (nid2 gt 0) then newmask[id2]=2
  id12=where(chumask eq 5,nid12)
  if (nid12 gt 0) then newmask[id12]=3
  id3=where(chumask eq 9,nid3)
  if (nid3 gt 0) then newmask[id3]=4
  id13=where(chumask eq 10,nid13)
  if (nid13 gt 0) then newmask[id13]=5
  id23=where(chumask eq 13,nid23)
  if (nid23 gt 0) then newmask[id23]=6
  id123=where(chumask eq 14,nid123)
  if (nid123 gt 0) then newmask[id123]=7


  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  clearplot
  if (!version.os_family eq 'Windows') then set_plot,'win' else set_plot,'x'
  device,retain=2, decomposed=0
  mydevice = !d.name
  !p.font=0
  !p.multi=[0,1,4]
  !y.style=17
  !x.style=17
  !p.charsize=2
  !p.thick=4

  loadct,39,/silent
  ; colour for FPMA and FPMB
  cta=220
  ctb=80

  if keyword_set(eps) then begin
    set_plot,'ps'
    device, /encapsulated, /color, / isolatin1,/inches, $
      bits=8, xsize=5, ysize=8,file='figs/nsltc_'+obsid+fextra+'_'+strmid(string(tbin+10000,format='(i5)'),1,4)+'.eps'
  endif


  utplot,midt,countsa,psym=10,tit=obsid,ytit='counts',/nodata,timer=[t1,t2],$
    yrange=[0.9*min([countsa,countsb]) >2500,1.1*max([countsa,countsb])],ytickf='(i5)',$
    xtickf='(a1)',xtit='',position=[0.16,0.75,0.97,0.95]
  outplot,midt,countsa,psym=10,color=cta
  outplot,midt,countsb,psym=10,color=ctb

  utplot,midt,livea,psym=10,ytit='livetime %',/nodata,timer=[t1,t2],$
    yrange=[(0.5*min([livea,liveb])*100 >1.0)<10,101],/ylog,$
    xtickf='(a1)',xtit='',position=[0.16,0.53,0.97,0.73]
  outplot,midt,livea*100,psym=10,color=cta
  outplot,midt,liveb*100,psym=10,color=ctb

  ratea=countsa/(livea*tbin)
  rateb=countsb/(liveb*tbin)

  utplot,midt,ratea,psym=10,ytit='count s!U-1!N',/nodata,timer=[t1,t2],$
    yrange=[0.9*min([ratea,rateb])>50,1.1*max([ratea,rateb])],$
    xtickf='(a1)',xtit='',position=[0.16,0.31,0.97,0.51]
  outplot,midt,ratea,psym=10,color=cta
  outplot,midt,rateb,psym=10,color=ctb


  ylab=[' ','1','2','12','3','13','23','123',' ']
  utplot,chutime,newmask,psym=4,yrange=[0,8],ytitle='CHUs',yticks=8,yminor=1,ytickname=ylab,$
    timer=[t1,t2],symsize=0.5,position=[0.16,0.09,0.97,0.29]

  if keyword_set(eps) then begin
    xyouts, 100,100,'FPMA',color=cta,/device,chars=1
    xyouts, 1.5e3,100,'FPMB',color=ctb,/device,chars=1
    device,/close
    set_plot, mydevice
  endif else begin
    xyouts, 10,10,'FPMA',color=cta,/device,chars=1
    xyouts, 40,10,'FPMB',color=ctb,/device,chars=1
  endelse

;  stop
end