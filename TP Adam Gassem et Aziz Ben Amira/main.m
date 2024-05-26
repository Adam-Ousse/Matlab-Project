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

%Taille de la police
fontsize= 16;

% Entrée de l'utilisateur, si l'entrée est invalide, on prendra les valeurs par défauts
%Entrée de Ug :
global Ug = entree_valide('Entrer la valeur de Ug: ', @(x) x > 0, default_Ug);
%Entrée de Ug :
global Ud = entree_valide('Entrer la valeur de Ud : ', @(x) x > 0, default_Ud);
%Entrée de Ug :
global pg = entree_valide('Entrer la valeur de pg: ', @(x) x > 0, default_pg);
%Entrée de Ug :
global pd = entree_valide('Entrer la valeur de pd : ', @(x) x >0 , default_pd);
%Entrée de Ug :
global alpha = entree_valide('Enter value for alpha (<=1 pour un schema stable): ', @(x) x > 0, default_alpha);
%Entrée de Ug :
global Nx = entree_valide('Enter value for Nx(>0): ', @(x) x > 0, default_Nx);

%Entrée du choix de schéma :
choix_schema = entree_valide(["Choisir un schéma numérique : \n" ...
               "0 pour le schéma de Lax-Friedrichs\n" ...
               "1 pour le schéma de Rusanov\n" ...
               "2 pour le schéma HLL\n"], @(x) x >=0&&x<=2, 0);
%on replace laf onciton G par le schéma correspondant
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

% valeur de  gamma
global gamma = 1.4;

% Discretisation spatiale
global Nt = 500;
global Nx = Nx;
%Discretisation temporelle
x_minn= -2;
x_maxx = 2;
t_minn = 0;
t_maxx = 0.2;
%delta x
global deltax = (x_maxx-x_minn)/(Nx-1);


%Discretisation spatial pour la determination de p* et u*
h_p = (pd-0)/Nx;
%interval [0,pg]
p1=linspace(0, pg-h_p, Nx);
% interval [0,pd]
p2= linspace(0,pd-h_p,Nx);
%Initialisation du compteur d'itérations et du temps initial
n=0;

%Fonction difference entre UD1 et UD2
f = @(p) UD1(p)-UD2(p);
%Abscisse d'intersection entre UD1 et UD2
% determination de p* s'il existe
global p_et;
try
    %si fzero retourne une valeur, nous serons dans la soltuion dente detente si non on affichera seulement le graphe R_1^alpha et R_2^alpha
    p_et = fzero(f, [min(p1), max(p1)]);
    disp('Les conditions pour deux ondes de détente sont satisfaites.');
