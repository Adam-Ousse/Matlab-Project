%Effacer tout les variables stocker
clear all;
%Fermer la fenetre de la figure si elle ouverte
close all;

% Valeurs par defaut de
%Ug
default_Ug = 1;
%Ud
default_Ud = 4;
%Ug
default_pg = 1;
%Ud
default_pd = 4;
%alpha
default_alpha = 1;
%Nx nombre de points x
default_Nx = 500;

% Prendre
global Ug = entree_valide('Entrer la valeur de Ug: ', @(x) x > 0, default_Ug);
global Ud = entree_valide('Entrer la valeur de Ud : ', @(x) x > 0, default_Ud);
global pg = entree_valide('Entrer la valeur de pg: ', @(x) x > 0, default_pg);
global pd = entree_valide('Entrer la valeur de pd : ', @(x) x >0 , default_pd);
global alpha = entree_valide('Enter value for alpha (<=1 pour un schema stable): ', @(x) x > 0, default_alpha);
global Nx = entree_valide('Enter value for Nx(>0): ', @(x) x > 0, default_Nx);
prompt_text = ["Choisir un schéma numérique : \n" ...
               "0 pour le schéma de Lax-Friedrichs\n" ...
               "1 pour le schéma de Rusanov\n" ...
               "2 pour le schéma HLL\n"];
choix_schema = entree_valide(prompt_text, @(x) x >=0&&x<=2, 0);
if (choix_schema==0)
    disp('Schéma de Lax-Friedrichs');
    schema = "Schéma de Lax-Friedrichs";
    G=@Gab_lf;
elseif (choix_schema==1)
    disp('Schéma de Rusanov');
    schema = "Schéma de Rusanov";
    G=@Gab_rusanov;
else
    disp('Schéma HLL');
    schema = "Schéma HLL";
    G=@Gab_hll;
end

% gamma
global gamma = 1.4;

% Discretisation spatiale
global Nt = 500;
global Nx = Nx;
%Discretisation temporelle
x_minn= -2;
x_maxx = 2;
t_minn = 0;
t_maxx = 0.2;
global deltax = (x_maxx-x_minn)/(Nx-1);
global alpha =1;
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
##global p_et = fzero(f, [min(p1), max(p1)]);

global p_et;
try
    p_et = fzero(f, [min(p1), max(p1)]);
    disp('Les conditions pour deux ondes de détente sont satisfaites.');
catch
    disp('Les conditions pour deux ondes de détente ne sont pas satisfaites.');
    subplot(2,2,[1 2]);
    hold on;
    %Plot de u1 et u2
    u1 = UD1(p1);
    u2 =  UD2(p2);
    plot(p1,u1,p2,u2);
    xlabel("p");
    ylabel("U");


    set(gca, 'XTick', [pg, pd]);  % Set the tick locations
    set(gca, 'XTickLabel', {'p_g', 'p_d'});  % Set the tick labels

    grid on ;
    title("U_D^1 et U_D^2");
    legend('U_g^1(p)', 'U_D^2(p)');
    hold off;
    return;
end
%u*
global u_et = UD1(p_et);
%Affichage du point d'intersection
disp("Intersection p^* : ");
disp(p_et);
disp("Intersection U^* : ");
disp(u_et);


%Plot du point d'intersection
subplot(2,2,[1 2]);
plot(p_et,u_et , 'o','Markersize',3);
hold on;
%Plot de u1 et u2
u1 = UD1(p1);
u2 =  UD2(p2);
plot(p1,u1,p2,u2);
xlabel("p");
ylabel("U");


set(gca, 'XTick', [p_et,pg, pd]);  % Set the tick locations
set(gca, 'XTickLabel', {'p^*','p_g', 'p_d'});  % Set the tick labels
set(gca, 'YTick', [u_et,Ug, Ud]);  % Set the tick locations
set(gca, 'YTickLabel', {'u^*','u_g', 'u_d'});  % Set the tick labels

grid on ;
title("U_D^1 et U_D^2");
legend("(p^* , u^*)",'U_g^1(p)', 'U_D^2(p)');
hold off;
if (pg > p_et && pd > p_et && Ug < u_et && u_et < Ud)
    disp('Les conditions pour deux ondes de détente sont satisfaites.');
else
    disp('Les conditions pour deux ondes de détente ne sont pas satisfaites.');
