set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 600, 400 
set output 'simple.png'
#set title "Simple Plots" font ",20"
set key left box
set samples 500
set style data points

plot [-20:20] sin(x),atan(x),cos(atan(x))
