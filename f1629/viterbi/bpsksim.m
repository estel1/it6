clc, clear all ;
snrs_db = -2:2:8 ;
ber1 = zeros(size(snrs_db)) ;
ber2 = zeros(size(snrs_db)) ;
snr_n = 1 ;
for snr_db = snrs_db
    [ber1(snr_n)] = bpskmod(snr_db) ;
    [ber2(snr_n)] = bpskmod_vtrb(snr_db) ;
    fprintf('snr=%5.2f uncoded ber=%12.10f/%12.10f, encoded ber=%12.10f\n',snr_db,ber1(snr_n),.5*erfc(sqrt(10.^(snr_db/10))),ber2(snr_n)) ;
    snr_n = snr_n + 1 ;
end
hold off, semilogy(snrs_db,ber1,'b-^','LineWidth',2),grid on
hold on, semilogy(snrs_db,.5*erfc(sqrt(10.^(snrs_db/10))),...
    'r-*','LineWidth',2,'Color',[.8 0 0]) ;
hold on, semilogy(snrs_db,ber2,'k-.','LineWidth',2) ;
set(gca,'FontSize',14) ;
title('BPSK BER estimation')
xlabel('SNR,dB') ;
ylabel('BER') ;
