# HeartJ
Package of ImageJ macros for quantification of cardiac histology.

Required plugins: MorphoLibJ_-1.4.0, Read and Write Excel

---
### HeartJ_Gomori

* [HeartJ-Gomori.txt](HeartJ_Gomori_v5.txt)

Image requirements: Gomori silver staining for reticulum, standard image formats like BMP, GIF, JPEG, PNG, or TIFF.

This macro measures the size of cardiomyocytes (Group 1) in different parameters on slides stained with Gomori silver staining. The results are reported in an Excel spreadsheet on the desktop, which contains the individual results as well as an average value. An overlay image and color-coded instances will also be created. In addition, the size of the nuclei of the cardiomyocytes (Group 2) and the size of the capillaries (Group 3) are measured. Furthermore, the number of capillaries bordering each cardiomyocyte is measured (capillary contacts).

---
### HeartJ_WGA+DAPI+CD31

* [HeartJ_FL_WGA+DAPI+CD31_v8.txt](HeartJ_FL_WGA+DAPI+CD31_v8.txt)

Image requirements: Immunofluorescence staining (WGA (Channel: Green), Nuclei (e.g. DAPI) (Channel: blue), Capillaries (e.g. CD31) (Channel: red)), standard image formats like BMP, GIF, JPEG, PNG, or TIFF.

This macro measures the size of cardiomyocytes (Group 1) in different parameters on slides stained with WGA+CD31+DAPI. The results are reported in an Excel spreadsheet on the desktop, which contains the individual results as well as an average value. An overlay image and color-coded instances will also be created. In addition, the size of the nuclei of the cardiomyocytes (Group 2) and the size of capillaries (Group 3) are measured. Furthermore, the number of capillaries bordering each cardiomyocyte is measured (capillary contacts).

---
### HeartJ_WGA+DAPI+intramyo-signal

* [HeartJ_FL_WGA+DAPI+intramyo-signal_v2.txt](HeartJ_FL_WGA+DAPI+intramyo-signal_v2.txt)

Image requirements: Immunofluorescence staining (WGA (Channel: Green), Nuclei (e.g. DAPI) (Channel: blue), intramyozyte or/and intramyocyte-nuclei signal (e.g. pro-ANP) (Channel: red)), standard image formats like BMP, GIF, JPEG, PNG, or TIFF.

This macro measures the size of cardiomyocytes (Group 1) in different parameters on slides stained with WGA+CD31+intramyozyte and intramyocyte-nuclei signal. The results are reported in an Excel spreadsheet on the desktop, which contains the individual results as well as an average value. An overlay image and color-coded instances will also be created. In addition, the size of the nuclei of the cardiomyocytes (Group 2) are measured. Furthermore an intramyozyte and intramyocyte-nuclei signal in channel red is measured, the result is reported as %-value per signal instances.
