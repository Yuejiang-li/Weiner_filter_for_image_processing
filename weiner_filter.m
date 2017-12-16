%��ȡͼ��
im = imread('satellite_degraded.tiff');
figure;
imshow(im);
%K������ʾά���˲��ĺ㶨�����
K = 0.0001;
%ͼ����500*500������ͼ����Ҫ�޸Ĳ���
H = zeros(500,500);
%calcu�����Ǽ��㣬ά���˲��л�ԭ���̵�������H(x,y)��K�йصļ�����ʽ
calcu = zeros(500,500);
for i= 1:500
    for j = 1:500
          H(i,j) = exp(-0.0025*((i-250)^2+(j-250)^2));
          calcu(i,j) = (abs(H(i,j)))^2./(((abs(H(i,j)))^2 + K).*H(i,j));
    end
end

%��ԭ�źŹ�һ��������Ҷ�任�����ѵ�Ƶ�����м䣬��Ƶ�����ĸ���
signal_1 = im;
signal_1 = im2double(signal_1);
F_signal_1 = fft2(signal_1);
F_last_signal = fftshift(F_signal_1);
%ά���˲�
for i= 1:500
    for j = 1:500
        F_last_signal(i,j) = F_last_signal(i,j).*calcu(i,j);
    end
end
%���任
F_last_signal = ifftshift(F_last_signal);
last_signal = ifft2(F_last_signal);
last_signal = abs(last_signal);
%�����任��Ľ����һ������ת��Ϊɫ��ֵ
m = max(max(last_signal));
last_signal = last_signal/m;
last_figure = uint16(last_signal*65535);
figure;
imshow(last_figure);