pro load_phas

  dir='~/data/heasarc_nustar/ns_20170321/20211002001/event_cl/'
  phaf='nu20211002001B06_chu3_S_sr.pha'
  rmff='nu20211002001B06_chu3_S_sr.rmf'
  arff='nu20211002001B06_chu3_S_sr.arf'

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sdir='spec_CCB1000'
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the pha
  pha=mrdfits(dir+sdir+'/'+phaf,1,phah)
  spec1000=pha.counts
  esepc1000=sqrt(pha.counts)

  ; extract the extra info from the pha file
  ; livetime
  livetime1000=sxpar(phah,'LIVETIME')
  dur1000=sxpar(phah,'ONTIME')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the rmf and arf
  rmfread, dir+sdir+'/'+rmff, rmf_str, compressed='UNCOMPRESSED'
  rmf1000 = transpose(*(rmf_str.data))
  drmf1000=diag_matrix(rmf1000)
  edges = *(rmf_str.ebins)
  emid=get_edges(edges,/mean)
  fxbopen, unit, dir+sdir+'/'+arff, 'SPECRESP', ah, errmsg=err
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, arf1000, errmsg=err
  fxbclose, unit
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sdir='spec_CCB1001'
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the pha
  pha=mrdfits(dir+sdir+'/'+phaf,1,phah)
  spec1001=pha.counts
  esepc1001=sqrt(pha.counts)

  ; extract the extra info from the pha file
  ; livetime
  livetime1001=sxpar(phah,'LIVETIME')
  dur1001=sxpar(phah,'ONTIME')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the rmf and arf
  rmfread, dir+sdir+'/'+rmff, rmf_str, compressed='UNCOMPRESSED'
  rmf1001 = transpose(*(rmf_str.data))
  drmf1001=diag_matrix(rmf1001)
  edges = *(rmf_str.ebins)
  emid=get_edges(edges,/mean)
  fxbopen, unit, dir+sdir+'/'+arff, 'SPECRESP', ah, errmsg=err
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, arf1001, errmsg=err
  fxbclose, unit
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sdir='spec_CCB1002'
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the pha
  pha=mrdfits(dir+sdir+'/'+phaf,1,phah)
  spec1002=pha.counts
  esepc1002=sqrt(pha.counts)

  ; extract the extra info from the pha file
  ; livetime
  livetime1002=sxpar(phah,'LIVETIME')
  dur1002=sxpar(phah,'ONTIME')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the rmf and arf
  rmfread, dir+sdir+'/'+rmff, rmf_str, compressed='UNCOMPRESSED'
  rmf1002 = transpose(*(rmf_str.data))
  drmf1002=diag_matrix(rmf1002)
  edges = *(rmf_str.ebins)
  emid=get_edges(edges,/mean)
  fxbopen, unit, dir+sdir+'/'+arff, 'SPECRESP', ah, errmsg=err
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, arf1002, errmsg=err
  fxbclose, unit
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sdir='spec_CCB1003'
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the pha
  pha=mrdfits(dir+sdir+'/'+phaf,1,phah)
  spec1003=pha.counts
  esepc1003=sqrt(pha.counts)

  ; extract the extra info from the pha file
  ; livetime
  livetime1003=sxpar(phah,'LIVETIME')
  dur1003=sxpar(phah,'ONTIME')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; load the rmf and arf
  rmfread, dir+sdir+'/'+rmff, rmf_str, compressed='UNCOMPRESSED'
  rmf1003 = transpose(*(rmf_str.data))
  drmf1003=diag_matrix(rmf1003)
  edges = *(rmf_str.ebins)
  emid=get_edges(edges,/mean)
  fxbopen, unit, dir+sdir+'/'+arff, 'SPECRESP', ah, errmsg=err
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, arf1003, errmsg=err
  fxbclose, unit
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  clearplot
  if (!version.os_family eq 'Windows') then set_plot,'win' else set_plot,'x'
  device,retain=2, decomposed=0
  mydevice = !d.name
  !p.font=0
  tlc_igh
  !p.thick=2
  !p.charsize=2
  !y.style=17
  !x.style=17
  !p.multi=[0,3,1]

  set_plot,'ps'
  device, /encapsulated, /color, / isolatin1,/inches,bits=8, xsize=9, ysize=3,$
    file='figs/specovr_CCB.eps'

  plot,emid,spec1000,xrange=[1,10],yrange=[0.5,1e4],psym=10,/ylog,/nodata,ytit='Counts',xtitle='Energy [keV]',ytickf='exp1'
  oplot,emid,spec1000,psym=10,color=25
  oplot,emid,spec1001,psym=10,color=26
  oplot,emid,spec1002,psym=10,color=27
  oplot,emid,spec1003,psym=10,color=28
  xyouts,9,10d^3.5,'60"',color=25,align=1,/data,chars=1
  xyouts,9,10d^3.1,'120"',color=26,align=1,/data,chars=1
  xyouts,9,10d^2.7,'180"',color=27,align=1,/data,chars=1
  xyouts,9,10d^2.3,'240"',color=28,align=1,/data,chars=1

  plot,emid,arf1000,xrange=[1,10],yrange=[0,400],psym=10,/nodata,ytit='ARF cm!U2!N',xtitle='Energy [keV]'
  oplot,emid,arf1000,psym=10,color=25
  oplot,emid,arf1001,psym=10,color=26
  oplot,emid,arf1002,psym=10,color=27
  oplot,emid,arf1003,psym=10,color=28

  plot,emid,drmf1000,xrange=[1,10],yrange=[0.08,0.09],psym=10,/nodata,ytit='diag(RMF)',xtitle='Energy [keV]'
  oplot,emid,drmf1000,psym=10,color=25
  oplot,emid,drmf1001,psym=10,color=26
  oplot,emid,drmf1002,psym=10,color=27
  oplot,emid,drmf1003,psym=10,color=28

  device,/close
  set_plot, mydevice

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  de=edges[1,0]-edges[0,0]
  lvt=livetime1000
  ph1000=spec1000/drmf1000/arf1000
  ph1001=spec1001/drmf1001/arf1001
  ph1002=spec1002/drmf1002/arf1002
  ph1003=spec1003/drmf1003/arf1003

  !p.multi=0
  !p.charsize=1

  set_plot,'ps'
  device, /encapsulated, /color, / isolatin1,/inches,bits=8, xsize=5, ysize=4,$
    file='figs/specovr_CCB_ph.eps'

  plot,emid,ph1000/lvt/de,xrange=[1,10],yrange=[1e-3,1e4],psym=10,/ylog,/nodata,$
    ytit='ph cm!U-2!N keV!U-1!N s!U-1!N',xtitle='Energy [keV]',ytickf='exp1'
  oplot,emid,ph1000/lvt/de,psym=10,color=25
  oplot,emid,ph1001/lvt/de,psym=10,color=26
  oplot,emid,ph1002/lvt/de,psym=10,color=27
  oplot,emid,ph1003/lvt/de,psym=10,color=28
  xyouts,9,10d^3.5,'60"',color=25,align=1,/data,chars=1
  xyouts,9,10d^3.1,'120"',color=26,align=1,/data,chars=1
  xyouts,9,10d^2.7,'180"',color=27,align=1,/data,chars=1
  xyouts,9,10d^2.3,'240"',color=28,align=1,/data,chars=1

  device,/close
  set_plot, mydevice

  id2=where(edges[0,*] ge 2.5 and edges[1,*] lt 5.5)
  id1=where(edges[0,*] ge 3.0 and edges[1,*] lt 5.0)

  t1cnt=fltarr(4)
  t1ecnt=fltarr(4)
  t1ph=fltarr(4)
  t1eph=fltarr(4)

  t1cnt[0]=total(spec1000[id1])
  t1ecnt[0]=sqrt(t1cnt[0])
  t1ph[0]=total(ph1000[id1])
  ; just use the ratio of the error?
  t1eph[0]=t1ecnt[0]*t1ph[0]/t1cnt[0]

  t1cnt[1]=total(spec1001[id1])
  t1ecnt[1]=sqrt(t1cnt[1])
  t1ph[1]=total(ph1001[id1])
  ; just use the ratio of the error?
  t1eph[1]=t1ecnt[1]*t1ph[1]/t1cnt[1]

  t1cnt[2]=total(spec1002[id1])
  t1ecnt[2]=sqrt(t1cnt[2])
  t1ph[2]=total(ph1002[id1])
  ; just use the ratio of the error?
  t1eph[2]=t1ecnt[2]*t1ph[2]/t1cnt[2]

  t1cnt[3]=total(spec1003[id1])
  t1ecnt[3]=sqrt(t1cnt[3])
  t1ph[3]=total(ph1003[id1])
  ; just use the ratio of the error?
  t1eph[3]=t1ecnt[3]*t1ph[3]/t1cnt[3]

  print,t1cnt
  print,t1ecnt
  print,t1ph
  print,t1eph
  print,t1ph/lvt/de
  print,t1eph/lvt/de
  





  stop
end