t = -4:0.1:4 ;
F = 1/2+1/2/sqrt(2)*erf(t/sqrt(2)) ;

plot(t,F,'Color',[0 0 0],'LineWidth',2) 
grid on, set(gca,'FontSize',14)

%addpath('\Projects\export_fig') ;
%export_fig figure1.pdf
%rmpath('\Projects\export_fig') ;
