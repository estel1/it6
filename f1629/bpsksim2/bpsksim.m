clc, clear all ;
snrs_db = 0:2:10 ;
ber = zeros(size(snrs_db)) ;
snr_n = 1 ;
for snr_db = snrs_db
    [ber(snr_n)] = bpskmod(snr_db) ;
    fprintf('snr=%5.2f ber=%12.10f/%12.10f\n',snr_db,ber(snr_n),.5*erfc(sqrt(10.^(snr_db/10)))) ;
    snr_n = snr_n + 1 ;
end
hold off, semilogy(snrs_db,ber,'b-^','LineWidth',2),grid on
hold on, semilogy(snrs_db,.5*erfc(sqrt(10.^(snrs_db/10))),...
    'r-*','LineWidth',2,'Color',[.8 0 0]) ;
set(gca,'FontSize',14) ;
title('BPSK BER estimation')
xlabel('SNR,dB') ;
ylabel('BER') ;
