## Fractals

![]()
<h6 align="center"><em>Work of the built program</em></h6>

# Task description

The task of the work is as follows: to study the concept of fractals and implement their own fractal set in Wolfram Mathematica app.  
  
A fractal is a set that has the property of self-similarity (an object that exactly or approximately coincides with a part of itself, that is, the whole has the same shape as one or more parts).  

<p align="center">
  <img width="600" src="">
  <h6 align="center"><em>Figure 1. The Mandelbrot set is a classic example of a fractal</em></h6>
</p>

Necessary condition for a fractal: with one iteration of crushing, more than one figure similar to the figure in the previous iteration appears.  
  
The original object is an equilateral triangle.  
At each iteration, this triangle is divided into 4 equal equilateral internal triangles, then the three outer triangles must be transformed in such a way that the angle between the corresponding side of the central triangle and the corresponding side of each of the outer triangles is 90 degrees, and the outer triangles touch in the middle of the sides of the central triangle.  
Further, the operation described above is applied to the three extreme triangles.  
  
In order to obtain the required configuration of the extreme triangles, it is necessary to shift and rotate relative to the point of the corresponding midpoint of the corresponding side of the central triangle.  
To make a rotation about a given point, you need to move the figure to the origin, make a rotation already relative to the origin, and then move it back.  

# Description of the algorithm

Each triangle is represented by a list of its vertex coordinates (passing the vertices counterclockwise).  
Array *sideTriangles* will contain the objects of the extreme triangles, and array *centralTriangles* will contain the central triangles (we will draw them in red).  
To draw a triangle and apply transformations to the triangle, let's create functions *drawTriangle* and *transformTriangle*, respectively.  
Further, depending on the number of given iterations *n*, we will go through all the triangles in array *sideTriangles* and apply to them a function *splitTriangle*  that divides the triangle into 4 equal ones, applies a transformation to the 3 extreme ones, and writes the central one to the *centralTriangles* array.  
At the end, we visualize the resulting fractal object in two ways: with and without central triangles.  

# Visualization of the program

<p align="center">
  <img width="800" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/initialDots.png">
  <h6 align="center"><em>Figure 3. Location of anchor points</em></h6>
</p>

<p align="center">
  <img width="800" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/150dots.png">
  <h6 align="center"><em>Figure 4. Grid at 50% completed program (150 dots)</em></h6>
</p>

<p align="center">
  <img width="800" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/customTriangulation.png">
  <h6 align="center"><em>Figure 5. The final grid of the customTriangulation.m program</em></h6>
</p>

<p align="center">
  <img width="800" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/builtinTriangulation.png">
  <h6 align="center"><em>Figure 6. The grid of the builtinTriangulation.m program</em></h6>
</p>