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
## @deftypefn {} {@var{retval} =} dt (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-14

function retval = deltat (W)
%Fonction qui permet de calculer le pa de temps à l'instant t
%Input : Matrice W de taille (2,NX) :  la premiere ligne continienne la valeur de p et la 2me eligne contient la valeur de p*u
%Output : Scalaire contenant la valeur de delta t à l'instant n
global deltax alpha;
u = W(2,:)./W(1,:);
p = W(1,:);
lambdaa1 = lambda1(p,u);
lambdaa2 = lambda2(p,u);
m1 = max(abs(lambdaa1));
m2 = max(abs(lambdaa2));
retval = alpha * deltax /(max(m1,m2));
endfunction
