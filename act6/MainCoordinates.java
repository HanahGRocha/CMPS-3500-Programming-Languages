/*
 * NAME: Hanah Rocha
 * ORGN: CSUB CMPS 3500
 * ASGN: Activity 6
 * DATE: 11/14/25
 * */


// MainCoordinates.java
// Puts everything together: 2D and 3D demos + closest/farthest pairs + largest triangle areas.

import java.io.*;
import java.util.*;

public class MainCoordinates {
    public static void main(String[] args) throws Exception {

        //////////////  Testing 2D Points

        System.out.println("\n  Testing 2D Points:");
        System.out.println("  ******************\n");

        //Step 1 set up
        Point p1 = new Point(1, 2);
        Point p2 = new Point(3, 4);
        Point p3 = new Point(3, 4);
        Point p4 = p1;

        System.out.println("  Objects (Points) created from Point class:");
        System.out.println("  p1: " + p1);
        System.out.println("  p2: " + p2);
        System.out.println("  p3: " + p3);
        System.out.println("  p4: " + p4);

        System.out.println("\n  Comparing Points:");
        System.out.println("  p1 == p1? " + (p1 == p1));
        System.out.println("  p1 == p2? " + (p1 == p2));
        System.out.println("  p2 == p3? " + (p2 == p3));
        System.out.println("  p1 == p4? " + (p1 == p4));

        System.out.println("\n  The distance between p1 and p2 is: " + p1.distance(p2) + "\n");

        System.out.println("\n\n  Setting new coordinates for point 1:");
        p1.setX(-99); p1.setY(-1);
        System.out.println("  p1: " + p1);

        System.out.println("\n  Changing some values at the object level:");
        p4.setX(5);
        p1 = new Point(7, 8);
        System.out.println("  p1: " + p1);
        System.out.println("  p4: " + p4);
        System.out.println("  p1.equals(p1)? " + p1.equals(p1));
        System.out.println("  p1.equals(p2)? " + p1.equals(p2));
        System.out.println("  p2.equals(p3)? " + p2.equals(p3));
        System.out.println("  p1.equals(p4)? " + p1.equals(p4));
        System.out.println();

        // Load 2D file and compute min, max, largest area
        PointSet2D set2 = new PointSet2D();
        set2.loadFromFile("2dinputpoint.txt");

        System.out.println("  Closest Points:");
        System.out.println("  --------------");
        double dmin2 = set2.minDistance();
        System.out.println("  All points closest to each other at a minimum distance of " + dmin2 + " are:");
        for (int[] ij : set2.minDistancePairs()) {
            Point a = set2.getPoints().get(ij[0]);
            Point b = set2.getPoints().get(ij[1]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + "), (" + b.getX() + ", " + b.getY() + ")");
        }

        System.out.println("\n  Farthest Points:");
        System.out.println("  ---------------");
        double dmax2 = set2.maxDistance();
        System.out.println("  All points farthest to each other at a minimum distance of " + dmax2 + " are:");
        for (int[] ij : set2.maxDistancePairs()) {
            Point a = set2.getPoints().get(ij[0]);
            Point b = set2.getPoints().get(ij[1]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + "), (" + b.getX() + ", " + b.getY() + ")");
        }

        System.out.println("\n  Largest Triangle Area:");
        System.out.println("  ---------------------");
        double area2 = set2.maxTriangleArea();
        System.out.println("  All points from all triangles of maximum area of " + area2 + " are:");
        for (int[] t : set2.maxAreaTriples()) {
            Point a = set2.getPoints().get(t[0]);
            Point b = set2.getPoints().get(t[1]);
            Point c = set2.getPoints().get(t[2]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + "), (" + b.getX() + ", " + b.getY() + "), (" + c.getX() + ", " + c.getY() + ")");
        }



        /////// Testing 3D Points

        System.out.println("\n\n  Testing 3D Points:");
        System.out.println("  ******************");

        Point3D q1 = new Point3D(1, 2, 3);
        Point3D q2 = new Point3D(3, 4, 5);
        Point3D q3 = new Point3D(6, 7, 0);
        Point3D q4 = q1;

        System.out.println("\n  Objects (Points) created from Point3D class:");
        System.out.println("  p1: " + q1);
        System.out.println("  p2: " + q2);
        System.out.println("  p3: " + q3);
        System.out.println("  p4: " + q4);

        System.out.println("\n  Comparing Point3Ds:");
        System.out.println("  p1 == p1? " + (q1 == q1));
        System.out.println("  p1 == p2? " + (q1 == q2));
        System.out.println("  p2 == p3? " + (q2 == q3));
        System.out.println("  p1 == p4? " + (q1 == q4));

        System.out.println("\n  The distance between p1 and p2 is: " + q1.distance(q2));
        System.out.println("  The area of the triangle formed by p1, p2, and p3 is: " +
                Coordinates.computeTriangleArea(q1, q2, q3));

        System.out.println("\n\n  Setting new coordinates for Point3D 1:");
        q1.setX(-99); q1.setY(-1); q1.setZ(3);
        System.out.println("  p1: " + q1);

        System.out.println("\n  Changing some values at the object level:");
        q1 = new Point3D(10, 11, 12);
        q4 = new Point3D(5, -1, 3);
        System.out.println("  p1: " + q1);
        System.out.println("  p4: " + q4);
        System.out.println("  p1.equals(p1)? " + q1.equals(q1));
        System.out.println("  p1.equals(p2)? " + q1.equals(q2));
        System.out.println("  p2.equals(p3)? " + q2.equals(q3));
        System.out.println("  p1.equals(p4)? " + q1.equals(q4));

        // Load 3D file and compute min, max, largest area
        PointSet3D set3 = new PointSet3D();
        set3.loadFromFile("3dinputpoint.txt");

        System.out.println("\n  Closest Points:");
        System.out.println("  ***************");
        double dmin3 = set3.minDistance();
        System.out.println("  All points closest to each other at a minimum distance of " + dmin3 + " are:");
        for (int[] ij : set3.minDistancePairs()) {
            Point3D a = set3.getPoints().get(ij[0]);
            Point3D b = set3.getPoints().get(ij[1]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), (" +
                    b.getX() + ", " + b.getY() + ", " + b.getZ() + ")");
        }

        System.out.println("\n  Farthest Points:");
        System.out.println("  ***************");
        double dmax3 = set3.maxDistance();
        System.out.println("  All points farthest to each other at a maximum distance of " + dmax3 + " are:");
        for (int[] ij : set3.maxDistancePairs()) {
            Point3D a = set3.getPoints().get(ij[0]);
            Point3D b = set3.getPoints().get(ij[1]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), (" +
                    b.getX() + ", " + b.getY() + ", " + b.getZ() + ")");
        }

        System.out.println("\n  Largest Triangle Area:");
        System.out.println("  ---------------------");
        double area3 = set3.maxTriangleArea();
        System.out.println("  All points from all 3D triangles of maximum area of " + area3 + " are:");
        for (int[] t : set3.maxAreaTriples()) {
            Point3D a = set3.getPoints().get(t[0]);
            Point3D b = set3.getPoints().get(t[1]);
            Point3D c = set3.getPoints().get(t[2]);
            System.out.println("  (" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), (" +
                    b.getX() + ", " + b.getY() + ", " + b.getZ() + "), (" +
                    c.getX() + ", " + c.getY() + ", " + c.getZ() + ")");
        }
    }
}

