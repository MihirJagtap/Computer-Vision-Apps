constraints: |rho| <= Image Diagonal
             0 <= theta < pi

To accumulate votes, we go through the x-edges and in an 
inner loop iterate through the values of theta (separated
by specific intervals or bins). I am taking my rho values 
using the formula rho = y * cos(theta(k)) - x * sin(theta(k)).
I am then taking out the row index by adding the rho with the 
half of the diagonal, as to stay in range, and dividing by rho
step to be consistent with spacing between two rho values.
Then assign the hough_img accumulator array with the row index. 
I am doing my algorithm because it is based on the fact that for 
every point on image space there is a line in parametric space and 
for every line in image space there is point on parameter space.
By the above algorithm, the waves by a single point on a straight line 
(in image space) cocncentrate on a single point which is our hough peak. 


I iterate through the number of rho and theta, and find which 
combination (in the accumulator array) gives greater value than 
the hough threshold specified. I am reversing the formula to get 
theta, rho and consecutive x and y values using the above formula.
I am taking cases when x=0 and another when y=0. From it I am able 
to find the slope and intercept of the line. We have to adjust 
according to the centre, so ranging x from -Width/2 to Width/2. 
I am then generating the y values for the adjusted x coordinates.
After that make an array for x going from 0 to W and y values
adjusted with the -H/2 to H/2 for the same reason as for x.
We pass x and y points for the line() to plot. 

To filter out the multiple parallel lines annotated in the image, 
I firstly padding zeros to the hough accumulator array. I am then 
considering a 5x5 matrix around the peak. When my hough image 
coordinate system, strong_hough_img(i,j) is e
qual to the 
max(max(strong_hough_img(i-5:i+5, j-5:j+5))) 


Having the approach same as line finder, in this line segment function
I am trying to create a segment by comapring a particular points neighbour
Where the edge value is 0 in the edge map, I try to stop drawing of line 
their. To implement the aforesaid idea, I am trying to find the 
sum(sum(edge_img(y_1-2:y_1+2, x_1-2:x_1+2))), in between I am dividing 
by 16 to fit the line in with my square where y_1 and x_1 are 
line coordinates (that is going to infinite) if this sum magnitude is 
greater than a specified threshold (I have taken 0.1 or 0.098), 
I am trying to draw a line with the specified [(x_1-1) x_1], 
[(y_1-m) y_1] coordinates. 
