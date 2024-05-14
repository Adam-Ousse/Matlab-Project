clear all;
##global Ug,Ud,pg,pd
%gamma
global gamma = 1.4;
%Ug
global Ug = 1;
%Ud
global Ud =4;
%Ro gauche
global pg = 1;
%Ro Droite
global pd=4;
%Discretisation spatiale
global Nt = 500;
global Nx = 500;
%Discretisation temporelle
alpha = 1;
x_minn= -2;
x_maxx = 2;
t_minn = 0;
t_maxx = 0.2;
global deltax = (x_maxx-x_minn)/(Nx-1);
global alpha =0.5;
%Discretisation spatial pour la determination de p* et u*
h_p = (pd-0)/Nx;
%[0,pg]
p1=linspace(0, pg-h_p, Nx);
%[0,pd]
p2= linspace(0,pd-h_p,Nx);
%Initialisation du compteur d'itérations et du temps initial
n=0;

%Fonction difference entre UD1 et UD2
f = @(p) UD1(p)-UD2(p);
%Abscisse d'intersection entre UD1 et UD2
%p*
global p_et = fzero(f, 0);
%u*
global u_et = UD1(p_et);
%Affichage du point d'intersection
disp("Intersection p^* : ");
disp(p_et);
disp("Intersection U^* : ");
disp(u_et);
%Plot du point d'intersection
subplot(221);
plot(p_et,u_et , 'o','Markersize',3);
hold on;
%Plot de u1 et u2
u1 = UD1(p1);
u2 =  UD2(p2);
plot(p1,u1,p2,u2);
xlabel("p");
ylabel("U");


set(gca, 'XTick', [1, 4]);  % Set the tick locations
set(gca, 'XTickLabel', {'p_g', 'p_d'});  % Set the tick labels

grid on ;
title("U_D^1 et U_D^2");
legend("Intersection",'U_g^1(p)', 'U_D^2(p)');
hold off;
x_minn= -2;
x_maxx = 2;
t_minn = 0;
t_maxx = 0.2;
x_vals = linspace(x_minn,x_maxx,Nx);
##t_vals = linspace(t_minn,t_maxx,Nt);
U_vect = zeros(Nx, 2); % 2D cell array with 2 columns for u and p
##Uex = Uexacte(x_vals,0);
% Créer une seule fois les sous-graphiques en dehors de la boucle
##subplot(222);
##u_plot = plot(x_vals,Uex(2,1:Nx));
##axis('equal')
##xlabel('x');
##ylabel('u(x,t)');
##title('t = 0');
##yticks([0, Ug, u_et, 2, 3, Ud]); % Correction: specify multiple ticks as an array
##yticklabels({'0', 'u_g', 'u^*', '2', '3', 'u_d'});
##ylim([0,4.5]);
##xlim([-2,2]);
##subplot(224);
##p_plot = plot(x_vals, Uex(1,1:Nx));
##axis('equal')
##xlabel('x');
##ylabel('p(x,t)');
##title('t = 0');
##yticks([0, p_et, pg, 2, 3, pd]); % Correction: specify multiple ticks as an array
##yticklabels({'0', 'p^*', 'p_g', '2', '3', 'p_d'});
##ylim([0, 4.5]);
##xlim([-2,2]);
##% Iterate over each x and t value
##for i = 2:Nt
##    t = t_vals(i);
##    Uex = Uexacte(x_vals, t);
##
##    % Mettre à jour les graphiques avec les nouvelles valeurs
##    subplot(222); % Sélectionner le sous-graphique pour u_plot
##    set(u_plot, 'YData', Uex(2, 1:Nx));
##    title(['t = ', num2str(t)]);
##
##    subplot(224); % Sélectionner le sous-graphique pour p_plot
##    set(p_plot, 'YData', Uex(1, 1:Nx));
##    title(['t = ', num2str(t)]);
##
##    % Mettre une pause pour visualiser les graphiques mis à jour
##    drawnow;
##    pause(0.00001);
##end

n_iter_max = 1000;
U = zeros(2,Nx);
%Condition initiale
epsilon = 1e-6;
U = Uexacte(x_vals,t_minn+epsilon);
%initialisation de W
W= zeros(2,Nx);
W = utow(U);
Wjp1 = zeros(2,Nx);
Wjp1(1,:) = [W(1, 2:Nx) pd];
Wjp1(2,:) = [W(2, 2:Nx) Ud*pd];
Wjm1 = zeros(2,Nx);
display("lol");
Wjm1(1,:) = [pg W(1, 2:Nx)];
Wjm1(2,:) = [Ug*pg W(2, 2:Nx)];
t = t_minn+epsilon;
n_iter = 1;
p_hist =zeros(n_iter_max,Nx);
u_hist = zeros(n_iter_max, Nx);
p_hist(1,:) = W(1,:);
u_hist(1,:) = W(2,:)./W(1,:);
tt=[0];


subplot(223);
p_plot_prox = plot(x_vals,W(1,:));
subplot(224);
u_plot_prox = plot(x_vals,W(2,:)./W(1,:));

while (tt(n_iter) < t_maxx && n_iter <= n_iter_max)
    dt = deltat(W);
    Wjp1(1,:) = [W(1, 2:Nx), pd];
    Wjp1(2,:) = [W(2, 2:Nx), Ud*pd];
    Wjm1(1,:) = [pg, W(1, 1:Nx-1)];
    Wjm1(2,:) = [Ug*pg, W(2, 1:Nx-1)];
    dt_sur_dx = dt/deltax;
    tt = [tt, tt + dt];
    W = W - dt_sur_dx*(Gab_lf(W, Wjp1, dt_sur_dx) - Gab_lf(Wjm1, W, dt_sur_dx));
    n_iter = n_iter + 1;
    U = wtou(W);
    p_hist(n_iter,:) = W(1,:);
    u_hist(n_iter,:) = W(2,:)./W(1,:);

    % Mise à jour des graphiques
    subplot(223);
    set(p_plot_prox, 'YData', W(1,:));
    subplot(224);
    set(u_plot_prox, 'YData', W(2,:)./W(1,:));
    drawnow;
    pause(0.00001);
end
disp("Finie");