##    return;
end
x_minn= -2;
x_maxx = 2;
t_minn = 0;
t_maxx = 0.3;
x_vals = linspace(x_minn,x_maxx,Nx);
##t_vals = linspace(t_minn,t_maxx,Nt);
U_vect = zeros(Nx, 2); % 2D cell array with 2 columns for u and p


n_iter_max = 1000;
U = zeros(2,Nx);
%Condition initiale
epsilon = 1e-6;
U_apro = Uexacte(x_vals,t_minn+epsilon);
%initialisation de W
W= zeros(2,Nx);
W = utow(U_apro);
Wjp1 = zeros(2,Nx);
Wjp1(1,:) = [W(1, 2:Nx) pd];
Wjp1(2,:) = [W(2, 2:Nx) Ud*pd];
Wjm1 = zeros(2,Nx);

Wjm1(1,:) = [pg W(1, 2:Nx)];
Wjm1(2,:) = [Ug*pg W(2, 2:Nx)];
t = t_minn+epsilon;
n_iter = 1;
p_hist =zeros(n_iter_max,Nx);
u_hist = zeros(n_iter_max, Nx);
p_hist(1,:) = W(1,:);
u_hist(1,:) = W(2,:)./W(1,:);
##tt=[0];
U_exacte = Uexacte(x_vals, t);

subplot(223);
grid on ;
hold on;

p_plot_prox = plot(x_vals,W(1,:),'DisplayName', strcat('solution approchée de p par le ', schema));
p_plot_exacte =plot(x_vals, U_exacte(1,:), 'r','DisplayName', 'solution exacte de p');
##axis('equal')
xlabel('x');
ylabel('p(x,t)');
title({'Graph de p', ['t = 0']});
yticks([0, p_et, pg, pd]); % Correction: specify multiple ticks as an array
yticklabels({'0', 'p^*', 'p_g', 'p_d'});
ylim([0, max([pd p_et])+1]);
xlim([-2,2]);
legend('Location', 'northoutside', 'Orientation', 'horizontal');
##axis tight;
hold off;


subplot(224);
grid on ;
hold on;
u_plot_prox = plot(x_vals,W(2,:)./W(1,:),'DisplayName', strcat('solution approchée de p par le ', schema));
u_plot_exacte=plot(x_vals, U_exacte(2,:), 'r ','DisplayName', 'solution exacte de u');
##axis('equal')
xlabel('x');
ylabel('u(x,t)');
title({'Graph de u', ['t = 0']});
yticks([0, Ug, u_et, Ud]); % Correction: specify multiple ticks as an array
yticklabels({'0', 'u_g', 'u^*', 'u_d'});
ylim([0,max([Ud u_et])+1]);
xlim([-2,2]);
legend('Location', 'northoutside', 'Orientation', 'horizontal');
hold off;

while (t < t_maxx && n_iter <= n_iter_max)
    dt = deltat(W);
    Wjp1(1,:) = [W(1, 2:Nx), pd];
    Wjp1(2,:) = [W(2, 2:Nx), Ud*pd];
    Wjm1(1,:) = [pg, W(1, 1:Nx-1)];
    Wjm1(2,:) = [Ug*pg, W(2, 1:Nx-1)];
    dt_sur_dx = dt/deltax;
##    tt = [tt, tt + dt];
    t = t+dt;
    W = W - dt_sur_dx*(G(W, Wjp1, dt_sur_dx) - G(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_lf(W, Wjp1, dt_sur_dx) - Gab_lf(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_rusanov(W, Wjp1, dt_sur_dx) - Gab_rusanov(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_hll(W, Wjp1, dt_sur_dx) - Gab_hll(Wjm1, W, dt_sur_dx));
    n_iter = n_iter + 1;
    U_apro = wtou(W);
    p_hist(n_iter,:) = W(1,:);
    u_hist(n_iter,:) = W(2,:)./W(1,:);
    U_exacte = Uexacte(x_vals,t);
    % Mise à jour des graphiques
    subplot(223);
    set(p_plot_prox, 'YData', W(1,:));
    set(p_plot_exacte, 'YData',U_exacte(1,:) );
    title({'Graph de la p', ['t = ', num2str(t)]});
    subplot(224);
    set(u_plot_prox, 'YData', W(2,:)./W(1,:));
    set(u_plot_exacte, 'YData',U_exacte(2,:) );
    title({'Graph de la u', ['t = ', num2str(t)]});
##    axis tight;
    drawnow;
    pause(0.001);
end
disp("Finie");