catch
    disp('Les conditions pour deux ondes de détente ne sont pas satisfaites.');
    %affichage du graph (pas d'intersection)
    subplot(2,2,[1 2]);
    hold on;
    %Plot de u1 et u2
    u1 = UD1(p1);
    u2 =  UD2(p2);
    %plot
    plot(p1,u1,'LineWidth', 1.5,p2,u2,'LineWidth', 1.5);
    set(gca,'fontsize', fontsize);
    %label
    xlabel("p",'FontSize', fontsize);
    ylabel("U",'FontSize', fontsize);

    %ticks
    set(gca, 'XTick', [pg, pd]);  % Set the tick locations
    set(gca, 'XTickLabel', {'p_g', 'p_d'});  % Set the tick labels
    set(gca, 'YTick', [Ug, Ud]);  % Set the tick locations
    set(gca, 'YTickLabel', {'u_g', 'u_d'});  % Set the tick labels
    %grille :
    grid on ;
    %titre
    title("U_D^1 et U_D^2",'FontSize', fontsize+2);
    %legend
    legend('U_g^1(p)', 'U_D^2(p)','FontSize', fontsize);
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
u1 = UD1(p1);
u2 =  UD2(p2);
%plot des deux courbes
plot(p1,u1,'Color',[ 0.850000   0.325000   0.098000],'LineWidth', 1.5,p2,u2,'Color',[ 0.9290   0.6940   0.1250],'LineWidth', 1.5);
hold on;
%plot du point d'intersection
plot(p_et,u_et ,'Color',[0   0.4470   0.7410], 'o','Markersize',4,'Linewidth',1.5);

%police
set(gca, 'fontsize', fontsize);
xlabel("p",'FontSize', fontsize);
ylabel("U",'FontSize', fontsize);

%ticks
set(gca, 'XTick', [p_et,pg, pd]);  % Set the tick locations
set(gca, 'XTickLabel', {'p^*','p_g', 'p_d'});  % Set the tick labels
set(gca, 'YTick', [u_et,Ug, Ud]);  % Set the tick locations
set(gca, 'YTickLabel', {'u^*','u_g', 'u_d'});  % Set the tick labels
%grille
grid on ;
%titre
title("U_D^1 et U_D^2",'FontSize', fontsize+2);
%legende
legend("(p^* , u^*)",'U_g^1(p)', 'U_D^2(p)','FontSize', fontsize);

% Sous titre pour afficher les valeurs de ug,ud, pg, pd , alpha et N
subtitle_text = sprintf('U_g = %.2f, U_d = %.2f, p_g = %.2f, p_d = %.2f, \\alpha = %.2f, N = %d', Ug, Ud, pg, pd, alpha, Nx);
%affichage du text en bas de la figure
annotation('textbox', [0.5, 0.01, 0, 0.05], 'String', subtitle_text, 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom' ,'FontSize', fontsize+2);
hold off;


%Solution Approchée et solution exacte :
%Interval de x
x_minn= -2;
x_maxx = 2;
%interval de t
t_minn = 0;
t_maxx = 0.3;
%discretisation spacial de Nx points
x_vals = linspace(x_minn,x_maxx,Nx);

%nombres d'iteration maximal :
n_iter_max = 1000;

%Condition initiale est la solution exacte à t = 0
epsilon = 1e-6;
U_apro = Uexacte(x_vals,t_minn+epsilon);
%initialisation de W tel que la premiere ligne contient p et la deuxieme ligne contient p*u
W= zeros(2,Nx);
% On transforme la condition unitale au format de W
W = utow(U_apro);
%Wjp1 represente W_j+1 à l'instant n
Wjp1 = zeros(2,Nx);
Wjp1(1,:) = [W(1, 2:Nx) pd];
Wjp1(2,:) = [W(2, 2:Nx) Ud*pd];

%Wjp1 represente W_j-1 à l'instant n
Wjm1 = zeros(2,Nx);
Wjm1(1,:) = [pg W(1, 2:Nx)];
Wjm1(2,:) = [Ug*pg W(2, 2:Nx)];
% t initial
t = t_minn+epsilon;
%Compteur d'iteration
n_iter = 1;
%historique des valeur de p
p_hist =zeros(n_iter_max,Nx);
%historique des valeurs de u
u_hist = zeros(n_iter_max, Nx);
%remplissage par la condition initial;
p_hist(1,:) = W(1,:);
u_hist(1,:) = W(2,:)./W(1,:);


%soltuion exacte
U_exacte = Uexacte(x_vals, t);



%plot de p à gauche en bas
subplot(223);
set(gca, 'fontsize', fontsize);
%grille
grid on ;
hold on;
%plot de la solution approchée
p_plot_prox = plot(x_vals,W(1,:),'DisplayName', strcat('p par', schema),'LineWidth', 1.5);
%plot de la solution exacte
p_plot_exacte =plot(x_vals, U_exacte(1,:), 'r:','DisplayName', 'solution exacte de p','LineWidth', 1.5);

%label
xlabel('x');
ylabel('p(x,t)');
%titre
title({'Graph de p', ['t = 0']},'FontSize', fontsize+2);
%ticks pour les valeurs importants comme p* pg et pd
yticks([0, p_et, pg, pd]); % Correction: specify multiple ticks as an array
yticklabels({'0', 'p^*', 'p_g', 'p_d'});
% on se limite à x [-2,2]
ylim([0, max([pd p_et])+1]);
xlim([x_minn,x_maxx]);
%pour que le plot occupera toute la zone
legend('Location', 'northoutside', 'Orientation', 'horizontal');

hold off;

%plot de u à droite en bas
subplot(224);
set(gca, 'fontsize', fontsize);
%grille
grid on ;
hold on;
%plot de la solution approchée u
u_plot_prox = plot(x_vals,W(2,:)./W(1,:),'DisplayName', strcat('u par le ', schema),'LineWidth', 1.5);
%plot de la solution exacte u
u_plot_exacte=plot(x_vals, U_exacte(2,:), 'r: ','DisplayName', 'solution exacte de u','LineWidth', 1.5);
## label
xlabel('x');
ylabel('u(x,t)');
%titre
title({'Graph de u', ['t = 0']},'FontSize', fontsize+2);
%ticks
yticks([0, Ug, u_et, Ud]); % Correction: specify multiple ticks as an array
yticklabels({'0', 'u_g', 'u^*', 'u_d'});
ylim([0,max([Ud u_et])+1]);
xlim([-2,2]);
%pour que le plot occupera toute la zone
legend('Location', 'northoutside', 'Orientation', 'horizontal');
hold off;

%boucle principale qui s'arrete si on arrive à tmax ou le nombre d'iteration est supermier au nombre d'iterations maximale
%ou si la norme infinie est superier à celle de la condition initial
while (t < t_maxx && n_iter <= n_iter_max && max(W(2,:)./W(1,:))<Ud*2 && max(W(1,:)<pd*2))
    %mise à jour de la valeur de dt par la fonction deltatt
    dt = deltat(W);
    %mise à jour des valeur Wjp1 et jm1
    Wjp1(1,:) = [W(1, 2:Nx), pd];
    Wjp1(2,:) = [W(2, 2:Nx), Ud*pd];
    Wjm1(1,:) = [pg, W(1, 1:Nx-1)];
    Wjm1(2,:) = [Ug*pg, W(2, 1:Nx-1)];
    % dt/dx
    dt_sur_dx = dt/deltax;
    %mise à jour de la valeur de t
    t = t+dt;
    % mise ç jour de W à partir du schema choisie G
    W = W - dt_sur_dx*(G(W, Wjp1, dt_sur_dx) - G(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_lf(W, Wjp1, dt_sur_dx) - Gab_lf(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_rusanov(W, Wjp1, dt_sur_dx) - Gab_rusanov(Wjm1, W, dt_sur_dx));
##    W = W - dt_sur_dx*(Gab_hll(W, Wjp1, dt_sur_dx) - Gab_hll(Wjm1, W, dt_sur_dx));
    %incrementation du nombre d'iterations
    n_iter = n_iter + 1;
    %La valeur de U à partir de la fonction wtou et W
    U_apro = wtou(W);
    % historique
    p_hist(n_iter,:) = W(1,:);
    u_hist(n_iter,:) = W(2,:)./W(1,:);
    %soltuion exacte :
    U_exacte = Uexacte(x_vals,t);
    % Mise à jour des graphiques
    subplot(223);
    set(gca, 'fontsize', fontsize);
    %mise à jour des valeur de la solution approchée de p
    set(p_plot_prox, 'YData', W(1,:));
    %mise à jour des valeur de la solution exacte de p
    set(p_plot_exacte, 'YData',U_exacte(1,:) );
    %mise à jour du titre par la valeur actuelle du temps
    title({'Graph de la p', ['t = ', num2str(t)]},'FontSize', fontsize+2);
    subplot(224);
    set(gca, 'fontsize', fontsize);
    %mise à jour des valeur de la solution approchée de u
    set(u_plot_prox, 'YData', W(2,:)./W(1,:));
    %mise à jour des valeur de la solution exacte de u
    set(u_plot_exacte, 'YData',U_exacte(2,:) );
    %mise à jour du titre par la valeur actuelle du temps
    title({'Graph de la u', ['t = ', num2str(t)]},'FontSize', fontsize+2);
    drawnow;
    %petite pause pour l'animation
    pause(0.001);
end
%affichage final
if(max(W(2,:)./W(1,:))<Ud*2 || max(W(1,:)<pd*2) )
disp("Shema diverge");
end
disp("Finie");



