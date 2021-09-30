## GC-FID 

This repository uses [MALDIquant](https://cran.r-project.org/web/packages/MALDIquant/index.html) to process two-dimensional GC-FID data.

To convert the `.dat` spectra, [OpenChrom](https://lablicate.com/platform/openchrom) is used.

![openchrom](img/Screenshot from 2021-09-30 09-56-53.png)

Open on [colab](http://colab.research.google.com/github/computational-chemical-biology/gc-fid/blob/master/explore_FID_data.ipynb)

To install the conda env:

```
conda env create -f environment.yml
```
To update the env:

```
conda env export | grep -v "^prefix: " > environment.yml
```
