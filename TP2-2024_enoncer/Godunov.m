%Schema de Godunov

%--------------------------------------------------------------------------
% U,V,W  : valeur pour lesquelles on veut calculer H
% dt_sur_h  : pas de temps divise par le pas d'espace
% flux   : flux a utiliser
%--------------------------------------------------------------------------

function H = Godunov(U, V, W, dt_sur_h, flux)



% Evaluation en x = 0 de la solution des problemes de Riemann
% a deux etats locaux

if(isequal(flux,@FluxTransport))

    display('On utilisera Godunov que pour des cas non linéaires');

elseif (isequal(flux,@FluxBurgers))
H = V - dt_sur_h * ( flux(wR(V,W),0)- flux( wR(U,V),0) );
     % Code a ajouter.

end



