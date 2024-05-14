global gama;
global rhod;
global rhog;
global ud;
global ug;
%discretisation de l'intervalle de définition de rho pour la detente
rho=0.01:1/100:3.99;
%discretisation de l'intervalle de définition de rho pour le choc
rhop=1.01:1/100:4;
%definition des paramètres du probléme
rhod=4;
ud=2;
rhog=1;
ug=3;
gama=1.4;
%dessination
subplot(223);
plot(rho,UD2(rho,rhod,ud),rhop,UC1(rhop,rhog,ug));
hold on;
xlabel('rho');
% xlim(0,4);
% ylim(-3,6);
ylabel('Valeur de la fonction');
%recherche du point d'intersection de coordonnées (rhoet,Uet)
f=@(rho,rhod,rhog,ud,ug) UD2(rho,rhod,ud)-UC1(rho,rhog,ug);
rhoet=fzero(@(rho) f(rho,rhod,rhog,ud,ug),3);
Uet=UD2(rhoet,rhod,ud);
plot(rhoet,Uet,'ro','MarkerSize',7);
text(rhoet,Uet, ['(', num2str(rhoet), ', ', num2str(Uet), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
plot(rhog,ug,'ro','MarkerSize',7);
text(rhog,ug, ['(', num2str(rhog), ', ', num2str(ug), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
plot(rhod,ud,'ro','MarkerSize',7);
text(rhod,ud, ['(', num2str(rhod), ', ', num2str(ud), ')'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
% plot(rhop,UC1(rhop));
% figure(1);
% clf;
grid on;
N=1000;
x=-2:4/N:2;
for T=0.01:1/1000:0.2
  Ux=Uex(x,T);
  subplot(221);
  plot(x,Ux(2,:));
  xlabel('x');
  ylabel('u(x,t)');
  hold on;
  xlim([-2 2]);
  ylim([0 5]);
  hold off;
  xlabel('x');
  ylabel('u(x,t)');
  title(['t = ',num2str(T)]);
  subplot(222);
  plot(x,Ux(1,:));
  xlabel('x');
  ylabel('p(x,t)');
  hold on;
  xlim([-2 2]);
  ylim([0 5]);
  hold off;
  title(['t = ',num2str(T)]);
  pause(0.001);
endfor
