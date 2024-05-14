%Schema de Lax-Friedrichs

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------

function H = LaxFriedrichs(U, V, W, dt_sur_h, flux)

% Code a ajouter.
Gab1 = Gab(V,W,dt_sur_h,flux);
Gab2 = Gab(U,V,dt_sur_h,flux);
H = V-dt_sur_h.*(Gab1-Gab2);
endfunction

