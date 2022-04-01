%%
%6288156 Sirada Vitoonvarakorn (Grace)
%load files
b1_img = imread('dataset\bg1.jpg'); %background images
b2_img = imread('dataset\bg2.jpg');
c1_img = imread('dataset\compo1.jpg'); %composite images
c2_img = imread('dataset\compo2.jpg');
newbg = imread('dataset\newbg.jpg'); %new background
white = imread('dataset\white.jpg'); %white background
%% 
%convert to double (since the formula can't be done with integers alone).
double_b1_img = double(b1_img);
double_b2_img = double(b2_img);
double_c1_img = double(c1_img);
double_c2_img = double(c2_img);
B = double(newbg);
W = double(white);
%% 
%color segmentation
Br1 = double_b1_img(:,:,1);
Bg1 = double_b1_img(:,:,2);
Bb1 = double_b1_img(:,:,3);

Br2 = double_b2_img(:,:,1);
Bg2 = double_b2_img(:,:,2);
Bb2 = double_b2_img(:,:,3);

Cr1 = double_c1_img(:,:,1);
Cg1 = double_c1_img(:,:,2);
Cb1 = double_c1_img(:,:,3);

Cr2 = double_c2_img(:,:,1);
Cg2 = double_c2_img(:,:,2);
Cb2 = double_c2_img(:,:,3);
%% 
%blue screen matting formula
numerator = (Cr1-Cr2).*(Br1-Br2)+(Cg1-Cg2).*(Bg1-Bg2)+(Cb1-Cb2).*(Bb1-Bb2);
denominator = (Br1-Br2).^2+(Bg1-Bg2).^2+(Bb1-Bb2).^2;
alpha = 1-(numerator./denominator);
%% 
%find foreground of r, g ,b
Fr = (Cr1-(1-alpha).*Br1)./alpha;
Fg = (Cg1-(1-alpha).*Bg1)./alpha;
Fb = (Cb1-(1-alpha).*Bb1)./alpha;
%% 
%combine into rgb image
F(:,:,1) = Fr;
F(:,:,2) = Fg;
F(:,:,3) = Fb;
%F = cat(3, Fr, Fg, Fb);
%% 
%extracted matte/foreground 
Fg = alpha.*F+(1-alpha).*W;
Foreground = uint8(Fg);
imwrite(Foreground,'extramatte.jpg');
%% 
%new composite
C = alpha.*F+(1-alpha).*B;
Composite = uint8(C);
imwrite(Composite,'newcompo.jpg');
%% 
%clear