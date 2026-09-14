#!/usr/bin/env python3
"""
GROMACS .xvg Plotting Utility for Beginners
Requires: matplotlib
Usage: python plot_metrics.py
"""

import os
import matplotlib.pyplot as plt

def parse_xvg(filepath):
    x, y = [], []
    with open(filepath, 'r') as f:
        for line in f:
            if not line.startswith(('@', '#')):
                parts = line.split()
                if len(parts) >= 2:
                    x.append(float(parts[0]))
                    y.append(float(parts[1]))
    return x, y

def create_plot(x, y, title, xlabel, ylabel, outname):
    plt.figure(figsize=(8, 5))
    plt.plot(x, y, color='#1f77b4', linewidth=1.5)
    plt.title(title, fontsize=14, fontweight='bold')
    plt.xlabel(xlabel, fontsize=12)
    plt.ylabel(ylabel, fontsize=12)
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout()
    plt.savefig(outname, dpi=300)
    plt.close()
    print(f"✅ Generated {outname}")

if __name__ == "__main__":
    print("--- MD Plotting Utility ---")
    
    if os.path.exists("rmsd.xvg"):
        x, y = parse_xvg("rmsd.xvg")
        create_plot(x, y, "RMSD over Time", "Time (ns)", "RMSD (nm)", "plot_rmsd.png")
    else:
        print("⚠️ rmsd.xvg not found.")

    if os.path.exists("rmsf.xvg"):
        x, y = parse_xvg("rmsf.xvg")
        create_plot(x, y, "Per-Residue RMSF", "Residue Number", "RMSF (nm)", "plot_rmsf.png")
    else:
        print("⚠️ rmsf.xvg not found.")

    if os.path.exists("sasa.xvg"):
        x, y = parse_xvg("sasa.xvg")
        # Time usually in ps for SASA default, adapt if necessary
        create_plot(x, y, "Solvent Accessible Surface Area", "Time (ps)", "Area (nm²)", "plot_sasa.png")
    else:
        print("⚠️ sasa.xvg not found.")
        
    print("Plotting complete!")
