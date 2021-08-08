clc; clear; close all;
 
%%% Proses Pelatihan
% membaca file citra
nama_folder = 'data latih';
nama_file = dir(fullfile(nama_folder,'*.png'));
jumlah_file = numel(nama_file);
% inisialisasi variabel ciri_latih
ciri_latih = zeros(jumlah_file,3);
 
for n = 1:jumlah_file
    % membaca citra RGB
    Img = im2double(imread(fullfile(nama_folder,nama_file(n).name)));
    % konversi citra RGB menjadi grayscale
    Img_gray = rgb2gray(Img);
    % konversi citra grayscale menjadi biner
    bw = imbinarize(Img_gray,.9);
    % operasi morfologi
    bw = imcomplement(bw);
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,100);
    % ekstraksi ciri warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    R(~bw) = 0;
    G(~bw) = 0;
    B(~bw) = 0;
    Red = sum(sum(R))/sum(sum(bw));
    Green = sum(sum(G))/sum(sum(bw));
    Blue = sum(sum(B))/sum(sum(bw));
    % mengisi hasil ekstraksi ciri pada variabel ciri_latih
    ciri_latih(n,1) = Red;
    ciri_latih(n,2) = Green;
    ciri_latih(n,3) = Blue;
end
 
% standarisasi data
[ciri_latihZ,muZ,sigmaZ] = zscore(ciri_latih);
 
% pca
[coeff,score_latih,latent,tsquared,explained] = pca(ciri_latihZ);
 
% inisialisasi variabel kelas_latih
kelas_latih = cell(jumlah_file,1);
% mengisi nama2 sayur pada variabel kelas_latih
for k = 1:3
    kelas_latih{k} = 'Sakit';
end
 
for k = 4:7
    kelas_latih{k} = 'Sehat';
end
 
% ekstrak PC1 & PC2
PC1 = score_latih(:,1);
PC2 = score_latih(:,2);
 
% kelas sakit
x1 = PC1(1:3);
y1 = PC2(1:3);
 
% kelas sehat
x2 = PC1(4:7);
y2 = PC2(4:7);

% menampilkan sebaran data pada masing-masing kelas pelatihan
figure
plot(x1,y1,'r.','MarkerSize',30)
hold on
plot(x2,y2,'g.','MarkerSize',30)
hold off
grid on
xlabel('PC1')
ylabel('PC2')
legend('Sakit','Sehat')
title('Sebaran data pelatihan KNN')
 
% klasifikasi menggunakan knn
Mdl = fitcknn([PC1,PC2],kelas_latih,'NumNeighbors',3);
 
% menyimpan variabel-variabel hasil pelatihan
save hasil_pelatihan Mdl muZ coeff sigmaZ