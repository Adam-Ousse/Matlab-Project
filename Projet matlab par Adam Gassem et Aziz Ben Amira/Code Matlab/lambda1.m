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
## @deftypefn {} {@var{retval} =} lambda1 (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-07

function retval = lambda1 (p,u)
  % Fonction qui calcule la première valeur propre (vitesse de propagation d'onde) pour un système hyperbolique de lois de conservation.
  % Input :
  % - p : Vecteur contenant les densités (ρ) pour chaque cellule.
  % - u : Vecteur contenant les vitesses (u) pour chaque cellule.
  %
  % Output :
  % - retval : Vecteur contenant la première valeur propre pour chaque cellule.

global gamma;
retval = u- (gamma * (p.^(gamma-1))).^0.5;
endfunction
