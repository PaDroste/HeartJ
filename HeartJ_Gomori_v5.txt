// HeartJ_Gomori_v5.ijm
// Written by Patrick Droste, LaBooratory of Nephropathology, Institute of Pathology and Division of Nephrology and Clinical Immunology, RWTH Aachen University Hospital, Aachen, Germany
// Last updated on 2023 April
//
//This macro measures the size of cardiomyocytes (Group 1) in different parameters on slides stained with Gomori. The results are reported in an Excel spreadsheet on the desktop, which contains the individual results as well as an average value. In addition, the size of the nuclei of the cardiomyocytes (Group 2) and the size of the capillaries (Group 3) are measured. Furthermore, the number of capillaries bordering each cardiomyocyte is measured.
//
//Required plugins: MorphoLibJ_-1.4.0, Read and Write Excel
//
//
macro "HeartJ_Gomori_v5 [q]" {
run("Clear Results");
//
//
//Define as "scale" how many pixels are a micrometer (1µm = "scale" Pixel).
scale = 3.96
//
//Define size thresholds in micrometer
minCardio = 60
minNuc = 6
maxNuc = 100
minCap = 1.5
maxCap = 100
//
//
run("Set Scale...", "distance=scale known=1 unit=µm global");
a = getTitle();
run("Duplicate...", "title=T");
run("Duplicate...", "title=M");
//Segmentation with Gomori
selectWindow("M");
run("8-bit");
run("Invert");
run("Morphological Segmentation");
waitForUser("Define the appropriate tolerance value","Find the appropriate tolerance for this image. Enter a tolerance (usually between 50 to 70), click on Run. If the tolerance fits, click OK. If the tolerance does not fit, enter a new tolerance and repeat the process.");
call("inra.ijpb.plugins.MorphologicalSegmentation.setDisplayFormat", "Watershed lines");
wait(8000)
call("inra.ijpb.plugins.MorphologicalSegmentation.createResultImage");
run("Options...", "iterations=1 count=1 black");
rename("Cardiomyocytes Segmentation");
selectWindow("Morphological Segmentation");
run("Close");
selectWindow("Log");
run("Close");
selectWindow("M");
run("Close");
//Manually correction of segmentation
selectWindow("Cardiomyocytes Segmentation");
run("Create Selection");
roiManager("Add");
selectWindow(a);
roiManager("Show All");
run("Line Width...", "line=3");
run("Colors...", "foreground=black background=black selection=cyan");
waitForUser("Correction of segmentation","Correct the segmentation by drawing missing lines and clicking Add in the ROI Manager.");
selectWindow("Cardiomyocytes Segmentation");
run("Line Width...", "line=2");
roiManager("Select all");
roiManager("Draw");
roiManager("Delete");
run("Dilate");
run("Invert");
run("Dilate");
setThreshold(0, 100);
run("Analyze Particles...", "size=minCardio-Infinity circularity=0.00-1.00 add");
//Colour Threshold for HE
selectWindow("T");
min=newArray(3);
max=newArray(3);
filter=newArray(3);
b=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=170;
max[0]=255;
filter[0]="pass";
min[1]=33;
max[1]=255;
filter[1]="pass";
min[2]=139;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(b);
run("Set Measurements...", "area_fraction redirect=None decimal=3");
//Delete rois without HE staining
r = roiManager("count")-1;
c = 0;
for (i=0; i<r; i++) {
	roiManager("Select", c);
	run("Measure");
	p = getResult("%Area", i);
	if (p>40) {
		roiManager("Select", c);
		roiManager("Delete");
		}
	else {
		c = c+1;
		}
	}
close();
selectWindow("Cardiomyocytes Segmentation");
run("Colors...", "foreground=white background=black selection=cyan");
roiManager("Fill");
roiManager("select all");
roiManager("Delete");
selectWindow("Results");
run("Close");
run("Clear Results");
//Prepare picture for nuclei
selectWindow("Cardiomyocytes Segmentation");
run("Duplicate...", "title=N+");

//Cardiomyocytes
run("Set Measurements...", "area feret's redirect=None decimal=3");
selectWindow("Cardiomyocytes Segmentation");
rename("Cardiomyocytes");
run("Analyze Particles...", "size=minCardio-Infinity circularity=0.00-1.00 summarize exclude include add");
x = roiManager("count");
for(i=0; i<x; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(1);
roiManager("Set Color", "red");
 }
//exclude rois of Cardiomyocytes only rois of capillaries remain
selectWindow("Cardiomyocytes");
RoiManager.selectGroup(1);
run("Colors...", "foreground=white background=black selection=cyan");
roiManager("Fill");
run("Analyze Particles...", "size=minCardio-Infinity include add");
c = roiManager("count"); 
for(i=x; i<c; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(5);
 } 
RoiManager.selectGroup(5);
roiManager("Fill");
RoiManager.selectGroup(5);
roiManager("Delete");

//Cardiomyocyte Nuclei
selectWindow("N+");
rename("Cardiomyocyte Nuclei");
RoiManager.selectGroup(1);
roiManager("Combine");
run("Clear Outside");
run("Select None");
selectWindow("Cardiomyocyte Nuclei");
run("Analyze Particles...", "size=minNuc-maxNuc circularity=0.00-1.00 exclude summarize include add");
c = roiManager("count"); 
for(i=x; i<c; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(2);
roiManager("Set Color", "blue");
 } 
//Capillaries
selectWindow("Cardiomyocytes")
rename("Capillaries")
setOption("BlackBackground", true);
run("Convert to Mask");
run("Invert");
run("Erode");
run("Open");
run("Dilate");
run("Invert");
run("Analyze Particles...", "size=minCap-maxCap circularity=0.00-1.00 exclude summarize add");
z = roiManager("count"); 
for(i=c; i<z; i++) { 
roiManager("Select", i); 
RoiManager.setGroup(3);
roiManager("Set Color", "green");
 }
Table.rename("Summary", "Results"); 
Table.deleteColumn("%Area");
Table.renameColumn("Count", "Amount");
Table.renameColumn("Slice", "Structure");
selectWindow("Cardiomyocyte Nuclei");
rename(a);
run("Read and Write Excel");
close();
selectWindow("Results");
run("Close");
roiManager("select all");
roiManager("multi-measure measure_all");
run("Read and Write Excel");
selectWindow("Results");
run("Close");
//Capillary-Cardiomyocyte relationship
selectWindow("Capillaries");
rename("Capillary-Cardiomyocyte relationship");
selectWindow("Capillary-Cardiomyocyte relationship");
RoiManager.selectGroup(3);
roiManager("Combine");
run("Clear Outside");
run("Select None");
for (i=0; i<(2*scale); i++) {
	i+1;
	run("Dilate");
	}
RoiManager.selectGroup(1);
roiManager("Combine");
run("Clear Outside");
run("Set Measurements...", "  redirect=None decimal=3");
for (i=0 ; i<x; i++) {
	roiManager("select", i);
	run("Analyze Particles...", "size=1-Infinity summarize ");
}
Table.rename("Summary", "Results");
selectWindow("Results");
Table.deleteColumn("%Area");
Table.deleteColumn("Average Size");
Table.deleteColumn("Total Area");
Table.deleteColumn("Slice");
Table.renameColumn("Count", "Capillary contacts");
run("Read and Write Excel");
close("Results");
selectWindow(a);
roiManager("show all without labels");
}
