%% Load image
load clown
clown(20,319)

%% Show image
imshow (clown)

%% Rotate image
ImageOut = rotate(clown, 30)
imshow (ImageOut)

%% Shear image
ImageOut2 =  shear(clown, 2, 1)
imshow (ImageOut2)