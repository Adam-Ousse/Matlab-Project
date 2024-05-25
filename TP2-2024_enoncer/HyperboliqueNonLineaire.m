% Resolution des lois de conservation 1D :
%     o Equation du transport.
%     o Equation de Burgers.
%-----------------------------------------------------------------
%
%    dt(u) + dx f(u) = 0;  x \in [x_min,x_max], t>0
%    u(x,0) = u0(x);   x \in [x_min,x_max]
%    u(x_min,t) = u(x_max,t),  t>0.
%
% par des schemas explicites a deux niveaux de temps et trois pas d'espace :
%
% u(n+1,j) = H_n(u(n,j-1),u(n,j),u(n,j+1)).
%
% h            : pas d'espace donne (x_max-x_min)/N
% alpha        : rapport nominal dt/dx
% x_min, x_max : intervalle de resolution spatial
% T            : Temps final,
% N            : nombre de points en x
% NT           : nombre d'iterations en temps
%
% u0(x)        : fonction donnee initiale
% uex(x,t)     : solution exacte si connue
%
% le pas de temps est determine par la regle suivante de type CFL
% generalise
%
% dt(n) = alpha h / sup_j | a(u(n,j)) |.
%
% ou a(u) = f'(u).
%
%--------------------------------------------------------------

clear all;


%--------------------------------------------------------------------------
%Parametres a modifier pour le tp------------------------------------------
%--------------------------------------------------------------------------


%Le flux qui determine la lois de conservation a resoudre : f(u)
% assigning a function to a variable  a = @function_name
%flux  = @FluxTransport;   % Flux pour l equation de transport.
flux = @FluxBurgers;     % Flux pour l equation de Burgers.


%Condition intiale a utiliser
ConditionInitiale = @Rampe;
%ConditionInitiale = @Creneau;

%Schema a utiliser (expression de H(u,v,w))
%Hscheme = @Decentre;         % (A coder)
%Hscheme = @MurmanRoe;        % (A coder)
Hscheme = @LaxFriedrichs;    % (A coder)
%Hscheme = @Godunov;          % (A coder)


%Discretisation spatiale
N = 300;

%Discretisation temporelle
alpha = 3;

%Variable valant 1 si l'on veut afficher la solution exacte
%Attention, fonctionne pour :
% -Tous les problemes de transports lineaire
% -Burgers avec condition initiale rampe
sol_exacte=1;

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Le code qui suit ne doit pas etre modifier dans le cadre du TP
%--------------------------------------------------------------------------

%Domaine spatiale et temporel
xmin = -2;
xmax = 2;
Tmin = 0;
Tmax = 3;


%Discretisation spatial
h = (xmax-xmin)/N;
x=linspace(xmin, xmax-h, N);

%Initialisation du compteur d'itérations et du temps initial
n=0;
t=Tmin;

%Condition initiale
u(1,:) = ConditionInitiale(x);

%Solution exacte
%matrice contenant N_t ligne chaque ligne contient les solutions  à t=nb ligne, et la colonne contient les valeurs u(t, nb_col)
uexact(1,:) = u(1,:);

%Estimation du nomb0re maximale d'iterations en temps
dt = alpha * h / max( abs( flux(u(1,:),1) ) );
NT = floor( (Tmax - Tmin) / dt );

%Estimation de la norme infinie de la solution
LinftyCondInit = max(abs(u));

%calcul du min et max pour regler les axes
umin = min(u(1,:));
umax = max(u(1,:));
du = abs(umax-umin);
umin = umin - 0.1*du;
umax = umax + 0.1*du;

%Initialise la figure
figure(1);
clf;

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%boucle en temps
%--------------------------------------------------------------------------
% Calculate the frame interval
frameInterval = ceil(NT / 50);

% Initialize frame counter
frameCounter = 1;

% Before the while loop, create a directory to store frames
if ~exist('frames/','dir')
    mkdir('frames');
end

