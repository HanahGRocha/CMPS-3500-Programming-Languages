//CS 3500 - Class Point
//Works with p\Point.java

public class MainPoint3D {
    public static void main(String[] args) throws Exception {

        //creating mote object points
        Point3D p1 = new Point3D(1, 2, 3);
        Point3D p2 = new Point3D(3, 4, 5);
        Point3D p3 = new Point3D(6, 7, 0);
        Point3D p4 = p1;
        double d12;

        //printing all points
        System.out.println("\nObjects (Poins) created from Point3d class:");
        System.out.println("p1: " + p1);
        System.out.println("p2: " + p2);
        System.out.println("p3: " + p3);
        System.out.println("p4: " + p4);

        //comparing some points
        System.out.println("\nComparing Point3ds:");
        System.out.println("p1 == p1? " + (p1 == p1));
        System.out.println("p1 == p2? " + (p1 == p2));
        System.out.println("p2 == p3? " + (p2 == p3));
        System.out.println("p1 == p4? " + (p1 == p4));

        //caluclatin the distance between p1 and p2
        System.out.println("\nThe distance between p1 and p2 is: " + 
                p1.distance(p2));
        System.out.println("The area of the triangle formed by" +
                " p1, p2,and p3 is: " + 
                PointSet3D.triangleArea(p1, p2, p3));

        // Setting new coordinates on point 1
        System.out.println("\nSetting new coordinates for pointi3d 1: ");
        p1.setX(-99);
        p1.setY(-1);
        p1.setZ(3);
        System.out.println("p1: " + p1);

        System.out.println("\nChanging some values at the object level:");

        p1 = new Point3D(10, 11, 12);
        p1 = new Point3D(5, -1, 3);

        System.out.println("p1: " + p1);
        System.out.println("p4: " + p4);

        System.out.println("p1.equals(p1)? " + p1.equals(p1));
        System.out.println("p1.equals(p2)? " + p1.equals(p2));
        System.out.println("p2.equals(p3)? " + p2.equals(p3));
        System.out.println("p1.equals(p4)? " + p1.equals(p4));

        //Step 1 with PointSet
        PointSet3D set = new PointSet3D();
        set.loadFromFile("3dinputpoint.txt");

        System.out.println("\nAll 3D points read:");
        int idx = 0;
        for (Point3D q : set.getPoints()) {
            System.out.println("[" + (idx++) + "] " + q);
        }

        // Closest pairs
        System.out.println();
        System.out.println("Closest Points:");
        System.out.println("***************");
        double dmin = set.minDistance();
        System.out.println("All points closest to each other at a minimum distance of " + dmin + " are:");
        for (int[] ij : set.minDistancePairs()) {
            Point3D a = set.getPoints().get(ij[0]);
            Point3D b = set.getPoints().get(ij[1]);
            System.out.println("(" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), ("
                    + b.getX() + ", " + b.getY() + ", " + b.getZ() + ")");
        }

        // Farthest pairs
        System.out.println();
        System.out.println("Farthest Points:");
        System.out.println("***************");
        double dmax = set.maxDistance();
        System.out.println("All points farthest to each other at a maximum distance of " + dmax + " are:");
        for (int[] ij : set.maxDistancePairs()) {
            Point3D a = set.getPoints().get(ij[0]);
            Point3D b = set.getPoints().get(ij[1]);
            System.out.println("(" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), ("
                    + b.getX() + ", " + b.getY() + ", " + b.getZ() + ")");
        }

        // Largest triangle area
        System.out.println();
        System.out.println("Largest Triangle Area:");
        System.out.println("---------------------");
        double amax = set.maxTriangleArea();
        System.out.println("All points from all 3D triangles of maximum area of " + amax + " are:");
        for (int[] ijk : set.maxAreaTriples()) {
            Point3D a = set.getPoints().get(ijk[0]);
            Point3D b = set.getPoints().get(ijk[1]);
            Point3D c = set.getPoints().get(ijk[2]);
            System.out.println("(" + a.getX() + ", " + a.getY() + ", " + a.getZ() + "), ("
                    + b.getX() + ", " + b.getY() + ", " + b.getZ() + "), ("
                    + c.getX() + ", " + c.getY() + ", " + c.getZ() + ")");
        }
    }
}
