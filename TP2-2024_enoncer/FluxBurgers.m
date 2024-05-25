% Flux associe a l'equation de Burgers.

%--------------------------------------------------------------------------
% u      : valeur pour laquelle on veut calculer le flux (ou la derivee du flux)
% nderiv : vaut 0 si on souhaite calculer le flux ou 1 si
%          l'on souhaite calculer la derivee du flux
%--------------------------------------------------------------------------


function F = FluxBurgers(u, nderiv)

% Code a ajouter.

%Correction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nderiv == 0)
    F = 0.5*u.*u;
elseif (nderiv == 1)
    F=u;
else
    error('FluxBurgers : Argument nderiv qui n est pas correct.');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

