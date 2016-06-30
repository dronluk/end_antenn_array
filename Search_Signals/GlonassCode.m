%ГЛОНАСС
function G=GlonassCode(fs)
% fd= 2046000;
% fs= fd/1023000;
N = 511;
G = zeros(1,N);
PT = [1 1 1 1 1 1 1 1 1 ]' ; %начальная последовательность


for k = 1:N;
    PT_xor = xor(PT(5),PT(9)); %образующий полином
    
    P_T_code = PT(7); %7й разряд 9ти разрядного регистра


    PT = circshift(PT,1); % сдвиг массива
    PT(1) = PT_xor;

     G(k) = P_T_code ;
end;

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
 