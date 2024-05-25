%Schema de Murman Roe

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------



% Code a ajouter.
function H = MurmanRoe(U, V, W, dt_sur_h, flux)
fU=flux(U,0);
fV=flux(V,0);
fW=flux(W,0);
fpV=flux(V,1);
% Code a ajouter.
%programation de a*
aUV=sign(fU-fV).*sign(U-V).*(U!=V)+sign(fpV).*(U==V);
aVW=sign(fV-fW).*sign(V-W).*(V!=W)+sign(fpV).*(V==W);
%le reste
gUV=fU.*(aUV>=0)+fV.*(aUV<0);
gVW=fV.*(aVW>=0)+fW.*(aVW<0);
H=V-dt_sur_h*(gVW-gUV);

endfunction
