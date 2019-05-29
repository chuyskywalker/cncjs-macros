# cncjs-macros

Some CNCJS macros I used on my Shapeoko 3, but I suppose they could work elsewhere too!

- [xyz.nc](./xyz.nc) This is designed for a touch plate which has a hole centered on XY position you wish to find and will also use the probe surface to find the depth. It includes a "tool change" pause to allow you to remove the probe and then will move back to 0,0,0 (ie: the corner of your workpiece.) It is designed to be used on the lower left WCS of your workpiece.
- [xy.nc](./xy.nc) Same as above, but reduced to just find the XY position.

Here's [a video showing off what this does](https://youtu.be/YRHsWt38QY8).
