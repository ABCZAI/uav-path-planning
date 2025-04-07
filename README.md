# UAV Path Planning using K-means and Genetic Algorithm

This project implements a path planning algorithm for multiple UAVs using **K-means clustering** and a custom **Genetic Algorithm (GA)**. The goal is to divide the task area and optimize the visiting path within each region.

## 🧩 File Overview

- `main.m`  
  👉 **Main script** to run the full algorithm. It reads the input CSV, performs clustering, and optimizes the path for each cluster.

- `kmeans_clustering.m`  
  👉 Contains the K-means clustering logic.

- `genetic_algorithm.m`  
  👉 Implements the GA used for solving TSP inside each cluster.

- `random_point.py`  
  👉 Optional script to **generate a random dataset** (`random_points.csv`). Only needed to run **once** if you want to regenerate the input.

- `random_points.csv`  
  👉 Input file containing 2D coordinates for task points.

## ✅ How to Use

1. (Optional) Run `random_point.py` to generate a new set of random points.  
2. Open `main.m` in MATLAB and run it to see the clustering and path planning results.

## 📌 Notes

- MATLAB is required to run `.m` files.
- Python 3 is required only for `random_point.py`.
