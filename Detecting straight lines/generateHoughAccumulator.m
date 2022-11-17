function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
	% output array
    hough_img = zeros(rho_num_bins, theta_num_bins);
	
    [H, W] = size(img);
    
	% coordinate system
    [x, y] = meshgrid(1:W, 1:H);

    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------

    % YOU CAN MODIFY/REMOVE THE PART BELOW IF YOU WANT
    % ------------------------------------------------
    % here we assume origin = middle of image, not top-left corner
    % you can fix the top-left corner too (just remove the part below)
    centre_x = floor(W/2);
    centre_y = floor(H/2);
    x = x - centre_x;
    y = y - centre_y;
    % ------------------------------------------------

    % img is an edge image
    x_edge = x(img > 0);
    y_edge = y(img > 0);

    

    % Calculate rho and theta for the edge pixels
     
     % The diagonal of the image
     D = sqrt((H)^2 + (W)^2);

     % how many rho values should be there
     rho_step =(D)/(rho_num_bins - 1);

     %rho = (-ceil(D)+(rho_step)/2):rho_step:(ceil(D)-(rho_step)/2);

     % how many theta values should be there
     theta_step = (180 - 1)/(theta_num_bins - 1);

     % theta values separated by the steps 
     theta = (0):theta_step:(179);

    % Map to an index in the hough_img array
    % and accumulate votes.
    for i = 1 : size(x_edge,1)
        for k = 1 : length(theta)
            % rho value calculation
            rho1 = y_edge(i, 1) * cosd(theta(k)) - x_edge(i,1) * sind(theta(k));
            % index to map
            index = floor((rho1 + ceil(D/2)) / rho_step);
            % map for each edge point
            hough_img(index, k) = hough_img(index, k) + 1;                   
        end           
    end 

    % scale the values 0 to 255
    hough_img = (255 * mat2gray(hough_img));
    
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end

