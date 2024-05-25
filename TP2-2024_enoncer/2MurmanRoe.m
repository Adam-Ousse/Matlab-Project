%Schema de Murman Roe

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------

function H = MurmanRoe(U, V, W, dt_sur_h, flux)
fU = flux(U, 0);
fV = flux(V, 0);
fW = flux(W, 0);
% Code a ajouter.
f1U = flux(U,1);
suv=sign(U-V);
fuvs=sign(fU-fV);
fuvs1=sign(f1U);
cuv = U==V;
auv =  fuvs .* suv .*(1-cuv) +fuvs1 .* cuv;


guv=fU .*(auv>=0 ) + fV.*(auv <0) ;

f1V = flux(V,1);
svw=sign(V-W);
fvws=sign(fV-fW);
fvws1=sign(f1V);
cvw = V==W;
avw =  fvws .* svw .*(1-cvw) +fvws1 .* cvw;


gvw=fV  .*(avw>=0) + fW.*(avw <0) ;
H =V - dt_sur_h*(gvw-guv);
