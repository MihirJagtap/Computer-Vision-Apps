# Detecting Straight Lines using Hough Transform

Our task is to develop a vision system that recognizes lines in an image using the Hough
Transform. We will call it the line finder . Test your line finder on these three images:
hough_1.png, hough_2.png, and hough_3.png.


The line finder pipeline is divided into four sub-parts, each corresponding to a program you
need to write. 

[1] We need to find the edge pixels in the image. Used the built-in edge
function to generate an edge image from the input gray-level image.

[2] We need to implement the Hough Transform for line detection. The line equation
y = mx + c is not suitable, as it requires a
huge accumulator array. So, use the equation
x sin(θ) – y cos(θ) + ρ = 0.
Be careful while choosing the range of possible θ and ρ values and the number of bins
for the accumulator array. A low resolution will not give you sufficient accuracy in the
estimated parameters. On the other hand, a very high resolution will increase
computations and reduces the number of votes in each bin. If you get bad results, you
may want to vote for a small patch of bins rather than a single bin in the accumulator
array. After voting, scale the values of the accumulator so that they lie between 0 and
255, and return the resulting accumulator.

[3] To find strong lines in the image, scan through the accumulator array looking for“ ”
peaks. You can either use a standard threshold to find the peaks or use a smarter
method. Briefly explain the method you use to find the peaks in your README. You
can assign zero to hough_threshold if you did not use the standard threshold method.
After having detected the peaks that correspond to lines, draw the detected lines on a
copy of the original image (using the MATLAB line function). Make sure you draw
the line using a color that is clearly visible in the output image. 

[4] Note that the above implementation does not detect the end-points of line segments in
the image. Implement an algorithm that prunes the detected lines so that they
correspond to the line segments from the original image (i.e., not infinite). Briefly
explain your algorithm in the README. Again, you can assign zero to
hough_threshold if you did not use the standard threshold method.

# Run 


```
Run the runHw2.m file in MATLAB
```

# Additional Notes:

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