////////// Helpers for I/O and computations

class PointSet2D {
    private final List<Point> points = new ArrayList<>();
    public void loadFromFile(String path) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim(); if (line.isEmpty()) continue;
                String[] t = line.split("\\s+|,");
                int x = Integer.parseInt(t[0]);
                int y = Integer.parseInt(t[1]);
                points.add(new Point(x, y));
            }
        }
    }
    public List<Point> getPoints() { return Collections.unmodifiableList(points); }

    public double minDistance() {
        double best = Double.POSITIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.min(best, points.get(i).distance(points.get(j)));
        return best;
    }
    public double maxDistance() {
        double best = Double.NEGATIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.max(best, points.get(i).distance(points.get(j)));
        return best;
    }
    public List<int[]> minDistancePairs() {
        double d = minDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
        return pairs;
    }
    public List<int[]> maxDistancePairs() {
        double d = maxDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
        return pairs;
    }
    public double maxTriangleArea() {
        double best = 0.0;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                for (int k = j + 1; k < points.size(); k++)
                    best = Math.max(best, Coordinates.computeTriangleArea(points.get(i), points.get(j), points.get(k)));
        return best;
    }
    public List<int[]> maxAreaTriples() {
        double best = maxTriangleArea();
        List<int[]> res = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                for (int k = j + 1; k < points.size(); k++) {
                    double a = Coordinates.computeTriangleArea(points.get(i), points.get(j), points.get(k));
                    if (Math.abs(a - best) <= 1e-9) res.add(new int[]{i, j, k});
                }
        return res;
    }
}

class PointSet3D {
    private final List<Point3D> points = new ArrayList<>();
    public void loadFromFile(String path) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim(); if (line.isEmpty()) continue;
                String[] t = line.split("\\s+|,");
                int x = Integer.parseInt(t[0]);
                int y = Integer.parseInt(t[1]);
                int z = Integer.parseInt(t[2]);
                points.add(new Point3D(x, y, z));
            }
        }
    }
    public List<Point3D> getPoints() { return Collections.unmodifiableList(points); }

    public double minDistance() {
        double best = Double.POSITIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.min(best, points.get(i).distance(points.get(j)));
        return best;
    }
    public double maxDistance() {
        double best = Double.NEGATIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.max(best, points.get(i).distance(points.get(j)));
        return best;
    }
    public List<int[]> minDistancePairs() {
        double d = minDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
        return pairs;
    }
    public List<int[]> maxDistancePairs() {
        double d = maxDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
        return pairs;
    }
    public double maxTriangleArea() {
        double best = 0.0;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                for (int k = j + 1; k < points.size(); k++)
                    best = Math.max(best, Coordinates.computeTriangleArea(points.get(i), points.get(j), points.get(k)));
        return best;
    }
    public List<int[]> maxAreaTriples() {
        double best = maxTriangleArea();
        List<int[]> res = new ArrayList<>();
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                for (int k = j + 1; k < points.size(); k++) {
                    double a = Coordinates.computeTriangleArea(points.get(i), points.get(j), points.get(k));
                    if (Math.abs(a - best) <= 1e-9) res.add(new int[]{i, j, k});
                }
        return res;
    }
}

