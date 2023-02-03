function refocusApp(rgb_stack, depth_map)

imshow(rgb_stack(:,:,1:3));
msgbox(['Choose a object scene to refocus. Please wait for some ' ...
    'seconds for the point selector to appear. Enter button exits the ' ...
    'program!']);

pause(3);

[width, height] = size(rgb_stack);

[input_x,input_y] = ginput(1);

while ~isempty(input_x)  && ~isempty(input_y) ...
        && ceil(input_x) <= height && ceil(input_y) <= width
    
    image_fragment = depth_map(ceil(input_y), ceil(input_x));

    left_end = (3 * image_fragment - 2);

    right_end = (3 * image_fragment);

    imshow(rgb_stack(:,:, left_end : right_end));

    pause(3);
    
    [input_x,input_y] = ginput(1);
end

% close all figs
close all
