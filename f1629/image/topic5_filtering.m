I = imread('moon.tif') ;
axes() ;
set(gca,'Position',[.01,.01, .45, .96]) ;
imshow(I)
h = fspecial('unsharp') ;
I2 = imfilter(I,h) ;
axes() ;
set(gca,'Position',[.5,.01, .45, .96]) ;
imshow(I2)
