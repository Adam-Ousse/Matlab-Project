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
## @deftypefn {} {@var{retval} =} Gab_rusanov (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@LORD_SOH_I>
## Created: 2024-05-25

function retval = Gab_rusanov (W1,W2,dt_sur_h)
  u1 = W1(2,:)./W1(1,:);
  p1 = W1(1,:);
  u2 = W2(2,:)./W2(1,:);
  p2 = W2(1,:);
  lambdaa11 = lambda1(p1,u1);
  lambdaa21 = lambda2(p1,u1);
  lambdaa12 = lambda1(p2,u2);
  lambdaa22 = lambda2(p2,u2);
  c = max([abs(lambdaa11); abs(lambdaa12); abs(lambdaa21); abs(lambdaa22)])
  retval = 0.5 * (flux_ph(W1)+flux_ph(W2)) - 0.5*c.*(W2-W1);

endfunction
