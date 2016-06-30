%BeiDou
function G = BeiDouCode(svnum, fs)
%svnum=1;
% fd= 2046000;
% fs= fd/1023000;

N=2046;
G=zeros(1,N);
G1 = [0 1 0 1 0 1 0 1 0 1 0]'; %начальная последовательность G1
G2 = [0 1 0 1 0 1 0 1 0 1 0]'; %начальная последовательность G2


tap=[1 3;  1 4;   1 5;   1 6;   1 8;   1 9;   1 10;   1 11; ...  
     2 7;  3 4;   3 5;   3 6;   3 8;   3 9;   3 10;   3 11; ...
                  4 5;   4 6;   4 8;   4 9;   4 10;   4 11; ... 
                         5 6;   5 8;   5 9;   5 10;   5 11; ...
                                6 8;   6 9;   6 10;   6 11; ...
                                       8 9;   8 10;   8 11; ...
                                              9 10;   9 11; ...
                                                     10 11];



tap_select = tap(svnum,:);

for k = 1:N;
    G1_xor = xor(xor(xor(xor(xor(G1(11),G1(10)),G1(9)),G1(8)),G1(7)),G1(1));
    G2_xor = xor(xor(xor(xor(xor(xor(xor(G2(11),G2(9)),G2(8)),G2(5)),G2(4)),G2(3)),G2(2)),G2(1));

    G21 = xor(G2(tap_select(1)),G2(tap_select(2)));        %PSP
    G(k) = xor(G1(11),G21);

    %circshift G1
    G1(2:11) = G1(1:10);
    G1(1)    = G1_xor;
    
    %circshift G2
    G2(2:11) = G2(1:10);
    G2(1)    = G2_xor;
end
for num=1:N
    if G(num)==0
        G(num)=-1;
    end;
 end;
 
  gfs = zeros(1,length(1/fs:1/fs:N));
  
%повышение частоты дискретизации
if fs~=1
	%fractional upsampling with zero order hold
	index=0;
	for cnt = 1/fs:1/fs:N
		index=index+1;
		if ceil(cnt) > N   %поиск ошибок с плавающей запятой в индексе
			gfs(:,index)=G(:,N);
		else
			gfs(:,index)=G(:,ceil(cnt));
		end
	end 
	G=gfs';
end