# Week 1 Tutorial: Introduction to MATLAB  

**Date:** 15/01/2026  
**Script:** `/Users/nicolestott/Documents/GitHub/Visual_systems/Lab1-Introduction/matlab/week1.m`

---

## Summary  

This lab introduced the representation of images as numerical matrices in MATLAB and explored how geometric transformations can be implemented through linear algebra. The focus was not simply on applying built-in functions, but on understanding how rotation and shearing operate at pixel level using transformation matrices and reverse mapping.

---

## Representing Images as Matrices  

After loading the `clown` image:

```matlab
load clown
imshow(clown)
```

Accessing a specific pixel:
```matlab
clown(20,319)
```
returns a single grayscale intensity value. This proves the idea that an image is simply structured numerical data.

---

## Task 1 - Image rotation

```matlab
ImageOut = rotate(clown, 30);
imshow(ImageOut)
````
Observations:
- The image rotates correctly about its centre, confirming that subtracting and re-adding the centre point is essential.
- Clipping occurs at the boundaries because the output matrix must remain the same size.
- Using reverse mapping avoids holes in the output image.
- Nearest neighbour interpolation introduces slight jaggedness along diagonal edges.

With this excercise I understood that image transformations are basically coordinate transformations. Forward mapping leaves empty pixels because multiple source pixels may map to the same destination, while reverse mapping ensures every destination pixel is assigned a value.

---

## Task 2 - Image shearing

```matlab
ImageOut2 = shear(clown, 2, 1);
imshow(ImageOut2)
````

Observations
- The image appears slanted while maintaining structural coherence.
- The centre pixel remains stationary, confirming correct centring.
- Extreme shear values produce significant distortion and clipping.
- As with rotation, reverse mapping prevents holes in the output.

---

## Reflection

Rather than relying on built-in functions such as imrotate, constructing the transformations made the underlying geometry more understandable. It also highlighted how small implementation decisions influence quality.