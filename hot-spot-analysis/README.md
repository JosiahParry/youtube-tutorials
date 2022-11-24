# Hot Spot Analysis

Hot Spot Analysis is one of the most common uses of local indicators of spatial analysis (LISA). 


There are two videos: 

- [Hot Spot Analysis: the fundamentals](https://youtu.be/sjLyJW95fHM)
  - in which we discuss what a LISA is and briefly walk through the math of the Getis-Ord Local Gi & Gi* 
  
- [Hot Spot Analysis code walk through (Getis-Ord Gi)](https://www.youtube.com/watch?v=OnMNZwJywjs&ab_channel=JosiahParry)
  - In this code walk through we conduct a hot spot analysis using the Getis-Ord Local G (or Gi / Gi*) of Robbery in the metro Atlanta area using the R packages sfdep, dplyr, and ggplot2. We conclude by making a map of crime hot and cold spots.

See `exercise.R` for the code used in the video.


## Techniques

- Spatial Lag
- Global G
- Local G
- unnesting data frame columns

## Packages used 

- sfdep 
- dplyr
- ggplot2

## Resources

- [Local Indicators of Spatial Association - LISA](https://onlinelibrary.wiley.com/doi/10.1111/j.1538-4632.1995.tb00338.x)
- [Blog on Conditional Permution](https://josiahparry.com/posts/csr.html)
- 