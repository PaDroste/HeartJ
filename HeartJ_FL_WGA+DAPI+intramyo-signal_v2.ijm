// HeartJ_FL_WGA+DAPI+intramyo-signal_v2.ijm
// Written by Patrick Droste, LaBooratory of Nephropathology, Institute of Pathology and Division of Nephrology and Clinical Immunology, RWTH Aachen University Hospital, Aachen, Germany
// Last updated on 2023 April
//
//This macro measures the size of cardiomyocytes (Group 1). The results are reported in an Excel spreadsheet on the desktop, which contains the individual results as well as an average value. In addition, the size of the nuclei of the cardiomyocytes (Group 2) are measured. Furthermore an intramyozyte and intramyocyte-nuclei signal in channel red is measured, the result is reported as %-value.
//
//Required plugins: MorphoLibJ_-1.4.0, Read and Write Excel
//
//Requirements for images: WGA (Channel: Green), Nuclei (DAPI) (Channel: blue), Intramyocyte Signal (Channel: red)
//
//
macro "HeartJ_FL_WGA+DAPI+intramyo-signal_v2 [q]" {
a = getTitle();
run("Clear Results");
//
//
//Define as "scale" how many pixels are a micrometer (1µm = "scale" Pixel).
scale = 12.9
//
//Define size thresholds in micrometer
minCardio = 60
maxCardio = 4000
minNuc = 6
maxNuc = 100
//
// Threshold for intramyocyte signal
T = 50
//
//
run("Set Scale...", "distance=scale known=1 unit=µm global");
run("Duplicate...", "title=Merge");
selectWindow(a);
run("Split Channels");
//Cardiomyocytes segmentation
selectWindow(a+" (green)");
run("Morphological Segmentation");
waitForUser("Define the tolerance value","Find the appropriate tolerance for this image. Enter a tolerance (usually between 10 to 20), click on Run. If the tolerance fits, click OK. If the tolerance does not fit, enter a new tolerance and repeat the process.");
call("inra.ijpb.plugins.MorphologicalSegmentation.setDisplayFormat", "Watershed lines");
wait(4000)
call("inra.ijpb.plugins.MorphologicalSegmentation.createResultImage");
run("Options...", "iterations=1 count=1 black");
rename("Cardiomyocytes Segmentation");
selectWindow("Morphological Segmentation");
run("Close");
selectWindow("Log");
run("Close");
//Manually correction of segmentation
selectWindow("Cardiomyocytes Segmentation");
run("Create Selection");
roiManager("Add");
selectWindow("Merge");
roiManager("Show All");
run("Line Width...", "line=4");
run("Colors...", "foreground=black background=black selection=red");
waitForUser("Correction of segmentation","Correct the segmentation by drawing missing lines and clicking Add in the ROI Manager.");
selectWindow("Cardiomyocytes Segmentation");
//Cardiomyocyte measurement
run("Set Measurements...", "area area_fraction feret's redirect=None decimal=3");
run("Line Width...", "line=2");
roiManager("Select all");
roiManager("Draw");
roiManager("Delete");
run("Dilate");
run("Invert");
run("Dilate");
run("Dilate");
setThreshold(0, 100);
rename("Cardiomyocytes");
run("Analyze Particles...", "size=minCardio-maxCardio circularity=0.00-1.00 summarize exclude include add");
x = roiManager("count");
for(i=0; i<x; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(1);
roiManager("Set Color", "magenta");
 }
selectWindow(a+" (green)");
close();
selectWindow("Cardiomyocytes");
close();
// Nuclei
selectWindow(a+" (blue)");
rename("Cardiomyocytes nuclei");
RoiManager.selectGroup(1);
roiManager("Combine");
run("Clear Outside");
setAutoThreshold("Huang dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Dilate");
run("Dilate");
run("Fill Holes");
run("Erode");
run("Erode");
run("Erode");
run("Analyze Particles...", "size=minNuc-maxNuc exclude summarize add");
c = roiManager("count"); 
for(i=x; i<c; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(2);
roiManager("Set Color", "white");
 } 
selectWindow("Cardiomyocytes nuclei");
run("Close");
//Summarize
selectWindow("Merge");
rename(a);
Table.rename("Summary", "Results");
Table.deleteColumn("%Area");
Table.renameColumn("Count", "Amount");
Table.renameColumn("Slice", "Structure");
run("Read and Write Excel");
run("Clear Results");
selectWindow(a);
rename("Merge");
// Intramyocyte signal
selectWindow(a+" (red)");
rename(a);
setThreshold(T, 255);
roiManager("select all");
roiManager("multi-measure measure_all");
run("Read and Write Excel");
selectWindow("Results");
run("Close");
selectWindow("Merge");
rename(a);
selectWindow(a);
roiManager("show all without labels");
}