while (t(n+1) <= Tmax)

  n = n + 1;
  t = [t ; t(n)+dt(n)];

  % Calcul du dt adaptatif
  %       alpha * h
  % dt = -----------------
  %       sup | a( u(n,:) ) |
  dt = [dt ; alpha * h / max( abs( flux(u(n,:),1) ) )];


  % U -> u_{j-1},  V  -> u_j,  W -> u_{j+1}
  U = [u(n,N), u(n,1:N-1)];
  V = u(n,:);
  W = [u(n,2:N), u(n,1)];

  % on applique le schema u_j^{n+1} = H(U,V,W) afain d'ajouter  u(t=n+1..)
  u = [u ; Hscheme(U, V, W, dt(n)/h, flux)];

  % calcul de la solution exacte.
  if(isequal(flux,@FluxTransport))
    uexact = [uexact ; ConditionInitiale(xmin+mod(x-xmin-flux(0,1)*t(n+1),(xmax-xmin)))];
  elseif(and(isequal(flux,@FluxBurgers),isequal(ConditionInitiale,@Rampe)))  % solution exacte pour la rampe

    gamma = 1.5*sqrt(1+t(n+1)) - 0.5*(1+t(n+1));
    uexact(n+1,:) =  (1.0/(1+t(n+1))*x.*(x > -0.5*(1+t(n+1))).*(x < gamma) - 0.5.* (x >= gamma).*(x <= 4.0-0.5*(1+t(n+1))) -0.5*(x <= -0.5*(1+t(n+1))));
    uexact(n+1,:) =  uexact(n+1,:) + 1.0/(1+t(n+1)).*(x-4).*(x > 4.0-0.5*(1+t(n+1)));

  elseif(and(isequal(flux,@FluxBurgers),isequal(ConditionInitiale,@Creneau)))  % solution exacte pour le creneau

     if (t<=4/3)
        uexact(n+1,:) = (x<(-t(n+1).*0.5-0.5)).*(-0.5) + (x>=(-t(n+1).*0.5-0.5)).*(x<=(t(n+1)-0.5)).*((x+0.5)./t(n+1)) + (x>(t(n+1)-0.5)).*(x<(0.25.*t(n+1)+0.5)) + (x>=(0.25.*t(n+1)+0.5)).*(-0.5);
     else
        gamma =  sqrt(3)*sqrt(t(n+1))-t(n+1)*0.5-0.5;
        uexact(n+1,:) = (x<(-t(n+1).*0.5-0.5)).*(-0.5) + (x>=(-t(n+1).*0.5-0.5)).*(x<=gamma).*((x+0.5)./t(n+1)) + (x>gamma).*(-0.5);
        uexact(n+1,:) =  uexact(n+1,:) + ((x-4)>=(-t(n+1).*0.5-0.5)).*((x-4)<=gamma).*(((x-4)+0.5)./t(n+1)+0.5);
    end

  else
    uexact(n+1,:) = zeros(1,N);
  end

  % recherche du point pour lequel on a le plus grand saut
  [maxu,index] = max(abs(W-V));
  if (index == N)
      gamma_num(n)=x(1);
  else
      gamma_num(n)=x(index);
  end


  % on affiche la solution
  plot(x, u(n+1,:));
  if (sol_exacte==1)
      hold on;
      plot(x,uexact(n+1,:),'r');
  end
  hold off;
  axis('equal')
  axis([xmin xmax umin umax]);
  xlabel('x'); ylabel('u(x,t)');
  title(['t = ',num2str(t(n+1))]);
##if mod(n, frameInterval) == 0
########        % Capture the current figure window and save it as an image
##  frame = getframe(gcf);
##  imwrite(frame.cdata, sprintf('frames/frame%d.png', frameCounter));
##  frameCounter = frameCounter + 1;
##  end
frame = getframe(gcf);
        imwrite(frame.cdata, sprintf('frames/frame%d.png', frameCounter));
        frameCounter = frameCounter + 1;
  pause(0.02);


  if (n > 3*NT)
     display('Le nombre d iterations en temps depasse 3 fois le nombre d iterations maximal estime.');
     break;
  end

  if (max(abs(u(n+1,:))>5*LinftyCondInit))
    display('La norme L infinie de la solution depasse 5 la norme L infinie de la condition initiale');
    break;
  end

end

%Affichages----------------------------------------------------------------
##imwrite(sprintf('frames/frame%04d.png', 1:frameCounter-1), 'animation.gif', 'gif', 'DelayTime', 0.02);
figure(2);
clf;

%Affichage des courbes caract?ristiques
%surf(x,t,u);
contour(x,t,u,30);
colormap(1-gray);
axis('equal');
axis([xmin xmax Tmin Tmax]);
xlabel('x'); ylabel('t');
title('u(x,t)');
shading flat;
colorbar;


%--------------------------------------------------------------------------

