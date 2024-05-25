%Schema de Lax-Friedrichs

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------

function H = LaxFriedrichs(U, V, W, dt_sur_h, flux)

% Code a ajouter.
fU = flux(U, 0);
fV = flux(V, 0);
fW = flux(W, 0);
H = 0.5 .* (U+W) - dt_sur_h.*0.5 .*(fW-fU);
endfunction

