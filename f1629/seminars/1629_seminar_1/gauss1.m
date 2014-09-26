t = -4:0.1:4 ;
f = 1/sqrt(2*pi)*exp(-0.5*t.^2);
plot(t,f,'Color',[0 0 0],'LineWidth',2) 
grid on, set(gca,'FontSize',14)

addpath('\Projects\export_fig') ;
export_fig figure1.pdf
rmpath('\Projects\export_fig') ;
