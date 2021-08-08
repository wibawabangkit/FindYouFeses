%%% Proses Pengujian
% membaca file citra
nama_folder = 'data uji';
nama_file = dir(fullfile(nama_folder,'*.jpg'));
jumlah_file = numel(nama_file);
% inisialisasi variabel ciri_uji
ciri_uji = zeros(jumlah_file,3);
 
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
    % mengisi hasil ekstraksi ciri pada variabel ciri_uji
    ciri_uji(n,1) = Red;
    ciri_uji(n,2) = Green;
    ciri_uji(n,3) = Blue;
end
 
% standarisasi ciri uji
ciri_ujiZ = zeros(jumlah_file,3);
for k = 1:jumlah_file
    ciri_ujiZ(k,:) = (ciri_uji(k,:) - muZ)./sigmaZ;
end
 
% konversi ciri uji ke PC
score_uji = ciri_ujiZ*coeff;
 
% ekstrak PC1 & PC2
PC1 = score_uji(:,1);
PC2 = score_uji(:,2);
 
% mengujikan data uji pada knn
hasil_uji = predict(Mdl,[PC1,PC2]);
 
% menampilkan sebaran data pada masing-masing kelas pelatihan
figure
plot(x1,y1,'r.','MarkerSize',30)
hold on
plot(x2,y2,'g.','MarkerSize',30)
grid on
 
% kelas Sakit
x1 = [];
y1 = [];
jumlah_sakit = 0;
for n = 1:jumlah_file
    if isequal(hasil_uji{n},'Sakit');
        jumlah_sakit = jumlah_sakit+1;
        x1(jumlah_sakit,1) = PC1(n);
        y1(jumlah_sakit,1) = PC2(n);
    end
end
 
% kelas Sehat
x2 = [];
y2 = [];
jumlah_sehat = 0;
for n = 1:jumlah_file
    if isequal(hasil_uji{n},'Sehat');
        jumlah_sehat = jumlah_sehat+1;
        x2(jumlah_sehat,1) = PC1(n);
        y2(jumlah_sehat,1) = PC2(n);
    end
end
 
% menampilkan sebaran data pada masing-masing kelas pengujian
plot(x1,y1,'cx','LineWidth',4,'MarkerSize',10)
plot(x2,y2,'mx','LineWidth',4,'MarkerSize',10)
hold off
xlabel('PC1')
ylabel('PC2')
legend('Sakit (latih)','Sehat (latih)',...
'Sakit (uji)','Sehat (uji)')
title('Sebaran data pengujian KNN')