function [ e,W,Y,coef_filtr,SKO ] = LMS_metod( D,UINTER,MU,STEP )
%пространственно-временной  фильтр градиентного спуска
d=D;            % Эталонный сигнал выборки
Uinter=UINTER;  % Периферийные антенны выборки
mu =MU;         % шаг сходимости
step=STEP;
coef=zeros(3,step);
W=zeros(length(Uinter(:,1)),1);
SKO=[];
% W=[0;0;0;0;0;0;0;0;0];%коэффицент
%W=[0;0;0];
for n=1:step
    Y = W'*Uinter;     %сигналы с периферийных антенн стремящиеся к эталонному
    e = d - Y;         % выходной сигнал 
    W_ = mu*Uinter*e'; % расчёт коэффицента
    W = W + W_;
    for k=1:3          %запись в память коэффиценты для 3х переферийных антен
    coef_filtr(k,n)=W(k,1);
    end
    SKO(n)=std(e);
end;
std(e)%Среднее отклонение сходимости
figure(12);hold on
plot(real(coef_filtr(1,:)),'r');plot(real(coef_filtr(2,:)),'g');plot(real(coef_filtr(3,:)),'k');%Отображение как растут коэффиценты
title('Коэффиценты');

end

