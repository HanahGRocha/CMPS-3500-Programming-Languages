/*
 * NAME: Hanah Rocha
 * ORGN: CSUB CMPS 3500
 * ASGN: Activity 6
 * DATE: 11/14/25
 * */

// Coordinates.java
// Contains Point (2D), Point3D (3D), and a shared computeTriangleArea(..) method.

import java.util.Objects;

public class Coordinates {

    ////Heron's Form
    public static double computeTriangleArea(Point a, Point b, Point c) {
        double ab = a.distance(b);
        double bc = b.distance(c);
        double ca = c.distance(a);
        double s = (ab + bc + ca) / 2.0;
        double area2 = s * (s - ab) * (s - bc) * (s - ca);
        return area2 <= 0 ? 0.0 : Math.sqrt(area2);
    }
}

// 2D Point
class Point {
    private int x;
    private int y;

    public Point() { 
        this(0, 0); 
    }
    public Point(int x, int y) { 
        setX(x); 
        setY(y); 
    }

    public int getX() { 
        return x; 
    }
    public void setX(int x) { 
        this.x = x; 
    }
    public int getY() { 
        return y; 
    }
    public void setY(int y) { 
        this.y = y; 
    }

    public double distance(Point p2) {
        int dx = this.x - p2.x;
        int dy = this.y - p2.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    @Override public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Point)) return false;
    Point p = (Point) other;
    return this.x == p.x && this.y == p.y;
    }
    @Override public int hashCode() { 
    return Objects.hash(x, y); 
    }

    @Override public String toString() { 
    return "(" + x + "," + y + ")"; }
}

// 3D Point
class Point3D extends Point {
    private int z;

    public Point3D() { 
        this(0, 0, 0); 
    }
    public Point3D(int x, int y, int z) { 
        super(x, y); 
        setZ(z); 
    }

    public int getZ() { 
        return z; 
    }
    public void setZ(int z) { 
        this.z = z; 
    }

    @Override
    public double distance(Point p) {
        if (!(p instanceof Point3D)) return super.distance(p); 
        Point3D o = (Point3D) p;
        int dx = getX() - o.getX();
        int dy = getY() - o.getY();
        int dz = z - o.z;
        return Math.sqrt(dx*dx + dy*dy + dz*dz);
    }

    @Override public boolean equals(Object o) {
    if (o == this) return true;
    if (!(o instanceof Point3D)) return false;
    Point3D p = (Point3D) o;
    return getX() == p.getX() && getY() == p.getY() && z == p.z;
    }
    @Override public int hashCode() { 
    return Objects.hash(getX(), getY(), z); 
    }

    @Override public String toString() { 
    return "(" + getX() + "," + getY() + "," + z + ")"; }
}

