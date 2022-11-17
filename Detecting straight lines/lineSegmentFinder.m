function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
    fig = figure();
    imshow(orig_img);

	% --------------------------------------
	% START ADDING YOUR CODE HERE
	% --------------------------------------

    [H, W] = size(orig_img);    
    [N_rho, N_theta] = size(hough_img);	

    % have a edge map ready
    edge_img = edge(orig_img,"canny",0.1);

    % You'd want to change this.	
	strong_hough_img = hough_img;

    % padding the img with zeros

    % padding the rho axis with zeros
    strong_hough_img(:, N_theta+1) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+2) = zeros(N_rho, 1);
    strong_hough_img(:, N_theta+3) = zeros(N_rho, 1);

    % padding the theta axis with zeros
    strong_hough_img(N_rho+1,:) = zeros(1, N_theta+3);
    strong_hough_img(N_rho+2,:) = zeros(1, N_theta+3);
    strong_hough_img(N_rho+3,:) = zeros(1, N_theta+3);

    % the diagonal
    d = (sqrt(H^2+W^2));
	
    for i = 4:N_rho
        for j = 4:N_theta
            if strong_hough_img(i, j) > hough_threshold
                % filter out parallel lines
                max_mag = max(max(strong_hough_img(i-3:i+3, j-3:j+3)));
            	
            	% if the point (i,j) in hough img corresponds to our max
                % peak then consider it
                if strong_hough_img(i,j) == max_mag
                
                    % map to corresponding line parameters 
                    rho = ((1*i*(d))/(N_rho - 1)) - ceil(d/2);
                    theta = ((j*179)/(N_theta - 1));
            	    % generate some points for the line
                    % when x = 0
                    y = rho/cosd(theta);
                    % when y = 0
                    x = -rho/sind(theta);

                    % the slope
                    slope = (-y)/(x); 


                    % when x = 0 and y = rho/cosd(theta)

                    % the intercept
                    c = y;

                    % start looking for neighbours
                    for x1 = (-floor(W/2) + 3) : (floor(W/2) - 2)
                     
                        y1 = (slope * x1) + c;

                        % adjusting the y coordinates
                        y_1 = round(y1 + floor(H/2));

                        % adjusting the x coordinates
                        x_1 = round(x1 + floor(W/2));

                        % if y > 2 and y < H 
                        % here i am trying to keep the coordinates within
                        % the image height
                        if and(y_1 > 2 , y_1 < H - 1)

                            % find out the sum of the sum of the edge img 
                            % FROM SPECIFIED COORDINATES
                            sum_mag = sum(edge_img(y_1 - 2 : y_1 + 2, ...
                                x_1 - 2 : x_1 + 2));

                            % find the sum and divide by 16 to fit it in
                            sum_mag = (sum(sum_mag))/16;

                            % I am setting a threshold for the sum to be
                            % max 
                            if sum_mag >= 0.098

                                % x coordinates should go from x_1 -1
                                x2 = x_1 - 1;

                                % y coordinates should go from y_1 -slope
                                y2 = y_1 - slope;

                                % plot the line
                                hold on;

                                % the array of x-coordinates go from
                                % previous to current coordinate and i am
                                % taking y-coordinate from y minus its
                                % slope till the y coordinate that i
                                % calculated
                                line([(x2) x_1], [(y2) y_1], ...
                                    'Color', 'blue', 'LineWidth',4)
                            end
                        end
                    end 
                end
            end
        end
    end

    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------

    % provided in demoMATLABTricksFun.m
    cropped_line_img = saveAnnotatedImg(fig);
    close(fig);
end
