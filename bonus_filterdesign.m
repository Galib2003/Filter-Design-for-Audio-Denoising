% BONUS: Manual Difference Equation Filtering
% Galib Raid - CSE 3313 - Spring 2025

% Step 1: Load the audio
[y, Fs] = audioread('noisyaudio-1.wav');

% Step 2: Frequency Analysis
N = length(y);
Y = abs(fft(y));
f = (0:N-1)*(Fs/N);

% Step 3: Design Butterworth Filter
wp = 2000;    % Passband edge (Hz)
ws = 2500;    % Stopband start (Hz)
Ap = 1;       % Passband ripple (dB)
As = 30;      % Stopband attenuation (dB)

wp_norm = wp / (Fs/2);
ws_norm = ws / (Fs/2);

[N, Wn] = buttord(wp_norm, ws_norm, Ap, As);
[b, a] = butter(N, Wn);

% Step 4: Manual Filtering using Difference Equation
y_manual = zeros(size(y));  % Initialize output signal

for n = 1:length(y)
    % Apply input side (b coefficients)
    for k = 1:length(b)
        if n-k+1 > 0
            y_manual(n) = y_manual(n) + b(k)*y(n-k+1);
        end
    end
    % Apply output side (a coefficients, skip a(1))
    for k = 2:length(a)
        if n-k+1 > 0
            y_manual(n) = y_manual(n) - a(k)*y_manual(n-k+1);
        end
    end
end

% Step 5: Save manually filtered audio
audiowrite('filteredaudio_manual.wav', y_manual, Fs);

% Step 6: DFT of manually filtered audio
N_manual = length(y_manual);
Y_manual = abs(fft(y_manual));
f_manual = (0:N_manual-1)*(Fs/N_manual);

% Step 7: Plot DFT of manually filtered signal
figure;
plot(f_manual(1:floor(N_manual/2)), Y_manual(1:floor(N_manual/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of Manually Filtered Audio');
grid on;

% Step 8: Comparison with original
figure;
subplot(2,1,1);
plot(f(1:floor(N/2)), Y(1:floor(N/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Original Noisy Audio Spectrum');
grid on;

subplot(2,1,2);
plot(f_manual(1:floor(N_manual/2)), Y_manual(1:floor(N_manual/2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Manually Filtered Audio Spectrum');
grid on;
