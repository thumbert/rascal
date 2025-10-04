<p style="text-align: center">Adrian A. Drăgulescu<br>October 3, 2025</p>

# Introduction

The New York Times launched a new puzzle game called [Pips](https://www.nytimes.com/games/pips) on August 18, 2025.  To solve the puzzle, the player needs to place dominoes on a board in a way that satisfies a set of constraints.  It comes in 3 flavors (small, medium and hard) based on the size of the board.  The board shape and the constraints are different every day. 

Here's the easy puzzle from September 16, 2025: 
![alt text](assets/pips_easy.png)

In this puzzle, there are 6 dominoes to fill a 12 square grid and three constraints on the dominoes values (pips).  To facilitate the discussion, I've labeled the squares from `a` to `l` as shown on the right.  The constraints require that
```
b = c = d = e
f + g = 11
h + i = 4
```

A naive way to solve the puzzle is to generate all the possible domino arrangements that fill 
the board and check which one satisfies the given constraints.  For this puzzle, given that there 
are 6 dominoes, there are `6!` ways of placing them on the grid.  However, each domino can be 
flipped so there are `2^6` ways to do that.  In total, there are `2^6 * 6! = 46,080` arrangements 
to check, which can be checked easily by computer. 

Hard puzzles have 12 dominoes or more.  For a puzzle with 12 dominoes, there are 
`2^12 * 12! = 1,961,990,553,600` possible arrangements.  In this case the naive, brute force approach 
is unfeasible.  

It's time for the **Constraint Programming solver** to enter the chat...








