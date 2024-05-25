% Flux associe a l'equation de transport.

%--------------------------------------------------------------------------
% u      : valeur pour laquelle on veut calculer le flux (ou la derivee du flux)
% nderiv : vaut 0 si on souhaite calculer le flux ou 1 si
%          l'on souhaite calculer la derivee du flux
%--------------------------------------------------------------------------


function F = FluxTransport(u, nderiv)

c = 1.0;
if (nderiv == 0)
  F = c*u;
elseif (nderiv == 1)
  F = c;
else
  error('FluxTransport : Argument nderiv qui n est pas correct.');
end

end