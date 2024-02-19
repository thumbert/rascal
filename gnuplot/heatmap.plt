reset
set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 1200, 500 

# set term gif size 1200, 500 fontscale 1.0 animate delay 20 loop 0
# set output 'hills_optimization.gif'


$map1 << EOD
0 0 0 0 0 0 0 2 3 4 5 6 7 7 8 9 9 8 7 6 5 4 3 3 5 5 5 5 7 7 7 5 5 5 7 7 7 7
0 0 1 1 0 0 2 3 4 5 6 6 7 8 8 9 9 8 7 6 5 4 3 5 5 5 6 7 7 7 7 7 7 7 7 7 7 7
0 0 0 1 1 2 3 4 5 6 6 7 7 8 9 9 8 7 7 6 6 5 4 5 5 5 6 6 7 7 7 7 7 7 7 8 7 7
0 0 0 0 0 2 3 4 5 6 6 7 8 8 9 9 8 7 7 6 6 5 4 3 5 5 6 6 6 8 8 8 7 7 8 7 7 7
1 1 0 0 0 2 3 4 5 6 7 7 7 8 9 9 9 8 7 6 5 5 4 2 4 4 6 6 6 8 8 8 8 8 8 7 7 7
1 1 0 0 0 0 3 4 5 6 6 6 7 7 8 9 9 8 7 6 5 4 3 2 4 4 6 6 6 8 8 8 8 8 8 7 7 7
2 1 1 1 1 0 2 3 4 5 6 6 7 7 8 9 8 7 7 6 5 4 2 2 4 4 4 6 6 8 8 8 8 8 7 7 7 7
2 2 2 2 1 0 0 2 3 3 5 6 6 7 7 8 7 7 6 5 4 3 2 4 4 4 6 6 6 8 8 8 9 9 9 7 7 7
2 2 2 2 1 0 0 1 1 2 3 5 6 6 7 7 7 6 5 4 3 2 2 4 4 4 6 6 8 8 8 8 7 7 7 7 7 7
2 2 2 2 1 1 1 1 1 1 2 3 5 6 6 6 6 5 4 3 2 2 4 4 4 6 6 6 8 8 7 7 7 7 7 7 7 7
3 3 2 2 2 1 1 1 1 1 1 1 3 5 5 5 5 3 3 2 2 2 4 4 6 6 6 8 8 8 8 8 8 7 7 7 8 8
4 4 3 2 2 2 1 1 1 1 1 1 1 3 3 3 1 1 1 2 2 4 4 4 6 6 6 8 8 8 8 8 8 7 7 7 8 8
5 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 6 6 6 6 6 8 8 6 8 8 7 7 7 7
EOD

system('mkdir -p animation')
do for [i=2817:2816] { # 2816
    # set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 1200, 500 
    set output sprintf('animation/hills_optimization_%04.0f.png', i)

    # set title "A* optimization"
    unset key
    set tics out

    set palette maxcolors 10
    set palette rgb 33,13,10 

    set cbrange [0:9]
    set cblabel "Height"
    unset cbtics

    set xrange [-0.5:37.5]
    set yrange [-0.5:12.5]
    set cbtics 1 

    set multiplot
    set view map
    splot '$map1' matrix with image

    # Add the frontier points on top of the heatmap 
    set style line 1 linecolor rgb "black" linewidth 2 pointsize 1 pointtype 6
    unset key
    unset xtics
    unset ytics
    unset border

    # I need to set the right size and origin of the plot (ugly but I does the job).
    set size 0.818, 0.776
    set origin 0.0926, 0.128
    plot sprintf('data/queue_%04.0f.dat', i) with points linestyle 1 
    unset multiplot 
    reset
}


# make one last file to show the solution at the end
set output 'animation/hills_optimization_2817.png'
unset key
set tics out

set palette maxcolors 10
set palette rgb 33,13,10 

set cbrange [0:9]
set cblabel "Height"
unset cbtics

set xrange [-0.5:37.5]
set yrange [-0.5:12.5]
set cbtics 1 

set multiplot
set view map
splot '$map1' matrix with image

# Add the optimal trajectory on top of the splot. 
set style line 1 linecolor rgb "black" linewidth 3 pointsize 1 pointtype 7
unset key
unset xtics
unset ytics
unset border

set size 0.818, 0.776
set origin 0.0926, 0.128
plot 'data/solution.dat' with linespoints linestyle 1 
unset multiplot 
reset




# To create a gif from all the png files, use ImageMagick. It comes with a utility 
# called convert.  
# convert -delay 20 -loop 0 *.png hills_optimization.gif

# Or, start GIMP and load all the files as layers (File > Open as Layers). After this 
# save all layers together as an animated gif file.
