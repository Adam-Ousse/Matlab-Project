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
## @deftypefn {} {@var{retval} =} u (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@UNKNOWN>
## Created: 2024-05-06

function Uex= Uexacte(x, t)
global Ug pg Ud pd p_et u_et Nx Nt;
## methode vectoriel
## Lambda1 et 2 correcte

l1g = x<=lambda1(pg,Ug)*t;
l1et = (lambda1( pg,Ug)*t < x).* (x <= lambda1(p_et,u_et)*t);
l1l2et = (x<=lambda2(p_et,u_et)*t  ).* (lambda1(p_et,u_et)*t < x);
l2et = (x<=lambda2( pd,Ud)*t  ) .* (lambda2(p_et,u_et)*t < x);
l2d = x>lambda2(pd,Ud)*t;
Uex = zeros(2, Nx);
Uex(1, 1:Nx) = l1g.*pg + l1et.*p1det(x,t) + l1l2et.* p_et + l2et.*p2det(x,t) + l2d.* pd;
Uex(2, 1:Nx) = l1g.*Ug + l1et.*u1det(x,t) + l1l2et.* u_et + l2et.*u2det(x,t) + l2d.* Ud;

##
##
##if(x./t<=lambda1([Ug,pg]))
##  u = Ug;
##  p = pg;
##elseif(x/t <= lambda1([u_et,p_et]))
##  u= u1det(x,t);
##  p = p1det(x,t);
##elseif(x/t<= lambda2([u_et,p_et]))
##  u= u_et;
##  p = p_et;
##elseif(x/t<= lambda2([Ud,pd]))
##  u=u2det(x,t);
##  p= p2det(x,t);
##else
##  u=Ud;
##  p=pd;
##endif
endfunction
