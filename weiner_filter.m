%读取图像
im = imread('satellite_degraded.tiff');
figure;
imshow(im);
%K参数表示维纳滤波的恒定信噪比
K = 0.0001;
%图像是500*500，其他图像需要修改参数
H = zeros(500,500);
%calcu算子是计算，维纳滤波中还原过程的所有与H(x,y)及K有关的计算表达式
calcu = zeros(500,500);
for i= 1:500
    for j = 1:500
          H(i,j) = exp(-0.0025*((i-250)^2+(j-250)^2));
          calcu(i,j) = (abs(H(i,j)))^2./(((abs(H(i,j)))^2 + K).*H(i,j));
    end
end

%将原信号归一化做傅里叶变换，并把低频移至中间，高频移至四个角
signal_1 = im;
signal_1 = im2double(signal_1);
F_signal_1 = fft2(signal_1);
F_last_signal = fftshift(F_signal_1);
%维纳滤波
for i= 1:500
    for j = 1:500
        F_last_signal(i,j) = F_last_signal(i,j).*calcu(i,j);
    end
end
%反变换
F_last_signal = ifftshift(F_last_signal);
last_signal = ifft2(F_last_signal);
last_signal = abs(last_signal);
%将反变换后的结果归一化后再转变为色度值
m = max(max(last_signal));
last_signal = last_signal/m;
last_figure = uint16(last_signal*65535);
figure;
imshow(last_figure);