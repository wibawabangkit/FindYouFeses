clc; clear; close all; warning off all;

% membaca citra
I = imread ('2 tahun 1 bulan.jpeg');
figure, imshow(I)
%-----------------------------------------------------------------------
%ekstraksi RGB
R = I (:,:,1);
G = I (:,:,2);
B = I (:,:,3);

%invers dari masing2 komponen
mR = 1/(mean(mean(R)));
mG = 1/(mean(mean(G)));
mB = 1/(mean(mean(B)));

%mencari nilai invers maksimal
maxRGB = max(max(mR, mG), mB);

%menghitung faktor skala
mR = mR/maxRGB;
mG = mG/maxRGB;
mB = mB/maxRGB;

%melakukan penskalaan nilai pixel
out = uint8(zeros(size(I)));
out (:,:,1) = R*mR;
out (:,:,2) = G*mG;
out (:,:,3) = B*mB;

%figure, imshow(out)

%-----------------------------------------------------------------------
%konversi citra RGB menjadi citra YCbCr
img_ycbcr = rgb2ycbcr (out);
figure, imshow(img_ycbcr)

%mengekstrak komponen Cb dan Cr
Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%-----------------------------------------------------------------------

%deteksi warna feses
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);

%ambil nilai pixel pada hasil deteksi (rekontruksi nilai pixel hasil
%deteksi
numind = size (r,1);
bin = false (size(I,1), size(I,2));
for i = 1:numind
    bin (r(i), c(i)) = 1;
end
%-----------------------------------------------------------------------

%melakukan morfologi untuk menyeleksi hasil segmentasi dengan nilai
%trashhold
bin = imfill(bin, 'holes'); 
bin = bwareaopen(bin, 90);
figure, imshow(bin)
%-----------------------------------------------------------------------

%menampilkan citra rgb hasil segmentasi
R (~bin) = 0;
G (~bin) = 0;
B (~bin) = 0;
RGB = cat(3, R,G,B);
figure, imshow (RGB)

