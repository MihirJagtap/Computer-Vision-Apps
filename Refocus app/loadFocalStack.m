function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)

    cd (focal_stack_dir)

    [height, len, channels] = size(imread('frame1.jpg'));

    

    rgb_stack  = cast(zeros(height,len, channels*25),'uint8');
    gray_stack = cast(zeros(height,len, 25),'uint8');

    for i = 1:25

        name = strcat('frame', num2str(i), '.jpg');
        
        img = imread(name);

        rgb_stack(:,:,((channels * i) - 2):(channels * i)) = img;
        
        gray_stack(:,:,i)= rgb2gray(img);
        
    end

    cd ('..')
    





