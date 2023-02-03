function result = computeFlow(img1, img2, search_radius, template_radius, grid_MN)
    % Check images have the same dimensions, and resize if necessary
    if find(size(img2) ~= size(img1))
        img2 = imresize(img2, size(img1));
    end
    % Get number of rows and cols for output grid
    M = grid_MN(1);
    N = grid_MN(2);

    [H, W] = size(img1);
    % locations where we estimate the flow
    grid_y = round(linspace(template_radius+1, H-template_radius, M));
    grid_x = round(linspace(template_radius+1, W-template_radius, N));
    
    % allocate matrices where we will store the computed optical flow
    U = zeros(M, N);    % horizontal motion
    V = zeros(M, N);    % vertical motion
    
   
    function ext = getExt(x, y, r)
    lx = min(x - 1, r);
    ly = min(y - 1, r);
    rx = min(W - x, r);
    ry = min(H - y, r);
    ext = [lx rx ly ry];
end

% Extract the template window given the extension
function win = getWin(img, x, y, ext)
    win = img(y-ext(3):y+ext(4), x-ext(1):x+ext(2));
end


    % compute flow for each grid patch
    for i = 1:M
        for j = 1:N
            %------------- PLEASE FILL IN THE NECESSARY CODE WITHIN THE FOR LOOP -----------------
            % Note: Wherever there are questions mark you should write
            % code and fill in the correct values there. You may need
            % to write more lines of code to obtain the correct values to 
            % input in the questions marks.
            
            % extract the current patch/window (template)
            col = grid_x(j);
            row = grid_y(i);
            
            % where we'll look for the template
            tmpl_ext = getExt(col, row, template_radius);
        template = getWin(img1, col, row, tmpl_ext);
        % search window
        search_ext = getExt(col, row, search_radius );
        search_area = getWin(img2, col, row, search_ext);

            % where we'll look for the template
  
            %%%%%%%%%%%%%%%%%%%%%
          

            % compute correlation
            corr_map = normxcorr2(template, search_area);
            
            % Look at the correlation map and find the best match
            % The best match will have the Maximum Correlation value
            [~, max_ind] = max(corr_map(:));
            % Convert the index into row and col
            [max_ind_row, max_ind_col] = ind2sub(size(corr_map), max_ind);
            
            % express peak location as offset from template location
            U(i, j) = -search_ext(1) + max_ind_col-1 - tmpl_ext(2);

            V(i, j) = -search_ext(3) + max_ind_row-1 - tmpl_ext(4);
        end
    end
    
    % Any post-processing or denoising needed on the flow

    filter = fspecial('gaussian');
    U = imfilter(U, filter);
    V = imfilter(V, filter);
    % plot the flow vectors
    fig = figure();
    imshow(img1);
    hold on; quiver(grid_x, grid_y, U, V, 2, 'y', 'LineWidth', 1.3);
    % From https://www.mathworks.com/matlabcentral/answers/96446-how-do-i-convert-a-figure-directly-into-an-image-matrix-in-matlab-7-6-r2008a
    frame = getframe(gcf);
    result = frame2im(frame);
    hold off;
    close(fig);
end