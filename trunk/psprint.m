function psprint(filename)
#Set linewidth and font size 
__gnuplot_set__ terminal postscript color eps lw 5 "Helvetica" 25
#Set figure size relative x,y
__gnuplot_set__ size 0.8,1
#Choose the legend position
__gnuplot_set__ top right
#Set the filename
a=(['__gnuplot_set__ output "' nimi '.ps"'])
eval(a)
#Print to file
replot
