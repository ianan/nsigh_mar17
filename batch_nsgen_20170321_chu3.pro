pro batch_nsgen_20170321_chu3

;  make_nsgen_ltc,obsid='20211001001',/eps,fextra='_chu3_S_cl'
;  make_nsgen_ltc,obsid='20211002001',/eps,fextra='_chu3_S_cl'
;  make_nsgen_ltc,obsid='20211003001',/eps,fextra='_chu3_S_cl'
;  make_nsgen_ltc,obsid='20211004001',/eps,fextra='_chu3_S_cl'
;
; ; remember needs to be _sunpos version for the map
;  make_nsgen_map,obsid='20211001001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
;  make_nsgen_map,obsid='20211002001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
;  make_nsgen_map,obsid='20211003001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
;  make_nsgen_map,obsid='20211004001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
  
  make_nsgen_map_cor,obsid='20211001001',fextra='_chu12_S_cl_sunpos',sh_axy=[-40,0],sh_bxy=[-45,5]
  make_nsgen_map_cor,obsid='20211002001',fextra='_chu12_S_cl_sunpos',sh_axy=[-40,0],sh_bxy=[-45,5]
  make_nsgen_map_cor,obsid='20211003001',fextra='_chu12_S_cl_sunpos',sh_axy=[-40,0],sh_bxy=[-45,5]
  make_nsgen_map_cor,obsid='20211004001',fextra='_chu12_S_cl_sunpos',sh_axy=[-40,0],sh_bxy=[-45,5]
  
  make_nsgen_map_cor,obsid='20211001001',fextra='_chu3_S_cl_sunpos',sh_axy=[-15,55],sh_bxy=[-15,60]
  make_nsgen_map_cor,obsid='20211002001',fextra='_chu3_S_cl_sunpos',sh_axy=[-15,55],sh_bxy=[-15,60]
  make_nsgen_map_cor,obsid='20211003001',fextra='_chu3_S_cl_sunpos',sh_axy=[-15,55],sh_bxy=[-15,60]
  make_nsgen_map_cor,obsid='20211004001',fextra='_chu3_S_cl_sunpos',sh_axy=[-15,55],sh_bxy=[-15,60]

  stop
end