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
## @deftypefn {} {@var{retval} =} entree_valide (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: adamg <adamg@LORD_SOH_I>
## Created: 2024-05-25

function val = entree_valide (prompt, condition, default_val)
  % Fonction qui demande à l'utilisateur de saisir une valeur et vérifie si elle est valide.
  % Input :
  % - prompt : Chaîne de caractères, le message à afficher à l'utilisateur pour l'inviter à entrer une valeur.
  % - condition : Fonction handle, une condition que l'entrée de l'utilisateur doit satisfaire.
  % - default_val : Scalaire, la valeur par défaut à utiliser si l'entrée de l'utilisateur est invalide.
  % Output :
  % - val : Scalaire, la valeur validée par l'utilisateur ou la valeur par défaut si l'entrée est invalide.

  val = input(prompt);
  if ~(isnumeric(val) && condition(val))
    disp(['Entrée invalide. Usage de la valeur par défaut: ', num2str(default_val)]);
    val = default_val;
  end
end

