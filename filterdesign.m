% Filter Design Project Script
% Galib Raid - CSE 3313 - Spring 2025

% Step 1: Load the audio
[y, Fs] = audioread('noisyaudio-1.wav');

% Step 2: Frequency Analysis
N = length(y);
Y = abs(fft(y));
f = (0:N-1)*(Fs/N);

% Plot DFT of original audio
figure;
plot(f(1:floor(N/2)), Y(1:floor(N/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of Noisy Audio');
grid on;

% Step 3: Design Butterworth Filter
wp = 2000;    % Passband edge (Hz)
ws = 2500;    % Stopband start (Hz)
Ap = 1;       % Passband ripple (dB)
As = 30;      % Stopband attenuation (dB)

wp_norm = wp / (Fs/2);
ws_norm = ws / (Fs/2);

[N, Wn] = buttord(wp_norm, ws_norm, Ap, As);
[b, a] = butter(N, Wn);

% Step 4: Apply Filter
y_filtered = filter(b, a, y);

% Step 5: Save filtered audio
audiowrite('filteredaudio.wav', y_filtered, Fs);

% Step 6: DFT of filtered audio
N_filtered = length(y_filtered);
Y_filtered = abs(fft(y_filtered));
f_filtered = (0:N_filtered-1)*(Fs/N_filtered);

% Plot DFT of filtered audio
figure;
plot(f_filtered(1:floor(N_filtered/2)), Y_filtered(1:floor(N_filtered/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of Filtered Audio');
grid on;

% Plot comparison
figure;
subplot(2,1,1);
plot(f(1:floor(N/2)), Y(1:floor(N/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Original Noisy Audio Spectrum');
grid on;

subplot(2,1,2);
plot(f_filtered(1:floor(N_filtered/2)), Y_filtered(1:floor(N_filtered/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Filtered Audio Spectrum');
grid on;
