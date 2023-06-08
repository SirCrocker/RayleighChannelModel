clear
close all
clc
%% Script for testing constellations created

% Generating bits
n_bits = 1e5+8;
bits_list = GenerateBits(n_bits);

% Mapping bits to different modulations
symbols_list_QPSK = Modulate(bits_list, 'QPSK');
symbols_list_8PSK = Modulate(bits_list, '8PSK');
symbols_list_16QAM = Modulate(bits_list, '16QAM');

% Create a circle of radius 1 as reference
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);

% Plot QPSK
figure('Position', [100 100 600 540]);
plot(real(symbols_list_QPSK),imag(symbols_list_QPSK),'x');
hold on
plot(xunit, yunit); % plot a circle of radius 1
title('QPSK Modulation');
xlabel('Real Axis');
ylabel('Img Axis');
grid();

% Plot 8PSK
figure('Position', [100 100 600 540]);
plot(real(symbols_list_8PSK),imag(symbols_list_8PSK),'x');
hold on
plot(xunit, yunit); % plot a circle of radius 1
title('8PSK Modulation');
xlabel('Real Axis');
ylabel('Img Axis');
grid();

% Plot 16QAM
figure('Position', [100 100 600 540]);
plot(real(symbols_list_16QAM),imag(symbols_list_16QAM),'x');
hold on
plot(xunit, yunit); % plot a circle of radius 1
title('16QAM Modulation');
xlabel('Real Axis');
ylabel('Img Axis');
grid();

