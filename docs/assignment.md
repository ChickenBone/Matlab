The overall goal of this computational project is to compute 2D strain 
 from a computational mesh with nodes defined in 3D. You may use any code you prefer (MATLAB, Python, ... C?) to complete the project but it of course must be your own code.

1. Data Management - Reading the Mesh

The first task is to simply read in the mesh. It is stored in UCD (unstructured cell data) format, which is described in several Links to an external site. different Links to an external site. places Links to an external site. on the web, but for our purposes may be simplified as

A single header line containing #nodes, #elem, and three more numbers we can ignore (for now);
#node lines containing node id (integer), x, y, z coordinates (double precision);
#elem lines containing elem id, material id (ignore), elem_type (it will always be 'tri'), and element nodal connectivity - that is, 3 node ids that define the element.
For part 1, there are 6 meshes that you can use (and will need to do things with). Two are provided below:

Basic2D_Reference.ucd Download Basic2D_Reference.ucd          Adv2D_Reference.ucd Download Adv2D_Reference.ucd  

Looking at these files (they're ASCII), notice that all the nodes' z-coordinate is 1. What this means is that they are simply in an X-Y plane already (to make things easy to start out with).

How you read this in (MATLAB: fopen/fscanf, textscan, readmatrix? / Python: genfromtxt, read_table,...) is up to you, but you do not have to be fancy with it. At the end of the read, it is enough to have a #nodes×3 matrix of nodal coordinates, and a #elems×3 matrix of element connectivity.

2. First Strain Computation - 2D coords.

Towards the end of lecture 15 I introduce the matrix equation:

Untitled.png

in which A is the area of the element (triangle - computable using a simpler matrix expression given at the end of lecture 15), 
, 
, or nodal coordinate differences for the element (i.e. 
 is the x-coordinate of node i), and a 
 is the c-axis (x or y) displacement of node n (n = 1, 2, or 3). For the purposes of computing strain, the area and nodal coordinate differences are always computed from the reference, or undeformed mesh (the ones above), and the displacements are computed from the difference in coordinates from a deformed mesh (such as the two below) and the reference mesh. Two deformed meshes:

Basic2D_Deformed.ucd Download Basic2D_Deformed.ucd          Adv2D_Deformed.ucd Download Adv2D_Deformed.ucd  

So, with the mesh reader (step 1), you can read in the two meshes of each type (Basic or Advanced), IGNORE the z-coordinate, compute the reference values (A, xij, yij), determine the differences in position of the nodal coordinates between the reference and deformed meshes, and compute strain for each element. This of course is done one element at a time. LOOPS!

3. Projection of 3D Elements into local 2D coordinate system.

OK, here is where things REALLY get fun. We of course actually live in 3 spatial dimensions, and so too models must consider all three dimensions. To analyze a translating, rotating, deforming planar (triangle) element in 3D, we must first project the element (reference or deformed) into its own 2D "local" coordinate system. This system is defined as follows:

The x-axis is defined by the vector that points from the 1st node to the 2nd node;
The normal direction is defined by the vector cross product of the x-axis and the vector pointing from the 1st node to the 3rd node;
The y-axis is defined by the cross product of the normal and the x-axis.
Each of these can be computed (per element) and immediately normalized (i.e. made of unit length). Note that vector direction is important; note too that these axes remain 3D vectors - they may have nonzero z-length once you are using 3D meshes.

Once the local axes are defined, the local (x, y) nodal coordinates may be found. It is simple enough to assume that node 1 will always be at (0, 0), then find the other two coordinates with respect to it. To do this, we

Find the vector that points from node 1 to the other node (2 or 3) - note we did this above already;
Find the dot products of this vector with the normalized x-axis (yields x coordinate) and with the normalized y-axis (yields y coordinate).
Note that because the x-axis is defined as the vector from node 1 to node 2, node 2's y-coordinate will always be zero.

So, we need to compute these for each element, and save (at least) the local (x, y) coordinates for each node long enough to perform strain calculation...  this is where using a structure (or object) may start to come in handy. You don't have to be efficient - this projection can happen repeatedly per element if it helps with data management (i.e. just compute the values when you need them, don't save them).

Test this process with the two 2D reference meshes above, and the two 3D reference meshes below:

Basic3D_Reference.ucd Download Basic3D_Reference.ucd           Adv3D_Reference.ucd Download Adv3D_Reference.ucd 

These 3D meshes are just rotated, translated versions of the 2D meshes - thus, once transformed, their local coordinates should be pretty much the same (w/in 1e-6) as the 2D local coordinates. That is, once both are transformed, they should be very close to equal. But, why check that way? Instead, compute the "local" strains from the 2D meshes and the 3D meshes with these 3D deformed meshes. If they are the same, you're golden.

Basic3D_Deformed.ucd Download Basic3D_Deformed.ucd             Adv3D_Deformed.ucd Download Adv3D_Deformed.ucd

4. Reduced / simplified strain-displacement relation.

Noting from the projection details above that the local coordinates of node 1 will always be (0, 0), and the y-coordinate of node 2 will always be zero, with a symbolic processor (MUCH preferred) or if you really want, by hand, simplify the strain-displacement relationship above. I recommend using Mathematica. Note that the Area (A) is also a function of nodal coordinates and should also be simplified... and area of a triangle is of course just ½ base × height.

What to turn in.

Your code - functions that: 1) read the mesh; 2) compute strain (using complete expression in item #2, not reduced - you don't have  to code that up yet); 3) find element local vectors (n21 and n31) and axes (x, y, normal); and 4) project 3D elements into 2D local coords - and a script (script is fine) that runs the whole thing (does loading, calls appropriate things to compute strains).
For #2, a listing (output) of the three strains for elements 100-110 for the advanced mesh.
For #3, a listing (output) of strain from the advanced mesh elements 2, 3, 4 projected into local coords from either 2D and 3D meshes
For #4, a printout of the reduced strain-displacement equations - really this will be three equations, one for each strain, defined in terms of whatever is non-zero.
A document (text is fine) that describes each person's contribution to this assignment.
It should be easy to see in the codes where they are creating the  listings for items #2 and #3.