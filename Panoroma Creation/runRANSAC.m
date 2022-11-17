function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    m = length(inliers_id);
    
    for iter = 1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------

        
        inds = randperm(num_pts , 4);

        H_3x3 = computeHomography(Xs(inds,:), Xd(inds,:));

        ap_d = applyHomography(H_3x3, Xs); %nx2

        
        dist = sqrt(sum((ap_d - Xd).^2,2)); % 1 x n

        

        index = pts_id(dist < eps);

        if m < length(index)
             
             inliers_id = index; 
             m = length(inliers_id);
             H = H_3x3;
        end


        

        
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------
    end    
end
