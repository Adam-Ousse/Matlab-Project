## Copyright (C) 2024 adamg
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} Gab_hll (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@LORD_SOH_I>
## Created: 2024-05-25

function retval = Gab_hll  (W1,W2,dt_sur_h)
  % Fonction qui calcule le flux numérique avec le schéma HLL (Harten-Lax-van Leer).
  % Input :
  % - W1 : Matrice de taille (2, Nx), où la première ligne contient la densité (ρ) et la deuxième ligne contient la quantité de mouvement (ρu) pour l'état gauche.
  % - W2 : Matrice de taille (2, Nx), où la première ligne contient la densité (ρ) et la deuxième ligne contient la quantité de mouvement (ρu) pour l'état droite.
  % - dt_sur_h : vecteur , le rapport entre le pas de temps et le pas spatial.
  %
  % Output :
  % - retval : Matrice de taille (2, Nx), contenant le flux numérique calculé avec le schéma HLL.

  % Calcul de la vitesse (u) et de la densité (p) pour les états gauche (W1) et droite (W2)
  u1 = W1(2,:) ./ W1(1,:);
  p1 = W1(1,:);
  u2 = W2(2,:) ./ W2(1,:);
  p2 = W2(1,:);

  % Calcul des valeurs propres (vitesses de propagation des ondes) pour les états gauche et droite
  lambdaa11 = lambda1(p1, u1);
  lambdaa21 = lambda2(p1, u1);
  lambdaa12 = lambda1(p2, u2);
  lambdaa22 = lambda2(p2, u2);

  % Détermination des vitesses d'onde minimale (c1) et maximale (c2)
  c1 = min([lambdaa11; lambdaa12; lambdaa21; lambdaa22]);
  c2 = max([lambdaa11; lambdaa12; lambdaa21; lambdaa22]);

  % Calcul des indicateurs pour les trois cas du schéma HLL
  k1 = (c1 >= 0) .* (c2 > 0); % Cas où les deux vitesses d'onde sont positives
  k2 = (c1 < 0) .* (c2 > 0);  % Cas où les vitesses d'onde sont de signes opposés
  k3 = (c2 <= 0);             % Cas où les deux vitesses d'onde sont négatives
  retval = flux_ph(W1).*k1 + ((c2.* flux_ph(W1) - c1.*flux_ph(W2))./(c2-c1) + (c2.*c1)./(c2-c1) .* (W2-W1)).*k2 + flux_ph(W2).*k3;
endfunction
