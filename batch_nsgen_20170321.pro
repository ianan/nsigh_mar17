pro batch_nsgen_20170321

  ; make some figures for the disk centre pointed orbits of 21-Mar-2017
  ;
  ; 18-May-2017 IGH
  ;
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  make_nsgen_ltc,obsid='20211001001',/eps
  make_nsgen_ltc,obsid='20211002001',/eps
  make_nsgen_ltc,obsid='20211003001',/eps
  make_nsgen_ltc,obsid='20211004001',/eps

;  make_nsgen_ltc,obsid='20211001001',/eps,fextra='_chu3_N_cl'
;  make_nsgen_ltc,obsid='20211002001',/eps,fextra='_chu3_N_cl'
;  make_nsgen_ltc,obsid='20211003001',/eps,fextra='_chu3_N_cl'
;  make_nsgen_ltc,obsid='20211004001',/eps,fextra='_chu3_N_cl'
;
;  make_nsgen_ltc,obsid='20211001001',/eps,fextra='_chu12_N_cl'
;  make_nsgen_ltc,obsid='20211002001',/eps,fextra='_chu12_N_cl'
;  make_nsgen_ltc,obsid='20211003001',/eps,fextra='_chu12_N_cl'
;  make_nsgen_ltc,obsid='20211004001',/eps,fextra='_chu12_N_cl'

  make_nsgen_ltc,obsid='20211001001',/eps,fextra='_chu3_S_cl'
  make_nsgen_ltc,obsid='20211002001',/eps,fextra='_chu3_S_cl'
  make_nsgen_ltc,obsid='20211003001',/eps,fextra='_chu3_S_cl'
  make_nsgen_ltc,obsid='20211004001',/eps,fextra='_chu3_S_cl'

  make_nsgen_ltc,obsid='20211001001',/eps,fextra='_chu12_S_cl'
  make_nsgen_ltc,obsid='20211002001',/eps,fextra='_chu12_S_cl'
  make_nsgen_ltc,obsid='20211003001',/eps,fextra='_chu12_S_cl'
  make_nsgen_ltc,obsid='20211004001',/eps,fextra='_chu12_S_cl'

  make_nsgen_map,obsid='20211001001',/eps
  make_nsgen_map,obsid='20211002001',/eps
  make_nsgen_map,obsid='20211003001',/eps
  make_nsgen_map,obsid='20211004001',/eps

  make_nsgen_map,obsid='20211001001',/eps,/smooth
  make_nsgen_map,obsid='20211002001',/eps,/smooth
  make_nsgen_map,obsid='20211003001',/eps,/smooth
  make_nsgen_map,obsid='20211004001',/eps,/smooth

  make_nsgen_map,obsid='20211001001',/eps,/rebin
  make_nsgen_map,obsid='20211002001',/eps,/rebin
  make_nsgen_map,obsid='20211003001',/eps,/rebin
  make_nsgen_map,obsid='20211004001',/eps,/rebin

 ; remember needs to be _sunpos version for the map
  make_nsgen_map,obsid='20211001001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
  make_nsgen_map,obsid='20211002001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
  make_nsgen_map,obsid='20211003001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1
  make_nsgen_map,obsid='20211004001',/eps,/rebin,fextra='_chu3_S_cl_sunpos',dmn=10d^(-3.5),dmx=0.1


  stop
end