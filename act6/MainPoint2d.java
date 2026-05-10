//CS 3500 - Class Point
//Works with p\Point.java

public class MainPoint2d {
    public static void main(String[] args) throws Exception {
        //creating a new oject point with corrdinates (0, 0)
        Point origin = new Point();

        //creating mote object points
        Point p1 = new Point(1, 2);
        Point p2 = new Point(3, 4);
        Point p3 = new Point(3, 4);
        Point p4 = p1;
        double d12;

        //printing all points
        System.out.println("\nObjects (Poins) created from Point class:");
        System.out.println("p1: " + p1);
        System.out.println("p2: " + p2);
        System.out.println("p3: " + p3);
        System.out.println("p4: " + p4);

        //comparing some points
        System.out.println("\nComparing Points:");
        System.out.println("p1 == p1? " + (p1 == p1));
        System.out.println("p1 == p2? " + (p1 == p2));
        System.out.println("p2 == p3? " + (p2 == p3));
        System.out.println("p1 == p4? " + (p1 == p4));

        //caluclatin the distance between p1 and p2
        d12 = p1.distance(p2);
        System.out.println("\nThe distance between p1 and p2 is: " + d12 + "\n");

        // Setting new coordinates on point 1
        System.out.println("\nSetting new coordinates for point 1: ");
        p1.setX(-99);
        p1.setY(-1);
        System.out.println("p1: " + p1);

        System.out.println("\nChanging some values at the object level:");

        // changing the value of x of p1 changes it at the object level.
        // p4 refers to the same object so printing p4 will see the new
        // value too.
        p1.setX(5);

        // Setting p1 equal to a new Point only changes what p1 points too.
        // p4 still points to the original Point object.
        p1 = new Point(7, 8);

        System.out.println("p1: " + p1);
        System.out.println("p4: " + p4);

        System.out.println("p1.equals(p1)? " + p1.equals(p1));
        System.out.println("p1.equals(p2)? " + p1.equals(p2));
        System.out.println("p2.equals(p3)? " + p2.equals(p3));
        System.out.println("p1.equals(p4)? " + p1.equals(p4));

        //Step 1 with PointSet
        PointSet set = new PointSet();
        set.loadFromFile("2dinputpoint.txt");

        System.out.println();
        System.out.println("Closest Points:");
        System.out.println("***************");
        double dmin = set.minDistance();
        System.out.println("All points closest to each other at a minimum distance of " + dmin + " are:");
        for (int[] ij : set.minDistancePairs()) {
            Point a = set.getPoints().get(ij[0]);
            Point b = set.getPoints().get(ij[1]);
            System.out.println("(" + a.getX() + ", " + a.getY() + "), (" + b.getX() + ", " + b.getY() + ")");
        }

        System.out.println();
        System.out.println("Farthest Points:");
        System.out.println("***************");
        double dmax = set.maxDistance();
        System.out.println("All points farthest to each other at a maximum distance of " + dmax + " are:");
        for (int[] ij : set.maxDistancePairs()) {
            Point a = set.getPoints().get(ij[0]);
            Point b = set.getPoints().get(ij[1]);
            System.out.println("(" + a.getX() + ", " + a.getY() + "), (" + b.getX() + ", " + b.getY() + ")");
        }
    }

}
