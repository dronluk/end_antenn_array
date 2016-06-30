function [ e,W,Y ] = SMI_metod(  D,UINTER)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
d=D;            % Эталонный сигнал выборки
Uinter=UINTER;  % Периферийные антенны выборки

L=length(Uinter);
    R=1/L*(Uinter*Uinter');
    r=1/L*(d*Uinter');
    W=pinv(R)*r';
    Y = W'*Uinter;     %сигналы с периферийных антенн стремящиеся к эталонному
    e = d - Y;
 std(e)%Среднее отклонение сходимости
end

