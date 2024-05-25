%Schema decentre

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------

function H = Decentre(U, V, W, dt_sur_h, flux)


%a coder

%aide :
% calcul de f(u), f(v) et f(w)
fU = flux(U, 0);
fV = flux(V, 0);
fW = flux(W, 0);
s = sign(flux(V,1));
H =   (V -dt_sur_h*(fV-fU))*s + (1-s)*(V -dt_sur_h*(fW-fV));
endfunction

%%%%%%%%%%%%%%%%
