function index_map = generateIndexMap(gray_stack, w_size)
    [H, W, N] = size(gray_stack);
    
    % Compute the focus measure -- the sum-modified laplacian
    %
    % horizontal Laplacian kernel
    Kx = [0.25 0 0.25;...
           1  -3   1; ...
          0.25 0 0.25];
    Ky = Kx';   % vertical version
    
    % horizontal and vertical Laplacian responses
    Lx = zeros(H, W, N);
    Ly = zeros(H, W, N);
    for n = 1:N
        I = im2double(gray_stack(:,:,n));
        Lx(:,:,n) = imfilter(I, Kx, 'replicate', 'same', 'corr');
        Ly(:,:,n) = imfilter(I, Ky, 'replicate', 'same', 'corr');
    end
    
    % sum-modified Laplacian
    %SML = (abs(Lx) .^ 2) + (abs(Ly) .^ 2);
    % can also use the absolute value itself
    % this is probably more well-known
    SML = abs(Lx) + abs(Ly);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ADD YOUR CODE HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    index_map = size(gray_stack);
    filter = fspecial('average');
    focus_filter = imfilter(SML, filter);

    
    cum_sum_focus = cumsum(cumsum(focus_filter, 1), 2);
    upper_edge = 0;
    left_corner = 0;

    
    for img = 1 : N
        
        for y = 1 : H

            ceiling = y - (w_size + 1); 
            
            if (ceiling < 1)
                ceiling = upper_edge;
            end


            bottom = y + w_size;

            if (bottom > H)
                bottom = H;
            end 
   
            for x = 1 : W

                left  = x - w_size - 1;
                
                if (left < 1)
                    left = left_corner;
                end

                right = x + w_size;

                if (right > W)
                    right = W;
                end

                region_area = (bottom - ceiling) * (right - left);
                
                if and(ceiling  == upper_edge, left == left_corner)
                    
                    avg_sum = cum_sum_focus(bottom, right, img) / region_area;
                    
                    index_map(y,x,img) = avg_sum;
                else
                   
                    if (left == left_corner)

                        avg_sum = (cum_sum_focus(bottom, right, img) - cum_sum_focus(ceiling, right, img)) / region_area;
                        
                        index_map(y,x,img) = avg_sum; 
                    else
                        
                        if (ceiling == upper_edge)

                            avg_sum = (cum_sum_focus(bottom, right, img) - cum_sum_focus(bottom, left, img)) / region_area;

                            index_map(y,x,img) = avg_sum; 
                        
                        else
                            avg_sum = (cum_sum_focus(bottom, right, img) - cum_sum_focus(bottom, left, img) - ...
                                cum_sum_focus(ceiling, right, img) + cum_sum_focus(ceiling, left, img)) / region_area;

                            index_map(y,x,img) = avg_sum;
                        end
                    end
                end
            end
        end
    end

    [~, index_map] = max(index_map, [], 3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end