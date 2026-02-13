%% Challenge 1 (LAB-ONLY FIX): Fillings count + sizes (pixels)
clear; close all; clc;

A = imread('../assets/fillings.tif');   % or ../assets/fillings.tif
I = mat2gray(A);

figure; imshow(I); title('Original (scaled)');

%% 1) Noise reduction (still basic lab image processing)
% This image has heavy speckle -> median filter helps a lot
I1 = medfilt2(I, [3 3]);
figure; imshow(I1); title('After median filter');

%% 2) Remove smooth background / tooth shading, keep small bright objects (morphology)
% Top-hat = original - opening -> highlights small BRIGHT features
se = strel('disk', 12);    % tune: 8–20 (bigger = removes larger bright areas)
I2 = imtophat(I1, se);
I2 = imadjust(I2);
figure; imshow(I2); title('Top-hat enhanced (small bright features)');

%% 3) Threshold (segmentation)
BW = imbinarize(I2);       % try this first
% If it's still too noisy, force a slightly higher threshold:
% BW = I2 > 0.35;          % tune 0.25–0.55

figure; imshow(BW); title('Thresholded');

%% 4) Morphological cleanup
BW = bwareaopen(BW, 20);   % remove tiny specks (tune 10–100)

% Optional: keep only plausible filling sizes (VERY useful here)
% This removes remaining big blobs (like teeth regions) if they slip through
BW = bwareafilt(BW, [30 2000]);  % tune range after you see results

BW = imclose(BW, strel('disk', 1)); % connect tiny breaks
figure; imshow(BW); title('Cleaned fillings mask');

%% 5) Connected components + sizes (pixels)  (Lecture 6 style)
CC = bwconncomp(BW);
numFillings = CC.NumObjects;
sizesPx = cellfun(@numel, CC.PixelIdxList);

fprintf('Fillings found: %d\n', numFillings);
fprintf('Sizes (pixels):\n');
disp(sizesPx(:));

%% Visualise labels
L = labelmatrix(CC);
RGB = label2rgb(L, 'jet', 'k', 'shuffle');
figure; imshow(RGB); title('Labelled fillings (connected components)');