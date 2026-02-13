# Week 2 Tutorial: Colour Perception  

**Date:** 22/01/2026  
**Script:** `/Users/nicolestott/Documents/GitHub/Visual_systems/Lab2-Colour-Perception/matlab/week2.m`

---

## Summary  

This lab connected human colour perception with computational colour representation in digital images. In Part 1, I observed how perception can be biased by brain interpretation. In Part 2, I explored how MATLAB stores and transforms colour images across colour spaces (RGB, Grayscale and HSV), and how separating channels changes what visual information becomes emphasised.

---

## Finding My Blind Spot  

Following the video instructions, I found a distance where the secondary object disappeared even though it was still on-screen. The key observation is that the eyes do not see across the entire retina. This happens because the optic nerve exits the retina at the optic disc, which contains no photoreceptors. No visual data is captured there, so the missing area is filled in perceptually using surrounding context and information from the other eye. 

---

## Ishihara Colour Test  

I completed the Ishihara plates by identifying the embedded numbers. I was able to correctly identify all the plates shown. The Ishihara test targets red–green colour vision deficiencies by designing dot patterns that are confusing for long (L) and medium (M) wavelength cones. This test showed how colour perception depends heavily on cone sensitivity.

---

## Reverse Colour Afterimage  

After staring at the altered-colour American flag and then shifting my gaze to a blank white surface, I perceived the flag in normal red, white, and blue. The effect was strongest immediately after switching gaze and faded within a few seconds and the colours were the opposites of what I had been staring at. Staring at a colour fatigues the corresponding cone responses and when the stimulus is removed, the opponent channels dominate, producing a complementary afterimage.

---

## Troxler’s Fading  

When fixating steadily, peripheral details gradually faded or disappeared.

**Observations:**  
- The fading increased the longer I maintained fixation.
- Small movements (blinks or shifts in gaze) restored the faded details.

This supports the idea that the visual system prioritises change. When the retinal image is stable, neural responses adapt and reduce sensitivity, so stationary peripheral stimuli fade from awareness. It links to how the brain filters constant input to reduce overload, but it does not mean that it isn't present.

---

## Brain Sees What It Expects  

### Table illusion 
Even when measuring, the perceived length did not match the physical measurement at first glance. This illusion relies on depth and perspective cues. The brain interprets the shapes as 3D objects in space, then applies size corrections. The “longer” table is perceived that way because the brain compensates for implied depth, effectively over-correcting.

### Checker shadow illusion (A vs B)  
My immediate perception was that one square was darker, but when isolated, they matched. This shows brightness is contextual, the brain interprets the surface colour by mentally subtracting the effect of the shadow which is usually helpful in natural environments. The illusion shows that perception of luminance is not based purely on retinal intensity but also on inferred scene lighting.

---

## The Grid Illusion  

While staring at the centre, dark spots appeared and disappeared at intersections. This is consistent with how lateral inhibition and centre-surround receptive fields emphasise contrast. Peripheral vision is more susceptible because receptive fields are larger, making the illusion stronger away from fixation.

---

## Café Wall Illusion  

The horizontal mortar lines appeared tilted even though they are parallel.

**Observations:**  
- The effect weakened when contrast was reduced.
- The “tilt” was strongest where high-contrast edges met.

**Reflection:**  
The illusion likely arises from how edge detection and contrast interactions influence perceived orientation. The brain extracts structure from local contrast cues, and repeated high-contrast offsets bias global alignment perception.

---

## The Silhouette Illusion  

While watching the spinning dancer, I experienced an occasional flip in perceived rotation direction.

**Reflection:**  
This demonstrates perceptual ambiguity: the stimulus lacks depth cues, so the brain alternates between two valid 3D interpretations. The “switch” suggests perception is an active hypothesis rather than a fixed outcome.

---

## The Incomplete Triangles  

When counting triangles, I initially underestimated the total. On closer inspection, additional triangles emerged from grouping and implied edges.

**Reflection:**  
This shows how the brain completes shapes based on Gestalt principles (closure and grouping). The image contains more structure than is immediately obvious because perception prioritises coherent forms over raw geometry.

---

# Part 2 — Exploring Colours in MATLAB  

## Task 10 — RGB to Grayscale  

I loaded the `peppers.png` image and converted it to grayscale.

```matlab
%% Image information
imfinfo('peppers.png')

%% RGB
RGB = imread('peppers.png');  
imshow(RGB)

%% Greyscale image
I = rgb2gray(RGB);
figure
imshow(I)

%% Montage with title
figure
imshowpair(RGB, I, 'montage')
title('Original colour image (left) grayscale image (right)');
```

Observations and reflections:
The grayscale image preserved structure (edges, shapes, lighting) but removed colour-based distinctions.
Some objects became harder to distinguish because colour contrast was doing a lot of the segmentation work. Grayscale conversion compresses three channels into one using weighted sums which reflect human sensitivity to luminance. 

## Task 11 - Splitting RGB channels

```matlab
%% Split into Red, Green and Blue
figure
[R,G,B] = imsplit(RGB);
montage({R, G, B},'Size',[1 3])
```
Observations and reflections:
Red peppers were strongest in the red channel and darker in the blue channel, yellow/green peppers showed strong signal in both red and green channels, white objects (such as garlic highlights) appeared bright across all channels. Channel splitting made it obvious that colour in digital images is the relationship between channel intensities. This also helped me understand how certain features become more detectable depending on which channel you analyse.

## Task 12 - RGB to HSV

```matlab
%% Convert RGB to HSV
figure
HSV = rgb2hsv(RGB);
[H,S,V] = imsplit(HSV);
montage({H,S,V}, 'Size', [1 3])
```

Observations and reflections:
Hue (H) separated colour identity more than brightness, saturation (S) highlighted vivid regions vs dull/neutral areas and value (V) resembled a brightness map (closer to luminance perception).
HSV felt closer to how people describe colour, whereas RGB is more about how devices portray light. This helped clarify why HSV is useful in segmentation and colour-based filtering as it separates “what colour” from “how bright,” which can make algorithms more robust under lighting changes.

# Overall

This lab made a strong connection between perceptual and computational image representations. In Part 1, I saw multiple examples where perception is shaped by adaptation, contrast and expectation rather than raw retinal input. In Part 2, working with RGB and HSV reinforced that digital colour is just structured data, and different colour spaces reveal different aspects of the same image. Overall, the lab showed me that both biological and computational vision involve transformations that prioritise certain information while discarding other.