pro make_reg_file_chu3

  obsid=['20211001001','20211002001']
  midt=['21-Mar-17 13:51:55','21-Mar-17 15:28:36']
  ;; do it for the second orbit - a slight F1 in orbit 1
  id=1

  ;; write out where original disk centre was
  convert_sunxy_to_radec,0.,0.,ra0,dec0,time=midt[id]

  write_ds9_reg,ra0,dec0,30,'dc0_'+obsid[id]+'.reg',dash=1,color='white'

  ; shift for CHU 3 map
  sh_axy=[-15,55]
  sh_bxy=[-15,60]

  ;; so disk centre in orginal NuSTAR pointing is
  dca=-1.0*sh_axy
  dcb=-1.0*sh_bxy

  ;; just for FPMB as can avoid birght pixels
  ;    convert_sunxy_to_radec,dca[0],dca[1],raa,deca,time=midt[id]
  convert_sunxy_to_radec,dcb[0],dcb[1],rab,decb,time=midt[id]


  racbs=replicate(rab,4)
  decbs=replicate(decb,4)
  rad=60.
  ncc=n_elements(racbs)

  write_ds9_reg,racbs,decbs,rad+indgen(4)*rad,'CCB_'+obsid[id]+'.reg',dash=0,color='white'
  for i=0, ncc-1 do begin
    sname=string(1000+i,format='(i4)')
    write_ds9_reg,racbs[i],decbs[i],rad+i*rad,'CCB_'+obsid[id]+'_'+sname+'.reg',dash=0,color='white'
  endfor


  ; do a grid of 60" regions
  dia=2*rad
  gridx=[-1*dia,0,dia,-1*dia,0,dia,-1*dia,0,dia]
  gridy=[dia*[-1,-1,-1],0,0,0,dia*[1,1,1]]
  ng=n_elements(gridx)
  gridra=fltarr(ng)
  griddec=fltarr(ng)
  for i=0,ng-1 do begin
    convert_sunxy_to_radec,gridx[i]+dcb[0],gridy[i]+dcb[1],rat,dect,time=midt[id]
    gridra[i]=rat
    griddec[i]=dect
  endfor

  write_ds9_reg,gridra,griddec,replicate(rad,ng),'GDB_'+obsid[id]+'.reg',dash=0,color='white'
  
  for i=0, ng-1 do begin
    sname=string(1000+i,format='(i4)')
    write_ds9_reg,gridra[i],griddec[i],rad,'GDB_'+obsid[id]+'_'+sname+'.reg',dash=0,color='white'
  endfor





  stop
end