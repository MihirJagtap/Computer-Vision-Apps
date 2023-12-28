
function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
    fig = figure();
    imshow(orig_img);

	% --------------------------------------
	% START ADDING YOUR CODE HERE
	% --------------------------------------
    
    [H, W] = size(orig_img);    
    [N_rho, N_theta] = size(hough_img);
	
	% You'd want to change this.	
	strong_hough_img = hough_img;

    % padding the img with zeros

    % padding the rho axis
    strong_hough_img(:, N_theta+1) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+2) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+3) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+4) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+5) = zeros(N_rho, 1);

    % padding the theta axis
    strong_hough_img(N_rho+1,:) = zeros(1, N_theta+5);
    strong_hough_img(N_rho+2,:) = zeros(1, N_theta+5);
    strong_hough_img(N_rho+3,:) = zeros(1, N_theta+5);
    strong_hough_img(N_rho+4,:) = zeros(1, N_theta+5);
    strong_hough_img(N_rho+5,:) = zeros(1, N_theta+5);
 
    % the diagonal
    d = (sqrt(H^2+W^2));
	
    for i = 6:N_rho
        for j = 6:N_theta
            if strong_hough_img(i, j) > hough_threshold
                % filter out parallel lines
                max_mag = max(max(strong_hough_img(i-5:i+5, j-5:j+5)));
            	
                % if the point (i,j) in hough img corresponds to our max
                % peak then consider it
                if strong_hough_img(i,j) == max_mag
                
                    % map to corresponding line parameters 
                    rho = ((1*i*(d))/(N_rho - 1)) - floor(d/2);
                    theta = ((j*179)/(N_theta - 1));

            	    % generate some points for the line

                    % when x = 0
                    y = rho/cosd(theta);
                    % when y = 0
                    x = -rho/sind(theta);

                    % slope
                    m = (-y)/(x); 


                    % when x = 0 and y = rho/cosd(theta)

                    % intercept
                    c = y;

                    % x-axis adjusted to be in center
                    x1 = -floor(W/2)+1;

                    x2 = floor(W/2);

                    y1 = m * (x1) + c;

                    y2 = m * (x2) + c;

            	    % and draw on the figure
            	    

                    x_line = [0 W];

                    y_line = [(y1 + floor(H/2)) (y2 + floor(H/2))];

                    % ('hold on;' and call the line() function).
                    hold on;
                    line(x_line,y_line,'Color','blue','LineWidth',4)
                end
            end
        end
    end
    
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------

    % provided in demoMATLABTricksFun.m
    line_detected_img = saveAnnotatedImg(fig);
    close(fig);
end
