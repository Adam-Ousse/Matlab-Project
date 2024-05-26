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
## @deftypefn {} {@var{retval} =} u1det (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-07

function retval = u1det (x, t)
   % Fonction qui calcule u1det
  % Input :
  % - x : Position spatiale vecteur
  % - t : Temps scalire
  %
  % Output :
  % - retval : u1det(x,t)
global gamma Ug pg;
retval =(( 2/(gamma+1)) * (x./t)) + (((gamma-1)/(gamma+1)) * Ug) + ((2*sqrt(gamma))/(gamma+1)) *pg^((gamma-1)/2);
endfunction
