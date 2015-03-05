% get access to model
clc, clear %, clf ;
curPath = pwd() ;
cd('\Work\Melnikov2\2014\WORK\src\tests\tsim\model\') ;
modelPath = pwd() ;
cd( curPath ) ;
addpath(modelPath) ;

num_of_tests = 500 ;

fd= 16000 ;		% 16.368 MHz

% A = 1, E = 0.5
% [0:0.05:30] => 1/20 * [0:1:600] => Fs = 20 Hz, N = 600
A = 1 ; E = A^2 / 2 ;
SNR_dB = -20:1:10 ;
%SNR_dB = 100 ;
sigma = E ./ (10 .^ (SNR_dB./10)) ;
SNR = E ./ sigma ;
N = 6 ;

freq1 = zeros(length(SNR_dB), 1) ;
freq2 = zeros(length(SNR_dB), 1) ;
freq3 = zeros(length(SNR_dB), 1) ;
freq4 = zeros(length(SNR_dB), 1) ;

%w1 = -2*pi*4E3/fd ;
%w2 = 2*pi*4E3/fd ;
w1 = -pi*0.4 ;
w2 = pi*0.4 ;

fprintf('Compute subband matrices...') ;
F0 = get_sb_matrix(N, w1, w2, 0 ) ;
F1 = get_sb_matrix(N, w1, w2, 1 ) ;
F2 = get_sb_matrix(N, w1, w2, 2 ) ;
fprintf('done\n') ;

% Check for valid fast algorithms
%check_fast_alg = 0 ;
% if check_fast_alg
%     fs = 2000 + 1000*rand(1) ;
%     phase_arg = 2*pi*1*fs/fd*(0:N-1) ;
%     s = A * cos(phase_arg) ;
%     x = s + sqrt(sigma(1))*(randn(size(s))) ;
%     fast_xx4_real(x,1) ;
%     error('end_of_fast_xx4_real_test') ;
% end


matlabpool open 8 ;

parfor jj=1:length(SNR_dB)
    
    %     init_rand(1) ;
    fprintf('Actual: %.4f  dB\n', SNR_dB(jj)) ;
    
    tic() ;
    
    for k=1:num_of_tests
        fs = 2000 + 1000*rand(1) ;
        phase_arg = 2*pi*1*fs/fd*(0:N-1) ;
        s = A * cos(phase_arg) ;
        x = s + sqrt(sigma(jj))*(randn(size(s))) ;
        
        xx4 = fast_xx4_real(x,0) ;
        
        %%%%%%%%%%%%%%%%%%%
        % signal + noise
        X = fft(x,4*N) ;
        XX = X.*conj(X) ;
        rxx1 = ifft(XX) ;
        rxx2 = ifft(XX .^ 4) ;
        rxx3 = ifft(XX .^ 8) ;
        
        r04 = sum(sum(sum(sum(xx4.*F0)))) ;
        r14 = sum(sum(sum(sum(xx4.*F1)))) ;
        r24 = sum(sum(sum(sum(xx4.*F2)))) ;
        rxx4 = [r04, r14, r24 ] ;
        
%        rxx4 = [
%            Rxx_sb(x.', N, w1, w2, 0);
%            Rxx_sb(x.', N, w1, w2, 1);
%            Rxx_sb(x.', N, w1, w2, 2);
%            ];
        
        %%%%%%%%%%%%
        % 1
        b1 = ar_model([rxx1(1); rxx1(2); rxx1(3)]) ;
        [poles1, omega0_1, Hjw0_1] = get_ar_pole(b1) ;
        freq1(jj) = freq1(jj) + (omega0_1*fd/2/pi - fs)^2 ;
        
        %%%%%%%%%%%%
        % 2
        b2 = ar_model([rxx2(1); rxx2(2); rxx2(3)]) ;
        [poles2, omega0_2, Hjw0_2] = get_ar_pole(b2) ;
        freq2(jj) = freq2(jj) + (omega0_2*fd/2/pi - fs)^2 ;
        
        %%%%%%%%%%%%
        % 3
        b3 = ar_model([rxx3(1); rxx3(2); rxx3(3)]) ;
        [poles3, omega0_3, Hjw0_3] = get_ar_pole(b3) ;
        freq3(jj) = freq3(jj) + (omega0_3*fd/2/pi - fs)^2 ;
        
        %%%%%%%%%%%%
        % 4
        b4 = ar_model([rxx4(1); rxx4(2); rxx4(3)]) ;
        [poles4, omega0_4, Hjw0_4] = get_ar_pole(b4) ;
        freq4(jj) = freq4(jj) + (omega0_4*fd/2/pi - fs)^2 ;
        
        %fprintf('Estimated freq: %.4f Hz\n', freq3(k));
    end ;
    
    freq1(jj) = sqrt(freq1(jj) / num_of_tests) ;
    freq2(jj) = sqrt(freq2(jj) / num_of_tests) ;
    freq3(jj) = sqrt(freq3(jj) / num_of_tests)  ;
    freq4(jj) = sqrt(freq4(jj) / num_of_tests)  ;
    
    toc() ;
    
end ; % SNR

matlabpool close ;

SNR_dB_acf = SNR_dB ;
save('freq_sko_ar', 'freq1', 'freq2', 'freq3', 'freq4', 'SNR_dB_acf')

figure(1) ;
hold off ;
semilogy(SNR_dB, freq1, '-ko', 'LineWidth', 2, 'MarkerSize', 6 ) ;
hold on ;
semilogy(SNR_dB, freq2, '-b*', 'LineWidth', 2, 'MarkerSize', 8  ) ;
semilogy(SNR_dB, freq3, '-r+', 'LineWidth', 2, 'MarkerSize', 8  ) ;
semilogy(SNR_dB, freq4, '-m^', 'LineWidth', 3, 'MarkerSize', 8, 'Color', [0.1 0.7 0.1]  ) ;
set(gca,'FontSize',14) ;
title(sprintf('Band:-0.5\\pi...0.5\\pi, D=3, N=%d',N)) ,
legend('1', '2', '3', 'SB') ;
grid on ;
xlabel('SNR, dB') ;
ylabel('\sigma^2') ;
set(gcf,'Position',[325   340   747   444]) ;
%     phd_figure_style(gcf) ;

% remove model path
rmpath(modelPath) ;
