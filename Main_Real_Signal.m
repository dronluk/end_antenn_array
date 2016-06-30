clear all;
j=sqrt(-1);
step = 1000;%Кол.итераций
mu = 1/10000000000;%Шаг сходимости
Antenn=4;%кол.антенн
N = 1000; %длинна выборки
k = 20; %количество отводов STAP
sv=1;%номер спутника для модели сигнала
quant_jam=1; %количество помех
number_jam=2;%1-Узкополосная 2-Широкополосная 3-ЛЧМ

 data=Model_Signal(sv,quant_jam,number_jam);

% fileID = fopen('wide_75dBm_#2_gn32.txt');%чтение из файла
% % data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
% data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
% fclose(fileID);
% data=cell2mat(data1);

% path='';
% fileID = fopen([path 'no_jamm_20M.txt']);
% data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 1000000);
% fclose(fileID);
% data=cell2mat(data1);
for k=1:4
data(:,k) = data(:,k) - mean(data(:,k));
end
data = data';
clear data1 fileID;

% signal=My_Hilbert_Filter(data,Antenn);%Гилберт

signal=data;%Без Гилберта

% % e2=SMI_Filter(signal,N,k,Antenn);%Адаптивный фильтр
Inter=signal(:,1:N);
d=Inter(1,:);% Эталонный сигнал выборки
d2=signal(1,:);
U=signal(2:4,:);
%отводы(задержки)
U_tap =[];
for i=0:k
    U_tap = [U_tap; circshift(U',i)' ];
end;
%--------
Uinter = U_tap(:,1:N); % Периферийные антенны выборки
W=ones(length(Uinter(:,1)), 1);   %коэффицент
  [e,W,Y]=SMI_metod(d,Uinter);%SMI метод
% [e,W,Y]=LMS_metod(d,Uinter,mu,step);%LMS метод
  Y=W'*Uinter;
  e=d-Y;
 
  Y2=W'*U_tap;
  e2=d2-Y2; 
  std(e2);
  
   %e2=signal(1,:);%Без адаптивного фильтра
  
fprintf('СКО до подавителя: %f \n',std(signal(1,:)));
fprintf('СКО после: %f \n',std(e2));



 Korrelator(e2);
  %Korrelator(signal(1,:));

