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
## @deftypefn {} {@var{retval} =} FW (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-14

function retval = flux_ph(W)
  % Fonction qui calcule le flux physique
  % Input :
  % - W : Matrice de taille (2, Nx), où la première ligne contient la densité (ρ)
  %       et la deuxième ligne contient la quantité de mouvement (ρu) pour chaque cellule.
  %
  % Output :
  % - retval : Matrice de taille (2, Nx), où la première ligne contient le flux de densité
  %            (ρu) et la deuxième ligne contient le flux de quantité de mouvement (ρu^2 + ρ^γ).

  global gamma;
  global Nx;
  retval = zeros(2,Nx);
  retval(1,:) = W(2,:);
  retval(2,:) = W(2,:).^2 ./W(1,:) +W(1,:).^gamma ;
endfunction
