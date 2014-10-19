SuSolver
========

A Sudoku Solver written in Mirah for the JVM.

Solves with logic but has a brute force option.

Current State
-------------

The backend (SuSolverLib) is functional if incomplete.  It can be used to create whatever kind of frontend and solves most sudoku puzzles.

The Swing frontend is also functional and definitely incomplete.  At some point I'll include a screenshot.

The CodenameOne project, made possible by Steve Hannah's NetBeans plugin for Mirah (https://github.com/shannah/mirah-nbm) is partially functional.  The puzzle entry grid works in the simulator and has a button to go to the solver.  The solve grid displays and is connected to the backend, now with buttons to start solving.  It has a button to go back to the entry grid, a "Solve!" button to do the whole puzzle, a "Next Step" button to solve one step at a time, and a "Reset" button to start over.  The "Show Log" button isn't functional but will eventually show a log (the very idea!) of what the Solver is doing and why.  Maybe other things in the future...

Now builds on the build server!  But my Android phone was stolen last year so I can't test that build on an actual device and apparently I need Windows 8.1 to run the SDK for Windows Phone which it seems I need in order to sideload apps onto my Nokia and possibly $19 to siqn up as a developer though it looks like I should be able to test on one device without doing that.  The point is that I can't test the builds yet.  I should be able to load the Android build in an emulator.  Ah, some day.  In the mean time, the builds are in /dist.

Side note, CodenameOne has become a joy to write in Mirah now that I've had a chance to dig into it.  Drawing your own widgets is severely under-documented, so if it helps you should check out the overridden paint() method in SuSolveCell.mirah (also under-documented, I'm bad about not commenting in code, but should be readable).

Current ruby scripts for running, compiling and creating jars outside of NetBeans only have Windows in mind.  Will fix eventually.
