clc, clear ;
imfName = 'wt9.jpg' ;
% load image from file
imgInfo = imfinfo( imfName ) ;
bitDepth = imgInfo.BitDepth ;
a = imread ( imfName ) ;
% 0.2989 * R + 0.5870 * G + 0.1140 * B 
c = rgb2gray( a ) ;

figure(1)
clf ;
set(gcf,'NumberTitle','off') ;
set(gcf,'Name', 'source image' ) ;
set(gca,'Position',[.01,.55, .45, .4]) ;
imshow(c) ;
grid on ;
title('Source image') ;

% get source image histogram
axes() ;
set(gca,'Position',[.51,.55, .45, .4]) ;

%h = imhist(c) ;
numLevels = 256 ;
h = zeros(numLevels,1) ;
for n=1:numel(c)
    h(c(n)+1) = h(c(n)+1) + 1 ;
end
h = h/numel(c) ;

stem(h,'Marker','None') ;
title('Input histogram') ;
grid on ;

% make transform curve
% scale to 8 bit depth
axes() ;
set(gca,'Position',[.50,.04, .2, .4]) ;
gamma = 0.4 ;
C = 256/256^gamma ;
T = uint8(C*(0:255).^gamma) ;
hold off, plot(T) ;
grid on ;
title(sprintf('%2.1f\\cdotr^{%2.1f}',C,gamma),'Interpreter','tex')
    
axes() ;
set(gca,'Position',[.01,.03, .45, .4]) ;
e(:,:) = T(c(:,:)+1) ;
imshow(e) ;
title('Output image') ;

% get histogram
axes() ;
he = imhist(e) ;
stem(he,'Marker','None') ;
grid on ;
set(gca,'Position',[.75,.04, .2, .4]) ;
title('Output histogram') ;

