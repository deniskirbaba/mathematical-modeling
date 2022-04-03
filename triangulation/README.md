## Delaunay triangulation

# Task description

The purpose of this work is to study the methods of triangulation on the plane and the implementation of iterative construction of triangular grids based on the Delaunay criterion.

<p align="center">
  <img width="600" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/plane_triangulation.jpg">
  <h6 align="center"><em>Figure 1. Triangulation of the space around the aircraft model for solving the problem of aerodynamics</em></h6>
</p>

First of all, we recall what the Delaunay criterion is. It is said that a triangular grid in the plane satisfies the Delaunay criterion (or is a Delaunay triangulation) if no other nodes of this grid fall inside the circle circumscribed around any triangle.

In particular, the Delaunay triangulation has the largest sum of the minimum angles of all its triangles, and also
the smallest sum of radii of circles circumscribed around triangles among all possible grids on the same system of points.

Since the values of the minimum angles appear explicitly in some estimates of the quality of the approximation, we can say that the Delaunay triangulation for a given set of points is, in a certain sense, optimal.

In the two-dimensional case, there is a simple method for reducing an arbitrary triangulation to a Delaunay triangulation. 
The idea is based on the fact that a pair of triangles that do not satisfy the Delaunay criterion can be replaced by a pair of dual triangles that already necessarily satisfy the criterion. This is achieved by rearranging the inner edge of the quadrilateral formed by the triangles (see Figure below). The operation "flip" is continued iteratively for each pair of triangles that do not satisfy the criterion, until such triangles remain.

<p align="center">
  <img width="350" src="https://github.com/pivp/mathematical-modeling/blob/76ad7c82bd954fbfb8d78bad9820f87636a1314f/triangulation/visualization/flip.png">
  <h6 align="center"><em>Figure 2. A grid that satisfies the Delaunay criterion (left) and does not satisfy it (right)</em></h6>
</p>

# Description of the algorithm

1. Formation of a set U (points) - a set of given nodes
2. Creation of the so-called "superstructure" (rectangle), which is an arbitrary convex polygon with triangular faces such that all given nodes lie inside it. The vertices of the polygon can be either U elements or additional nodes. In the future, up to a certain stage, these nodes are treated like all the others
3. Formation of a set G of grid nodes, where all nodes U used as vertices of the superstructure (if any) are transferred.
4. If a triangle is used as a superstructure, go to step 5; otherwise, a Delaunay triangulation is formed based on the nodes of the superstructure. If a regular polygon is used as a superstructure, then this can be done as follows: choosing an arbitrary node from U, transfer it to G and, by inserting edges between this node and all the vertices of the polygon, form a grid of n triangles, where n is the number of faces, equal to 8 or 20 respectively. This grid will
be a Delaunay triangulation
5. Search for all triangles of the grid of centers and radii of the circumscribed circle
6. Choosing an arbitrary node q from the set U and moving it to G, then deleting all triangles for which q falls inside the circumscribed circle. In this case, a cavity is formed in the grid in the form of a polygon, in the general case having a star shape. Moreover, any ray emanating from q must intersect the boundary of this polygon at a single point. If triangles are found for which q lies in the plane of one of the faces (this is possible if the Delaunay triangulation is ambiguous, for example, if five or more points lie on the same circle), then they must also be removed. Note that an edge (or face) is actually removed only if all triangles adjacent to it are removed; the edges and faces of the superstructure are never removed. New triangles are formed by inserting edges between q and the vertices of this polygon.
It is proved that in this case a Delaunay triangulation is obtained.
7. Finding the center and radius of the circumscribed sphere for newly formed triangles
8. If the set U is not empty, then go to step 6, otherwise go to step 9.
9. Removal from the mesh of all triangles whose vertices include auxiliary nodes used to build the superstructure. The result is a mesh built only on the given nodes (G).

# Description of files for the program to work

The work was done in the Matlab language.

The input data is a randomly generated array of points on the plane contained in the file *points.dat*. There are 300 points in total.

*customTriangulation.m* - the main work program - the program builds a triangulation with the visualization of each iteration. In the program, you can choose the time (in seconds) of each step by changing the variable *updateTime*. The program also uses functions that perform various actions that are located in the */fucntions* folder.

*builtinTriangulation.m* - performs triangulation using the built-in matlab function.

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
