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
## @deftypefn {} {@var{retval} =} wtou (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-07

function retval = wtou (W)
   % Fonction qui convertit W en vecteur U
  % Input :
  % - W : Matrice de taille (2, Nx)
  %
  % Output :
  % - U : Matrice de taille (2, Nx)

global Nx ;
retval = zeros(2, Nx);
retval(1,:) = W(1,:);
##c= W(1,:)==0;
retval(2,:) = W(2,:) ./ W (1,:) ;
endfunction
