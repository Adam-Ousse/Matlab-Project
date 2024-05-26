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
## @deftypefn {} {@var{retval} =} Gab (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-14

function retval = Gab_lf (W1,W2,dt_sur_h)
  % Fonction qui calcule le flux numérique avec le schéma de Lax-Friedrichs.
  % Input :
  % - W1 : Matrice de taille (2, Nx), où la première ligne contient la densité (ρ) et la deuxième ligne contient la quantité de mouvement (ρu) pour l'état gauche.
  % - W2 : Matrice de taille (2, Nx), où la première ligne contient la densité (ρ) et la deuxième ligne contient la quantité de mouvement (ρu) pour l'état droite.
  % - dt_sur_h : vecteur, le rapport entre le pas de temps et le pas spatial.
  %
  % Output :
  % - retval : Matrice de taille (2, Nx), contenant le flux numérique calculé avec le schéma de Lax-Friedrichs.

  retval = 0.5*(flux_ph(W1)+flux_ph(W2)) - (0.5/dt_sur_h) .*(W2-W1);
endfunction
