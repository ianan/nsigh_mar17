pro tlc_igh,test=test

  ; 21-Nov-12 IGH;
  ; 28-Apr-17 IGH      - based from tube_line_colors.pro
  ; linecolors based on tfl tubes lines (and dlt, over etc)
  ;http://www.tfl.gov.uk/assets/downloads/corporate/tfl-colour-standard-issue03.pdf
  ; /test shows the line colors
  ;
  ; Then some more useful colors tables:
  ; 1-12    tubeline colors
  ; 13-16   fainter byrg
  ; 17-20   stornger byrg
  ; 21-23   just bgr


  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  loadct,0,/silent
  tvlct,rrr,ggg,bbb,/get
  tcs=[$

    ; tubelines 1-12
    [  0,  0,  0],$ ;Northern
    [227, 32, 23],$ ;Central
    [  0, 34,136],$ ;Piccadilly
    [  0,120, 42],$ ;District
    [232,106, 16],$ ;Overground
    [  0,160,226],$ ;Victoria
    [215,153,175],$ ;Hammersmith & City
    [118,208,189],$ ;Waterloo & City
    [117, 16, 86],$ ;Metropolitan
    [255,206,  0],$ ;Circle
    [134,143,152],$ ;Jubilee
    [137, 78, 36],$ ;Bakerloo
    ;  [  0,175,173],$ ;DLR not included as similar to Waterloo & City
    [  0,189, 25], $ ;Tramlink
    ; some other primary ones

    ; some fainter byrg 13-16
    [  88,149, 201],[  246,203,100] ,[238,74,88] ,[128,193,121],$
    ; some stonger byrg 17-20
    [ 0,132,209],[  255,211,32] ,[197,0,11] ,[0,128,0],$
    ; just primary bgr 21-23
    [ 0,0,255],[  255,0,0] ,[0,255,0]$

    ]
 


  ; via https://personal.sron.nl/~pault/
  rn=[0,238,51,153,17,238,102,204,255,119,0];[0,0,34,204,238,170,68,102,187];[51, 136, 68, 17, 153, 221, 204, 136, 170]
  gn=[0,119,108,34,170,51,170,204,238,119,0];[0,0,136,187,102,51,119,204,187];[34, 204, 170, 119, 153, 204, 102, 34, 68]
  bn= [0,34,170,136,153,51,85,85,51,119,0];[0,0,51,68,119,119,170,238,187];[136, 238, 153, 51, 51, 119, 119, 85, 153]
  nct=n_elements(tcs[0,*])
  nctn=n_elements(rn)
  tcols=intarr(3,nct+nctn)
  tcols[*,0:nct-1]=tcs
  
  tcols[0,nct:nct+nctn-1]=rn
  tcols[1,nct:nct+nctn-1]=gn
  tcols[2,nct:nct+nctn-1]=bn


  for i=0, n_elements(tcols[0,*])-1 do begin
    rrr[i]=tcols[0,i]
    ggg[i]=tcols[1,i]
    bbb[i]=tcols[2,i]
  endfor


  tvlct,rrr,ggg,bbb

  if keyword_set(test) then begin
    clearplot
    !p.multi=0
    !y.style=17
    plot,[0,1],[0,n_elements(tcols[0,*])],/nodata,xtickf='(a1)',chars=2
    for i=0, n_elements(tcols[0,*])-1 do oplot, [0,1],i*[1,1],color=i,thick=10
  endif

  return
end
